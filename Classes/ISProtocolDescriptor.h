@class ISMethodDescriptor;
@class ISPropertyDescriptor;

#import "ISDescriptor.h"

@interface ISProtocolDescriptor : NSObject <ISDescriptor> {
@private
    Protocol protocol;
}

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol)aProtocol;
+ (ISProtocolDescriptor*) descriptorForProtocolName:(NSString*)aProtocolName;

- (BOOL) protocolRespondsToSelector:(SEL)aSelector;
- (BOOL) isProtocolEqual:(ISProtocolDescriptor*)aProtocol;

- (id) initWithProtocol:(Protocol)aProtocol;

// isRequired in method descriptor
- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* requiredMethods;
@property (readonly) NSArray* optionalMethods;
@property (readonly) NSArray* properties;

@end
