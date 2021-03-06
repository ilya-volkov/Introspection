#import "MethodDescriptorTests.h"
#import "ISMethodDescriptor.h"
#import "ISAmbiguousMatchException.h"

#import "DerivedClassWithMethods.h"
#import "TestStruct.h"

#import "SenTestCase+CollectionAssert.h"

NSString* newMethodImp(id self, SEL _cmd) {
    return @"newImplementation";
}

@implementation MethodDescriptorTests

- (ISMethodDescriptor*) descriptorForSelector:(SEL)selector {
    return [ISMethodDescriptor descriptorForSelector:selector inClass:[DerivedClassWithMethods class]];
}

- (ISMethodDescriptor*) descriptorForSelector:(SEL)selector instance:(BOOL)isInstance {
    return [ISMethodDescriptor 
        descriptorForSelector:selector
        inClass:[DerivedClassWithMethods class]
        instance:isInstance
    ];
}

- (ISMethodDescriptor*) descriptorInProtocolForSelector:(SEL)selector {
    return [ISMethodDescriptor descriptorForSelector:selector inProtocol:@protocol(ProtocolWithMethods)];
}

- (ISMethodDescriptor*) descriptorInProtocolForSelector:(SEL)selector instance:(BOOL)isInstance required:(BOOL)isRequired {
    return [ISMethodDescriptor 
        descriptorForSelector:selector
        inProtocol:@protocol(ProtocolWithMethods) 
        instance:isInstance
        required:isRequired
    ];
}

- (void) testCreateDescriptorForInstanceMethod {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(instanceMethodWithoutParametersReturnsString)];
    
    STAssertEqualObjects(@"instanceMethodWithoutParametersReturnsString", descriptor.name, nil);
}

- (void) testCreateDescriptorForClassMethod {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(classMethodWithoutParameters)];
    
    STAssertEqualObjects(@"classMethodWithoutParameters", descriptor.name, nil);
}

- (void) testCreateDescriptorForInheritedInstanceMethod {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(baseInstanceMethod)];
    
    STAssertEqualObjects(@"baseInstanceMethod", descriptor.name, nil);
}

- (void) testCreateDescirptorForInheritedClassMethod {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(baseClassMethod)];
    
    STAssertEqualObjects(@"baseClassMethod", descriptor.name, nil);
}

- (void) testCreateDescriptorForNotDeclaredMethodFails {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(notDeclared)];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreateDescriptorForNotDeclaredInstanceMethodFails {
    ISMethodDescriptor *descriptor = [self 
        descriptorForSelector:@selector(classMethodWithoutParameters)
        instance:YES
    ];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreateDescriptorForNotDeclaredClassMethodFails {
    ISMethodDescriptor *descriptor = [self 
        descriptorForSelector:@selector(instanceMethodWithoutParametersReturnsString)
        instance:NO
    ];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreatedDescriptorForMethodWithNonUniqueNameFails {
    STAssertThrowsSpecific(
        [self descriptorForSelector:@selector(methodWithNonUniqueName)], 
        ISAmbiguousMatchException, 
        nil
    );
}

- (void) testCreateDescriptorForInstanceMethodInProtocol {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(instanceProtocolMethod:)];
    
    STAssertEqualObjects(@"instanceProtocolMethod:", descriptor.name, nil);
}

- (void) testCreateDescriptorForClassMethodInProtocol {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(classProtocolMethod:)];
    
    STAssertEqualObjects(@"classProtocolMethod:", descriptor.name, nil);
}

- (void) testCreateDescriptorForInheritedInstanceMethodInProtocol {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(baseInstanceProtocolMethod:)];
    
    STAssertEqualObjects(@"baseInstanceProtocolMethod:", descriptor.name, nil);
}

- (void) testCreateDescirptorForInheritedClassMethodInProtocol {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(baseClassProtocolMethod:)];
    
    STAssertEqualObjects(@"baseClassProtocolMethod:", descriptor.name, nil);
}

