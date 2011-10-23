#import "ClassDescriptorTests.h"
#import "ISClassDescriptor.h"
#import "TestClass.h"

#import "SenTestCase+CollectionAssert.h"
#import "NSArray+CollectionQuery.h"

@implementation ClassDescriptorTests

- (void)setUp {
    [super setUp];
}

- (void)testCreateDescriptorForClassName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"TestClass"];
    
    STAssertEqualObjects(@"TestClass", descriptor.name, @"Classes names should be equal");
}

- (void)testCreateDescriptorForClassNameFails {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"NotExistingClass"];
    
    STAssertNil(descriptor, @"Class descriptor should be nil");
}


- (void)testListAllClasses {
    NSArray *classes = [ISClassDescriptor allClasses];    
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self assertCollection:[NSArray arrayWithObject:@"TestClass"] isSubsetOfCollection:names];
}

- (void)testListClassesInBundle {
    NSArray *classes = [ISClassDescriptor classesInBundle:[NSBundle bundleWithIdentifier:@"com.ilyavolkov.IntrospectionTests"]];
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self assertObject:@"TestClass" containsInCollection:names];
}

- (void)testGetName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[TestClass class]];
        
    STAssertEqualObjects(@"TestClass", descriptor.name, @"Class names not equal");
}

- (void)testGetBundle {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[TestClass class]];
    
    STAssertEqualObjects(@"com.ilyavolkov.IntrospectionTests", [descriptor.bundle bundleIdentifier], @"Class names not equal");
}

- (void)tearDown {
    [super tearDown];
}

@end
