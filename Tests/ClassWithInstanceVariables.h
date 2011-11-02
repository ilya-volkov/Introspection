#import <Foundation/Foundation.h>
#import "TestStruct.h"

@interface ClassWithInstanceVariables : NSObject {
@package
    int packageInt;
    NSString *packageString;
@private
    int privateInt;
    NSString *privateString;
@protected
    int protectedInt;
    NSString *protectedString;
@public
    int publicInt;
    NSString *publicString;
    TestStruct publicStruct;
}

@end
