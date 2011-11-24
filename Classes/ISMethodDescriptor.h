#import <objc/runtime.h>

#import "ISBindingFlags.h"
#import "ISDescriptor.h"

@interface ISMethodDescriptor : NSObject <ISDescriptor>

+ (ISMethodDescriptor*) descriptorForMethodName:(NSString*)name inClass:(Class)aClass;
+ (ISMethodDescriptor*) descriptorForMethodName:(NSString*)name inClass:(Class)aClass usingFlags:(ISBindingFlags)flags;
+ (ISMethodDescriptor*) descriptorForMethod:(Method)aMethod;

- (id) initWithMethod:(Method)aMethod;
- (id) initWithClassMethod:(Method)aMethod;
- (id) initWithInstanceMethod:(Method)aMethod;

- (NSValue*) invokeOnObject:(id)anObject withArguments:(NSArray*)args;

@property (readonly) BOOL isStatic;
@property (readonly, strong) NSString* returnTypeEncoding;
@property (readonly, strong) NSArray* argumentTypeEncodings;
@property (readonly) SEL methodSelector;
@property IMP implementation;

@end

@interface ISMethodDescriptor ()

- (void) initProperties;
- (void) initArgumentTypeEncodings;

@end