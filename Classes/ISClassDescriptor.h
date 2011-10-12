@class ISProtocolDescriptor;
@class ISMethodDescriptor;
@class ISPropertyDescriptor;
@class ISInstanceVariableDescriptor;

#import "ISDescriptor.h"

@interface ISClassDescriptor : NSObject <ISDescriptor> {
@private
    Class _class;
}

+ (NSArray*) allClasses;
+ (ISClassDescriptor*) descriptorForClass:(Class)aClass;
+ (ISClassDescriptor*) descriptorForClassName:(NSString*)aClassName;

// TODO: existing methods overrides
- (BOOL) respondsToSelector:(SEL)aSelector;
- (BOOL) conformsToProtocol:(ISProtocolDescriptor*)aProtocol;

- (id) initWithClass:(Class)aClass;

- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*)instanceVariableWithName:(NSString*)name;

@property (readonly) ISClassDescriptor* superclass;
@property (copy) NSNumber* version;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
@property (readonly) NSArray* instanceVariables;

@end
