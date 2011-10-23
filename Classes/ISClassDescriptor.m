#import "ISClassDescriptor.h"

@implementation ISClassDescriptor {
@private
    Class _class;
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
}

/*
- (BOOL)respondsToSelector:(SEL)aSelector {
}

- (BOOL)conformsToProtocol:(ISProtocolDescriptor*)aProtocol {
}

- (NSNumber*)version {
}

- (void)setVersion:(NSNumber*)aVersion

- (NSString*)name {
    return nil;
}

- (NSArray*)superclass {
    return nil;
}

- (NSArray*)protocols {
    return nil;
}

- (NSArray*)methods {
    return nil;
}

- (NSArray*)properties {
    return nil;
}

- (NSArray*)instanceVariables {
    return nil;
}
*/

@end
