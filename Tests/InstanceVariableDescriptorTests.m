#import "InstanceVariableDescriptorTests.h"
#import "ISInstanceVariableDescriptor.h"
#import "ClassWithInstanceVariables.h"
#import "TestStruct.h"

@implementation InstanceVariableDescriptorTests

- (void)setUp {
    [super setUp];
    
    [self raiseAfterFailure];
}

- (void)testCreateDescriptorForInstanceVariableName {
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"privateString" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    STAssertEqualObjects(@"privateString", descriptor.name, nil);
}

- (void)testCreateDescriptorForInstanceVariableNameFails {
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"notExistingVariable" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testGetObjectValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    instance->publicString = @"SomeString";

    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    NSString* value = [[descriptor getValueFromObject:instance] nonretainedObjectValue];
    
    STAssertEqualObjects(@"SomeString", value, nil);
}

- (void)testSetObjectValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    [descriptor setValue:[NSValue valueWithNonretainedObject:@"SomeString"] inObject:instance];
    
    STAssertEqualObjects(@"SomeString", instance->publicString, nil);
}

- (void)testGetStructValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    TestStruct value = { .field1 = 111.1, .field2 = 222 };
    instance->publicStruct = value;
    
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicStruct" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    TestStruct actual;
    NSValue *structValue = [descriptor getValueFromObject:instance];
    [structValue getValue:&actual];
    
    TestStruct expected = { .field1 = 111.1, .field2 = 222 };
    STAssertEquals(expected, actual, nil);
}

- (void)testSetStructValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicStruct" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    TestStruct value = { .field1 = 222.2, .field2 = 444 };
    [descriptor setValue:[NSValue valueWithBytes:&value objCType:@encode(TestStruct)] inObject:instance];
    
    TestStruct expected = { .field1 = 222.2, .field2 = 444 };
    STAssertEquals(expected, instance->publicStruct, nil);
}

- (void)testGetValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    instance->publicInt = 123;
    
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    int intValue;
    NSValue *value = [descriptor getValueFromObject:instance];
    [value getValue:&intValue];
    
    STAssertEquals(123, intValue, nil);
}

- (void)testSetValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    int intValue = 111;
    [descriptor setValue:[NSValue valueWithBytes:&intValue objCType:@encode(int)] inObject:instance];
    
    STAssertEquals(111, instance->publicInt, nil);
}


- (void)testGetTypeEncoding {
    ISInstanceVariableDescriptor *descriptor1 = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    ISInstanceVariableDescriptor *descriptor2 = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    STAssertEqualObjects(@"@\"NSString\"", descriptor1.typeEncoding, nil);
    STAssertEqualObjects([NSString stringWithCString:@encode(int)], descriptor2.typeEncoding, nil);
}

@end
