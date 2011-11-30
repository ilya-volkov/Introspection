#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISProtocolDescriptor;
@class ISMethodDescriptor;
@class ISPropertyDescriptor;
@class ISInstanceVariableDescriptor;

// TODO: research property modifiers: strong, weak (NSNumber), when use copy (NSString???)
// use string and copy, default: string vs. weak

@interface ISClassDescriptor : NSObject <ISDescriptor>

+ (NSArray*) allClasses;
+ (NSArray*) classesInBundle:(NSBundle*)aBundle;
+ (ISClassDescriptor*) descriptorForClass:(Class)aClass;
+ (ISClassDescriptor*) descriptorForClassName:(NSString*)aClassName;

- (id) initWithClass:(Class)aClass;

- (BOOL) classRespondsToSelector:(SEL)aSelector;
- (BOOL) classConformsToProtocol:(ISProtocolDescriptor*)aProtocol;

- (ISMethodDescriptor*) methodWithName:(NSString*)name;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name;

/*- (NSArray*) methodsFilteredBy:(ISBindingFlags)flags;
- (NSArray*) propertiesFilteredBy:(ISBindingFlags)flags;
- (NSArray*) instanceVariablesFilteredBy:(ISBindingFlags)flags;*/

@property (readonly) ISClassDescriptor* classSuperclass;

// TODO: weak or strong by default ??? assign for NSNumber etc???
@property (copy) NSNumber* classVersion;
@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
@property (readonly) NSArray* instanceVariables;
// TODO: Test ivar layout + weak layouts
@property (readonly, copy) NSString* instanceVariablesLayout;
@property (readonly, strong) NSBundle* bundle;

@end
