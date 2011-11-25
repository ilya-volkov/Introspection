#import "DerivedClassWithMethods.h"
#import "TestStruct.h"

@implementation DerivedClassWithMethods

+ (void)methodWithNonUniqueName {
}

+ (NSString*)classMethodWithoutParameters {
    return @"classMethodWithoutParameters";
}

+ (NSString*)classProtocolMethod:(NSString *)arg1 {
    return [@"classProtocolMethod" stringByAppendingString:arg1];
}

- (void)mehtodWithoutReturnValue {
}

- (void)methodWithNonUniqueName {
}

- (NSString*)instanceMethodWithoutParametersReturnsString {
    return @"stringFromMethod";
}

- (NSString*)methodForChangingImplementation {
    return @"oldImplementation";
}

- (int)instanceMethodWithoutParametersReturnsInt {
    return 123;
}

- (NSString*)instanceMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3 {
    return [NSString stringWithFormat:@"%@:%i:%.1f:%i", param1, param2, param3.field1, param3.field2];
}

- (NSString *)instanceProtocolMethod:(NSString *)arg1 {
    return [@"instanceProtocolMethod" stringByAppendingString:arg1];
}

- (TestStruct)instanceMethodReturnsStruct {
    TestStruct result = { .field1 = 44.4, .field2 = 555 };
    
    return result;
}

@end
