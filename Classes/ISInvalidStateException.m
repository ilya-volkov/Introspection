#import "ISInvalidStateException.h"

@implementation ISInvalidStateException

+ (ISInvalidStateException*)exceptionWithReason:(NSString*)reason {
    return [[ISInvalidStateException alloc] 
        initWithName:@"ISInvalidStateException" 
        reason:reason 
        userInfo:nil
    ];
}

@end
        