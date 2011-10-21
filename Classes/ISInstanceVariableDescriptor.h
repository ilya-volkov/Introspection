#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISInstanceVariableDescriptor : NSObject <ISDescriptor>

+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(NSString*)name inClass:(Class)aClass;
+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(Ivar)anInstanceVariable;

- (id)initWithInstanceVariable:(Ivar)anInstanceVariable;

- (void)setValue:(void*)value inObject:(id)anObject;
- (void*)getValueFromObject:(id)anObject;

@property (nonatomic, readonly, strong) NSString* typeEncoding;

@end
