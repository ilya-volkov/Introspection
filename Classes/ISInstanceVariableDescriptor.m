#import "ISInstanceVariableDescriptor.h"

@implementation ISInstanceVariableDescriptor {
@private
    Ivar ivar;
    BOOL isObjectType;
}

@synthesize name;
@synthesize typeEncoding;

+ (ISInstanceVariableDescriptor*) descriptorForName:(NSString*)name inClass:(Class)class {
    Ivar ivar = class_getInstanceVariable(class, [name cStringUsingEncoding:NSASCIIStringEncoding]);
    if (ivar == nil)
        return nil;
    
    return [ISInstanceVariableDescriptor descriptorForInstanceVariable:ivar];
}

+ (ISInstanceVariableDescriptor*) descriptorForInstanceVariable:(Ivar)instanceVariable {
    return [[ISInstanceVariableDescriptor alloc] initWithInstanceVariable:instanceVariable];
}

- (id) initWithInstanceVariable:(Ivar)instanceVariable {
    self = [super init];
    if (self) {
        ivar = instanceVariable;
        name = [NSString stringWithCString:ivar_getName(ivar) encoding:NSASCIIStringEncoding];
        typeEncoding = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSASCIIStringEncoding];
        isObjectType = [typeEncoding 
            hasPrefix:[NSString stringWithCString:@encode(id) encoding:NSASCIIStringEncoding]
        ];
    }
    
    return self;
}

- (void) setValue:(NSValue*)value inObject:(id)object {
    if (isObjectType) {
        object_setIvar(object, ivar, [value nonretainedObjectValue]);
        return;
    }
    
    void *valuePointer = (__bridge void *)object + ivar_getOffset(ivar);
    [value getValue:valuePointer];
}

- (NSValue*) getValueFromObject:(id)object {
    if (isObjectType)
        return [NSValue valueWithNonretainedObject:object_getIvar(object, ivar)];
    
    void *valuePointer = (__bridge void *)object + ivar_getOffset(ivar);
    return [NSValue 
        valueWithBytes:valuePointer
        objCType:[typeEncoding cStringUsingEncoding:NSASCIIStringEncoding]
    ];
}

@end
