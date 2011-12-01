#import "ISMethodDescriptor.h"
#import "ISAmbiguousMatchException.h"

#import "NSValue+Extensions.h"
#import "NSInvocation+Extensions.h"

BOOL isMethodDescriptionEmpty(MethodDescription description) {
    return description.name == NULL && description.types == NULL;
}

@implementation ISMethodDescriptor {
@private
    Method method;
    MethodDescription methodDescription;
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
    
    if (instanceMethod != nil && classMethod != nil)
        @throw [ISAmbiguousMatchException exceptionWithReason:@"More than one matching method found"];
    
    if (instanceMethod != nil)
        return [ISMethodDescriptor descriptorForMethod:instanceMethod instance:YES];
    
    if (classMethod != nil) 
        return [ISMethodDescriptor descriptorForMethod:classMethod instance:NO];
    
    return nil;
}

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)class instance:(BOOL)isInstance {
    Method method = isInstance ? class_getInstanceMethod(class, selector)
                               : class_getClassMethod(class, selector);
    
    if (method == nil)
        return nil;
    
    return [ISMethodDescriptor descriptorForMethod:method instance:isInstance];
}

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)protocol {
    MethodDescription classDescription = protocol_getMethodDescription(protocol, selector, YES, NO);
    MethodDescription instanceDescription = protocol_getMethodDescription(protocol, selector, YES, YES);
    
    if (!isMethodDescriptionEmpty(instanceDescription) && !isMethodDescriptionEmpty(classDescription))
        @throw [ISAmbiguousMatchException exceptionWithReason:@"More than one matching method found"];
    
    if (!isMethodDescriptionEmpty(instanceDescription))
        return [ISMethodDescriptor descriptorForMethodDescription:instanceDescription instance:YES];
    
    if (!isMethodDescriptionEmpty(classDescription)) 
        return [ISMethodDescriptor descriptorForMethodDescription:classDescription instance:NO];
    
    return nil;
}

+ (ISMethodDescriptor*) descriptorForSelector: (SEL)selector 
                                   inProtocol: (Protocol*)protocol 
                                     instance: (BOOL)isInstance 
                                     required: (BOOL)isRequired 
{
    MethodDescription description = protocol_getMethodDescription(protocol, selector, isRequired, isInstance);
    if (description.name == NULL && description.types == NULL)
        return nil;
    
    return [ISMethodDescriptor descriptorForMethodDescription:description instance:isInstance];
}

+ (ISMethodDescriptor*) descriptorForMethod:(Method)method instance:(BOOL)isInstance {
    return [[ISMethodDescriptor alloc] initWithMethod:method instance:isInstance];
}

+ (ISMethodDescriptor*) descriptorForMethodDescription:(MethodDescription)methodDescription instance:(BOOL)isInstance {
    return [[ISMethodDescriptor alloc] initWithMethodDescription:methodDescription instance:isInstance];
}

- (id) initWithMethod:(Method)method instance:(BOOL)isInstance {
    self = [super init];
    if (self != nil) {
        self->method = method;
        isInstanceMethod = isInstance;
        
        [self initProperties];
    }
    
    return self;
}

- (id) initWithMethodDescription:(MethodDescription)methodDescription instance:(BOOL)isInstance {
    self->methodDescription = methodDescription;
    
    return [self initWithMethod:(Method)&(self->methodDescription) instance:isInstance];
}

- (IMP) implementationForClass:(Class)class {
    return class_getMethodImplementation(class, selector);
}

- (IMP) setImplementationForClass:(Class)class value:(IMP)value {
    Method m = isInstanceMethod ? class_getInstanceMethod(class, selector)
                                : class_getClassMethod(class, selector);
    
    if (m == nil)
        return nil;
    
    return method_setImplementation(m, value);
}

- (NSValue*) invokeOnObject:(id)object withArguments:(NSArray*)args {
    NSInvocation *invocation = [NSInvocation 
        invocationWithMethodSignature:[object methodSignatureForSelector:selector]
    ];
   
    [invocation retainArguments];
    for (int i = 0; i < [args count]; i++) {
        NSMutableData *arg = [[[args objectAtIndex:i] dataValue] mutableCopy];
        [invocation setArgument:[arg mutableBytes] atIndex:i + 2];
    }
    [invocation setSelector:selector];
    [invocation invokeWithTarget:object];
    
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

@end
