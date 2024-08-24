//
//  KJIJKPlayerManager.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import "KJIJKPlayerManager.h"
//#import "IJKMediaFramework.h"//IJKPlayer静态库
#import <IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h>//IJKPlayer动态库

@interface KJIJKPlayerManager ()
@property (nonatomic, strong) id<IJKMediaPlayback> ijkPlayer;
@property (nonatomic, strong) IJKFFOptions *ffOptions;

@property (nonatomic, strong) NSTimer *timeObserver;

@end

@implementation KJIJKPlayerManager

static KJIJKPlayerManager *ijkPlayerSharedManager = nil;

+ (KJIJKPlayerManager *)sharedInstance
{
    if (ijkPlayerSharedManager == nil) {
        ijkPlayerSharedManager = [[KJIJKPlayerManager alloc] init];
    }
    return ijkPlayerSharedManager;
}

/// 构造IJKPlayer播放器
- (void)initWithPlayerItem:(AVPlayerItem *)playerItem superView:(UIView *)flashView {
    AVURLAsset *urlAsset = (AVURLAsset *)playerItem.asset;
    [self constructPlayer:urlAsset.URL superView:flashView];
}

- (void)initWithPlayerUrl:(NSURL *)playerUrl superView:(UIView *)flashView {
    [self constructPlayer:playerUrl superView:flashView];
}

- (void)constructPlayer:(NSURL *)videoURL superView:(UIView *)flashView {
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#endif
    
    self.ijkPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:videoURL withOptions:self.ffOptions];
    
    [self.ijkPlayer setScalingMode:IJKMPMovieScalingModeAspectFit];
    self.ijkPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.ijkPlayer.shouldAutoplay = NO;
    
    self.ijkPlayer.view.alpha = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.ijkPlayer.view.alpha = 1;
        self.ijkPlayer.view.frame = flashView.bounds;
        //shouldAutoplay不开启，需手动调用play
        [self play];
    });
    
    [flashView addSubview:self.ijkPlayer.view];
    
    //需要在播放前监听
    [self addPlayerNotificationObservers];
    
    [self.ijkPlayer prepareToPlay];
    
    self.timeObserver = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timeObserver forMode:NSRunLoopCommonModes];
    
}

- (void)play {
    [self.ijkPlayer play];
}

- (void)pause {
    [self.ijkPlayer pause];
}

- (void)stop {
    [self.ijkPlayer stop];
    [self.ijkPlayer shutdown];
    
    [self removePlayerNotificationObservers];
    [self.timeObserver invalidate];
    self.timeObserver = nil;
    
    [self.ijkPlayer.view removeFromSuperview];
    self.ijkPlayer = nil;
    
}

- (float)sliderSelectedEndWithValue:(float)value {
        
    double dragTime = self.ijkPlayer.duration * value;
    if (dragTime >= self.ijkPlayer.duration) {
        dragTime = self.ijkPlayer.duration;
    }
    self.ijkPlayer.currentPlaybackTime = dragTime;
    
    return 0;
}

- (void)updateProgress {
    
    if (![self.ijkPlayer isPlaying]) {
        return;
    }
    
    NSTimeInterval currentPlayTime = self.ijkPlayer.currentPlaybackTime;
    NSTimeInterval totalDuration = self.ijkPlayer.duration;
    if (currentPlayTime > totalDuration) {
        currentPlayTime = totalDuration;
    }
    CGFloat progress = currentPlayTime/totalDuration;
    
    [KJPlayerLogic sharedInstance].playerDuration = totalDuration;
 
    if ([self.delegate respondsToSelector:@selector(currentPlayUpdateWithCurrentTimeText:progress:)]) {
        [self.delegate currentPlayUpdateWithCurrentTimeText:[NSString stringWithFormat:@"%f",currentPlayTime] progress:progress];
    }
}

- (void)addPlayerNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerFirstVideoFrameRenderedNotification:)
                                                 name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification
                                               object:self.ijkPlayer];
}

# pragma mark - Notification handlers
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{

}

- (void)loadStateDidChange:(NSNotification*)notification
{
 
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    switch (self.ijkPlayer.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
        {
            if ([self.delegate respondsToSelector:@selector(playEnd)]) {
                [self.delegate playEnd];
            }
        }
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
        {
            if ([self.delegate respondsToSelector:@selector(playerItemStatusReadyToPlay)]) {
                [self.delegate playerItemStatusReadyToPlay];
            }
        }
            break;
            
        case IJKMPMoviePlaybackStatePaused:
        {
            
        }
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            
            break;
        default:
            break;
    }
}

- (void)moviePlayerFirstVideoFrameRenderedNotification:(NSNotification*)notification
{

}

- (void)moviePlayBackFinish:(NSNotification*)notification
{

}

- (void)removePlayerNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:self.ijkPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerFirstVideoFrameRenderedNotification
                                                  object:self.ijkPlayer];
}


- (IJKFFOptions *)ffOptions {
    if (!_ffOptions) {
        _ffOptions = [IJKFFOptions optionsByDefault];
        
        [_ffOptions setPlayerOptionIntValue:5 forKey:@"framedrop"];
        /// 精准seek
        [_ffOptions setPlayerOptionIntValue:1 forKey:@"enable-accurate-seek"];
        
        [_ffOptions setOptionIntValue:1 forKey:@"dns_cache_clear" ofCategory:kIJKFFOptionCategoryFormat];
        
        [_ffOptions setFormatOptionIntValue:1024 forKey:@"probesize"];
        // 自动转屏开关
        [_ffOptions setFormatOptionIntValue:1 forKey:@"auto_convert"];
        
        [_ffOptions setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
        [_ffOptions setPlayerOptionIntValue:3 forKey:@"reconnect"];
        
        [_ffOptions setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter"];
        [_ffOptions setCodecOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame"];
        
        [_ffOptions setPlayerOptionIntValue:0 forKey:@"max_cached_duration"];
        [_ffOptions setPlayerOptionIntValue:0 forKey:@"infbuf"];
        [_ffOptions setPlayerOptionIntValue:1 forKey:@"packet-buffering"];
    }
    return _ffOptions;
}

@end
