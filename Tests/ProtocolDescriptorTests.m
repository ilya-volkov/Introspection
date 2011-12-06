#import "ProtocolDescriptorTests.h"
#import "ISProtocolDescriptor.h"

#import "NSArray+CollectionQuery.h"
#import "SenTestCase+CollectionAssert.h"

@implementation ProtocolDescriptorTests

- (void)testListAllProtocols {
    NSArray *protocols = [ISProtocolDescriptor allProtocols];    
    NSArray *names = [protocols selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"ProtocolWithMethods", 
            @"ProtocolWithProperties", 
            @"BaseProtocolWithProperties", nil
        ] 
        isSubsetOfCollection:names
    ];
}

- (void)testCreateDescriptorForName {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithProperties"];
    
    STAssertEqualObjects(@"ProtocolWithProperties", descriptor.name, nil);
}

- (void)testCreateDescriptorForNameFails {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"NonExistentProtocol"];
    
    STAssertNil(descriptor, nil);
}

// TODO: fix test, conforms to base protocol
/*- (void)testConformsToProtocol {
    ISProtocolDescriptor *first = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    ISProtocolDescriptor *second = [ISProtocolDescriptor descriptorForName:@"BaseProtocolWithMethods"];
    
    STAssertTrue([first protocolConformsToProtocol:second], nil);
}*/

- (void)testNotConformsToProtocol {
    ISProtocolDescriptor *first = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    ISProtocolDescriptor *second = [ISProtocolDescriptor descriptorForName:@"ProtocolWithProperties"];
    
    STAssertFalse([first protocolConformsToProtocol:second], nil);
}

- (void)testListProtocols {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    NSArray *names = [descriptor.protocols selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"BaseProtocol", 
            @"BaseProtocolWithMethods", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListProperties {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithProperties"];
    
    NSArray *names = [descriptor.properties selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"requiredProperty",
            @"optionalProperty", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListMethods {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    NSArray *names = [descriptor.methods selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"methodWithNonUniqueNameInProtocol",
            @"classProtocolMethod:",
            @"instanceProtocolMethod:",
            @"instanceProtocolMethodWithParametersFirst:second:third:",
            @"methodWithNonUniqueNameInProtocol",
            @"requiredProtocolMethod", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListInstanceRequiredMethods {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    NSArray *names = [[descriptor methodsInstance:YES required:YES] selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"methodWithNonUniqueNameInProtocol",
            @"instanceProtocolMethod:",
            @"instanceProtocolMethodWithParametersFirst:second:third:",
            @"requiredProtocolMethod", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListInstanceOptionalMethods {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    NSArray *names = [[descriptor methodsInstance:YES required:NO] selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObject:@"optionalProtocolMethod"] 
        isEquivalentToCollection:names
    ];
}

- (void)testListClassRequiredMethods {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    NSArray *names = [[descriptor methodsInstance:NO required:YES] selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObjects:
            @"methodWithNonUniqueNameInProtocol", 
            @"classProtocolMethod:", nil
        ] 
        isEquivalentToCollection:names
    ];
}

- (void)testListClassOptionalMethods {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    NSArray *names = [[descriptor methodsInstance:NO required:NO] selectUsingBlock:^(id obj) {
        return (NSString*)[obj name];
    }];
    
    [self 
        assertCollection:[NSArray arrayWithObject:@"optionalClassProtocolMethod"] 
        isEquivalentToCollection:names
    ];
}

@end
