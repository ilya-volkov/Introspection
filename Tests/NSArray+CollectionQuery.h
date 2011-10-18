#import <Foundation/Foundation.h>

typedef id (^Selector)(id obj);
typedef BOOL (^Filter)(id obj);

@interface NSArray (CollectionQuery)

- (NSArray*) selectUsingBlock:(Selector)selector;
- (NSArray*) filterUsingBlock:(Filter)filter;

@end
