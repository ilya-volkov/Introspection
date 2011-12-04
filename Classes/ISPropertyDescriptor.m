#import "ISPropertyDescriptor.h"
#import "ISSetterSemanticsType.h"
#import "ISInvalidStateException.h"

#import "NSString+Extensions.h"
#import "NSValue+Extensions.h"
#import "NSInvocation+Extensions.h"

@interface ISPropertyDescriptor ()

- (void) parsePropertyAttributeDescription:(NSString*)description;
- (void) setDefaultAttributeValues;

@end

@implementation ISPropertyDescriptor {
@private
    objc_property_t property;
    BOOL isObjectType;
    NSString *attributesDescription;
}

@synthesize name;
@synthesize backingVariable;
@synthesize getter;
@synthesize setter;
@synthesize typeEncoding;
@synthesize setterSemanticsType;
@synthesize isReadOnly;
@synthesize isNonAtomic;
@synthesize isDynamic;
@synthesize isWeakReference;
@synthesize isEligibleForGarbageCollection;

+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inClass:(Class)class {
    objc_property_t property = class_getProperty(class, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    if (property == nil)
        return nil;
    
    return [ISPropertyDescriptor descriptorForProperty:property];
}

+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inProtocol:(Protocol*)protocol {
    objc_property_t property = protocol_getProperty(
        protocol, [name cStringUsingEncoding:NSASCIIStringEncoding], YES, YES
    );
    
    if (property == nil)
        return nil;
    
    return [ISPropertyDescriptor descriptorForProperty:property];
}

+ (ISPropertyDescriptor*) descriptorForProperty:(objc_property_t)property {
    return [[ISPropertyDescriptor alloc] initWithProperty:property];
}

- (id) initWithProperty:(objc_property_t)property {
    self = [super init];
    if (self) {
        self->property = property;
        name = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
        
        [self parsePropertyAttributeDescription:
            [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding]
        ];
    }
    
    return self;
}

- (void) setValue:(NSValue*)value inObject:(id)object {
    if (isReadOnly)
        @throw [ISInvalidStateException exceptionWithReason:@"Can't set readonly property"];
    
    if (isObjectType) {
        [object performSelector:setter withObject:[value nonretainedObjectValue]];
        return;
    }
    
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:setter]];
    [invocation setSelector:setter];
    NSMutableData* dataValue = [[value dataValue] mutableCopy];
    [invocation setArgument:[dataValue mutableBytes] atIndex:2];
    
    [invocation invokeWithTarget:object];
}

- (NSValue*) getValueFromObject:(id)object {
    if (isObjectType)
        return [NSValue valueWithNonretainedObject:[object performSelector:getter]];
    
    NSInvocation* invocation = [NSInvocation 
        invocationWithMethodSignature:[object methodSignatureForSelector:getter]
    ];
    [invocation setSelector:getter];
    [invocation invokeWithTarget:object];
    
    return [invocation getReturnValue];
}

- (void) setDefaultAttributeValues {
    getter = NSSelectorFromString(name);
    setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [name camelcaseString]]);
    setterSemanticsType = ISAssignSetterSemanticsType;
}

- (void) parsePropertyAttributeDescription:(NSString*)description {
    [self setDefaultAttributeValues];
    
    attributesDescription = description;
    NSArray* attributes = [description componentsSeparatedByString:@","];
    
    for (NSString *attribute in attributes) {
        if ([attribute hasPrefix:@"T"])
            typeEncoding = [attribute substringFromIndex:1];
        if ([attribute isEqualToString:@"R"])
            isReadOnly = YES;
        if ([attribute isEqualToString:@"C"])
            setterSemanticsType = ISCopySetterSemanticsType;
        if ([attribute isEqualToString:@"&"])
            setterSemanticsType = ISRetainSetterSemanticsType;
        if ([attribute isEqualToString:@"N"])
            isNonAtomic = YES;
        if ([attribute hasPrefix:@"G"])
            getter = NSSelectorFromString([attribute substringFromIndex:1]);
        if ([attribute hasPrefix:@"S"])
            setter = NSSelectorFromString([attribute substringFromIndex:1]);
        if ([attribute isEqualToString:@"D"])
            isDynamic = YES;
        if ([attribute isEqualToString:@"W"])
            isWeakReference = YES;
        if ([attribute isEqualToString:@"P"])
            isEligibleForGarbageCollection = YES;
        if ([attribute hasPrefix:@"V"])
            backingVariable = [attribute substringFromIndex:1];
    }
    
    if (isReadOnly)
        setter = nil;
    
    isObjectType = [typeEncoding 
        hasPrefix:[NSString stringWithCString:@encode(id) encoding:NSASCIIStringEncoding]
    ];
}

@end


