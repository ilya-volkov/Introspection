#import "ISMethodDescriptor.h"
#import "ISAmbiguousMatchException.h"

#import "NSValue+Extensions.h"
#import "NSInvocation+Extensions.h"

// TODO: refactor get/set implementation

@implementation ISMethodDescriptor {
@private
    Method method;
    struct objc_method_description methodDescription;
}

@synthesize isInstanceMethod;
@synthesize returnTypeEncoding;
@synthesize argumentTypeEncodings;
@synthesize typeEncoding;
@synthesize selector;
@synthesize name;

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)aClass {
    Method instanceMethod = class_getInstanceMethod(aClass, selector);
    Method classMethod = class_getClassMethod(aClass, selector);
    
    return [ISMethodDescriptor descriptorForInstanceMethod:instanceMethod classMethod:classMethod];
}

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)aClass isInstance:(BOOL)isInstance {
    Method instanceMethod = nil;
    Method classMethod = nil;
    
    if (isInstance)
        instanceMethod = class_getInstanceMethod(aClass, selector);
    else
        classMethod = class_getClassMethod(aClass, selector);
    
    return [ISMethodDescriptor descriptorForInstanceMethod:instanceMethod classMethod:classMethod];
}

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)aProtocol {
    struct objc_method_description description = protocol_getMethodDescription(aProtocol, selector, YES, YES);
    if (description.name == NULL && description.types == NULL)
        return nil;
    
    
    // TODO: instance or static
    return [[ISMethodDescriptor alloc] initWithMethodDescription:description];
    
    /*if (isInstance)
        return [ISMethodDescriptor descriptorForInstanceMethod:method];
    else
        return [ISMethodDescriptor descriptorForClassMethod:method];*/
}

+ (ISMethodDescriptor*) descriptorForSelector: (SEL)selector 
                                   inProtocol: (Protocol*)aProtocol 
                                   isInstance: (BOOL)isInstance 
                                   isRequired: (BOOL)isRequired 
{
    /*Method methodDescription = protocol_getMethodDescription(aProtocol, selector, isRequired, isInstance);
    if (method == nil)
        return nil;
    
    if (isInstance)
        return [ISMethodDescriptor descriptorForInstanceMethod:method];
    else
        return [ISMethodDescriptor descriptorForClassMethod:method];*/
}

+ (ISMethodDescriptor*) descriptorForInstanceMethod:(Method)aMethod {
    return [[ISMethodDescriptor alloc] initWithInstanceMethod:aMethod];
}

+ (ISMethodDescriptor*) descriptorForClassMethod:(Method)aMethod {
    return [[ISMethodDescriptor alloc] initWithClassMethod:aMethod];
}

+ (ISMethodDescriptor*) descriptorForInstanceMethod:(Method)instanceMethod classMethod:(Method)classMethod {
    if (instanceMethod != nil && classMethod != nil)
        @throw [ISAmbiguousMatchException exceptionWithReason:@"More than one matching method found"];
    
    if (instanceMethod != nil)
        return [ISMethodDescriptor descriptorForInstanceMethod:instanceMethod];
    
    if (classMethod != nil)
        return [ISMethodDescriptor descriptorForClassMethod:classMethod];
    
    return nil;
}

- (id) initWithClassMethod:(Method)aMethod {
    self = [self initWithMethod:aMethod];
    if (self != nil)
        isInstanceMethod = NO;
    
    return self;
}

- (id) initWithInstanceMethod:(Method)aMethod {
    self = [self initWithMethod:aMethod];
    if (self != nil)
        isInstanceMethod = YES;
    
    return self;
}

- (IMP) implementation {
    return method_getImplementation(method);
}

- (void) setImplementation:(IMP)value {
    method_setImplementation(method, value);
}

- (NSValue*) invokeOnObject:(id)anObject withArguments:(NSArray*)args {
    NSInvocation *invocation = [NSInvocation 
        invocationWithMethodSignature:[anObject methodSignatureForSelector:selector]
    ];
   
    [invocation retainArguments];
    for (int i = 0; i < [args count]; i++) {
        NSMutableData *arg = [[[args objectAtIndex:i] dataValue] mutableCopy];
        [invocation setArgument:[arg mutableBytes] atIndex:i + 2];
    }
    [invocation setSelector:selector];
    [invocation invokeWithTarget:anObject];
    
    return [invocation getReturnValue];
}

- (void) initArgumentTypeEncodings {
    int argCount = method_getNumberOfArguments(method);
    NSMutableArray *argsEncoding = [NSMutableArray arrayWithCapacity:argCount];
    
    for (int i = 0; i < argCount; i++) {
        char *argType = method_copyArgumentType(method, i);
        [argsEncoding addObject:[NSString stringWithCString:argType encoding:NSASCIIStringEncoding]];
        free(argType);
    }
    
    argumentTypeEncodings = argsEncoding;
}

- (void) initProperties {
    selector = method_getName(method);
    name = NSStringFromSelector(selector);
    
    typeEncoding = [NSString stringWithCString:method_getTypeEncoding(method) encoding:NSASCIIStringEncoding];
    
    char *returnType = method_copyReturnType(method);
    returnTypeEncoding = [NSString stringWithCString:returnType encoding:NSASCIIStringEncoding];
    free(returnType);
    
    [self initArgumentTypeEncodings];
}

- (id) initWithMethod:(Method)aMethod {
    self = [super init];
    if (self != nil) {
        method = aMethod;
        
        [self initProperties];
    }
    
    return self;
}

// TODO: refactor
- (id) initWithMethodDescription:(struct objc_method_description)description {
    self = [super init];
    if (self != nil) {
        methodDescription = description;
        method = (Method)&description;
        
        [self initProperties];
    }
    
    return self;
}

@end
