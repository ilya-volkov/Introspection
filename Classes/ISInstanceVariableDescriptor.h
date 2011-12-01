#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISInstanceVariableDescriptor : NSObject <ISDescriptor>

+ (ISInstanceVariableDescriptor*) descriptorForName:(NSString*)name inClass:(Class)aClass;
+ (ISInstanceVariableDescriptor*) descriptorForInstanceVariable:(Ivar)instanceVariable;

- (id) initWithInstanceVariable:(Ivar)instanceVariable;

- (void) setValue:(NSValue*)value inObject:(id)object;
- (NSValue*) getValueFromObject:(id)object;

@property (readonly, copy) NSString* typeEncoding;

@end
