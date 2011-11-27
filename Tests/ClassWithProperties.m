#import "ClassWithProperties.h"
#import "PropertyImplementation.h"

@implementation ClassWithProperties{
    PropertyImplementation *implementation;
}

@dynamic idDynamicReadonly;
@dynamic intDynamicNonatomic;

@synthesize idRetainNonatomic;
@synthesize structNonatomic;
@synthesize intGetterSetter;
@synthesize intNonatomic;
@synthesize idCopy;
@synthesize requiredProperty;
//@synthesize optionalProperty;

- (id)init {
    self = [super init];
    if (self != nil) {
        implementation = [PropertyImplementation new];
    }
    
    return self;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector {
    BOOL isDynamicNonatomicProperty = aSelector == @selector(intDynamicNonatomic)
                                      || aSelector == @selector(setIntDynamicNonatomic:);
    
    if (isDynamicNonatomicProperty)
        return [implementation methodSignatureForSelector:aSelector];
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation*)anInvocation {
    BOOL isDynamicNonatomicProperty = [anInvocation selector] == @selector(intDynamicNonatomic)
                                      || [anInvocation selector] == @selector(setIntDynamicNonatomic:);
    
    if (isDynamicNonatomicProperty)
        [anInvocation invokeWithTarget:implementation];
}


@end
