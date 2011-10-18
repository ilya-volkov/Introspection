#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISMethodDescriptor;
@class ISPropertyDescriptor;

@interface ISProtocolDescriptor : NSObject <ISDescriptor> {
@private
    Protocol *protocol;
}

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)aProtocol;
+ (ISProtocolDescriptor*) descriptorForProtocolName:(NSString*)aProtocolName;

- (BOOL) protocolRespondsToSelector:(SEL)aSelector;
- (BOOL) isProtocolEqual:(ISProtocolDescriptor*)aProtocol;

- (id) initWithProtocol:(Protocol*)aProtocol;

- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* requiredMethods;
@property (readonly) NSArray* optionalMethods;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;

@end
