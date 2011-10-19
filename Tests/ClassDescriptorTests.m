#import "ClassDescriptorTests.h"
#import "ISClassDescriptor.h"
#import "SimpleClass.h"

#import "SenTestCase+CollectionAssert.h"
#import "NSArray+CollectionQuery.h"

@implementation ClassDescriptorTests

- (void)setUp {
    [super setUp];
}

- (void)testCreateDescriptorForClassName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"SimpleClass"];
    
    STAssertEqualObjects(@"SimpleClass", descriptor.name, @"Classes names should be equal");
}

- (void)testCreateDescriptorForClassNameFailed {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"NotExistingClass"];
    
    STAssertNil(descriptor, @"Class descriptor should be nil");
}


- (void)testListAllClasses {
    NSArray *classes = [ISClassDescriptor allClasses];    
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self assertCollection:[NSArray arrayWithObject:@"SimpleClass"] isSubsetOfCollection:names];
}

- (void)testListClassesInBundle {
    NSArray *classes = [ISClassDescriptor classesInBundle:[NSBundle bundleWithIdentifier:@"com.ilyavolkov.IntrospectionTests"]];
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self assertObject:@"SimpleClass" containsInCollection:names];
}

- (void)testGetName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[SimpleClass class]];
        
    STAssertEqualObjects(@"SimpleClass", descriptor.name, @"Class names not equal");
}

- (void)testGetBundle {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[SimpleClass class]];
    
    STAssertEqualObjects(@"com.ilyavolkov.IntrospectionTests", [descriptor.bundle bundleIdentifier], @"Class names not equal");
}

- (void)tearDown {
    [super tearDown];
}

@end
