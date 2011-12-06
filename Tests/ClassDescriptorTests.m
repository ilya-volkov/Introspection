#import "ClassDescriptorTests.h"
#import "ISClassDescriptor.h"
#import "ClassWithProperties.h"
#import "ClassWithInstanceVariables.h"
#import "DerivedClassWithMethods.h"

#import "SenTestCase+CollectionAssert.h"
#import "NSArray+CollectionQuery.h"

@implementation ClassDescriptorTests

- (void)testListAllClasses {
    NSArray *classes = [ISClassDescriptor allClasses];    
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"ClassWithProperties", 
            @"ClassWithInstanceVariables", 
            @"ClassWithMethods", nil
        ] 
        isSubsetOfCollection:names
    ];
}

- (void)testListClassesInBundle {
    NSArray *classes = [ISClassDescriptor 
        classesInBundle:[NSBundle bundleWithIdentifier:@"com.ilyavolkov.IntrospectionTests"]
    ];
    NSArray *names = [classes selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"ClassWithProperties", 
            @"ClassWithInstanceVariables", 
            @"ClassWithMethods", nil
        ] 
        isSubsetOfCollection:names
    ];
}

- (void)testCreateDescriptorForClassName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"ClassWithProperties"];
    
    STAssertEqualObjects(@"ClassWithProperties", descriptor.name, nil);
}

- (void)testCreateDescriptorForClassNameFails {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClassName:@"NotExistentClass"];
    
    STAssertNil(descriptor, nil);
}

- (void)testGetName {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithProperties class]];
    
    STAssertEqualObjects(@"ClassWithProperties", descriptor.name, nil);
}

- (void)testClassRespondsToSelector {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    STAssertTrue([descriptor classRespondsToSelector:@selector(instanceProtocolMethod:)], nil);
}

- (void)testClassNotRespondsToSelector {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    STAssertFalse([descriptor classRespondsToSelector:@selector(notExistentSelector:)], nil);
}

- (void)testClassConformsToProtocol {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    STAssertTrue([descriptor classConformsToProtocol:@protocol(ProtocolWithMethods)], nil);
}

- (void)testClassConformsToBaseProtocol {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    STAssertTrue([descriptor classConformsToProtocol:@protocol(BaseProtocolWithMethods)], nil);
}

- (void)testClassNotConformsToProtocol {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    STAssertTrue([descriptor classConformsToProtocol:@protocol(ProtocolWithProperties)], nil);
}

- (void)testClassSuperclass {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    STAssertEqualObjects(@"ClassWithMethods", descriptor.classSuperclass.name, nil);
}

- (void)testNSObjectClassSuperclass {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[NSObject class]];
    
    STAssertNil(descriptor.classSuperclass.name, nil);
}

- (void)testGetBundle {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithProperties class]];
    
    STAssertEqualObjects(@"com.ilyavolkov.IntrospectionTests", [descriptor.bundle bundleIdentifier], nil);
}

- (void)testClassVersion {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithProperties class]];

    STAssertEqualObjects([NSNumber numberWithUnsignedInteger:1], descriptor.classVersion, nil);
}

- (void)testInstanceVariablesLayout {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithInstanceVariables class]];
    
    NSString *r = descriptor.instanceVariablesLayout;
    STAssertEqualObjects(@"", descriptor.instanceVariablesLayout, nil);
}

- (void)testWeakInstanceVariableLayout {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithInstanceVariables class]];
    
    NSString *r = descriptor.weakInstanceVariablesLayout;
    STAssertEqualObjects(@"", descriptor.weakInstanceVariablesLayout, nil);
}

/* 
 - (NSArray*) methodsInstance:(BOOL)isInstance;
 @property (readonly) NSArray* protocols;
 @property (readonly) NSArray* methods;
 @property (readonly) NSArray* properties;
 @property (readonly) NSArray* instanceVariables;
 */

- (void)testListMethods {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    NSArray *names = [descriptor.methods selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"methodWithNonUniqueName",
            @"classMethodWithoutParameters",
            @"classProtocolMethod:",
            @"baseClassProtocolMethod:",
            @"methodWithNonUniqueNameInProtocol",
            @"mehtodWithoutReturnValue",
            @"methodWithNonUniqueName",
            @"instanceMethodWithoutParametersReturnsString",
            @"methodForChangingImplementation",
            @"instanceMethodWithoutParametersReturnsInt",
            @"instanceMethodWithParametersFirst:second:third:",
            @"instanceProtocolMethod:",
            @"instanceProtocolMethodWithParametersFirst:second:third:",
            @"methodWithNonUniqueNameInProtocol",
            @"requiredProtocolMethod",
            @"baseInstanceProtocolMethod:", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListInstanceMethods {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    NSArray *names = [descriptor.methods selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"mehtodWithoutReturnValue",
            @"methodWithNonUniqueName",
            @"instanceMethodWithoutParametersReturnsString",
            @"methodForChangingImplementation",
            @"instanceMethodWithoutParametersReturnsInt",
            @"instanceMethodWithParametersFirst:second:third:",
            @"instanceProtocolMethod:",
            @"instanceProtocolMethodWithParametersFirst:second:third:",
            @"methodWithNonUniqueNameInProtocol",
            @"requiredProtocolMethod",
            @"baseInstanceProtocolMethod:", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListClassMethods {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    NSArray *names = [descriptor.methods selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"methodWithNonUniqueName",
            @"classMethodWithoutParameters",
            @"classProtocolMethod:",
            @"baseClassProtocolMethod:",
            @"methodWithNonUniqueNameInProtocol", nil
        ] 
        isEquivalentToCollection:names
    ];

}

- (void)testListProperties {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithProperties class]];
    
    NSArray *names = [descriptor.properties selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"idDynamicReadonly",
            @"idRetainNonatomic",
            @"structNonatomic",
            @"intGetterSetter",
            @"intNonatomic",
            @"intDynamicNonatomic",
            @"idCopy", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListInstanceVariables {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[ClassWithInstanceVariables class]];
    
    NSArray *names = [descriptor.instanceVariables selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"packageInt",
            @"packageString",
            @"privateInt",
            @"privateString",
            @"protectedInt",
            @"protectedString",
            @"publicInt",
            @"publicString",
            @"publicStruct", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListProtocols {
    ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[DerivedClassWithMethods class]];
    
    NSArray *names = [descriptor.protocols selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"ProtocolWithMethods", nil
        ] 
        isEquivalentToCollection:names
    ];
}

@end
