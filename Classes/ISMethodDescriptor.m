#import "ISMethodDescriptor.h"
#import "ISBindingFlags.h"
#import "ISCommon.h"
#import "ISAmbiguousMatchException.h"

#import "NSValue+Extensions.h"
#import "NSInvocation+Extensions.h"

@implementation ISMethodDescriptor {
@private
    Method method;
    NSString *typeEncoding;
}

@synthesize isStatic;
@synthesize returnTypeEncoding;
@synthesize argumentTypeEncodings;
@synthesize methodSelector;
@synthesize name;

+ (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name inClass:(Class)aClass {
    return [ISMethodDescriptor 
        descriptorForMethodName:name 
        inClass:aClass 
        usingFlags:ISStaticBindingFlag | ISInstanceBindingFlag
    ];
}

// TODO: support ISDeclaredOnlyBindingFlags ???
+ (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name inClass:(Class)aClass usingFlags:(ISBindingFlags)flags{
    Method instanceMethod = nil;
    Method classMethod = nil;
    
    if (isFlagSet(flags, ISInstanceBindingFlag))
        instanceMethod = class_getInstanceMethod(aClass, NSSelectorFromString(name));
    
    if (isFlagSet(flags, ISStaticBindingFlag))
        classMethod = class_getClassMethod(aClass, NSSelectorFromString(name));
    
    if (instanceMethod != nil && classMethod != nil)
        @throw [ISAmbiguousMatchException exceptionWithReason:@"More than one matching method found"];
    
    if (instanceMethod != nil)
        return [[ISMethodDescriptor alloc] initWithInstanceMethod:instanceMethod];
    
    if (classMethod != nil)
        return [[ISMethodDescriptor alloc] initWithClassMethod:classMethod];
    
    return nil;
}

+ (ISMethodDescriptor*)descriptorForMethod:(Method)aMethod {
    return [[ISMethodDescriptor alloc] initWithMethod:aMethod];
}

- (void)initArgumentTypeEncodings {
    int argCount = method_getNumberOfArguments(method);
    NSMutableArray *argsEncoding = [NSMutableArray arrayWithCapacity:argCount];
    
    for (int i = 0; i < argCount; i++) {
        char *argType = method_copyArgumentType(method, i);
        [argsEncoding addObject:[NSString stringWithCString:argType encoding:NSASCIIStringEncoding]];
        free(argType);
    }
    
    argumentTypeEncodings = argsEncoding;
}

- (void)initProperties {
    methodSelector = method_getName(method);
    name = NSStringFromSelector(methodSelector);
    
    typeEncoding = [NSString stringWithCString:method_getTypeEncoding(method) encoding:NSASCIIStringEncoding];
    
    char *returnType = method_copyReturnType(method);
    returnTypeEncoding = [NSString stringWithCString:returnType encoding:NSASCIIStringEncoding];
    free(returnType);
    
    [self initArgumentTypeEncodings];
}

- (id)initWithMethod:(Method)aMethod {
    self = [super init];
    if (self != nil) {
        method = aMethod;
        
        [self initProperties];
    }
    
    return self;
}

- (id)initWithClassMethod:(Method)aMethod {
    self = [self initWithMethod:aMethod];
    if (self != nil) {
        isStatic = YES;
    }
    
    return self;
}

- (id)initWithInstanceMethod:(Method)aMethod {
    self = [self initWithMethod:aMethod];
    if (self != nil) {
        isStatic = NO;
    }
    
    return self;
}

// TODO: get/set methods returning struct
- (IMP)implementation {
    return method_getImplementation(method);
}

- (void)setImplementation:(IMP)value {
    method_setImplementation(method, value);
}

- (NSValue*)invokeOnObject:(id)anObject withArguments:(NSArray*)args {
    NSInvocation *invocation = [NSInvocation 
        invocationWithMethodSignature:[anObject methodSignatureForSelector:methodSelector]
    ];
   
    [invocation retainArguments];
    for (int i = 0; i < [args count]; i++) {
        NSMutableData* arg = [[[args objectAtIndex:i] dataValue] mutableCopy];
        [invocation setArgument:[arg mutableBytes] atIndex:i + 2];
    }
    [invocation setSelector:methodSelector];
    [invocation invokeWithTarget:anObject];
    
    return [invocation getReturnValue];
}

@end
