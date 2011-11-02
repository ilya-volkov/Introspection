#import "ISInstanceVariableDescriptor.h"

@implementation ISInstanceVariableDescriptor {
@private
    Ivar ivar;
    BOOL isObjectType;
}

@synthesize name;
@synthesize typeEncoding;

// TODO: add override with bindign flags + UTs, static, instance
+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(NSString*)name inClass:(Class)aClass {
    Ivar ivar = class_getInstanceVariable(aClass, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    if (ivar == nil)
        return nil;
    
    return [ISInstanceVariableDescriptor descriptorForInstanceVariableName:ivar];
}

+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(Ivar)anInstanceVariable {
    return [[ISInstanceVariableDescriptor alloc] initWithInstanceVariable:anInstanceVariable];
}

- (id)initWithInstanceVariable:(Ivar)anInstanceVariable {
    self = [super init];
    if (self) {
        ivar = anInstanceVariable;
        name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSASCIIStringEncoding];
        typeEncoding = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSASCIIStringEncoding];
        isObjectType = [typeEncoding 
            hasPrefix:[NSString stringWithCString:@encode(id) encoding:NSASCIIStringEncoding]
        ];
            
    }
    
    return self;
}

- (void)setValue:(NSValue*)value inObject:(id)anObject {
    if (isObjectType) {
        object_setIvar(anObject, ivar, [value nonretainedObjectValue]);
        return;
    }
    
    void *valuePointer = (__bridge void *)anObject + ivar_getOffset(ivar);
    [value getValue:valuePointer];
}

- (NSValue*)getValueFromObject:(id)anObject {
    if (isObjectType)
        return [NSValue valueWithNonretainedObject:object_getIvar(anObject, ivar)];
    
    void *valuePointer = (__bridge void *)anObject + ivar_getOffset(ivar);
    return [NSValue 
        valueWithBytes:valuePointer
        objCType:[typeEncoding cStringUsingEncoding:NSASCIIStringEncoding]
    ];
}

@end
