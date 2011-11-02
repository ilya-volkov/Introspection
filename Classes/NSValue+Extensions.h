#import <Foundation/Foundation.h>

@interface NSValue (Extensions)

@property (readonly) NSUInteger size;

-(NSData*)dataValue;

@end
