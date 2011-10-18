#import <SenTestingKit/SenTestingKit.h>

@interface SenTestCase (CollectionAssert)

- (void)assertCollection:(NSArray*)expected areEqualToCollection:(NSArray*)actual;
- (void)assertCollection:(NSArray*)expected areEquivalentToCollection:(NSArray*)actual;
- (void)assertCollection:(NSArray*)expected isSubsetOfCollection:(NSArray*)actual;

@end
