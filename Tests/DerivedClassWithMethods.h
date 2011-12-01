#import <Foundation/Foundation.h>

#import "ClassWithMethods.h"
#import "ProtocolWithMethods.h"
#import "TestStruct.h"

@interface DerivedClassWithMethods : ClassWithMethods <ProtocolWithMethods>

+ (void)methodWithNonUniqueName;

- (void)mehtodWithoutReturnValue;
- (void)methodWithNonUniqueName;
- (NSString*)instanceMethodWithoutParametersReturnsString;
- (NSString*)methodForChangingImplementation;
- (int)instanceMethodWithoutParametersReturnsInt;

@end
