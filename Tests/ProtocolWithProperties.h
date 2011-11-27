#import <Foundation/Foundation.h>

@protocol ProtocolWithProperties <NSObject>
@required

@property (readonly, copy) NSString *requiredProperty;

@optional

@property (nonatomic) int optionalProperty;

@end
