#import "ProtocolDescriptorTests.h"
#import "ISProtocolDescriptor.h"
#import "BaseProtocolWithMethods.h"
#import "ProtocolWithProperties.h"
#import "ProtocolWithMethods.h"
#import "SuperBaseProtocol.h"


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

- (void)testConformsToProtocol {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    STAssertTrue([descriptor protocolConformsToProtocol:@protocol(BaseProtocolWithMethods)], nil);
}

- (void)testConformsToBaseProtocol {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForProtocol:@protocol(ProtocolWithMethods)];
    
    STAssertTrue([descriptor protocolConformsToProtocol:@protocol(SuperBaseProtocol)], nil);
}

- (void)testNotConformsToProtocol {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    STAssertFalse([descriptor protocolConformsToProtocol:@protocol(ProtocolWithProperties)], nil);
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
            @"requiredProtocolMethod", 
            @"optionalProtocolMethod",
            @"optionalClassProtocolMethod", nil
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
