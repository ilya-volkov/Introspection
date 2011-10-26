#import <Foundation/Foundation.h>
#import "ClassWithMethods.h"

typedef struct _TestStruct {
    double field1;
    int field2;
} TestStruct;

@interface DerivedClassWithMethods : ClassWithMethods

+ (void)methodWithNonUniqueName;
+ (void)classMethodWithoutParameters;

- (void)methodWithNonUniqueName;
- (NSString*)instanceMethodWithoutParametersReturnsString;
- (int)instanceMethodWithoutParametersReturnsInt;
- (NSString*)overrideInstanceMethod;
- (NSString*)instanceMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct*)param3;
- (NSString*)instanceMethodWithVarArgs:(NSString*)param1, ... NS_REQUIRES_NIL_TERMINATION;

@end
