#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISMethodDescriptor : NSObject <ISDescriptor> {
@private
    Method method;
}

+ (ISMethodDescriptor*)descriptorForMethodName:(NSString*)name inClass:(Class)aClass;
+ (ISMethodDescriptor*)descriptorForMethod:(Method)aMethod;

- (id)initWithMethod:(Method)aMethod;

// use NSInvocation - no var arg, no union parameter
- (id)invokeOnObject:(id)anObject withArguments:(NSArray*)args;

@property (readonly) BOOL isStatic;
@property (readonly) NSString* returnTypeEncoding;
@property (readonly) NSArray* argumentsTypeEncodings;
@property (assign) IMP implementation;

@end
