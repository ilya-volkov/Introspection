#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISMethodDescriptor;
@class ISPropertyDescriptor;

@interface ISProtocolDescriptor : NSObject <ISDescriptor>

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)protocol;
+ (ISProtocolDescriptor*) descriptorForName:(NSString*)protocolName;

- (id) initWithProtocol:(Protocol*)protocol;

- (BOOL) protocolRespondsToSelector:(SEL)selector;
- (BOOL) isProtocolEqual:(ISProtocolDescriptor*)protocol;

- (ISMethodDescriptor*) methodWithSelector:(NSString*)selector;
- (ISMethodDescriptor*) methodWithSelector:(NSString*)selector instance:(BOOL)isInstance required:(BOOL)isRequired;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)propertyName;

- (NSArray*) methodsInstance:(BOOL)isInstance required:(BOOL)isRequired;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;

@end
