//
//  JXMacro.h
//  JXEfficient
//
//  Created by augsun on 4/24/18.
//  Copyright © 2018 CoderSun. All rights reserved.
//

#import <Foundation/Foundation.h>

// 自定义色
#define JX_COLOR_RGBA(rr, gg, bb, aa)   [UIColor colorWithRed:(rr) / 255.0 green:(gg) / 255.0 blue:(bb) / 255.0 alpha:(aa) / 1.0] // RGBA 颜色
#define JX_COLOR_RGB(rr, gg, bb)        JX_COLOR_RGBA(rr, gg, bb, 1.0)                                   // RGB 颜色

#define JX_COLOR_HEX(hexValue)          [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 \
                                        green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 \
                                        blue:((float)(hexValue & 0xFF)) / 255.0 \
                                        alpha:1.0]                                                      // 十六进制 (0x9daa76)

#define JX_COLOR_GRAY(gray)             JX_COLOR_RGBA(gray, gray, gray, 1.0)                            // 灰度 [0, 255]
#define JX_COLOR_GRAY_PERCENT(percent)  JX_COLOR_GRAY(percent * 0.01 * 255.0)                           // 百分比灰度 [0, 100]
#define JX_COLOR_RANDOM                 JX_COLOR_RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256)) // 随机颜色

// 系统色
#define JX_COLOR_SYS_SECTION            JX_COLOR_RGB(239, 239, 244)                                     // (EFEFF4) section 颜色
#define JX_COLOR_SYS_CELL_LINE          JX_COLOR_RGB(200, 199, 204)                                     // (C8C7CC) cell分割线颜色
#define JX_COLOR_SYS_CELL_SELECTION     JX_COLOR_RGB(217, 217, 217)                                     // (D9D9D9) cell选中颜色
#define JX_COLOR_SYS_BLUE               JX_COLOR_RGB(000, 122, 255)                                     // (007AFF) btn 蓝色
#define JX_COLOR_SYS_TAB_LINE           JX_COLOR_RGB(167, 167, 170)                                     // (A7A7AA) tab nav 栏的横线
#define JX_COLOR_SYS_TAB_FONT           JX_COLOR_RGB(146, 146, 146)                                     // (929292) tab nav 栏的灰色字
#define JX_COLOR_SYS_PLACEHOLDER        JX_COLOR_RGB(199, 199, 204)                                     // (c7c7cc) placeholder
#define JX_COLOR_SYS_IMG_BG             JX_COLOR_RGB(217, 217, 217)                                     // (D9D9D9) 图片背景
#define JX_COLOR_SYS_SEARCH             JX_COLOR_RGB(200, 200, 206)                                     // (C8C8CE) 搜索框边上颜色

#define JX_SCREEN_W                     [UIScreen mainScreen].bounds.size.width                         // 屏幕宽
#define JX_SCREEN_H                     [UIScreen mainScreen].bounds.size.height                        // 屏幕高

#define JX_SCREEN_SCALE                 [UIScreen mainScreen].scale                                     // 屏幕缩放刻度比例

#define JX_SCREEN_W_IS_320              (JX_SCREEN_W == 320.0 ? YES : NO)                               // 是否 320 宽的手机 5s
#define JX_SCREEN_W_IS_375              (JX_SCREEN_W == 375.0 ? YES : NO)                               // 是否 375 宽的手机 6s
#define JX_SCREEN_W_IS_414              (JX_SCREEN_W == 414.0 ? YES : NO)                               // 是否 414 宽的手机 6sP

#define JX_SCREEN_H_IS_480              (JX_SCREEN_H == 480.0 ? YES : NO)                               // 是否 480 高的手机 4s
#define JX_SCREEN_H_IS_568              (JX_SCREEN_H == 568.0 ? YES : NO)                               // 是否 568 高的手机 5s
#define JX_SCREEN_H_IS_667              (JX_SCREEN_H == 667.0 ? YES : NO)                               // 是否 667 高的手机 6s
#define JX_SCREEN_H_IS_736              (JX_SCREEN_H == 736.0 ? YES : NO)                               // 是否 736 高的手机 6sP
#define JX_SCREEN_H_IS_812              (JX_SCREEN_H == 812.0 ? YES : NO)                               // 是否 812 高的手机 iPhone X, XS
#define JX_SCREEN_H_IS_896              (JX_SCREEN_H == 896.0 ? YES : NO)                               // 是否 896 高的手机 iPhone XS Max, XR

#define JX_SCREEN_ONE_PIX               (1.0 / JX_SCREEN_SCALE)                                         // 屏幕一个像素

#define JX_STATUSBAR_H                  [UIApplication sharedApplication].statusBarFrame.size.height    // 状态栏高
#define JX_STATUSBAR_H_IS_44            (JX_STATUSBAR_H == 44.0)                                        // iPhone X
#define JX_NAVBAR_H                     (JX_STATUSBAR_H_IS_44 ? 88.0 : 64.0)                            // 导航条高
#define JX_TABBAR_H                     (JX_STATUSBAR_H_IS_44 ? 83.0 : 49.0)                            // 标签栏高

#define JX_WEAK_SELF                    __weak __typeof(self) weakSelf = self
#define JX_STRONG_SELF                  __strong __typeof(weakSelf) self = weakSelf

#define JX_DOCUMENT_DIRECTORY           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] // Document 目录
#define JX_DOCUMENT_APPEND(path)        [JX_DOCUMENT_DIRECTORY stringByAppendingPathComponent:path]     // Document 下路径拼接

#define JX_SECONDS_OF_DAY               86400                                                           // 一天的秒数
#define JX_UNUSE_AREA_OF_BOTTOM         (JX_TABBAR_H - 49.0)                                            // X 底部闲置区域 34pt
#define JX_BLOCK_EXEC(block, ...)       !block ? nil : block(__VA_ARGS__)                               // 执行无返回值的 block

#define JX_ALWAYS_INLINE                __inline__ __attribute__((always_inline))

#define JX_DRAW_OPTION                  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading          // 文本计算选项

#define JX_DEALLOC_TEST_LOG             NSLog(@"jx_dealloc -> %@", NSStringFromClass([self class]))
#define JX_DEALLOC_TEST                 - (void)dealloc { JX_DEALLOC_TEST_LOG; }

#define JX_ASSERT_MSG(assertMsg)        [NSString stringWithFormat:@"%@: %@", NSStringFromClass([self class]), assertMsg]

@interface JXMacro : NSObject

@end
