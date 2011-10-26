#import "MethodDescriptorTests.h"
#import "ISMethodDescriptor.h"
#import "ISAmbiguousMatchException.h"

#import "DerivedClassWithMethods.h"

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

- (void)testCreateDescriptorForNotDeclaredInTargetClassMethodFails {
    ISMethodDescriptor* descriptor = [self 
        descriptorForMethodName:@"baseInstanceMethod" 
        usingFlags:ISDeclaredOnlyBindingFlag
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testCreatedDescriptorForMethodWithNonUniqueNameFails {
    STAssertThrowsSpecific(
        [self descriptorForMethodName:@"notDeclared"], 
        ISAmbiguousMatchException, 
        nil
    );
}

- (void)testGetSelector {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    
    STAssertEquals(@selector(instanceMethodWithParametersFirst:second:third:), descriptor.methodSelector, nil);
}

- (void)testGetReturnTypeEncoding {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    
    STAssertEqualObjects([NSString stringWithCString:@encode(void)], descriptor.returnTypeEncoding, nil);
}

- (void)testGetArgumentTypeEncodings {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:@"@", @"i", @"#", nil] 
        isEqualToCollection:descriptor.argumentTypeEncodings
    ];
}

- (void)testGetImplementation {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    IMP implementation = descriptor.implementation;
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"instanceMethodWithoutParametersReturnsString", 
        implementation(instance, @selector(instanceMethodWithoutParameters)), 
        nil
    );
}

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


// TODO: finish 2 tests

/*- (void)testInvokeInstanceMethodWithArguments {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    
    STAssertEqualObjects(
        @"instanceMethodWithoutParametersReturnsString", 
        [descriptor invokeOnObject:instance withArguments:nil],
        nil
    );
}


- (void)testInvokeInstanceMethodWithVarArgs {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithParametersFirst:second:third:"];
    
}
*/

- (void)testInvokeInstanceMethodWithoutArgumentsReturnsString {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsString"];
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEqualObjects(
        @"instanceMethodWithoutParametersReturnsString", 
        [descriptor invokeOnObject:instance withArguments:nil],
        nil
    );
}

- (void)testInvokeInstanceMethodWithoutArgumentsReturnsInt {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"instanceMethodWithoutParametersReturnsInt"];
    
    DerivedClassWithMethods* instance = [DerivedClassWithMethods new];
    
    STAssertEquals(123, [descriptor invokeOnObject:instance withArguments:nil], nil);
}

- (void)testInvokeStaticMethodWithoutAruments {
    ISMethodDescriptor* descriptor = [self descriptorForMethodName:@"classMethodWithoutParameters"];
    
    STAssertEqualObjects(
        @"classMethodWithoutParameters", 
        [descriptor invokeOnObject:nil withArguments:nil],
        nil
    );
}

@end
