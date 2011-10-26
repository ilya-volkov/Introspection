#import "ISAmbiguousMatchException.h"

@implementation ISAmbiguousMatchException

+ (ISAmbiguousMatchException*)exceptionWithReason:(NSString*)reason {
    return [[ISAmbiguousMatchException alloc] 
        initWithName:@"ISAmbiguousMatchException" 
        reason:reason 
        userInfo:nil
    ];
}


@end
