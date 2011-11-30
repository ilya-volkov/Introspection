#import <objc/runtime.h>

#import "ISDescriptor.h"
#import "ISSetterSemanticsType.h"

@interface ISPropertyDescriptor : NSObject <ISDescriptor>

+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inClass:(Class)aClass;
+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inProtocol:(Protocol*)aProtocol;
//+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inProtocol:(Protocol*)aProtocol isRequired:(BOOL)isRequired;
+ (ISPropertyDescriptor*) descriptorForProperty:(objc_property_t)aProperty;

- (id) initWithProperty:(objc_property_t)aProperty;

- (void) setValue:(NSValue*)value inObject:(id)anObject;
- (NSValue*) getValueFromObject:(id)anObject;

@property (readonly, copy) NSString* backingVariable;
@property (readonly) SEL getter;
@property (readonly) SEL setter;
@property (readonly, copy) NSString* typeEncoding;
@property (readonly) ISSetterSemanticsType setterSemanticsType;
@property (readonly) BOOL isReadOnly;
@property (readonly) BOOL isNonAtomic;
@property (readonly) BOOL isDynamic;
@property (readonly) BOOL isWeakReference;
@property (readonly) BOOL isEligibleForGarbageCollection;

@end

@interface ISPropertyDescriptor ()

- (void) parsePropertyAttributeDescription:(NSString*)description;
- (void) setDefaultAttributeValues;

@end