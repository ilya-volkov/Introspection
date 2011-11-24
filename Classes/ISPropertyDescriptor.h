#import <objc/runtime.h>

#import "ISDescriptor.h"
#import "ISSetterSemanticsType.h"

@interface ISPropertyDescriptor : NSObject <ISDescriptor>

+ (ISPropertyDescriptor*) descriptorForPropertyName:(NSString*)name inClass:(Class)aClass;
+ (ISPropertyDescriptor*) descriptorForProperty:(objc_property_t)aProperty;

- (id) initWithProperty:(objc_property_t)aProperty;

- (void) setValue:(NSValue*)value inObject:(id)anObject;
- (NSValue*) getValueFromObject:(id)anObject;

@property (readonly, nonatomic, strong) NSString* backingVariable;
@property (readonly, nonatomic) SEL getter;
@property (readonly, nonatomic) SEL setter;
@property (readonly, nonatomic, strong) NSString* typeEncoding;
@property (readonly, nonatomic) ISSetterSemanticsType setterSemanticsType;
@property (readonly, nonatomic) BOOL isReadOnly;
@property (readonly, nonatomic) BOOL isNonAtomic;
@property (readonly, nonatomic) BOOL isDynamic;
@property (readonly, nonatomic) BOOL isWeakReference;
@property (readonly, nonatomic) BOOL isEligibleForGarbageCollection;

@end

@interface ISPropertyDescriptor ()

- (void) parsePropertyAttributeDescription:(NSString*)description;
- (void) setDefaultAttributeValues;

@end