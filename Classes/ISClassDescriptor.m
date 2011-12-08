#import "ISClassDescriptor.h"

#import "ISMethodDescriptor.h"
#import "ISPropertyDescriptor.h"
#import "ISInstanceVariableDescriptor.h"
#import "ISProtocolDescriptor.h"

@implementation ISClassDescriptor {
@private
    Class class;
}

+ (NSArray*) allClasses {
    unsigned int outCount;
    Class* classes = objc_copyClassList(&outCount);
    
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISClassDescriptor* class = [ISClassDescriptor descriptorForClass:classes[i]];
        [result addObject:class];
    }
    
    free(classes);
    
    return result;
}

+ (ISClassDescriptor*) descriptorForClass:(Class)class {
    return [[ISClassDescriptor alloc] initWithClass:class];
}

+ (ISClassDescriptor*) descriptorForName:(NSString*)name {
    Class class = objc_getClass([name cStringUsingEncoding:NSASCIIStringEncoding]);
    if (class == nil)
        return nil;
    
    return [ISClassDescriptor descriptorForClass:class];
}

+ (NSArray*) classesInBundle:(NSBundle*)bundle {
    unsigned int count = 0;
    const char **classNames = objc_copyClassNamesForImage(
        [[bundle executablePath] cStringUsingEncoding:NSUTF8StringEncoding],                                                  
        &count
    );
    
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [result addObject:
            [ISClassDescriptor 
                descriptorForName:[NSString stringWithCString:classNames[i] encoding:NSASCIIStringEncoding]
            ]
        ];
    }
    
    free(classNames);
    
    return result;
}

- (id) initWithClass:(Class)class {
    self = [super init];
    if (self != nil) {
        self->class = class;
    }
    
    return self;
}

- (BOOL) classRespondsToSelector:(SEL)selector {
    return class_respondsToSelector(class, selector);
}

- (BOOL) classConformsToProtocol:(Protocol*)protocol {
    return class_conformsToProtocol(class, protocol);
}

- (NSString*) name {
    const char *name = class_getName(class);
    
    return [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
}

- (NSBundle*) bundle {
    return [NSBundle bundleForClass:class];
}

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector {
    return [ISMethodDescriptor descriptorForSelector:selector inClass:class];
}

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance {
    return [ISMethodDescriptor descriptorForSelector:selector inClass:class instance:isInstance];
}

- (ISPropertyDescriptor*) propertyWithName:(NSString*)name {
    return [ISPropertyDescriptor descriptorForName:name inClass:class];
}

- (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name {
    return [ISInstanceVariableDescriptor descriptorForName:name inClass:class];
}

- (ISClassDescriptor*) classSuperclass {
    Class superclass = class_getSuperclass(class);
    if (superclass == [NSObject superclass])
        return nil;
        
    return [ISClassDescriptor descriptorForClass:superclass];
}

- (NSNumber*) classVersion {
    return [NSNumber numberWithInt:class_getVersion(class)];
}

- (NSArray*) methods {
    NSMutableArray *methods = [[self methodsInstance:YES] mutableCopy];
    [methods addObjectsFromArray:[self methodsInstance:NO]];
    
    return methods;
}

- (NSArray*) methodsInstance:(BOOL)isInstance {
    Class targetClass = isInstance ? class : object_getClass(class);
    
    unsigned int outCount;
    Method *methods = class_copyMethodList(targetClass, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISMethodDescriptor *descriptor = [ISMethodDescriptor descriptorForMethod:methods[i] instance:isInstance];
        [result addObject:descriptor];
    }
    
    free(methods);
    
    return result;
}

- (NSArray*) protocols {
    unsigned int outCount;
    Protocol *__unsafe_unretained *protocols = class_copyProtocolList(class, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForProtocol:protocols[i]];
        [result addObject:descriptor];
    }
    
    free(protocols);
    
    return result;
}

- (NSArray*) properties {
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISPropertyDescriptor *descriptor = [ISPropertyDescriptor descriptorForProperty:properties[i]];
        [result addObject:descriptor];
    }
    
    free(properties);
    
    return result;
}

- (NSArray*) instanceVariables {
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(class, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor descriptorForInstanceVariable:ivars[i]];
        [result addObject:descriptor];
    }
    
    free(ivars);
    
    return result;
}

@end
