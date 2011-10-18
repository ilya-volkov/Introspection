#import "ClassDescriptorTests.h"
#import "ISClassDescriptor.h"
#import "SimpleClass.h"

#import "SenTestCase+CollectionAssert.h"
#import "NSArray+CollectionQuery.h"

@implementation ClassDescriptorTests

- (void)setUp {
    [super setUp];
}

- (void)testCreateDescriptorForClass {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[SimpleClass class]];
    
    STAssertEqualObjects(@"SimpleClass", descriptor.name, @"Class names not equal");
}

- (void)testCreateDescriptorForClassName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"SimpleClass"];
    
    STAssertEqualObjects(@"SimpleClass", descriptor.name, @"Class names not equal");
}

- (void)testListAllClasses {
    NSArray *classes = [ISClassDescriptor allClasses];    
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self assertCollection:[NSArray arrayWithObject:@"SimpleClass"] isSubsetOfCollection:names];
}

- (void)tearDown {
    [super tearDown];
}

@end
