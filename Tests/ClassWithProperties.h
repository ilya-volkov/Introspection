#import <Foundation/Foundation.h>

#import "TestStruct.h"

@interface ClassWithProperties : NSObject

@property (readonly) id idDynamicReadonly;
@property (nonatomic, strong) id idRetainNonatomic;
@property (nonatomic) TestStruct structNonatomic;
@property (getter=intGetFoo, setter=intSetFoo:) int intGetterSetter;
@property (nonatomic) int intNonatomic;
@property (nonatomic) int intDynamicNonatomic;
@property (copy) id idCopy;

@end
