#import <objc/runtime.h>

#import "ISDescriptor.h"

@class ISMethodDescriptor;
@class ISPropertyDescriptor;
@class ISInstanceVariableDescriptor;

@interface ISClassDescriptor : NSObject <ISDescriptor>

+ (NSArray*) allClasses;
+ (NSArray*) classesInBundle:(NSBundle*)aBundle;
+ (ISClassDescriptor*) descriptorForClass:(Class)class;
+ (ISClassDescriptor*) descriptorForClassName:(NSString*)name;

- (id) initWithClass:(Class)aClass;

- (BOOL) classRespondsToSelector:(SEL)selector;
- (BOOL) classConformsToProtocol:(Protocol*)protocol;

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector;
- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name;

- (NSArray*) methodsInstance:(BOOL)isInstance;

@property (readonly) ISClassDescriptor* classSuperclass;
@property (readonly) NSNumber* classVersion;
@property (readonly) NSString* instanceVariablesLayout;
@property (readonly) NSString* weakInstanceVariablesLayout;
@property (readonly) NSBundle* bundle;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
@property (readonly) NSArray* instanceVariables;

@end
