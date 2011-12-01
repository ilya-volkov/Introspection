#import "NSString+Extensions.h"

@implementation NSString (Extensions)

- (NSString*) camelcaseString {
    return [[[self substringToIndex:1] uppercaseString] 
        stringByAppendingString:[self substringFromIndex:1]
    ];
}

@end
