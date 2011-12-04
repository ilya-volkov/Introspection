#import <objc/runtime.h>

#import "ISDescriptor.h"
#import "ISSetterSemanticsType.h"

@interface ISPropertyDescriptor : NSObject <ISDescriptor>

+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inClass:(Class)class;
+ (ISPropertyDescriptor*) descriptorForName:(NSString*)name inProtocol:(Protocol*)protocol;
+ (ISPropertyDescriptor*) descriptorForProperty:(objc_property_t)property;

- (id) initWithProperty:(objc_property_t)property;

- (void) setValue:(NSValue*)value inObject:(id)object;
- (NSValue*) getValueFromObject:(id)object;

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