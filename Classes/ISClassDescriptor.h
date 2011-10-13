@class ISProtocolDescriptor;
@class ISMethodDescriptor;
@class ISPropertyDescriptor;
@class ISInstanceVariableDescriptor;

#import "ISDescriptor.h"
#import "ISBindingFlags.h"

@interface ISClassDescriptor : NSObject <ISDescriptor> {
@private
    Class class;
}

+ (NSArray*) allClasses;
+ (ISClassDescriptor*) descriptorForClass:(Class)aClass;
+ (ISClassDescriptor*) descriptorForClassName:(NSString*)aClassName;

- (BOOL) classRespondsToSelector:(SEL)aSelector;
- (BOOL) classConformsToProtocol:(ISProtocolDescriptor*)aProtocol;

- (id) initWithClass:(Class)aClass;

- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*)instanceVariableWithName:(NSString*)name;

- (NSArray*) methodsFilteredBy:(ISBindingFlags)flags;
- (NSArray*) propertiesFilteredBy:(ISBindingFlags)flags;
- (NSArray*) instanceVariablesFilteredBy:(ISBindingFlags)flags;

@property (readonly) ISClassDescriptor* classSuperclass;
@property (assign) NSNumber* classVersion;

// inherited protocols
@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
// test class variables
@property (readonly) NSArray* instanceVariables;
// variables visibility: public, protected, public

@end
