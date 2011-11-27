#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISMethodDescriptor;
@class ISPropertyDescriptor;

// 1. TODO: add find method and property in protocol to corresponding descriptors 
//          ??? if not needed remove commented code and update test classes
// 2. TODO: Test protocol_getMethodDescription, create descriptro for method ???

@interface ISProtocolDescriptor : NSObject <ISDescriptor>

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)aProtocol;
+ (ISProtocolDescriptor*) descriptorForProtocolName:(NSString*)aProtocolName;

- (id) initWithProtocol:(Protocol*)aProtocol;

- (BOOL) protocolRespondsToSelector:(SEL)aSelector;
- (BOOL) isProtocolEqual:(ISProtocolDescriptor*)aProtocol;

// TODO: better names for methods
- (ISMethodDescriptor*) methodWithSelector:(NSString*)aSelector;
- (ISMethodDescriptor*) methodWithSelector:(NSString*)aSelector required:(BOOL)isRequired instance:(BOOL)isInstance;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name required:(BOOL)isRequired instance:(BOOL)isInstance;
- (NSArray*) methodsRequired:(BOOL)required instance:(BOOL)isInstance;
- (NSArray*) propertyRequired:(BOOL)required instance:(BOOL)isInstance;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;

@end
