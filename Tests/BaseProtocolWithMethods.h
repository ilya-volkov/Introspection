#import <Foundation/Foundation.h>
#import "SuperBaseProtocol.h"

@protocol BaseProtocolWithMethods <SuperBaseProtocol>

+ (NSString*) baseClassProtocolMethod:(NSString*)arg1;
- (NSString*) baseInstanceProtocolMethod:(NSString*)arg1;

@end
