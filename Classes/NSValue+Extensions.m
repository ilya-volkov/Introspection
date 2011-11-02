#import "NSValue+Extensions.h"

@implementation NSValue (Extensions)

- (NSUInteger)size {
    NSUInteger size;
    NSGetSizeAndAlignment([self objCType], &size, nil);
    
    return size;
}

-(NSData*)dataValue {
    NSMutableData *data = [NSMutableData dataWithLength:self.size];
    [self getValue:[data mutableBytes]];

    return data;
}

@end
