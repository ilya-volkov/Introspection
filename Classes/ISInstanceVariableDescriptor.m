#import "ISInstanceVariableDescriptor.h"

@implementation ISInstanceVariableDescriptor {
@private
    Ivar ivar;
}

@synthesize name;
@synthesize typeEncoding;

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
    }
    
    return self;
}

- (void)setValue:(void*)value inObject:(id)anObject {
    object_setIvar(anObject, ivar, (__bridge id)value);
}

- (void*)getValueFromObject:(id)anObject {
    return (__bridge void*)object_getIvar(anObject, ivar);
}

@end
