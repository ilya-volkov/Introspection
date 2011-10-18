#import "ISClassDescriptor.h"

// research objc_copyImageNames

@implementation ISClassDescriptor

// filter out classes with empty names
+ (NSArray*) allClasses {
    unsigned int outCount;
    Class* classes = objc_copyClassList(&outCount);
    
    NSMutableArray* result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        id class = [ISClassDescriptor descriptorForClass:classes[i]];
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
    
    return [[ISClassDescriptor alloc] initWithClass:class];
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
