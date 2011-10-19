#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISInstanceVariableDescriptor : NSObject <ISDescriptor> {
@private
    Ivar ivar;
}

+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(NSString*)name inClass:(Class)aClass;
+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(Ivar)anInstanceVariable;

- (id)initWithInstanceVariable:(Ivar)anInstanceVariable;

// test get/set with non reference types (struct, int, etc.)
- (void)setValue:(id)value inObject:(id)anObject;
- (id)getValueFromObject:(id)anObject;

@property (readonly) NSString* typeEncoding;

@end
