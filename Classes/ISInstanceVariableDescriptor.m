#import "ISInstanceVariableDescriptor.h"

@implementation ISInstanceVariableDescriptor

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
    if (self)
        ivar = anInstanceVariable;
    
    return self;
}

- (void)setValue:(id)value inObject:(id)anObject {
    object_setIvar(anObject, ivar, value);
}

- (id)getValueFromObject:(id)anObject {
    return object_getIvar(anObject, ivar);
}

- (NSString*) typeEncoding {
    return [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSASCIIStringEncoding];
}

- (NSString*) name {
    return [NSString stringWithCString:ivar_getName(ivar) encoding:NSASCIIStringEncoding];
}

@end
