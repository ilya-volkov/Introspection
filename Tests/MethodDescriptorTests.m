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

- (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name {
    return [ISMethodDescriptor descriptorForMethodName:name inClass:[DerivedClassWithMethods class]];
}

- (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name usingFlags:(ISBindingFlags)flags {
    return [ISMethodDescriptor 
        descriptorForMethodName:name 
        inClass:[DerivedClassWithMethods class]
        usingFlags:flags
    ];
} 

- (void)testCreateDescriptorForInstanceMethod {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    
    STAssertEqualObjects(@"instanceMethodWithoutParametersReturnsString", descriptor.name, nil);
}

- (void)testCreateDescriptorForClassMethod {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"classMethodWithoutParameters"];
    
    STAssertEqualObjects(@"classMethodWithoutParameters", descriptor.name, nil);
}

- (void)testCreateDescriptorForInheritedInstanceMethod {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"baseInstanceMethod"];
    
    STAssertEqualObjects(@"baseInstanceMethod", descriptor.name, nil);
}

- (void)testCreateDescirptorForInheritedClassMethod {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"baseClassMethod"];
    
    STAssertEqualObjects(@"baseClassMethod", descriptor.name, nil);
}

- (void)testCreateDescriptorForNotDeclaredMethodFails {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"notDeclared"];
    
    STAssertNil(descriptor, nil);
}

- (void)testCreateDescriptorForNotDeclaredInstanceMethodFails {
    ISMethodDescriptor* descriptor = [self 
        descriptorForMethodName:@"classMethodWithoutParameters" 
        usingFlags:ISInstanceBindingFlag
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testCreateDescriptorForNotDeclaredClassMethodFails {
    ISMethodDescriptor* descriptor = [self 
        descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString" 
        usingFlags:ISStaticBindingFlag
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testCreateDescriptorWithEmptyFlagsFails {
    ISMethodDescriptor* descriptor = [self 
        descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString" 
        usingFlags:0
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testCreatedDescriptorForMethodWithNonUniqueNameFails {
    STAssertThrowsSpecific(
        [self descriptorForMethodName:@"methodWithNonUniqueName"], 
        ISAmbiguousMatchException, 
        nil
    );
}

- (void)testGetSelector {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    
    STAssertEquals(@selector(instanceMethodWithParametersFirst:second:third:), descriptor.methodSelector, nil);
}

- (void)testGetReturnTypeEncoding {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"classMethodWithoutParameters"];
    
    STAssertEqualObjects([NSString stringWithCString:@encode(id)], descriptor.returnTypeEncoding, nil);
}

- (void)testGetArgumentTypeEncodings {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"@", @":", @"@", @"i", 
            [NSString stringWithCString:@encode(TestStruct)], 
            nil
        ] 
        isEqualToCollection:descriptor.argumentTypeEncodings
    ];
}

- (void)testGetImplementation {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    IMP implementation = descriptor.implementation;
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"stringFromMethod", 
        implementation(instance, @selector(instanceMethodWithoutParametersReturnsString)), 
        nil
    );
}

// changes environment!!!
- (void)testSetImplementation {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    descriptor.implementation = (IMP)newMethodImp;
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"newImplementation", 
        [instance instanceMethodWithoutParametersReturnsString], 
        nil
    );
}

- (void)testIsStatic {
    ISMethodDescriptor* staticDescriptor = [self descriptorForMethodName:@"classMethodWithoutParameters"];
    ISMethodDescriptor* instanceDescriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    
    STAssertTrue(staticDescriptor.isStatic, nil);
    STAssertFalse(instanceDescriptor.isStatic, nil);
}

- (void)testInvokeInstanceMethodWithArguments {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    int arg2 = 222;
    TestStruct arg3 = { 33.3, 444 };
    
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

- (void)testInvokeInstanceMethodWithoutArgumentsReturnsString {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"stringFromMethod", 
        [[descriptor invokeOnObject:instance withArguments:nil] nonretainedObjectValue],
        nil
    );
}

- (void)testInvokeInstanceMethodWithoutArgumentsReturnsInt {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsInt"];
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    NSValue *intValue = [descriptor invokeOnObject:instance withArguments:nil];
    int actualValue;
    [intValue getValue:&actualValue];
    
    STAssertEquals(123, actualValue, nil);
}

- (void)testInvokeStaticMethodWithoutAruments {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"classMethodWithoutParameters"];
    
    STAssertEqualObjects(
        @"classMethodWithoutParameters", 
        [[descriptor invokeOnObject:[DerivedClassWithMethods class] withArguments:nil] nonretainedObjectValue],
        nil
    );
}

- (void)testInvokeInstanceMethodWithoutReturnValue {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"methodWithoutReturnValue"];
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];

    STAssertNoThrow([descriptor invokeOnObject:instance withArguments:nil], nil);
}

@end
