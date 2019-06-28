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

static const CGFloat k_min_content_width = 20.0;
static const CGFloat k_contentEdgeInsets_LR = 4.0;
static const CGFloat k_titleLabel_minimumScaleFactor = 0.65;

const NSInteger JXNavigationBarItemNormalTitleColorDefault = 0x333333;
const NSInteger JXNavigationBarItemHighlightedColorDefault = 0xcccccc;
const NSInteger JXNavigationBarItemDisabledColorDefault = 0xbbbbbb;

static const CGFloat kFont = 15.0;

typedef NS_ENUM(NSUInteger, JXNavigationBarItemType) {
    JXNavigationBarItemTypeUnSet,
    JXNavigationBarItemTypeTitle,
    JXNavigationBarItemTypeAttributedTitle,
    JXNavigationBarItemTypeImage,
};

@interface JXNavigationBarItem ()

@property (nonatomic, strong) UIButton *jx_button;
@property (nonatomic, assign) CGFloat jx_contentWidth;

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

- (instancetype)init {
    self = [super init];
    if (self) {
        _contentEdgeInsets = UIEdgeInsetsMake(0.0, k_contentEdgeInsets_LR, 0.0, k_contentEdgeInsets_LR);
        
        self.jx_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.jx_button.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.jx_button.titleLabel.minimumScaleFactor = k_titleLabel_minimumScaleFactor;
        self.jx_button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.jx_button];
        self.jx_button.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:[self.jx_button jx_con_edgeEqual:self]];
        self.jx_button.contentEdgeInsets = self.contentEdgeInsets;
        [self.jx_button addTarget:self action:@selector(jx_button_click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

// 设置方式 1: 不同状态下 [同一标题 同一字体 同一颜色]
- (void)setTitle:(NSString *)title
           color:(UIColor *)color
            font:(UIFont *)font
{
    if (color == nil || ![color isKindOfClass:[UIColor class]]) {
        color = nil;
    }
    [self setNormalTitle:title
             normalColor:color ? color : JX_COLOR_HEX(JXNavigationBarItemNormalTitleColorDefault)
        highlightedTitle:title
        highlightedColor:color ? color : JX_COLOR_HEX(JXNavigationBarItemHighlightedColorDefault)
           disabledTitle:title
           disabledColor:color ? color : JX_COLOR_HEX(JXNavigationBarItemDisabledColorDefault)
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
    normalTitle = jx_strValue(normalTitle);
    highlightedTitle = jx_strValue(highlightedTitle);
    disabledTitle = jx_strValue(disabledTitle);
    
    if (normalTitle.length > 0 || highlightedTitle.length > 0 || disabledTitle.length > 0) {
        if (font == nil || ![font isKindOfClass:[UIFont class]]) {
            font = [UIFont systemFontOfSize:kFont];
        }
        
        self.jx_button.titleLabel.font = font;

        [self.jx_button setTitle:normalTitle forState:UIControlStateNormal];
        [self.jx_button setTitle:highlightedTitle forState:UIControlStateHighlighted];
        [self.jx_button setTitle:disabledTitle forState:UIControlStateDisabled];
        
        [self.jx_button jx_titleColorStyleNormalColor:normalColor
                                     highlightedColor:highlightedColor
                                        disabledColor:disabledColor];

        [self.jx_button setImage:nil forState:UIControlStateNormal];
        [self.jx_button setImage:nil forState:UIControlStateHighlighted];
        [self.jx_button setImage:nil forState:UIControlStateDisabled];

        CGFloat (^count_title_w)(NSString *) = ^ CGFloat (NSString *title) {
            CGFloat title_w = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44.0)
                                                  options:JX_DRAW_OPTION
                                               attributes:@{NSFontAttributeName: font}
                                                  context:nil].size.width + 1.0;
            return title_w;
        };
        
        CGFloat contentWidth = k_min_content_width;
        if (normalTitle.length > 0) {
            
            CGFloat title_w = count_title_w(normalTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        if (highlightedTitle.length > 0 &&
            ![highlightedTitle isEqualToString:normalTitle]) {
            
            CGFloat title_w = count_title_w(highlightedTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        if (disabledTitle.length > 0 &&
            ![disabledTitle isEqualToString:normalTitle] &&
            ![disabledTitle isEqualToString:highlightedTitle]) {
            
            CGFloat title_w = count_title_w(disabledTitle);
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
        self.jx_contentWidth = contentWidth;
    }
    else {
        self.jx_contentWidth = 0.0;
    }
}

- (void)setNormalAttributedTitle:(NSAttributedString *)normalAttributedTitle
      highlightedAttributedTitle:(NSAttributedString *)highlightedAttributedTitle
         disabledAttributedTitle:(NSAttributedString *)disabledAttributedTitle
{
    if (![normalAttributedTitle isKindOfClass:[NSAttributedString class]]) { normalAttributedTitle = nil; }
    if (![highlightedAttributedTitle isKindOfClass:[NSAttributedString class]]) { highlightedAttributedTitle = nil; }
    if (![disabledAttributedTitle isKindOfClass:[NSAttributedString class]]) { disabledAttributedTitle = nil; }
    
    if (normalAttributedTitle.length > 0 || highlightedAttributedTitle.length > 0 || disabledAttributedTitle.length > 0) {

        [self.jx_button setAttributedTitle:normalAttributedTitle forState:UIControlStateNormal];
        [self.jx_button setAttributedTitle:highlightedAttributedTitle forState:UIControlStateHighlighted];
        [self.jx_button setAttributedTitle:disabledAttributedTitle forState:UIControlStateDisabled];

        [self.jx_button setImage:nil forState:UIControlStateNormal];
        [self.jx_button setImage:nil forState:UIControlStateHighlighted];
        [self.jx_button setImage:nil forState:UIControlStateDisabled];

        CGFloat (^count_title_w)(NSAttributedString *) = ^ CGFloat (NSAttributedString *title) {
            CGFloat title_w = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44.0)
                                                  options:JX_DRAW_OPTION
                                                  context:nil].size.width + 1.0;
            return title_w;
        };
        
        CGFloat contentWidth = k_min_content_width;
        if (normalAttributedTitle.length > 0) {
            
            CGFloat title_w = count_title_w(normalAttributedTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        BOOL ret0 = normalAttributedTitle ? (![highlightedAttributedTitle isEqualToAttributedString:normalAttributedTitle]) : YES; // 无 或 不相等 需要计算
        if (highlightedAttributedTitle.length > 0 && ret0) {
            
            CGFloat title_w = count_title_w(highlightedAttributedTitle);
            if (title_w > contentWidth) {
                contentWidth = title_w;
            }
        }
        BOOL ret1 = normalAttributedTitle ? ![disabledAttributedTitle isEqualToAttributedString:normalAttributedTitle] : YES;
        BOOL ret2 = highlightedAttributedTitle ? ![disabledAttributedTitle isEqualToAttributedString:highlightedAttributedTitle] : YES;
        if (disabledAttributedTitle.length > 0 && ret1 && ret2) {
            
            CGFloat title_w = count_title_w(disabledAttributedTitle);
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
        self.jx_contentWidth = contentWidth;
    }
    else {
        self.jx_contentWidth = 0.0;
    }
}

- (void)setImageForNormal:(UIImage *)normalImage
              highlighted:(UIImage *)highlightedImage
                 disabled:(UIImage *)disabledImage
{
    if (![normalImage isKindOfClass:[UIImage class]]) { normalImage = nil; }
    if (![highlightedImage isKindOfClass:[UIImage class]]) { highlightedImage = nil; }
    if (![disabledImage isKindOfClass:[UIImage class]]) { disabledImage = nil; }

    BOOL right_normal = normalImage.size.width > 0.0 && normalImage.size.height > 0.0;
    BOOL right_highlighted = highlightedImage.size.width > 0.0 && highlightedImage.size.height > 0.0;
    BOOL right_disabled = disabledImage.size.width > 0.0 && disabledImage.size.height > 0.0;

    if (right_normal || right_highlighted || right_disabled) {
        [self.jx_button jx_titleForAllStatus:nil];
        [self.jx_button setImage:normalImage forState:UIControlStateNormal];
        [self.jx_button setImage:highlightedImage forState:UIControlStateHighlighted];
        [self.jx_button setImage:disabledImage forState:UIControlStateDisabled];
        
        CGFloat (^count_w)(UIImage *) = ^ CGFloat (UIImage *img) {
            CGFloat w = img.size.width;
            CGFloat h = img.size.height;
            CGFloat r = w / h;
            CGFloat count_w = 0.0;
            CGFloat remain_h = 44.0 - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom;
            if (h < remain_h) {
                count_w = h * r;
            }
            else if (h > remain_h) {
                count_w = remain_h * r;
            }
            return count_w;
        };

        CGFloat contentWidth = k_min_content_width;
        if (right_normal) {
            contentWidth = count_w(normalImage);
        }
        if (highlightedImage && highlightedImage != normalImage) {
            contentWidth = MAX(contentWidth, count_w(highlightedImage));
        }
        if (disabledImage && disabledImage != normalImage && disabledImage != highlightedImage) {
            contentWidth = MAX(contentWidth, count_w(disabledImage));
        }
        
        //
        self.type = JXNavigationBarItemTypeImage;
        self.normalImage = normalImage;
        self.highlightedImage = highlightedImage;
        self.disabledImage = disabledImage;

        //
        self.jx_contentWidth = contentWidth;
    }
    else {
        self.jx_contentWidth = 0.0;
    }
}

- (BOOL)rightImg:(UIImage *)img {
    if (img.size.width > 0.0 && img.size.height > 0.0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setBackgroundImageForNormal:(UIImage *)normalBgImage highlighted:(UIImage *)highlightedBgImage disabled:(UIImage *)disabledBgImage {
    [self.jx_button setBackgroundImage:normalBgImage forState:UIControlStateNormal];
    [self.jx_button setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
    [self.jx_button setBackgroundImage:disabledBgImage forState:UIControlStateDisabled];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    _contentEdgeInsets = contentEdgeInsets;
    self.jx_button.contentEdgeInsets = contentEdgeInsets;
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
    [self jx_needLayout];
}

- (void)setEnable:(BOOL)enable {
    _enable = enable;
    self.userInteractionEnabled = enable;
    self.jx_button.enabled = enable;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self jx_needLayout];
}

- (void)setTitleMinimumScaleFactor:(CGFloat)titleMinimumScaleFactor {
    if (titleMinimumScaleFactor > 0.0 && titleMinimumScaleFactor <= 1.0) {
        _titleMinimumScaleFactor = titleMinimumScaleFactor;
        self.jx_button.titleLabel.minimumScaleFactor = titleMinimumScaleFactor;
    }
}

- (void)setJx_contentWidth:(CGFloat)jx_contentWidth {
    _jx_contentWidth = jx_contentWidth;
    [self jx_needLayout];
}

- (void)jx_needLayout {
    if (self.jx_contentWidth == 0.0) {
        _rightForShowing = NO;
        self.jx_button.hidden = YES;
        _itemWidth = 0.0;
    }
    else {
        _rightForShowing = YES;
        self.jx_button.hidden = NO;
        _itemWidth = self.jx_contentWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    }
    JX_BLOCK_EXEC(self.needLayout);
}

- (void)jx_button_click {
    JX_BLOCK_EXEC(self.click);
}

@end

