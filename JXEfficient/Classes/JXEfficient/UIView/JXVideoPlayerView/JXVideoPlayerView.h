//
//  JXVideoPlayerView.m
//  JXEfficient
//
//  Created by augsun on 1/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 播放状态 */
typedef NS_ENUM(NSUInteger, JXVideoPlayerViewStatus) {
    /** 不可用 */
    JXVideoPlayerViewStatusUnavailable = 0,
    /** 不能播放 */
    JXVideoPlayerViewStatusCannotBePlayedOrUnknown,
    
    /** 已设置 URL */
    JXVideoPlayerViewStatusDidSetURL,
    
    /** 播放准备就绪 */
    JXVideoPlayerViewStatusReadyToPlay,
    
    /** 播放中 */
    JXVideoPlayerViewStatusPlaying,
    /** 暂停中 */
    JXVideoPlayerViewStatusPause,
    /** 结束播放 */
    JXVideoPlayerViewStatusEndPlaying,
    
    /** 播放失败 */
    JXVideoPlayerViewStatusFailure,
};

@interface JXVideoPlayerView : UIView

+ (instancetype)videoPlayerView; ///< 指定初始化器

/**
 下载第一帧图片 该方法没有缓存 使用时自行缓存预览图 注意 cell 复用情况的性能花销
 @param URL 视频 URL
 @param completion 回调
 */
+ (void)firstVideoFrameForURL:(NSURL *)URL completion:(void (^)(UIImage * _Nullable img))completion; ///< 获取第一帧图片

@property (nonatomic, readonly) UIProgressView *progressView; ///< 播放进度
@property (nonatomic, assign) BOOL progressViewHidden; ///< 默认显示

/**
 @param URL 视频 URL
 @param prepareForPlay 是否准备进行播放 <进行缓冲>
 
 cell 复用的情况 prepareForPlay 传入 NO 以节约性能, 切记.
 如果服务器没有返回预览图片 可以外部调用 firstVideoFrameForURL: completion: 方法异步加载第一帧图片
 同时 自行在 JXVideoPlayerView 实例位置覆盖一层 UIImageView 以控制预览及视频播放层的显示隐藏状态.
 */
- (void)setURL:(NSURL *)URL prepareForPlay:(BOOL)prepareForPlay;

@property (nonatomic, readonly) JXVideoPlayerViewStatus status;
@property (nonatomic, copy, nullable) void (^statusDidChanged)(JXVideoPlayerViewStatus status); ///< 状态改变回调

@property (nonatomic, readonly) CGFloat duration; ///< 状态为 JXVideoPlayerViewStatusReadyToPlay 后才有效

/**
 调用 play 方法之后的 缓冲进度
 */
@property (nonatomic, copy, nullable) void (^loadingProgress)(CGFloat loadedTime, CGFloat duration);

/**
 调用 play 方法之后的 播放进度
 可能状态变为 JXVideoPlayerViewStatusPause 后 还会回调一次, 所以该回调实现里不建议处理状态相关业务, 只处理播放进度逻辑
 */
@property (nonatomic, copy, nullable) void (^playingProgress)(CGFloat currentTime, CGFloat duration);

@property (nonatomic, readonly) BOOL canPlay;
- (void)play;

@property (nonatomic, readonly) BOOL canReplay;
- (void)replay;

@property (nonatomic, readonly) BOOL canPause;
- (void)pause;

@end

NS_ASSUME_NONNULL_END





/* ================================================================================================== */
/* ====================================== JXEfficient Example. ====================================== */
/* ================================================================================================== */
#pragma mark - JXEfficient Example.

#if 0
- (void)awakeFromNib {
    [super awakeFromNib];
    JX_WEAK_SELF;
    
    // 实例化 videoPlayerView
    self.videoPlayerView = [JXVideoPlayerView videoPlayerView];
    [self.videoBgView addSubview:self.videoPlayerView];
    [_videoPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(kToL);
        make.right.mas_equalTo(self).with.offset(-kToR);
        make.top.bottom.mas_equalTo(self);
    }];
    
    // 状态改变回调
    self.videoPlayerView.statusDidChanged = ^(JXVideoPlayerViewStatus status) {
        JX_STRONG_SELF;
        switch (status) {
            case JXVideoPlayerViewStatusPlaying:
            {
                self.playImgView.hidden = YES;
            } break;
                
            case JXVideoPlayerViewStatusPause:
            case JXVideoPlayerViewStatusEndPlaying:
            {
                self.playImgView.hidden = NO;
            } break;
                
            default: break;
        }
    };
}

// 外部模型数据传入
- (void)refreshUI:(YJRMaterialDetailViewMap *)map {
    [super refreshUI:map];
    
    [self.videoPlayerView setURL:jx_URLValue(map.model.video) showFirstVideoFrame:YES];
}

// 播放 或 暂停 点击
- (IBAction)btnPlayClick:(id)sender {
    JX_BLOCK_EXEC(self.playClick);
    if (self.videoPlayerView.canPlay) {
        [self.videoPlayerView play];
    }
    else if (self.videoPlayerView.canPause) {
        [self.videoPlayerView pause];
    }
}

#endif
