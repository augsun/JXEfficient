//
//  JXVideoPlayerView.m
//  JXEfficient
//
//  Created by augsun on 1/22/19.
//  Copyright © 2019 CoderSun. All rights reserved.
//

#import "JXVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "JXMacro.h"
#import "JXInline.h"

static const CGFloat kProgressViewHeight = 3.0;

// ====================================================================================================
@interface JXAVPlayerLayerView : UIView

@property (nonatomic, readonly) AVPlayerLayer *playerLayer;

@end

@implementation JXAVPlayerLayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end

// ====================================================================================================
@interface JXVideoPlayerView ()

@property (nonatomic, strong) AVPlayerItem *avPlayerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) JXAVPlayerLayerView *playerLayerView;

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSURL *URL_previous;

@property (nonatomic, assign) JXVideoPlayerViewStatus realStatus;

@property (nonatomic, strong) NSMutableDictionary <NSString *, id> *observers;

@end

@implementation JXVideoPlayerView

+ (instancetype)videoPlayerView {
    JXVideoPlayerView *view = [[JXVideoPlayerView alloc] init];
    return view;
}

+ (void)firstVideoFrameForURL:(NSURL *)URL completion:(void (^)(UIImage * _Nullable))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 60);
        CGImageRef imgRef = [assetGen copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *image = [[UIImage alloc] initWithCGImage:imgRef];
        CGImageRelease(imgRef);
        dispatch_async(dispatch_get_main_queue(), ^{
            JX_BLOCK_EXEC(completion, image);
        });
    });
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.realStatus = JXVideoPlayerViewStatusUnavailable;
        self.observers = [[NSMutableDictionary alloc] init];

        // playerLayerView
        self.playerLayerView = [[JXAVPlayerLayerView alloc] init];
        [self addSubview:self.playerLayerView];
        self.playerLayerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.playerLayerView attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.playerLayerView attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeRight
                                                           multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.playerLayerView attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeTop
                                                           multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.playerLayerView attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0 constant:0.0],
                               ]
         ];
        
        self.playerLayerView.playerLayer.videoGravity = AVLayerVideoGravityResize;
        
        // progressView
        _progressView = [[UIProgressView alloc] init];
        [self addSubview:self.progressView];
        self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeft
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeLeft
                                                           multiplier:1.0 constant:0.0],
                               [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeRight
                                                           multiplier:1.0 constant:0.f],
                               [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0 constant:kProgressViewHeight],
                               [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0 constant:0.0],
                               ]
         ];
        self.progressView.hidden = YES;
        self.progressView.backgroundColor = [UIColor clearColor];
        self.progressView.trackTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.6f];

        // 播放完成
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(jx_avPlayerItemDidPlayToEndTimeNotification:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        // 播放失败
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(jx_avPlayerItemFailedToPlayToEndTimeNotification:)
                                                     name:AVPlayerItemFailedToPlayToEndTimeNotification
                                                   object:nil];
        // 异常中断
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(jx_avPlayerItemPlaybackStalledNotification:)
                                                     name:AVPlayerItemPlaybackStalledNotification
                                                   object:nil];
        
        // player
        AVPlayer *player = [AVPlayer playerWithPlayerItem:nil];
        JX_WEAK_SELF;
        self.timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 6.0) queue:nil usingBlock:^(CMTime time) {
            JX_STRONG_SELF;

            // 播放
            if (self.status != JXVideoPlayerViewStatusPlaying && self.player.rate == 1.0) {
                self.realStatus = JXVideoPlayerViewStatusPlaying;
                if (!self.progressViewHidden) {
                    self.progressView.hidden = NO;
                }
            }
            
            CGFloat currentTime = CMTimeGetSeconds(time);
            self.progressView.progress = currentTime / self.duration;
            JX_BLOCK_EXEC(self.playingProgress, currentTime, self.duration);
            
            // 暂停 或 结束播放
            if (self.status != JXVideoPlayerViewStatusPause && self.player.rate == 0.0) {
                CGFloat currentTime = CMTimeGetSeconds(self.player.currentTime);
                CGFloat duration = self.duration;
                if (currentTime != duration) {
                    self.realStatus = JXVideoPlayerViewStatusPause;
                    self.progressView.hidden = YES;
                }
            }
        }];
        self.player = player;
        self.playerLayerView.playerLayer.player = self.player;
        [self jx_obj:self.player addObserverSelfForKey:@"rate"];


    }
    return self;
}

- (void)setProgressViewHidden:(BOOL)progressViewHidden {
    _progressViewHidden = progressViewHidden;
    self.progressView.hidden = YES;
}

- (void)setRealStatus:(JXVideoPlayerViewStatus)realStatus {
    if (_realStatus == realStatus) {
        return;
    }
    _realStatus = realStatus;
    _status = realStatus;
    JX_BLOCK_EXEC(self.statusDidChanged, realStatus);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for (NSString *keyEnum in self.observers.allKeys) {
        [self removeObserverForKey:keyEnum];
    }
    [self.player removeTimeObserver:self.timeObserver];
}

- (void)removeObserverForKey:(NSString *)key {
    id obj = [self.observers objectForKey:key];
    if (obj) {
        [obj removeObserver:self forKeyPath:key];
    }
}

