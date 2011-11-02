#import "NSInvocation+Extensions.h"

@implementation NSInvocation (Extensions)

- (NSValue*)getReturnValue {
    NSUInteger length = [[self methodSignature] methodReturnLength];
    if (length == 0)
        return nil;
    
    NSMutableData *buffer = [NSMutableData dataWithLength:length];
    [self getReturnValue:[buffer mutableBytes]];
    
    return [NSValue 
        valueWithBytes:[buffer bytes] 
        objCType:[[self methodSignature] methodReturnType]
    ];
}

@end
