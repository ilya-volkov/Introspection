#import "InstanceVariableDescriptorTests.h"
#import "ISInstanceVariableDescriptor.h"
#import "TestClass.h"

@implementation InstanceVariableDescriptorTests

- (void)testCreateDescriptorForInstanceVariableName {
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"privateString" 
        inClass:[TestClass class]
    ];
    
    STAssertEqualObjects(@"privateString", descriptor.name, nil);
}

- (void)testCreateDescriptorForInstanceVariableNameFails {
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"notExistingVariable" 
        inClass:[TestClass class]
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testGetObjectValue {
    TestClass *instance = [TestClass new];
    instance->publicString = @"SomeString";

    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[TestClass class]
    ];
    
    id value = (NSString*)[descriptor getValueFromObject:instance];
    
    STAssertEqualObjects(@"SomeString", value, nil);
}

- (void)testSetObjectValue {
    TestClass *instance = [TestClass new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[TestClass class]
    ];
    
    [descriptor setValue:@"SomeString" inObject:instance];
    
    STAssertEqualObjects(@"SomeString", instance->publicString, nil);
}

- (void)testGetValue {
    TestClass *instance = [TestClass new];
    instance->publicInt = 123;
    
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[TestClass class]
    ];
    
    int value = (int)[descriptor getValueFromObject:instance];
    
    STAssertEquals(123, value, nil);
}

- (void)testSetValue {
    TestClass *instance = [TestClass new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[TestClass class]
    ];
    
    [descriptor setValue:(void*)111 inObject:instance];
    
    STAssertEquals(111, instance->publicInt, nil);
}


- (void)testGetTypeEncoding {
    ISInstanceVariableDescriptor *descriptor1 = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[TestClass class]
    ];
    
    ISInstanceVariableDescriptor *descriptor2 = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[TestClass class]
    ];
    
    STAssertEqualObjects(@"@\"NSString\"", descriptor1.typeEncoding, nil);
    STAssertEqualObjects([NSString stringWithCString:@encode(int)], descriptor2.typeEncoding, nil);
}

@end
