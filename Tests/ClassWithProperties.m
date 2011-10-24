#import "ClassWithProperties.h"
#import "PropertyImplementation.h"

@implementation ClassWithProperties{
    PropertyImplementation *implementation;
}

@dynamic idDynamicReadonly;
@dynamic intDynamicNonatomic;

@synthesize idRetainNonatomic;
@synthesize intGetterSetter;
@synthesize intNonatomic;
@synthesize idCopy;

- (id)init {
    self = [super init];
    if (self != nil) {
        implementation = [PropertyImplementation new];
    }
    
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL isDynamicNonatomicProperty = aSelector == @selector(intDynamicNonatomic)
    || aSelector == @selector(setIntDynamicNonatomic:);
    if (isDynamicNonatomicProperty)
        return YES;
    
    return [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation*)anInvocation {
    BOOL isDynamicNonatomicProperty = [anInvocation selector] == @selector(intDynamicNonatomic)
    || [anInvocation selector] == @selector(setIntDynamicNonatomic:);
    
    if (isDynamicNonatomicProperty)
        [anInvocation invokeWithTarget:implementation];
}


@end
