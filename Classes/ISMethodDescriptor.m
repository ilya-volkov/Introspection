#import "ISMethodDescriptor.h"

@implementation ISMethodDescriptor {
@private
    Method method;
}

@synthesize isStatic;
@synthesize returnTypeEncoding;
@synthesize argumentsTypeEncodings;
@synthesize methodSelector;
@synthesize implementation;

// TODO: test with static methods
+ (ISMethodDescriptor*)descriptorForMethodName:(SEL)name inClass:(Class)aClass {
    Method method = class_getInstanceMethod(aClass, name);
    if (method == nil)
        return nil;
    
    return [ISMethodDescriptor descriptorForMethod:method];
}

+ (ISMethodDescriptor*)descriptorForMethod:(Method)aMethod {
    return [[ISMethodDescriptor alloc] initWithMethod:aMethod];
}

- (id)initWithMethod:(Method)aMethod {
    self = [super init];
    if (self != nil) {
        method = aMethod;
    }
    
    return self;
}

- (id)invokeOnObject:(id)anObject withArguments:(NSArray*)args {
    return nil;
}

@end
