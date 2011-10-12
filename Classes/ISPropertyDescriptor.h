@interface ISPropertyDescriptor : NSObject

- (NSObject*) getValue:(id)anObject;
- (void) setValue:(NSObject*) aValue onObject:(id)anObject;

@end
