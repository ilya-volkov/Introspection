#import "RaiseOnErrorTestCase.h"

@implementation RaiseOnErrorTestCase

- (void)setUp {
    [super setUp];
    
    [self raiseAfterFailure];
}

@end