- (void) testCreateDescriptorForNotDeclaredMethodInProtocolFails {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(notDeclared)];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreateDescriptorForNotDeclaredInstanceMethodInProtocolFails {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(classProtocolMethod:)
        instance:YES
        required:YES
    ];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreateDescriptorForNotDeclaredClassMethodInProtocolFails {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(instanceProtocolMethod:)
        instance:NO
        required:YES
    ];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreatedDescriptorForMethodWithNonUniqueNameInProtocolFails {
    STAssertThrowsSpecific(
        [self descriptorInProtocolForSelector:@selector(methodWithNonUniqueNameInProtocol)], 
        ISAmbiguousMatchException, 
        nil
    );
}

- (void) testCreateDescriptorForOptionalMethod {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(optionalProtocolMethod)
        instance:YES
        required:NO
    ];
    
    STAssertEqualObjects(@"optionalProtocolMethod", descriptor.name, nil);
}

- (void) testCreateDescriptorForRequiredMethod {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(requiredProtocolMethod)
        instance:YES
        required:YES
    ];
    
    STAssertEqualObjects(@"requiredProtocolMethod", descriptor.name, nil);

}

- (void) testCreateDescriptorForOptionalMethodFails {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(requiredProtocolMethod)
        instance:YES
        required:NO
    ];
    
    STAssertNil(descriptor, nil);
}

- (void) testCreateDescriptorForRequiredMethodFails {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(optionalProtocolMethod)
        instance:YES
        required:YES
    ];
    
    STAssertNil(descriptor, nil);
}

- (void) testGetSelectorInProtocol {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(instanceProtocolMethodWithParametersFirst:second:third:)
    ];
    
    STAssertEquals(@selector(instanceProtocolMethodWithParametersFirst:second:third:), descriptor.selector, nil);
}

- (void) testGetReturnTypeEncodingInProtocol {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(instanceProtocolMethodWithParametersFirst:second:third:)
    ];
    
    STAssertEqualObjects([NSString stringWithCString:@encode(id)], descriptor.returnTypeEncoding, nil);
}

- (void) testGetArgumentTypeEncodingsInProtocol {
    ISMethodDescriptor *descriptor = [self 
        descriptorInProtocolForSelector:@selector(instanceProtocolMethodWithParametersFirst:second:third:)
    ];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"@", @":", @"@", @"i", 
            [NSString stringWithCString:@encode(TestStruct)], 
            nil
        ] 
        isEqualToCollection:descriptor.argumentTypeEncodings
     ];
}

- (void) testGetSelector {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(instanceMethodWithParametersFirst:second:third:)];
    
    STAssertEquals(@selector(instanceMethodWithParametersFirst:second:third:), descriptor.selector, nil);
}

- (void) testGetReturnTypeEncoding {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(classMethodWithoutParameters)];
    
    STAssertEqualObjects([NSString stringWithCString:@encode(id)], descriptor.returnTypeEncoding, nil);
}

- (void) testGetArgumentTypeEncodings {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(instanceMethodWithParametersFirst:second:third:)];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"@", @":", @"@", @"i", 
            [NSString stringWithCString:@encode(TestStruct)], 
            nil
        ] 
        isEqualToCollection:descriptor.argumentTypeEncodings
    ];
}

- (void) testGetImplementation {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(methodForChangingImplementation)];
    IMP implementation = [descriptor implementationForClass:[DerivedClassWithMethods class]];
    
    DerivedClassWithMethods *instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"oldImplementation", 
        implementation(instance, @selector(instanceMethodWithoutParametersReturnsString)), 
        nil
    );
}

- (void) testSetImplementation {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(methodForChangingImplementation)];
    [descriptor setImplementationForClass:[DerivedClassWithMethods class] value:(IMP)newMethodImp];
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"newImplementation", 
        [instance methodForChangingImplementation], 
        nil
    );
}

