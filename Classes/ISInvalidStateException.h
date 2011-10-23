#import <Foundation/Foundation.h>

@interface ISInvalidStateException : NSException

+ (ISInvalidStateException*)exceptionWithReason:(NSString*)reason;

@end
