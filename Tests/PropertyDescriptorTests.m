#import "ISPropertyDescriptor.h"
#import "ISInvalidStateException.h"

#import "PropertyDescriptorTests.h"
#import "ClassWithProperties.h"

@implementation PropertyDescriptorTests

- (void)testCreateDescriptorForPropertyName {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idDynamicReadonly" 
        inClass:[ClassWithProperties class]
    ];
    
    STAssertEqualObjects(@"idDynamicReadonly", descriptor.name, nil);
}

- (void)testCreateDescriptorForPropertyNameFails {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"notExistingProperty" 
        inClass:[ClassWithProperties class]
    ];
    
    STAssertNil(descriptor, nil);
}

- (void)testGetStructValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"structNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    TestStruct value = { .field1 = 123.4, .field2 = 444 };
    instance.structNonatomic = value;
    
    NSValue *structValue = [descriptor getValueFromObject:instance];
    TestStruct actual;
    [structValue getValue:&actual];
    
    TestStruct expected = { .field1 = 123.4, .field2 = 444 };
    STAssertEquals(expected, actual, nil);
}

- (void)testSetStructValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"structNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    TestStruct value = { .field1 = 432.1, .field2 = 555 };
    [descriptor 
        setValue:[NSValue valueWithBytes:&value objCType:@encode(TestStruct)] 
        inObject:instance
    ];
    
    TestStruct expected = { .field1 = 432.1, .field2 = 555 };
    STAssertEquals(expected, instance.structNonatomic, nil);
}

- (void)testGetObjectValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    instance.idRetainNonatomic = @"String111";
    
    NSString *actual = [[descriptor getValueFromObject:instance] nonretainedObjectValue];
    
    STAssertEqualObjects(@"String111", actual, nil);
}

- (void)testSetObjectValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    [descriptor setValue:[NSValue valueWithNonretainedObject:@"String222"] inObject:instance];
    
    STAssertEqualObjects(@"String222", instance.idRetainNonatomic, nil);
}

- (void)testGetValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    instance.intNonatomic = 333;
    
    int actual;
    NSValue *intValue = [descriptor getValueFromObject:instance];
    [intValue getValue:&actual];
    
    STAssertEquals(333, actual, nil);
}

- (void)testSetValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    int intValue = 222;
    [descriptor setValue:[NSValue valueWithBytes:&intValue objCType:@encode(int)] inObject:instance];
    
    STAssertEquals(222, instance.intNonatomic, nil);
}

- (void)testDynamicGetValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intDynamicNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    instance.intDynamicNonatomic = 987;
    
    int actual;
    NSValue *intValue = [descriptor getValueFromObject:instance];
    [intValue getValue:&actual];
    
    STAssertEquals(987, actual, nil);
}

- (void)testDynamicSetValue {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intDynamicNonatomic" 
        inClass:[ClassWithProperties class]
    ];
    
    int intValue = 111;
    [descriptor setValue:[NSValue valueWithBytes:&intValue objCType:@encode(int)] inObject:instance];
    
    STAssertEquals(111, instance.intDynamicNonatomic, nil);

}

- (void)testGetValueViaCustomGetter {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[ClassWithProperties class]
    ];
    
    instance.intGetterSetter = 432;
    
    int actual;
    NSValue *intValue = [descriptor getValueFromObject:instance];
    [intValue getValue:&actual];
    
    STAssertEquals(432, actual, nil);
}

- (void)testSetValueViaCustomSetter {
    ClassWithProperties *instance = [ClassWithProperties new];
    
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"intGetterSetter" 
        inClass:[ClassWithProperties class]
    ];
    int intValue = 555;
    [descriptor setValue:[NSValue valueWithBytes:&intValue objCType:@encode(int)] inObject:instance];
    
    STAssertEquals(555, instance.intGetterSetter, nil);
}

- (void)testRetainNonatomicAttributesDescription {
    ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
        descriptorForPropertyName:@"idRetainNonatomic" 
        inClass:[ClassWithProperties class]
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
        inClass:[ClassWithProperties class]
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
        inClass:[ClassWithProperties class]
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
        inClass:[ClassWithProperties class]
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
        inClass:[ClassWithProperties class]
    ];
    
    STAssertThrowsSpecific(
        [descriptor 
            setValue:[NSValue valueWithNonretainedObject:@"234"]  
            inObject:[ClassWithProperties new]
        ], 
        ISInvalidStateException, 
        nil
    );
}

@end
