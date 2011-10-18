#import "SenTestCase+CollectionAssert.h"

@implementation SenTestCase (CollectionAssert)

- (void)assertCollection:(NSArray*)expected areEqualToCollection:(NSArray*)actual {
    STAssertEquals([expected count], [actual count], @"Collections count not equal");
    
    for (int i = 0; i < [expected count]; i++) {        
        STAssertEquals(
            [expected objectAtIndex:i], 
            [actual objectAtIndex:i], 
            @"Elements at index %d not equal", i
        );
    }
}

- (void)assertCollection:(NSArray*)expected areEquivalentToCollection:(NSArray*)actual {
    STAssertEquals([expected count], [actual count], @"Collections count not equal");
    
    [self assertCollection:expected isSubsetOfCollection:actual];
}

- (void)assertCollection:(NSArray*)expected isSubsetOfCollection:(NSArray*)actual {
    for (int i = 0; i < [expected count]; i++) {
        BOOL contains = [actual containsObject:[expected objectAtIndex:i]];
        if (!contains)
            STFail(@"Expected object at index %d not exists in actual collection", i);
    }
}

@end
