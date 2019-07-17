//
//  JXNavigationBarItem.m
//  JXEfficient
//
//  Created by augsun on 3/5/19.
//

#import "JXNavigationBarItem.h"
#import "NSLayoutConstraint+JXCategory.h"
#import "JXMacro.h"
#import "JXInline.h"
#import "UIButton+JXCategory.h"
#import "UIView+JXCategory.h"

static const CGFloat k_min_content_width = 20.0;
static const CGFloat k_contentEdgeInsets_LR = 4.0;
static const CGFloat k_titleLabel_minimumScaleFactor = 0.65;

const NSInteger JXNavigationBarItemNormalTitleColorDefault = 0x333333;
const NSInteger JXNavigationBarItemHighlightedColorDefault = 0xcccccc;
const NSInteger JXNavigationBarItemDisabledColorDefault = 0xbbbbbb;

const NSInteger JXNavigationBarItemFontSizeDefault = 15.0;

typedef NS_ENUM(NSUInteger, JXNavigationBarItemType) {
    JXNavigationBarItemTypeUnSet,
    JXNavigationBarItemTypeTitle,
    JXNavigationBarItemTypeAttributedTitle,
    JXNavigationBarItemTypeImage,
};

@interface JXNavigationBarItem ()

@property (nonatomic, assign) JXNavigationBarItemType type;

// JXNavigationBarItemTypeTitle
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, copy) NSString *highlightedTitle;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, copy) NSString *disabledTitle;
@property (nonatomic, strong) UIColor *disabledColor;
@property (nonatomic, strong) UIFont *font;

// JXNavigationBarItemTypeAttributedTitle
@property (nonatomic, copy) NSAttributedString *normalAttributedTitle;
@property (nonatomic, copy) NSAttributedString *highlightedAttributedTitle;
@property (nonatomic, copy) NSAttributedString *disabledAttributedTitle;

// JXNavigationBarItemTypeImage
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *disabledImage;

@end

@implementation JXNavigationBarItem

