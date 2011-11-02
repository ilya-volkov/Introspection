#import "ClassDescriptorTests.h"
#import "ISClassDescriptor.h"
#import "ClassWithProperties.h"
#import "ClassWithInstanceVariables.h"

#import "SenTestCase+CollectionAssert.h"
#import "NSArray+CollectionQuery.h"

@implementation ClassDescriptorTests

- (void)setUp {
    [super setUp];
    
    [self raiseAfterFailure];
}

- (void)testCreateDescriptorForClassName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"ClassWithProperties"];
    
    STAssertEqualObjects(@"ClassWithProperties", descriptor.name, nil);
}

- (void)testCreateDescriptorForClassNameFails {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"NotExistingClass"];
    
    STAssertNil(descriptor, nil);
}


- (void)testListAllClasses {
    NSArray *classes = [ISClassDescriptor allClasses];    
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:@"ClassWithProperties", @"ClassWithInstanceVariables", nil] 
        isSubsetOfCollection:names
    ];
}

- (void)testListClassesInBundle {
    NSArray *classes = [ISClassDescriptor classesInBundle:[NSBundle bundleWithIdentifier:@"com.ilyavolkov.IntrospectionTests"]];
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:@"ClassWithProperties", @"ClassWithInstanceVariables", nil] 
        isSubsetOfCollection:names
    ];
}

- (void)testGetName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithProperties class]];
        
    STAssertEqualObjects(@"ClassWithProperties", descriptor.name, nil);
}

- (void)testGetBundle {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithProperties class]];
    
    STAssertEqualObjects(@"com.ilyavolkov.IntrospectionTests", [descriptor.bundle bundleIdentifier], nil);
}

@end
