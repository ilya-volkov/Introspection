#import "ISMethodDescriptor.h"

@implementation ISMethodDescriptor {
@private
    Method method;
}

@synthesize isStatic;
@synthesize returnTypeEncoding;
@synthesize argumentTypeEncodings;
@synthesize methodSelector;
@synthesize implementation;

// TODO: add override with binding flags + UTs
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
        // TODO init properties
    }
    
    return self;
}

- (id)invokeOnObject:(id)anObject withArguments:(NSArray*)args {
    return nil;
}

@end