@synthesize rightForShowing = _rightForShowing, contentWidth = _contentWidth;

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentEdgeInsets = UIEdgeInsetsMake(0.0, k_contentEdgeInsets_LR, 0.0, k_contentEdgeInsets_LR);
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.button.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.button.titleLabel.minimumScaleFactor = k_titleLabel_minimumScaleFactor;
        self.button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.button];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.button jx_con_edgeEqual:self]];
        self.button.contentEdgeInsets = self.contentEdgeInsets;
        [self.button addTarget:self action:@selector(jx_button_click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

//  标题 设置方式 1_0: 不同状态下 [同一标题 同一颜色 同一字体]
- (void)setTitle:(NSString *)title
{
    [self setTitle:title color:nil font:nil];
}

// 标题 设置方式 1_1: 不同状态下 [同一标题 同一颜色 同一字体]
- (void)setTitle:(NSString *)title
           color:(UIColor *)color
            font:(UIFont *)font
{
    [self setNormalTitle:title
             normalColor:color
        highlightedTitle:title
        highlightedColor:color
           disabledTitle:title
           disabledColor:color
                    font:font];
}

// 设置方式 2: 不同状态下 [同一标题 不同颜色 同一字体]
- (void)setTitle:(NSString *)title
     normalColor:(UIColor *)normalColor
highlightedColor:(UIColor *)highlightedColor
   disabledColor:(UIColor *)disabledColor
            font:(UIFont *)font
{
    [self setNormalTitle:title
             normalColor:normalColor
        highlightedTitle:title
        highlightedColor:highlightedColor
           disabledTitle:title
           disabledColor:disabledColor
                    font:font];
}

// 设置方式 3: 不同状态下 [不同标题 不同颜色 同一字体]
- (void)setNormalTitle:(NSString *)normalTitle
           normalColor:(UIColor *)normalColor
      highlightedTitle:(NSString *)highlightedTitle
      highlightedColor:(UIColor *)highlightedColor
         disabledTitle:(NSString *)disabledTitle
         disabledColor:(UIColor *)disabledColor
                  font:(UIFont *)font
{
    if (normalTitle && [normalTitle isKindOfClass:[NSString class]]) {
        
        highlightedTitle = jx_strValue(highlightedTitle);
        disabledTitle = jx_strValue(disabledTitle);
        
        if (highlightedTitle.length <= 0) {
            highlightedTitle = normalTitle;
        }
        if (disabledTitle.length <= 0) {
            disabledTitle = normalTitle;
        }
        
        // color
        if (!normalColor || ![normalColor isKindOfClass:[UIColor class]]) {
            normalColor = JX_COLOR_HEX(JXNavigationBarItemNormalTitleColorDefault);
        }
        if (!highlightedColor || ![highlightedColor isKindOfClass:[UIColor class]]) {
            highlightedColor = JX_COLOR_HEX(JXNavigationBarItemHighlightedColorDefault);
        }
        if (!disabledColor || ![disabledColor isKindOfClass:[UIColor class]]) {
            disabledColor = JX_COLOR_HEX(JXNavigationBarItemDisabledColorDefault);
        }
        
        // font
        if (font == nil || ![font isKindOfClass:[UIFont class]]) {
            font = [UIFont systemFontOfSize:JXNavigationBarItemFontSizeDefault];
        }
        
        //
        self.button.titleLabel.font = font;
        
        [self.button setTitle:normalTitle forState:UIControlStateNormal];
        [self.button setTitle:highlightedTitle forState:UIControlStateHighlighted];
        [self.button setTitle:disabledTitle forState:UIControlStateDisabled];
        
        [self.button jx_titleColorStyleNormalColor:normalColor
                                  highlightedColor:highlightedColor
                                     disabledColor:disabledColor];
        
        [self.button setImage:nil forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateHighlighted];
        [self.button setImage:nil forState:UIControlStateDisabled];
        
        static CGFloat (^count_title_w)(NSString *, UIFont *) = ^ CGFloat (NSString *t, UIFont *f) {
            CGFloat w = [t boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44.0)
                                        options:JX_DRAW_OPTION
                                     attributes:@{NSFontAttributeName: f}
                                        context:nil].size.width + 1.0;
            return w;
        };
        
        CGFloat contentWidth = k_min_content_width;
        
        {
            CGFloat title_w = count_title_w(normalTitle, font);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        if (![highlightedTitle isEqualToString:normalTitle]) {
            CGFloat title_w = count_title_w(normalTitle, font);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        if (![disabledTitle isEqualToString:normalTitle] && ![disabledTitle isEqualToString:highlightedTitle]) {
            CGFloat title_w = count_title_w(normalTitle, font);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        
        //
        self.type = JXNavigationBarItemTypeTitle;
        self.normalTitle = normalTitle;
        self.normalColor = normalColor;
        self.highlightedTitle = highlightedTitle;
        self.highlightedColor = highlightedColor;
        self.disabledTitle = disabledTitle;
        self.disabledColor = disabledColor;
        self.font = font;
        
        //
        self.contentWidth = contentWidth;
        self.rightForShowing = YES;
    }
    else {
        self.rightForShowing = NO;
    }
    
    //
    [self JXNavigationBarItem_needLayout];
}

- (void)setNormalAttributedTitle:(NSAttributedString *)normalAttributedTitle
      highlightedAttributedTitle:(NSAttributedString *)highlightedAttributedTitle
         disabledAttributedTitle:(NSAttributedString *)disabledAttributedTitle
{
    if (normalAttributedTitle && [normalAttributedTitle isKindOfClass:[NSAttributedString class]]) {
        
        if (!highlightedAttributedTitle || ![highlightedAttributedTitle isKindOfClass:[NSAttributedString class]]) {
            highlightedAttributedTitle = normalAttributedTitle;
        }
        if (!disabledAttributedTitle || ![disabledAttributedTitle isKindOfClass:[NSAttributedString class]]) {
            disabledAttributedTitle = normalAttributedTitle;
        }
        
        [self.button setAttributedTitle:normalAttributedTitle forState:UIControlStateNormal];
        [self.button setAttributedTitle:highlightedAttributedTitle forState:UIControlStateHighlighted];
        [self.button setAttributedTitle:disabledAttributedTitle forState:UIControlStateDisabled];
        
        [self.button setImage:nil forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateHighlighted];
        [self.button setImage:nil forState:UIControlStateDisabled];
        
        static CGFloat (^count_title_w_arr)(NSAttributedString *) = ^ CGFloat (NSAttributedString *t) {
            CGFloat w = [t boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44.0)
                                        options:JX_DRAW_OPTION
                                        context:nil].size.width + 1.0;
            return w;
        };
        
        CGFloat contentWidth = k_min_content_width;
        
        {
            CGFloat title_w = count_title_w_arr(normalAttributedTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        if (![highlightedAttributedTitle isEqualToAttributedString:normalAttributedTitle]) {
            CGFloat title_w = count_title_w_arr(highlightedAttributedTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        if ([disabledAttributedTitle isEqualToAttributedString:normalAttributedTitle] && [disabledAttributedTitle isEqualToAttributedString:highlightedAttributedTitle]) {
            CGFloat title_w = count_title_w_arr(disabledAttributedTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        
        //
        self.type = JXNavigationBarItemTypeAttributedTitle;
        self.normalAttributedTitle = normalAttributedTitle;
        self.highlightedAttributedTitle = highlightedAttributedTitle;
        self.disabledAttributedTitle = disabledAttributedTitle;
        
        //
        self.contentWidth = contentWidth;
        self.rightForShowing = YES;
    }
    else {
        self.rightForShowing = NO;
    }
    
    //
    [self JXNavigationBarItem_needLayout];
}

- (void)setImageForNormal:(UIImage *)normalImage
              highlighted:(UIImage *)highlightedImage
                 disabled:(UIImage *)disabledImage
{
    static BOOL (^rightImage)(UIImage *) = ^ BOOL (UIImage *img) {
        BOOL ret = img && [img isKindOfClass:[UIImage class]] && img.size.width > 0.0 && img.size.height > 0.0;
        return ret;
    };
    
    if (rightImage(normalImage)) {
        if (!rightImage(highlightedImage)) {
            highlightedImage = normalImage;
        }
        if (!rightImage(disabledImage)) {
            disabledImage = normalImage;
        }
        
        [self.button jx_titleForAllStatus:nil];
        [self.button setImage:normalImage forState:UIControlStateNormal];
        [self.button setImage:highlightedImage forState:UIControlStateHighlighted];
        [self.button setImage:disabledImage forState:UIControlStateDisabled];
        
        static CGFloat (^count_w)(UIImage *, UIEdgeInsets) = ^ CGFloat (UIImage *i, UIEdgeInsets e) {
            CGFloat w = i.size.width;
            CGFloat h = i.size.height;
            CGFloat r = w / h;
            CGFloat count_w = 0.0;
            CGFloat remain_h = 44.0 - e.top - e.bottom;
            if (h < remain_h) {
                count_w = h * r;
            }
            else if (h > remain_h) {
                count_w = remain_h * r;
            }
            return count_w;
        };
        
        CGFloat contentWidth = k_min_content_width;
        
        {
            contentWidth = count_w(normalImage, self.contentEdgeInsets);
        }
        if (highlightedImage && highlightedImage != normalImage) {
            contentWidth = MAX(contentWidth, count_w(highlightedImage, self.contentEdgeInsets));
        }
        if (disabledImage && disabledImage != normalImage && disabledImage != highlightedImage) {
            contentWidth = MAX(contentWidth, count_w(disabledImage, self.contentEdgeInsets));
        }
        
        //
        self.type = JXNavigationBarItemTypeImage;
        self.normalImage = normalImage;
        self.highlightedImage = highlightedImage;
        self.disabledImage = disabledImage;
        
        //
        self.contentWidth = contentWidth;
        self.rightForShowing = YES;
    }
    else {
        self.rightForShowing = NO;
    }
    
    //
    [self JXNavigationBarItem_needLayout];
}

- (void)setBackgroundImageForNormal:(UIImage *)normalBgImage highlighted:(UIImage *)highlightedBgImage disabled:(UIImage *)disabledBgImage {
    [self.button setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    [self.button setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    [self.button setBackgroundImage:disabledBgImage forState:UIControlStateDisabled];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    self.button.contentEdgeInsets = contentEdgeInsets;
    switch (self.type) {
        case JXNavigationBarItemTypeTitle:
        {
            [self setNormalTitle:self.normalTitle
                     normalColor:self.normalColor
                highlightedTitle:self.highlightedTitle
                highlightedColor:self.highlightedColor
                   disabledTitle:self.disabledTitle
                   disabledColor:self.disabledColor
                            font:self.font];
        } break;
            
        case JXNavigationBarItemTypeAttributedTitle:
        {
            [self setNormalAttributedTitle:self.normalAttributedTitle
                highlightedAttributedTitle:self.highlightedAttributedTitle
                   disabledAttributedTitle:self.disabledAttributedTitle];
        } break;
            
        case JXNavigationBarItemTypeImage:
        {
            [self setImageForNormal:self.normalImage
                        highlighted:self.highlightedImage
                           disabled:self.disabledImage];
        } break;
            
        default: break;
    }
    [self JXNavigationBarItem_needLayout];
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.userInteractionEnabled = enable;
}

- (void)setHidden:(BOOL)hidden {
    if (self.hidden != hidden) {
        [super setHidden:hidden];
        [self JXNavigationBarItem_needLayout];
    }
}

- (void)setContentWidth:(CGFloat)contentWidth {
    if (_contentWidth != contentWidth) {
        _contentWidth = contentWidth;
        [self JXNavigationBarItem_needLayout];
    }
}

- (void)setRightForShowing:(BOOL)rightForShowing {
    if (_rightForShowing != rightForShowing) {
        _rightForShowing = rightForShowing;
        self.button.hidden = !rightForShowing;
        [self JXNavigationBarItem_needLayout];
    }
}

- (void)JXNavigationBarItem_needLayout {
    _itemWidth = self.contentWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    JX_BLOCK_EXEC(self.setNeedsLayoutInHoldingView);
}

- (void)jx_button_click {
    JX_BLOCK_EXEC(self.click);
}

@end


