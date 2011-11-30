#import <objc/runtime.h>

#import "ISDescriptor.h"

// TODO: remove articles in arg names

@interface ISMethodDescriptor : NSObject <ISDescriptor>

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)aClass;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)aClass isInstance:(BOOL)isInstance;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)aProtocol;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)aProtocol isInstance:(BOOL)isInstance isRequired:(BOOL)isRequired;
+ (ISMethodDescriptor*) descriptorForInstanceMethod:(Method)aMethod;
+ (ISMethodDescriptor*) descriptorForClassMethod:(Method)aMethod;

- (id) initWithClassMethod:(Method)aMethod;
- (id) initWithInstanceMethod:(Method)aMethod;

- (NSValue*) invokeOnObject:(id)anObject withArguments:(NSArray*)args;

@property (readonly) BOOL isInstanceMethod;
@property (readonly, copy) NSString* returnTypeEncoding;
@property (readonly, strong) NSArray* argumentTypeEncodings;
@property (readonly) SEL selector;
@property (readonly, copy) NSString* typeEncoding;
@property IMP implementation;

@end

@interface ISMethodDescriptor ()

+ (ISMethodDescriptor*) descriptorForInstanceMethod:(Method)instanceMethod classMethod:(Method)classMethod;

- (id) initWithMethod:(Method)aMethod;
- (id) initWithMethodDescription:(struct objc_method_description)description;
- (void) initProperties;
- (void) initArgumentTypeEncodings;

@end