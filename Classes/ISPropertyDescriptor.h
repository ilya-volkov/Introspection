#import "ISDescriptor.h"
#import "ISSetterSemanticsType.h"

@interface ISPropertyDescriptor : NSObject <ISDescriptor> {
@private
    objc_property_t property;
    SEL setter;
    SEL getter;
}

+ (ISPropertyDescriptor*)descriptorForPropertyName:(NSString*)name inClass:(Class)aClass;
+ (ISPropertyDescriptor*)descriptorForProperty:(objc_property_t)aProperty;

- (id)initWithProperty:(objc_property_t)aProperty;

- (void)setValue:(id)value inObject:(id)anObject;
- (id)getValueFromObject:(id)anObject;

@property (readonly) NSString* typeEncoding;

@property (readonly) ISSetterSemanticsType setterSemanticType;
@property (readonly) BOOL isRetain;
@property (readonly) BOOL isReadOnly;
@property (readonly) BOOL isNonAtomic;
// get, set dynamic
@property (readonly) BOOL isDynamic;
// research not supported in 10.6 and iOS 4
@property (readonly) BOOL isWeakReference;
// research
@property (readonly) BOOL isEligibleForGarbageCollection;

@end
