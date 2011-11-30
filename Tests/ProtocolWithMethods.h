#import <Foundation/Foundation.h>

#import "BaseProtocolWithMethods.h"
#import "TestStruct.h"

@protocol ProtocolWithMethods // <BaseProtocolWithMethods>
/*@required

+ (NSString*) classProtocolMethod:(NSString*)arg1;
+ (void) methodWithNonUniqueNameInProtocol;
- (NSString*) instanceProtocolMethod:(NSString*)arg1;
- (void) methodWithNonUniqueNameInProtocol;
- (void) requiredProtocolMethod;

@optional

- (void) optionalProtocolMethod;
*/

- (NSString*)instanceProtocolMethodWithParametersFirst:(NSString*)param1 second:(int)param2 third:(TestStruct)param3;


@end
