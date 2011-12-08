#import "NSObject+Introspection.h"

#import "ISClassDescriptor.h"
#import "ISMethodDescriptor.h"
#import "ISPropertyDescriptor.h"
#import "ISInstanceVariableDescriptor.h"
#import "ISProtocolDescriptor.h"

@implementation NSObject (Introspection)

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector {
    return [ISMethodDescriptor descriptorForSelector:selector inClass:[self class]];
}

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance {
    return [ISMethodDescriptor descriptorForSelector:selector inClass:[self class] instance:isInstance];
}

- (ISPropertyDescriptor*) propertyWithName:(NSString*)name {
    return [ISPropertyDescriptor descriptorForName:name inClass:[self class]];
}

- (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name {
    return [ISInstanceVariableDescriptor descriptorForName:name inClass:[self class]];
}
 
- (ISClassDescriptor*) descriptor {
    return [ISClassDescriptor descriptorForClass:[self class]];
}

- (NSArray*) methodsInstance:(BOOL)isInstance {
    return [self.descriptor methodsInstance:isInstance];
}

- (NSArray*) protocols {
    return self.descriptor.protocols;
}

- (NSArray*) methods {
    return self.descriptor.methods;
}

- (NSArray*) properties {
    return self.descriptor.properties;
}

- (NSArray*) instanceVariables {
    return self.descriptor.instanceVariables;
}

@end
