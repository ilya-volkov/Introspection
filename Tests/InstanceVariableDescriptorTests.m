#import "InstanceVariableDescriptorTests.h"
#import "ISInstanceVariableDescriptor.h"
#import "SimpleClass.h"

@implementation InstanceVariableDescriptorTests

- (void)testGetName {
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"privateString" 
        inClass:[SimpleClass class]
    ];
    
    STAssertEqualObjects(@"privateString", descriptor.name, @"Descriptors name should be equal");
}

- (void)testGetObjectValue {
    SimpleClass *instance = [SimpleClass new];
    instance->publicString = @"SomeString";

    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[SimpleClass class]
    ];
    
    id value = (NSString*)[descriptor getValueFromObject:instance];
    
    STAssertEqualObjects(@"SomeString", value, @"Values should be equal");
}

- (void)testSetObjectValue {
    SimpleClass *instance = [SimpleClass new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[SimpleClass class]
    ];
    
    [descriptor setValue:@"SomeString" inObject:instance];
    
    STAssertEqualObjects(@"SomeString", instance->publicString, @"Values should be equal");
}

- (void)testGetValue {
    SimpleClass *instance = [SimpleClass new];
    instance->publicInt = 123;
    
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[SimpleClass class]
    ];
    
    int value = (int)[descriptor getValueFromObject:instance];
    
    STAssertEquals(123, value, @"Values should be equal");
}

- (void)testSetValue {
    SimpleClass *instance = [SimpleClass new];
    ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[SimpleClass class]
    ];
    
    [descriptor setValue:(void*)111 inObject:instance];
    
    STAssertEquals(111, instance->publicInt, @"Values should be equal");
}


- (void)testGetTypeEncoding {
    ISInstanceVariableDescriptor *descriptor1 = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicString" 
        inClass:[SimpleClass class]
    ];
    
    ISInstanceVariableDescriptor *descriptor2 = [ISInstanceVariableDescriptor 
        descriptorForInstanceVariableName:@"publicInt" 
        inClass:[SimpleClass class]
    ];
    
    //STAssertEqualObjects([NSString stringWithCString:@encode(NSString)], descriptor1.typeEncoding, @"Types should be equal");
    // Encode object type !!!
    STAssertEqualObjects(@"@\"NSString\"", descriptor1.typeEncoding, @"Types should be equal");
    STAssertEqualObjects([NSString stringWithCString:@encode(int)], descriptor2.typeEncoding, @"Types should be equal");
}

@end
