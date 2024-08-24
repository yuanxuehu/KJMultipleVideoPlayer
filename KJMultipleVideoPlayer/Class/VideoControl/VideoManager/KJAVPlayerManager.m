//
//  KJAVPlayerManager.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import "KJAVPlayerManager.h"

@interface KJAVPlayerManager ()

@property (nonatomic, strong) NSTimer *timeObserver;

@end

@implementation KJAVPlayerManager

static KJAVPlayerManager *avPlayerSharedManager = nil;

+ (KJAVPlayerManager *)sharedInstance
{
    if (avPlayerSharedManager == nil) {
        avPlayerSharedManager = [[KJAVPlayerManager alloc] init];
    }
    return avPlayerSharedManager;
}

- (void)initWithPlayerItem:(AVPlayerItem *)playerItem superView:(UIView *)flashView {
    
    self.playerItem = playerItem;
    self.playerItem.automaticallyPreservesTimeOffsetFromLive = YES;
    [self.playerItem seekToTime:kCMTimeZero completionHandler:nil];
    //初始化播放器
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.player.automaticallyWaitsToMinimizeStalling = NO;
    
    //视频播放层
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = flashView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    [flashView.layer addSublayer:self.playerLayer];
    
    //开始播放
    [self.player play];
    
    self.timeObserver = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timeObserver forMode:NSRunLoopCommonModes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnded:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self addObserver];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    //AVPlayer没有stop方法
    [self.player pause];
    self.player = nil;
    
    [self.timeObserver invalidate];
    self.timeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self removeObserver];

}

- (void)play {
    [self.player play];
}

- (float)sliderSelectedEndWithValue:(float)value {
    
    CMTime time = CMTimeMake([KJPlayerLogic sharedInstance].playerDuration * value, 1);
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    return 0;
}

- (void)playEnded:(NSNotification *)nofi {
    if ([self.delegate respondsToSelector:@selector(playEnd)]) {
        [self.delegate playEnd];
    }
}

- (void)playTimer:(NSTimer *)timer {
    
    [KJPlayerLogic sharedInstance].playerDuration = CMTimeGetSeconds(self.playerItem.duration);
    
    float seconds = CMTimeGetSeconds(self.playerItem.currentTime);
    if (seconds <= 0) {
        return;
    }
    
    NSString *currentTimeText = [NSString stringWithFormat:@"%f",seconds];
   
    float progress = CMTimeGetSeconds(self.playerItem.currentTime) / CMTimeGetSeconds(self.playerItem.duration);
    if (progress <= 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(currentPlayUpdateWithCurrentTimeText:progress:)]) {
        [self.delegate currentPlayUpdateWithCurrentTimeText:currentTimeText progress:progress];
    }
}

#pragma mark - AVPlayer Obsever
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = self.playerItem.status;
        switch (status) {
                //准备完毕，可以播放
            case AVPlayerItemStatusReadyToPlay:
            {
                if ([self.delegate respondsToSelector:@selector(playerItemStatusReadyToPlay)]) {
                    [self.delegate playerItemStatusReadyToPlay];
                }
            }
                break;
                //加载失败，网络或者服务器出现问题
            case AVPlayerItemStatusFailed:
            {
               
            }
                break;
                
            default:
                break;
        }
    } else if (object == self.playerItem && [keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
     
    } else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
       
    }
}

- (void)addObserver {
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

@end
