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
@synthesize name;

+ (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name inClass:(Class)aClass {
    Method method = class_getInstanceMethod(aClass, NSSelectorFromString(name));
    if (method == nil)
        return nil;
    
    return [ISMethodDescriptor descriptorForMethod:method];
}

+ (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name inClass:(Class)aClass usingFlags:(ISBindingFlags)flags{
    // TODO: implement
    return nil;
}

+ (ISMethodDescriptor*)descriptorForMethod:(Method)aMethod {
    return [[ISMethodDescriptor alloc] initWithMethod:aMethod];
}

- (void)initPropertiesFor:(Method)aMethod {
    // TODO: isStatic determinition
    methodSelector = method_getName(aMethod);
    name = NSStringFromSelector(methodSelector);
    implementation = method_getImplementation(aMethod);
    returnTypeEncoding = [NSString stringWithCString: method_getTypeEncoding(aMethod) encoding:NSASCIIStringEncoding];
    // TODO: implement
}

- (id)initWithMethod:(Method)aMethod {
    self = [super init];
    if (self != nil) {
        method = aMethod;
        
        [self initPropertiesFor:aMethod];
    }
    
    return self;
}

// TODO: find alternative to NSValue for each argument
- (void*)invokeOnObject:(id)anObject withArguments:(NSArray*)args {
    return nil;
}

@end
