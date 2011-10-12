@class ISMethodDescriptor;
@class ISPropertyDescriptor;

@interface ISProtocolDescriptor : NSObject {
@private
    Protocol *_protocol;
}

+ (NSArray*) allProtocols;
+ (ISProtocolDescriptor*) descriptorForProtocol:(Protocol*)aProtocol;
+ (ISProtocolDescriptor*) descriptorForProtocolName:(NSString*)aProtocolName;

// TODO: existing methods overrides
- (BOOL) respondsToSelector:(SEL)aSelector;
- (BOOL) isEqual:(ISProtocolDescriptor*)aProtocol;

- (id) initWithProtocol:(Protocol*)aProtocol;

// isRequired in method descriptor
- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;

@end
