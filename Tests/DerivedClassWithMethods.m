#import "DerivedClassWithMethods.h"

@implementation DerivedClassWithMethods

+ (void)methodWithNonUniqueName {
}

+ (NSString*)classMethodWithoutParameters {
    return @"classMethodWithoutParameters";
}

+ (NSString*)classProtocolMethod:(NSString *)arg1 {
    return [@"classProtocolMethod" stringByAppendingString:arg1];
}

+ (NSString*) baseClassProtocolMethod:(NSString*)arg1 { return nil; }

+ (void) methodWithNonUniqueNameInProtocol {}

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

- (NSString*)instanceProtocolMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3 {
    return [NSString stringWithFormat:@"%@:%i:%.1f:%i", param1, param2, param3.field1, param3.field2];
}

- (void) methodWithNonUniqueNameInProtocol {}

- (void) requiredProtocolMethod {}

- (NSString*) baseInstanceProtocolMethod:(NSString*)arg1 { return nil; }

@end
