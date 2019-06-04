//
//  JXEncryption.m
//  JXEfficient
//
//  Created by augsun on 4/25/19.
//

#import "JXEncryption.h"

#if 0
#define XOR_KEY 0xBB
void xorString(unsigned char *str, unsigned char key) {
    unsigned char *p = str;
    while( ((*p) ^=  key) != '\0') {
        p++;
    }
}

NSString * gIv(void) {
    unsigned char str[] = {
        (XOR_KEY ^ '0'),
        (XOR_KEY ^ '1'),
        (XOR_KEY ^ '2'),
        (XOR_KEY ^ '3'),
        (XOR_KEY ^ '4'),
        (XOR_KEY ^ '5'),
        (XOR_KEY ^ '6'),
        (XOR_KEY ^ '7'),
        (XOR_KEY ^ '8'),
        (XOR_KEY ^ '9'),
        (XOR_KEY ^ 'a'),
        (XOR_KEY ^ 'b'),
        (XOR_KEY ^ 'c'),
        (XOR_KEY ^ 'd'),
        (XOR_KEY ^ 'e'),
        (XOR_KEY ^ 'f'),
        (XOR_KEY ^ '\0')
    };
    
    xorString(str, XOR_KEY);
    
    size_t strLen = sizeof(str);
    char result[strLen];
    memcpy(result, str, strLen);
    
    char *dest_str;
    dest_str = (char *)malloc(sizeof(char) * (sizeof(result)));
    strncpy(dest_str, result, sizeof(result));
    
    NSString *result_str = [NSString stringWithCString:dest_str encoding:NSUTF8StringEncoding];
    return result_str;
}
#endif

@implementation JXEncryption

@end
