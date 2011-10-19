#import <SenTestingKit/SenTestingKit.h>

@interface ClassDescriptorTests : SenTestCase

- (void)testCreateDescriptorForClassName;
- (void)testCreateDescriptorForClassNameFailed;
- (void)testListAllClasses;
- (void)testListClassesInBundle;
- (void)testGetName;
- (void)testGetBundle;

@end
