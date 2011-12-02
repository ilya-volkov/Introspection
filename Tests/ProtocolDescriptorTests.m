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

- (void)testProtocolRespondsToSelector {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    STAssertTrue([descriptor respondsToSelector:@selector(baseClassProtocolMethod:)], nil);
}

- (void)testProtocolNotRespondsToSelector {
    ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForName:@"ProtocolWithMethods"];
    
    STAssertFalse([descriptor respondsToSelector:@selector(baseClassProtocolMethod:)], nil);
}

- (void)testProtocolEqual {
    ISProtocolDescriptor *first = [ISProtocolDescriptor descriptorForName:@"BaseProtocolWithMethods"];
    ISProtocolDescriptor *second = [ISProtocolDescriptor descriptorForName:@"BaseProtocolWithMethodsCopy"];
    
    STAssertTrue([first isProtocolEqual:second], nil);
}

- (void)testProtocolNotEqual {
    ISProtocolDescriptor *first = [ISProtocolDescriptor descriptorForName:@"BaseProtocolWithMethods"];
    ISProtocolDescriptor *second = [ISProtocolDescriptor descriptorForName:@"ProtocolWithProperties"];
    
    STAssertFalse([first isProtocolEqual:second], nil);
}

- (void)testListProtcols {
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

/*
 - (NSArray*) methodsInstance:(BOOL)isInstance required:(BOOL)isRequired;
 
 @property (readonly) NSArray* protocols;
 @property (readonly) NSArray* methods;
 @property (readonly) NSArray* properties;
 */

@end
