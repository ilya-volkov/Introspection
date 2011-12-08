#import "SenTestCase+CollectionAssert.h"

@implementation SenTestCase (CollectionAssert)

- (void)assertCollection:(NSArray*)expected isEqualToCollection:(NSArray*)actual {
    STAssertEquals([expected count], [actual count], @"Collections count not equal");
    
    for (int i = 0; i < [expected count]; i++) {        
        STAssertEqualObjects(
            [expected objectAtIndex:i], 
            [actual objectAtIndex:i], 
            @"Elements at index %d not equal", i
        );
    }
}

- (void)assertCollection:(NSArray*)expected isEquivalentToCollection:(NSArray*)actual {
    STAssertEquals([expected count], [actual count], @"Collections count not equal");
    
    [self assertCollection:expected isSubsetOfCollection:actual];
}

- (void)assertCollection:(NSArray*)expected isSubsetOfCollection:(NSArray*)actual {
    NSMutableArray *actualCopy = [actual mutableCopy];
    for (int i = 0; i < [expected count]; i++) {
        NSUInteger index = [actualCopy indexOfObject:[expected objectAtIndex:i]];
        if (index == NSNotFound)
            STFail(@"Expected object at index %d not exists in actual collection", i);
        
        [actualCopy removeObjectAtIndex:index];
    }
}

- (void)assertObject:(id<NSObject>)anObject containsInCollection:(NSArray*)actual {
    STAssertTrue([actual containsObject:anObject], @"Collection don't contain an object");
}

- (void)assertObject:(id<NSObject>)anObject notContainsInCollection:(NSArray*)actual {
    STAssertFalse([actual containsObject:anObject], @"Collection contains an object");
}

@end
