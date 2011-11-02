#import <Foundation/Foundation.h>

#import "ClassWithMethods.h"
#import "TestStruct.h"

@interface DerivedClassWithMethods : ClassWithMethods

+ (void)methodWithNonUniqueName;
+ (NSString*)classMethodWithoutParameters;

- (void)mehtodWithoutReturnValue;
- (void)methodWithNonUniqueName;
- (NSString*)instanceMethodWithoutParametersReturnsString;
- (int)instanceMethodWithoutParametersReturnsInt;
//- (NSString*)overrideInstanceMethod;
- (NSString*)instanceMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3;

@end
