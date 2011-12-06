#import "ClassDescriptorTests.h"
#import "ISClassDescriptor.h"
#import "ClassWithProperties.h"
#import "ClassWithInstanceVariables.h"

#import "SenTestCase+CollectionAssert.h"
#import "NSArray+CollectionQuery.h"

@implementation ClassDescriptorTests

/*
 + (NSArray*) allClasses;
 + (NSArray*) classesInBundle:(NSBundle*)aBundle;
 + (ISClassDescriptor*) descriptorForClass:(Class)class;
 + (ISClassDescriptor*) descriptorForClassName:(NSString*)name;
 
 - (id) initWithClass:(Class)aClass;
 
 - (BOOL) classRespondsToSelector:(SEL)selector;
 - (BOOL) classConformsToProtocol:(ISProtocolDescriptor*)protocol;
 
 - (ISMethodDescriptor*) methodWithSelector:(SEL)selector;
 - (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance;
 - (ISPropertyDescriptor*) propertyWithName:(NSString*)name;
 - (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name;
 
 - (NSArray*) methodsInstance:(BOOL)isInstance;
 
 @property (readonly) ISClassDescriptor* classSuperclass;
 @property (readonly) NSNumber* classVersion;
 // TODO: Test ivar layout + weak layouts
 @property (readonly, copy) NSString* instanceVariablesLayout;
 @property (readonly, strong) NSBundle* bundle;
 
 @property (readonly) NSArray* protocols;
 @property (readonly) NSArray* methods;
 @property (readonly) NSArray* properties;
 @property (readonly) NSArray* instanceVariables;
 */

/*- (void)testCreateDescriptorForClassName {
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
}*/

@end
