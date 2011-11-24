#import "ISPropertyDescriptor.h"
#import "ISSetterSemanticsType.h"
#import "ISInvalidStateException.h"

#import "NSString+Extensions.h"
#import "NSValue+Extensions.h"
#import "NSInvocation+Extensions.h"

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

// TODO: add override with binding flags + UTs, static, instance
+ (ISPropertyDescriptor*) descriptorForPropertyName:(NSString*)name inClass:(Class)aClass {
    objc_property_t property = class_getProperty(aClass, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    if (property == nil)
        return nil;
    
    return [ISPropertyDescriptor descriptorForProperty:property];
}

+ (ISPropertyDescriptor*) descriptorForProperty:(objc_property_t)aProperty {
    return [[ISPropertyDescriptor alloc] initWithProperty:aProperty];
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

- (id) initWithProperty:(objc_property_t)aProperty {
    self = [super init];
    if (self) {
        property = aProperty;
        name = [NSString stringWithCString:property_getName(aProperty) encoding:NSASCIIStringEncoding];
        
        [self parsePropertyAttributeDescription:
            [NSString stringWithCString:property_getAttributes(property) encoding:NSASCIIStringEncoding]
        ];
    }
    
    return self;
}

- (void) setValue:(NSValue*)value inObject:(id)anObject {
    if (isReadOnly)
        @throw [ISInvalidStateException exceptionWithReason:@"Can't set readonly property"];
    
    if (isObjectType) {
        [anObject performSelector:setter withObject:[value nonretainedObjectValue]];
        return;
    }
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[anObject methodSignatureForSelector:setter]];
    [invocation setSelector:setter];
    NSMutableData* dataValue = [[value dataValue] mutableCopy];
    [invocation setArgument:[dataValue mutableBytes] atIndex:2];
    
    [invocation invokeWithTarget:anObject];
}

- (NSValue*) getValueFromObject:(id)anObject {
    if (isObjectType)
        return [NSValue valueWithNonretainedObject:[anObject performSelector:getter]];
    
    NSInvocation* invocation = [NSInvocation 
        invocationWithMethodSignature:[anObject methodSignatureForSelector:getter]
    ];
    [invocation setSelector:getter];
    [invocation invokeWithTarget:anObject];
    
    return [invocation getReturnValue];
}

@end


