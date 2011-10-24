#import "InstanceVariableDescriptorTests.h"
#import "ISInstanceVariableDescriptor.h"
#import "ClassWithInstanceVariables.h"

@implementation InstanceVariableDescriptorTests

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
    
    id value = (NSString*)[descriptor getValueFromObject:instance];
    
    STAssertEqualObjects(@"SomeString", value, nil);
}

- (void)testSetObjectValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    [descriptor setValue:@"SomeString" inObject:instance];
    
    STAssertEqualObjects(@"SomeString", instance->publicString, nil);
}

- (void)testGetValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    instance->publicInt = 123;
    
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    int value = (int)[descriptor getValueFromObject:instance];
    
    STAssertEquals(123, value, nil);
}

- (void)testSetValue {
    ClassWithInstanceVariables *instance = [ClassWithInstanceVariables new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[ClassWithInstanceVariables class]
    ];
    
    [descriptor setValue:(void*)111 inObject:instance];
    
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
