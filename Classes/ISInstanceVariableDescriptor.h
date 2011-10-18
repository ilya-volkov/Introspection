#import <objc/runtime.h>

#import "ISDescriptor.h"

@interface ISInstanceVariableDescriptor : NSObject <ISDescriptor> {
@private
    Ivar ivar;
}

+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(NSString*)name inClass:(Class)aClass;
+ (ISInstanceVariableDescriptor*)descriptorForInstanceVariableName:(Ivar)anInstanceVariable;

- (id)initWithInstanceVariable:(Ivar)InstanceVariable;

- (void)setValue:(id)value inObject:(id)anObject;
- (id)getValueFromObject:(id)anObject;

// Test ivar layout + weak layouts
@property (readonly) NSString* layout;
@property (readonly) NSString* typeEncoding;

@end
