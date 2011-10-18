#import "NSArray+CollectionQuery.h"

@implementation NSArray (CollectionQuery)

- (NSArray*) selectUsingBlock:(Selector)selector {
    NSMutableArray* result = [NSMutableArray array];
    for (id item in self) {
        [result addObject:selector(item)];
    }
    
    return result;
}

- (NSArray*) filterUsingBlock:(Filter)filter {
    NSMutableArray* result = [NSMutableArray array];
    for (id item in self) {
        if (filter(item))
            [result addObject:item];
    }
    
    return result;
}

@end
