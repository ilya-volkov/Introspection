#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISMethodDescriptor;
@class ISPropertyDescriptor;

@interface ISProtocolDescriptor : NSObject <ISDescriptor>

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)aProtocol;
+ (ISProtocolDescriptor*) descriptorForProtocolName:(NSString*)aProtocolName;

- (id) initWithProtocol:(Protocol*)aProtocol;

- (BOOL) protocolRespondsToSelector:(SEL)aSelector;
- (BOOL) isProtocolEqual:(ISProtocolDescriptor*)aProtocol;

- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* requiredMethods;
@property (readonly) NSArray* optionalMethods;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;

@end
