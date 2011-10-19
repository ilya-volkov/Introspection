#import <SenTestingKit/SenTestingKit.h>

@interface SenTestCase (CollectionAssert)

- (void)assertCollection:(NSArray*)expected areEqualToCollection:(NSArray*)actual;
- (void)assertCollection:(NSArray*)expected areEquivalentToCollection:(NSArray*)actual;
- (void)assertCollection:(NSArray*)expected isSubsetOfCollection:(NSArray*)actual;
- (void)assertObject:(id<NSObject>)anObject containsInCollection:(NSArray*)actual;
- (void)assertObject:(id<NSObject>)anObject notContainsInCollection:(NSArray*)actual;

@end
