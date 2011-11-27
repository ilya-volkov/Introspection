#import <Foundation/Foundation.h>

#import "BaseProtocolWithMethods.h"

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

- (void) instanceProtocolMethod;
+ (void) classProtocolMethod;

@end
