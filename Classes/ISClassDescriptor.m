#import "ISClassDescriptor.h"

@implementation ISClassDescriptor {
@private
    Class class;
}

/*+ (NSArray*) allClasses;
+ (NSArray*) classesInBundle:(NSBundle*)aBundle;
+ (ISClassDescriptor*) descriptorForClass:(Class)class;
+ (ISClassDescriptor*) descriptorForClassName:(NSString*)name;

- (id) initWithClass:(Class)aClass;

- (BOOL) classRespondsToSelector:(SEL)selector;
- (BOOL) classConformsToProtocol:(Protocol*)protocol;

- (ISMethodDescriptor*) methodWithSelector:(SEL)selector;
- (ISMethodDescriptor*) methodWithSelector:(SEL)selector instance:(BOOL)isInstance;
- (ISPropertyDescriptor*) propertyWithName:(NSString*)name;
- (ISInstanceVariableDescriptor*) instanceVariableWithName:(NSString*)name;

- (NSArray*) methodsInstance:(BOOL)isInstance;

@property (readonly) ISClassDescriptor* classSuperclass;
@property (readonly) NSNumber* classVersion;
@property (readonly) NSString* instanceVariablesLayout;
@property (readonly) NSString* weakInstanceVariableLayout;
@property (readonly, strong) NSBundle* bundle;

@property (readonly) NSArray* protocols;
@property (readonly) NSArray* methods;
@property (readonly) NSArray* properties;
@property (readonly) NSArray* instanceVariables;*/

/*+ (NSArray*) allClasses {
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

+ (ISClassDescriptor*) descriptorForClass:(Class)aClass {
    return [[ISClassDescriptor alloc] initWithClass:aClass];
}

+ (ISClassDescriptor*) descriptorForClassName:(NSString*)aClassName {
    Class class = objc_getClass([aClassName cStringUsingEncoding:NSASCIIStringEncoding]);
    if (class == nil)
        return nil;
    
    return [ISClassDescriptor descriptorForClass:class];
}

+ (NSArray*) classesInBundle:(NSBundle*)aBundle {
    unsigned int count = 0;
    const char **classNames = objc_copyClassNamesForImage(
        [[aBundle executablePath] cStringUsingEncoding:NSUTF8StringEncoding],                                                  
        &count
    );
    
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [result addObject:
            [ISClassDescriptor 
                descriptorForClassName:[NSString stringWithCString:classNames[i] encoding:NSASCIIStringEncoding]
            ]
        ];
    }
    
    free(classNames);
    
    return result;
}

- (id) initWithClass:(Class)aClass {
    self = [super init];
    if (self)
        _class = aClass;
    
    return self;
}

- (NSString*)name {
    const char *name = class_getName(_class);
    
    return [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
}

- (NSBundle*)bundle {
    return [NSBundle bundleForClass:_class];
}*/

@end