- (void) testIsInstanceMethod {
    ISMethodDescriptor *classMethodDescriptor = [self descriptorForSelector:@selector(classMethodWithoutParameters)];
    ISMethodDescriptor *instanceMethodDescriptor = [
        self descriptorForSelector:@selector(instanceMethodWithoutParametersReturnsString)
    ];
    
    STAssertFalse(classMethodDescriptor.isInstanceMethod, nil);
    STAssertTrue(instanceMethodDescriptor.isInstanceMethod, nil);
}

- (void) testIsInstanceMethodInProtocol {
    ISMethodDescriptor *classMethodDescriptor = [self descriptorInProtocolForSelector:@selector(classProtocolMethod:)];
    ISMethodDescriptor *instanceMethodDescriptor = [self descriptorInProtocolForSelector:@selector(instanceProtocolMethod:)];
    
    STAssertFalse(classMethodDescriptor.isInstanceMethod, nil);
    STAssertTrue(instanceMethodDescriptor.isInstanceMethod, nil);
}

- (void) testInvokeInstanceMethodWithArguments {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(instanceMethodWithParametersFirst:second:third:)];
    DerivedClassWithMethods *instance = [DerivedClassWithMethods new];
    int arg2 = 222;
    TestStruct arg3 = { .field1 = 33.3, .field2 = 444 };
    
    NSArray *args = [NSArray arrayWithObjects:
        [NSValue valueWithNonretainedObject:@"arg1"],
        [NSValue valueWithBytes:&arg2 objCType:@encode(int)],
        [NSValue valueWithBytes:&arg3 objCType:@encode(TestStruct)],
        nil
    ];
    
    STAssertEqualObjects(
        @"arg1:222:33.3:444", 
        [[descriptor invokeOnObject:instance withArguments:args] nonretainedObjectValue],
        nil
    );
}

- (void) testInvokeInstanceMethodWithoutArgumentsReturnsString {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(instanceMethodWithoutParametersReturnsString)];
    
    DerivedClassWithMethods *instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"stringFromMethod", 
        [[descriptor invokeOnObject:instance withArguments:nil] nonretainedObjectValue],
        nil
    );
}

- (void) testInvokeInstanceMethodWithoutArgumentsReturnsInt {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(instanceMethodWithoutParametersReturnsInt)];
    
    DerivedClassWithMethods *instance = [DerivedClassWithMethods new];
    NSValue *intValue = [descriptor invokeOnObject:instance withArguments:nil];
    int actualValue;
    [intValue getValue:&actualValue];
    
    STAssertEquals(123, actualValue, nil);
}

- (void) testInvokeStaticMethodWithoutAruments {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(classMethodWithoutParameters)];
    
    STAssertEqualObjects(
        @"classMethodWithoutParameters", 
        [[descriptor invokeOnObject:[DerivedClassWithMethods class] withArguments:nil] nonretainedObjectValue],
        nil
    );
}

- (void) testInvokeInstanceMethodWithoutReturnValue {
    ISMethodDescriptor *descriptor = [self descriptorForSelector:@selector(methodWithoutReturnValue)];
    DerivedClassWithMethods *instance = [DerivedClassWithMethods new];

    STAssertNoThrow([descriptor invokeOnObject:instance withArguments:nil], nil);
}

- (void) testInvokeProtocolInstanceMethod {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(instanceProtocolMethod:)];
    
    NSArray *args = [NSArray arrayWithObject:[NSValue valueWithNonretainedObject:@"aaa"]];
    
    STAssertEqualObjects(
        @"instanceProtocolMethodaaa", 
        [[descriptor invokeOnObject:[DerivedClassWithMethods new] withArguments:args] nonretainedObjectValue], 
        nil
    );
}

- (void) testInvokeProtocolClassMethod {
    ISMethodDescriptor *descriptor = [self descriptorInProtocolForSelector:@selector(classProtocolMethod:)];
    
    NSArray *args = [NSArray arrayWithObject:[NSValue valueWithNonretainedObject:@"bbb"]];
    
    STAssertEqualObjects(
        @"classProtocolMethodbbb", 
        [[descriptor invokeOnObject:[DerivedClassWithMethods class] withArguments:args] nonretainedObjectValue], 
        nil
    );
}

@end
