#import <objc/runtime.h>

#import "ISDescriptor.h"

typedef struct objc_method_description MethodDescription;

BOOL isMethodDescriptionEmpty(MethodDescription description);

@interface ISMethodDescriptor : NSObject <ISDescriptor>

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)class;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)class instance:(BOOL)isInstance;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)protocol;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)protocol instance:(BOOL)isInstance required:(BOOL)isRequired;
+ (ISMethodDescriptor*) descriptorForMethod:(Method)method instance:(BOOL)isInstance;
+ (ISMethodDescriptor*) descriptorForMethodDescription:(MethodDescription)methodDescription instance:(BOOL)isInstance;

- (id) initWithMethod:(Method)method instance:(BOOL)isInstance;
- (id) initWithMethodDescription:(MethodDescription)methodDescription instance:(BOOL)isInstance;

- (NSValue*) invokeOnObject:(id)object withArguments:(NSArray*)args;
- (IMP) implementationForClass:(Class)class;
- (IMP) setImplementationForClass:(Class)class value:(IMP)value;

@property (readonly) BOOL isInstanceMethod;
@property (readonly, copy) NSString* returnTypeEncoding;
@property (readonly, strong) NSArray* argumentTypeEncodings;
@property (readonly) SEL selector;
@property (readonly, copy) NSString* typeEncoding;

@end