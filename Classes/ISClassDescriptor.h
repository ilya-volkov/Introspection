#import <objc/runtime.h>

#import "ISDescriptor.h"
#import "ISBindingFlags.h"

@class ISProtocolDescriptor;
@class ISMethodDescriptor;
@class ISPropertyDescriptor;
@class ISInstanceVariableDescriptor;

@interface ISClassDescriptor : NSObject <ISDescriptor> {
@private
    Class _class;
}

+ (NSArray*) allClasses;
+ (NSArray*) classesInBundle:(NSBundle*)aBundle;
+ (ISClassDescriptor*) descriptorForClass:(Class)aClass;
+ (ISClassDescriptor*) descriptorForClassName:(NSString*)aClassName;

- (id) initWithClass:(Class)aClass;

- (BOOL) classRespondsToSelector:(SEL)aSelector;
- (BOOL) classConformsToProtocol:(ISProtocolDescriptor*)aProtocol;

- (ISMethodDescriptor*)methodWithName:(NSString*)name;
- (ISPropertyDescriptor*)propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*)instanceVariableWithName:(NSString*)name;

- (NSArray*) methodsFilteredBy:(ISBindingFlags)flags;
- (NSArray*) propertiesFilteredBy:(ISBindingFlags)flags;
- (NSArray*) instanceVariablesFilteredBy:(ISBindingFlags)flags;

@property (readonly) ISClassDescriptor* classSuperclass;

// weak or strong by default ??? assign for NSNumber etc???
@property (weak) NSNumber* classVersion;

// inherited protocols
@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
// test class variables
@property (readonly) NSArray* instanceVariables;
// Test ivar layout + weak layouts
@property (readonly) NSString* instanceVariablesLayout;
// variables visibility: public, protected, public
@property (readonly) NSBundle* bundle;

@end
