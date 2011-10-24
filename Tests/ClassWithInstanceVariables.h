#import <Foundation/Foundation.h>

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
}

@end
