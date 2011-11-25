#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISMethodDescriptor : NSObject <ISDescriptor>

+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)aClass;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inClass:(Class)aClass isInstance:(BOOL)isInstance;
/*+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)aProtocol;
+ (ISMethodDescriptor*) descriptorForSelector:(SEL)selector inProtocol:(Protocol*)aProtocol isInstance:(BOOL)isInstance isRequired:(BOOL)isRequired;*/
+ (ISMethodDescriptor*) descriptorForInstanceMethod:(Method)aMethod;
+ (ISMethodDescriptor*) descriptorForClassMethod:(Method)aMethod;

- (id) initWithClassMethod:(Method)aMethod;
- (id) initWithInstanceMethod:(Method)aMethod;

- (NSValue*) invokeOnObject:(id)anObject withArguments:(NSArray*)args;

@property (readonly) BOOL isInstanceMethod;
@property (readonly, strong) NSString* returnTypeEncoding;
@property (readonly, strong) NSArray* argumentTypeEncodings;
@property (readonly) SEL selector;
@property IMP implementation;

@end

@interface ISMethodDescriptor ()

+ (ISMethodDescriptor*) descriptorForInstanceMethod:(Method)instanceMethod classMethod:(Method)classMethod;

- (id) initWithMethod:(Method)aMethod;
- (void) initProperties;
- (void) initArgumentTypeEncodings;

@end