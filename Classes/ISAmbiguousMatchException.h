#import <Foundation/Foundation.h>

@interface ISAmbiguousMatchException : NSException

+ (ISAmbiguousMatchException*)exceptionWithReason:(NSString*)reason;

@end
