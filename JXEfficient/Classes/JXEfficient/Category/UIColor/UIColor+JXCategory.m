//
//  UIColor+JXCategory.m
//  JXEfficient
//
//  Created by augsun on 1/21/19.
//

#import "UIColor+JXCategory.h"
#import "JXMacro.h"
#import "JXInline.h"

@implementation UIColor (JXCategory)

+ (UIColor *)jx_colorFromHEXString:(NSString *)HEXString {
    NSString *tempStr = jx_strValue(HEXString);
    if (tempStr.length != 6) {
        return nil;
    }
    const char *hexChar = [tempStr cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    
    UIColor *color = JX_COLOR_HEX(hexNumber);
    return color;
}

@end
