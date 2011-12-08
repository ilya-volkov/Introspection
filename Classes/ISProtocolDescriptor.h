#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISMethodDescriptor;
@class ISPropertyDescriptor;

@interface ISProtocolDescriptor : NSObject <ISDescriptor>

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)protocol;
+ (ISProtocolDescriptor*) descriptorForName:(NSString*)name;

- (id) initWithProtocol:(Protocol*)protocol;

- (BOOL) protocolConformsToProtocol:(Protocol*)protocol;

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector;
- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance required:(BOOL)isRequired;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name;

- (NSArray*) methodsInstance:(BOOL)isInstance required:(BOOL)isRequired;

@property (readonly, strong) NSArray* protocols;
@property (readonly, strong) NSArray* methods;
@property (readonly, strong) NSArray* properties;

@end
