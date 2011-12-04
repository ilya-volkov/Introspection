#import <Foundation/Foundation.h>

#import "BaseProtocolWithMethods.h"
#import "BaseProtocol.h"
#import "TestStruct.h"

@protocol ProtocolWithMethods <BaseProtocolWithMethods, BaseProtocol>
@required

+ (void) methodWithNonUniqueNameInProtocol;
+ (NSString*) classProtocolMethod:(NSString*)arg1;

- (NSString*) instanceProtocolMethod:(NSString*)arg1;
- (NSString*) instanceProtocolMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3;
- (void) methodWithNonUniqueNameInProtocol;
- (void) requiredProtocolMethod;

@optional

- (void) optionalProtocolMethod;
+ (void) optionalClassProtocolMethod;

@end
