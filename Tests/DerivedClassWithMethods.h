#import <Foundation/Foundation.h>

#import "ClassWithMethods.h"
#import "ProtocolWithMethods.h"
#import "TestStruct.h"

@interface DerivedClassWithMethods : ClassWithMethods <ProtocolWithMethods>

+ (void)methodWithNonUniqueName;
+ (NSString*)classMethodWithoutParameters;

- (void)mehtodWithoutReturnValue;
- (void)methodWithNonUniqueName;
- (NSString*)instanceMethodWithoutParametersReturnsString;
- (NSString*)methodForChangingImplementation;
- (int)instanceMethodWithoutParametersReturnsInt;
- (NSString*)instanceMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3;

@end
