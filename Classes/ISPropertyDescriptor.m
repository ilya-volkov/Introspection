#import "ISPropertyDescriptor.h"
#import "ISSetterSemanticsType.h"
#import "ISInvalidStateException.h"

#import "NSString+Extensions.h"

@implementation ISPropertyDescriptor {
@private
    objc_property_t property;
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

// TODO: add override with binding flags + UTs
+ (ISPropertyDescriptor*)descriptorForPropertyName:(NSString*)name inClass:(Class)aClass {
    objc_property_t property = class_getProperty(aClass, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    if (property == nil)
        return nil;
    
    return [ISPropertyDescriptor descriptorForProperty:property];
}

+ (ISPropertyDescriptor*)descriptorForProperty:(objc_property_t)aProperty {
    return [[ISPropertyDescriptor alloc] initWithProperty:aProperty];
}

- (void)setDefaultAttributeValues {
    getter = NSSelectorFromString(name);
    setter = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [name camelcaseString]]);
    setterSemanticsType = ISAssignSetterSemanticsType;
}

- (void)parsePropertyAttributeDescription:(NSString*)description {
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
}

- (id)initWithProperty:(objc_property_t)aProperty {
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

// TOOD: check standard exceptions
- (void)setValue:(void*)value inObject:(id)anObject {
    if (isReadOnly)
        @throw [ISInvalidStateException exceptionWithReason:@"Can't set readonly property"];
        
    [anObject performSelector:setter withObject:(__bridge id)value];
}

- (void*)getValueFromObject:(id)anObject {
    return (__bridge void*)[anObject performSelector:getter];
}

@end


