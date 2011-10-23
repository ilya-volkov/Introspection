#import "ISPropertyDescriptor.h"
#import "ISInvalidStateException.h"

#import "PropertyDescriptorTests.h"
#import "TestClass.h"

@implementation PropertyDescriptorTests

- (void)testCreateDescriptorForPropertyName {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idDynamicReadonly" 
        inClass:[TestClass class]
    ];
    
    STAssertEqualObjects(@"idDynamicReadonly", descriptor.name, nil);
}

- (void)testCreateDescriptorForPropertyNameFails {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"notExistingProperty" 
        inClass:[TestClass class]
    ];
    
    STAssertNil(descriptor, nil);
}


- (void)testGetName {

}

- (void)testGetObjectValue {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[TestClass class]
    ];
    
    instance.idRetainNonatomic = @"String111";
    
    STAssertEqualObjects(@"String111", (id)[descriptor getValueFromObject:instance], nil);
}

- (void)testSetObjectValue {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[TestClass class]
    ];
    
    [descriptor setValue:@"String222" inObject:instance];
    
    STAssertEqualObjects(@"String222", instance.idRetainNonatomic, nil);
}

- (void)testGetValue {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intNonatomic" 
        inClass:[TestClass class]
    ];
    
    instance.intNonatomic = 333;
    
    STAssertEquals(333, (int)[descriptor getValueFromObject:instance], nil);
}

- (void)testSetValue {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intNonatomic" 
        inClass:[TestClass class]
    ];
    
    [descriptor setValue:(void*)222 inObject:instance];
    
    STAssertEquals(222, instance.intNonatomic, nil);
}

// TODO: fix dynamic tests (resarch dynamic method resolution and method forwarding)
/*- (void)testDynamicGetValue {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intDynamicNonatomic" 
        inClass:[TestClass class]
    ];
    
    instance.intDynamicNonatomic = 987;
    
    STAssertEquals(987, (int)[descriptor getValueFromObject:instance], nil);
}

- (void)testDynamicSetValue {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intDynamicNonatomic" 
        inClass:[TestClass class]
    ];
    
    [descriptor setValue:(void*)111 inObject:instance];
    
    STAssertEquals(111, instance.intDynamicNonatomic, nil);

}*/

- (void)testGetValueViaCustomGetter {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[TestClass class]
    ];
    
    instance.intGetterSetter = 432;
    
    STAssertEquals(432, (int)[descriptor getValueFromObject:instance], nil);
}

- (void)testSetValueViaCustomSetter {
    TestClass *instance = [TestClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[TestClass class]
    ];
    
    [descriptor setValue:(void*)555 inObject:instance];
    
    STAssertEquals(555, instance.intGetterSetter, nil);
}

- (void)testRetainNonatomicAttributesDescription {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[TestClass class]
    ];
    
    STAssertEqualObjects(@"idRetainNonatomic", descriptor.backingVariable, nil);
    STAssertEquals(@selector(idRetainNonatomic), descriptor.getter, nil);
    STAssertEquals(@selector(setIdRetainNonatomic:), descriptor.setter, nil);
    STAssertEqualObjects(@"@", descriptor.typeEncoding, nil);
    STAssertEquals(ISRetainSetterSemanticsType, descriptor.setterSemanticsType, nil);
    STAssertEquals(NO, descriptor.isReadOnly, nil);
    STAssertEquals(YES, descriptor.isNonAtomic, nil);
    STAssertEquals(NO, descriptor.isDynamic, nil);
    STAssertEquals(NO, descriptor.isWeakReference, nil);
    STAssertEquals(NO, descriptor.isEligibleForGarbageCollection, nil);
}

- (void)testReadonlyCopyAttributesDescription {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idDynamicReadonly" 
        inClass:[TestClass class]
    ];
    
    STAssertNil(descriptor.backingVariable, nil);
    STAssertEquals(@selector(idDynamicReadonly), descriptor.getter, nil);
    STAssertTrue(descriptor.setter == nil, nil);
    STAssertEqualObjects(@"@", descriptor.typeEncoding, nil);
    STAssertEquals(ISAssignSetterSemanticsType, descriptor.setterSemanticsType, nil);
    STAssertEquals(YES, descriptor.isReadOnly, nil);
    STAssertEquals(NO, descriptor.isNonAtomic, nil);
    STAssertEquals(YES, descriptor.isDynamic, nil);
    STAssertEquals(NO, descriptor.isWeakReference, nil);
    STAssertEquals(NO, descriptor.isEligibleForGarbageCollection, nil);
}

- (void)testGetterSetterAttributesDescription {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[TestClass class]
    ];
    
    STAssertEqualObjects(@"intGetterSetter", descriptor.backingVariable, nil);
    STAssertEquals(@selector(intGetFoo), descriptor.getter, nil);
    STAssertEquals(@selector(intSetFoo:), descriptor.setter, nil);
    STAssertEqualObjects(@"i", descriptor.typeEncoding, nil);
    STAssertEquals(ISAssignSetterSemanticsType, descriptor.setterSemanticsType, nil);
    STAssertEquals(NO, descriptor.isReadOnly, nil);
    STAssertEquals(NO, descriptor.isNonAtomic, nil);
    STAssertEquals(NO, descriptor.isDynamic, nil);
    STAssertEquals(NO, descriptor.isWeakReference, nil);
    STAssertEquals(NO, descriptor.isEligibleForGarbageCollection, nil);
}

- (void)testCopyAttributesDescription {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idCopy" 
        inClass:[TestClass class]
    ];
    
    STAssertEqualObjects(@"idCopy", descriptor.backingVariable, nil);
    STAssertEquals(@selector(idCopy), descriptor.getter, nil);
    STAssertEquals(@selector(setIdCopy:), descriptor.setter, nil);
    STAssertEqualObjects(@"@", descriptor.typeEncoding, nil);
    STAssertEquals(ISCopySetterSemanticsType, descriptor.setterSemanticsType, nil);
    STAssertEquals(NO, descriptor.isReadOnly, nil);
    STAssertEquals(NO, descriptor.isNonAtomic, nil);
    STAssertEquals(NO, descriptor.isDynamic, nil);
    STAssertEquals(NO, descriptor.isWeakReference, nil);
    STAssertEquals(NO, descriptor.isEligibleForGarbageCollection, nil);
}

- (void)testSetReadonlyPropertyFails {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idDynamicReadonly" 
        inClass:[TestClass class]
    ];

    STAssertThrowsSpecific(
        [descriptor setValue:@"123" inObject:[TestClass new]], 
        ISInvalidStateException, 
        nil
    );
}

@end
