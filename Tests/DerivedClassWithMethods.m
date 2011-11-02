#import "DerivedClassWithMethods.h"

@implementation DerivedClassWithMethods

+ (void)methodWithNonUniqueName {
}

+ (NSString*)classMethodWithoutParameters {
    return @"classMethodWithoutParameters";
}

- (void)mehtodWithoutReturnValue {
}

- (void)methodWithNonUniqueName {
}

- (NSString*)instanceMethodWithoutParametersReturnsString {
    return @"stringFromMethod";
}

- (int)instanceMethodWithoutParametersReturnsInt {
    return 123;
}

- (NSString*)instanceMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3 {
    return [NSString stringWithFormat:@"%@:%i:%.1f:%i", param1, param2, param3.field1, param3.field2];
}

@end
