#import <Foundation/Foundation.h>

@protocol BaseProtocolWithMethods <NSObject>

+ (NSString*) baseClassProtocolMethod:(NSString*)arg1;
- (NSString*) baseInstanceProtocolMethod:(NSString*)arg1;

@end
