@class ISMethodDescriptor;
@class ISClassDescriptor;
@class ISPropertyDescriptor;
@class ISInstanceVariableDescriptor;

@interface NSObject (Introspection)

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector;
- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name;

- (NSArray*) methodsInstance:(BOOL)isInstance;

@property (readonly) ISClassDescriptor *descriptor;
@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
@property (readonly) NSArray* instanceVariables;

@end
