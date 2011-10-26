#import "DerivedClassWithMethods.h"

@implementation DerivedClassWithMethods

+ (void)methodWithNonUniqueName {
}

+ (void)classMethodWithoutParameters {
}

- (void)methodWithNonUniqueName {
}

- (NSString*)instanceMethodWithoutParametersReturnsString {
    return @"instanceMethodWithoutParameters";
}

- (int)instanceMethodWithoutParametersReturnsInt {
    return 123;
}

- (NSString*)instanceMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct*)param3 {
    return [NSString stringWithFormat:@"%@:%i:%f:%i", param1, param2, param3->field1, param3->field2];
}

- (NSString*)instanceMethodWithVarArgs:(NSString*)firstArg, ... {
    NSMutableString *result = [NSMutableString string];
    va_list args;
    va_start(args, firstArg);
    
    for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString*))
        [result appendString:arg];
    
    va_end(args);

    return result;
}

@end
