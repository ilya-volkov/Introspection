#import <Foundation/Foundation.h>

@interface SimpleClass : NSObject {
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

@property (readonly) id idDynamicReadonly;
@property (nonatomic, strong) id idRetainNonatomic;
@property (getter=intGetFoo, setter=intSetFoo:) int intGetterSetter;
@property (nonatomic) int intNonatomic;
@property (nonatomic) int intDynamicNonatomic;
@property (copy) id idCopy;

@end
