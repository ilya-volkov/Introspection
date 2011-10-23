#import "ISPropertyDescriptor.h"
#import "ISInvalidStateException.h"

#import "PropertyDescriptorTests.h"
#import "SimpleClass.h"

@implementation PropertyDescriptorTests

- (void)testGetName {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idDynamicReadonly" 
        inClass:[SimpleClass class]
    ];
    
    STAssertEqualObjects(@"idDynamicReadonly", descriptor.name, nil);
}

- (void)testGetObjectValue {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[SimpleClass class]
    ];
    
    instance.idRetainNonatomic = @"String111";
    
    STAssertEqualObjects(@"String111", (id)[descriptor getValueFromObject:instance], nil);
}

- (void)testSetObjectValue {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[SimpleClass class]
    ];
    
    [descriptor setValue:@"String222" inObject:instance];
    
    STAssertEqualObjects(@"String222", instance.idRetainNonatomic, nil);
}

- (void)testGetValue {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intNonatomic" 
        inClass:[SimpleClass class]
    ];
    
    instance.intNonatomic = 333;
    
    STAssertEquals(333, (int)[descriptor getValueFromObject:instance], nil);
}

- (void)testSetValue {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intNonatomic" 
        inClass:[SimpleClass class]
    ];
    
    [descriptor setValue:(void*)222 inObject:instance];
    
    STAssertEquals(222, instance.intNonatomic, nil);
}

// TODO: fix dynamic tests (resarch dynamic method resolution and method forwarding)
/*- (void)testDynamicGetValue {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intDynamicNonatomic" 
        inClass:[SimpleClass class]
    ];
    
    instance.intDynamicNonatomic = 987;
    
    STAssertEquals(987, (int)[descriptor getValueFromObject:instance], nil);
}

- (void)testDynamicSetValue {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intDynamicNonatomic" 
        inClass:[SimpleClass class]
    ];
    
    [descriptor setValue:(void*)111 inObject:instance];
    
    STAssertEquals(111, instance.intDynamicNonatomic, nil);

}*/

- (void)testGetValueViaCustomGetter {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[SimpleClass class]
    ];
    
    instance.intGetterSetter = 432;
    
    STAssertEquals(432, (int)[descriptor getValueFromObject:instance], nil);
}

- (void)testSetValueViaCustomSetter {
    SimpleClass *instance = [SimpleClass new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[SimpleClass class]
    ];
    
    [descriptor setValue:(void*)555 inObject:instance];
    
    STAssertEquals(555, instance.intGetterSetter, nil);
}

- (void)testRetainNonatomicAttributesDescription {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[SimpleClass class]
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
        inClass:[SimpleClass class]
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
        inClass:[SimpleClass class]
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
        inClass:[SimpleClass class]
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
        inClass:[SimpleClass class]
    ];

    STAssertThrowsSpecific(
        [descriptor setValue:@"123" inObject:[SimpleClass new]], 
        ISInvalidStateException, 
        nil
    );
}

@end
