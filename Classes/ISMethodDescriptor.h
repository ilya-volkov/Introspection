#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISMethodDescriptor : NSObject <ISDescriptor>

+ (ISMethodDescriptor*)descriptorForMethodName:(SEL)name inClass:(Class)aClass;
+ (ISMethodDescriptor*)descriptorForMethod:(Method)aMethod;

- (id)initWithMethod:(Method)aMethod;

// TODO:use NSInvocation - no var arg, no union parameter
- (id)invokeOnObject:(id)anObject withArguments:(NSArray*)args;

@property (readonly) BOOL isStatic;
@property (readonly, strong) NSString* returnTypeEncoding;
@property (readonly, strong) NSArray* argumentsTypeEncodings;
@property (readonly) SEL methodSelector;
@property IMP implementation;

@end
