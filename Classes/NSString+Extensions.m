#import "NSString+Extensions.h"

@implementation NSString (Extensions)


//TODO: fix NSString category for iOS tests target
- (NSString*) camelcaseString {
    return [[[self substringToIndex:1] uppercaseString] 
        stringByAppendingString:[self substringFromIndex:1]
    ];
}

@end
