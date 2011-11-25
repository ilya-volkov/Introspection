#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISInstanceVariableDescriptor : NSObject <ISDescriptor>

+ (ISInstanceVariableDescriptor*) descriptorForName:(NSString*)name inClass:(Class)aClass;
+ (ISInstanceVariableDescriptor*) descriptorForInstanceVariable:(Ivar)anInstanceVariable;

- (id) initWithInstanceVariable:(Ivar)anInstanceVariable;

- (void) setValue:(NSValue*)value inObject:(id)anObject;
- (NSValue*) getValueFromObject:(id)anObject;

@property (nonatomic, readonly, strong) NSString* typeEncoding;

@end
