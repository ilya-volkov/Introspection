#import <Foundation/Foundation.h>

#import "BaseProtocolWithProperties.h"

@protocol ProtocolWithProperties <BaseProtocolWithProperties>
@required

@property (readonly, copy) NSString *requiredProperty;

@optional

@property (nonatomic) int optionalProperty;

@end