- (void)jx_obj:(id)obj addObserverSelfForKey:(NSString *)key {
    [self removeObserverForKey:key];
    [self.observers setObject:obj forKey:key];
    [obj addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
}

// 播放完成
- (void)jx_avPlayerItemDidPlayToEndTimeNotification:(NSNotification *)noti {
    id object = noti.object;
    if (object == self.avPlayerItem) {
        self.progressView.hidden = YES;
        self.realStatus = JXVideoPlayerViewStatusEndPlaying;
    }
}

// 播放失败
- (void)jx_avPlayerItemFailedToPlayToEndTimeNotification:(NSNotification *)noti {
    id object = noti.object;
    if (object == self.avPlayerItem) {
        self.realStatus = JXVideoPlayerViewStatusFailure;
    }
}

// 异常中断
- (void)jx_avPlayerItemPlaybackStalledNotification:(NSNotification *)noti {
    id object = noti.object;
    if (object == self.avPlayerItem) {
        self.realStatus = JXVideoPlayerViewStatusFailure;
    }
}

- (void)setURL:(NSURL *)URL prepareForPlay:(BOOL)prepareForPlay {
    if (!URL) {
        return;
    }
    _URL = URL;
    
    self.realStatus = JXVideoPlayerViewStatusDidSetURL;
    
    if (!prepareForPlay) {
        return;
    }
    
    [self jx_checkIfNeedReInitial];
}

- (BOOL)canPlay {
    return
    self.realStatus == JXVideoPlayerViewStatusDidSetURL ||
    self.realStatus == JXVideoPlayerViewStatusReadyToPlay ||
    self.realStatus == JXVideoPlayerViewStatusPause ||
    self.realStatus == JXVideoPlayerViewStatusEndPlaying ||
    self.realStatus == JXVideoPlayerViewStatusFailure;
}

- (void)play {
    if (self.realStatus == JXVideoPlayerViewStatusDidSetURL) {
        [self jx_checkIfNeedReInitial];
        
        [self.player play];
    }
    else if (self.realStatus == JXVideoPlayerViewStatusReadyToPlay ||
             self.realStatus == JXVideoPlayerViewStatusPause ||
             self.realStatus == JXVideoPlayerViewStatusFailure) {
        
        [self.player play];
    }
    else if (self.realStatus == JXVideoPlayerViewStatusEndPlaying) {
        [self replay];
    }
    else {
        
    }
}

- (void)jx_checkIfNeedReInitial {
    if (![self.URL.absoluteString isEqualToString:self.URL_previous.absoluteString]) {
        self.URL_previous = self.URL;
        
        //
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:self.URL];
        [self jx_obj:item addObserverSelfForKey:@"status"];
        [self jx_obj:item addObserverSelfForKey:@"loadedTimeRanges"];
        self.avPlayerItem = item;
        
        [self.player replaceCurrentItemWithPlayerItem:item];
    }
}

- (BOOL)canReplay {
    return
    self.realStatus == JXVideoPlayerViewStatusReadyToPlay ||
    self.realStatus == JXVideoPlayerViewStatusPlaying ||
    self.realStatus == JXVideoPlayerViewStatusPause ||
    self.realStatus == JXVideoPlayerViewStatusEndPlaying ||
    self.realStatus == JXVideoPlayerViewStatusFailure;
}

- (void)replay {
    if (self.realStatus == JXVideoPlayerViewStatusPlaying ||
        self.realStatus == JXVideoPlayerViewStatusPause ||
        self.realStatus == JXVideoPlayerViewStatusEndPlaying ||
        self.realStatus == JXVideoPlayerViewStatusFailure ) {
        
        [self.player seekToTime:kCMTimeZero];
        [self.player play];
    }
    else {

    }
}

- (BOOL)canPause {
    return
    self.realStatus == JXVideoPlayerViewStatusPlaying;
}

- (void)pause {
    self.realStatus = JXVideoPlayerViewStatusPause;
    [self.player pause];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (object == self.avPlayerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerItemStatus status = jx_intValue(change[NSKeyValueChangeNewKey]);
            switch (status) {
                case AVPlayerItemStatusUnknown:
                {
                    self.realStatus = JXVideoPlayerViewStatusCannotBePlayedOrUnknown;
                } break;
                    
                case AVPlayerItemStatusReadyToPlay:
                {
                    _duration = CMTimeGetSeconds(self.avPlayerItem.duration);
                    self.realStatus = JXVideoPlayerViewStatusReadyToPlay;
                } break;
                    
                case AVPlayerItemStatusFailed:
                {
                    self.realStatus = JXVideoPlayerViewStatusCannotBePlayedOrUnknown;
                } break;
                    
                default: break;
            }
        }
        else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            _duration = CMTimeGetSeconds(self.avPlayerItem.duration);
            NSArray *array= self.avPlayerItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
            CGFloat start = CMTimeGetSeconds(timeRange.start);
            CGFloat duration = CMTimeGetSeconds(timeRange.duration);
            CGFloat loadedTime = start + duration;
            JX_BLOCK_EXEC(self.loadingProgress, loadedTime, self.duration);
        }
    }
    else if (object == self.player) {
        if ([keyPath isEqualToString:@"rate"]) {

        }
    }
}

@end









