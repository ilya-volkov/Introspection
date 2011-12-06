#import "ISProtocolDescriptor.h"
#import "ISClassDescriptor.h"
#import "ISPropertyDescriptor.h"
#import "ISMethodDescriptor.h"

@implementation ISProtocolDescriptor {
@private
    Protocol *protocol;
}

+ (NSArray*) allProtocols {
    unsigned int outCount;
    Protocol* __unsafe_unretained *protocols = objc_copyProtocolList(&outCount);
    
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISProtocolDescriptor* descriptor = [ISProtocolDescriptor descriptorForProtocol:protocols[i]];
        [result addObject:descriptor];
    }
    
    free(protocols);
    
    return result;
}

+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)protocol {
    return [[ISProtocolDescriptor alloc] initWithProtocol:protocol];
}

+ (ISProtocolDescriptor*) descriptorForName:(NSString*)name {
    Protocol *protocol = objc_getProtocol([name cStringUsingEncoding:NSASCIIStringEncoding]);
    
    if (protocol == nil)
        return nil;
    
    return [ISProtocolDescriptor descriptorForProtocol:protocol];
}

- (id) initWithProtocol:(Protocol*)protocol {
    self = [super init];
    if (self != nil) {
        self->protocol = protocol;
    }
    
    return self;
}

- (NSString*) name {
    const char *name = protocol_getName(protocol);
    
    return [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
}

- (NSArray*) protocols {
    unsigned int outCount;
    Protocol *__unsafe_unretained *protocols = protocol_copyProtocolList(protocol, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForProtocol:protocols[i]];
        [result addObject:descriptor];
    }
    
    free(protocols);
    
    return result;
}

// TODO: return optional methods too ???
- (NSArray*) methods {
    NSMutableArray *methods = [[self methodsInstance:YES required:YES] mutableCopy];
    [methods addObjectsFromArray:[self methodsInstance:NO required:YES]];
    
    return methods;
}

- (NSArray*) properties {
    unsigned int outCount;
    objc_property_t *properties = protocol_copyPropertyList(protocol, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISPropertyDescriptor *descriptor = [ISPropertyDescriptor descriptorForProperty:properties[i]];
        [result addObject:descriptor];
    }
    
    free(properties);
    
    return result;
}

- (NSArray*) methodsInstance:(BOOL)isInstance required:(BOOL)isRequired {
    unsigned int outCount;
    MethodDescription *methods = protocol_copyMethodDescriptionList(protocol, isRequired, isInstance, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISMethodDescriptor *descriptor = [ISMethodDescriptor 
            descriptorForMethodDescription:methods[i] instance:isInstance
        ];
        [result addObject:descriptor];
    }
    
    free(methods);
    
    return result;
}

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector {
    return [ISMethodDescriptor descriptorForSelector:selector inProtocol:protocol];
}

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance required:(BOOL)isRequired {
    return [ISMethodDescriptor descriptorForSelector:selector inProtocol:protocol instance:isInstance required:isRequired];
}

- (ISPropertyDescriptor*) propertyWithName:(NSString*)name {
    return [ISPropertyDescriptor descriptorForName:name inProtocol:protocol];
}

- (BOOL) protocolConformsToProtocol:(ISProtocolDescriptor*)protocol {
    return protocol_conformsToProtocol(self->protocol, protocol);
}

@end
