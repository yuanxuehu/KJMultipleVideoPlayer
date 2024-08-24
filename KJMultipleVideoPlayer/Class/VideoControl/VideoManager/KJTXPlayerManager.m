//
//  KJTXPlayerManager.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import "KJTXPlayerManager.h"
//#import <TXLiteAVSDK_Player/TXLiveBase.h>
#import <TXLiteAVSDK_Player/TXVodPlayer.h>

@interface KJTXPlayerManager ()

@property (nonatomic, strong) TXVodPlayer *player;
@property (nonatomic, strong) NSTimer *timeObserver;

@end

@implementation KJTXPlayerManager

static KJTXPlayerManager *txPlayerSharedManager = nil;

+ (KJTXPlayerManager *)sharedInstance
{
    if (txPlayerSharedManager == nil) {
        txPlayerSharedManager = [[KJTXPlayerManager alloc] init];
    }
    return txPlayerSharedManager;
}

- (void)initWithVideoUrl:(NSURL *)videoUrl superView:(UIView *)flashView {
    
    //初始化播放器
    self.player = [[TXVodPlayer alloc] init];
    [self.player setupVideoWidget:flashView insertIndex:0];
    [self.player setRenderMode:RENDER_MODE_FILL_EDGE];
    self.player.vodDelegate = self;
    
    //[self.player startVodPlay:videoUrl.absoluteString];
    [self.player startPlay:videoUrl.absoluteString];
    
    self.timeObserver = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timeObserver forMode:NSRunLoopCommonModes];
}

- (void)playTimer:(NSTimer *)timer {
    
    [KJPlayerLogic sharedInstance].playerDuration = self.player.duration;
    if ([self.delegate respondsToSelector:@selector(currentPlayUpdateWithCurrentTimeText:progress:)]) {
        [self.delegate currentPlayUpdateWithCurrentTimeText:[NSString stringWithFormat:@"%f",self.player.currentPlaybackTime] progress:self.player.currentPlaybackTime/self.player.duration];
    }
}

- (void)play {
    [self.player resume];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    if (self.timeObserver) {
        [self.timeObserver invalidate];
        self.timeObserver = nil;
    }
    [self.player stopPlay];
    [self.player removeVideoWidget];
    self.player = nil;
}

- (float)sliderSelectedEndWithValue:(float)value {
    
    int result = [self.player seek:value * self.player.duration];
    return result;
}


#pragma mark - TXVodPlayListener
//点播事件通知
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param
{
    if (EvtID == PLAY_EVT_PLAY_BEGIN) {
        if ([self.delegate respondsToSelector:@selector(playerItemStatusReadyToPlay)]) {
            [self.delegate playerItemStatusReadyToPlay];
        }
    } else if (EvtID == PLAY_EVT_PLAY_END) {
        if ([self.delegate respondsToSelector:@selector(playEnd)]) {
            [self.delegate playEnd];
        }
    } else if (EvtID == PLAY_EVT_PLAY_LOADING) {
        
    } else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
        
    }
    
}

//网络状态通知
- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param
{
    
}

//画中画状态回调
- (void)onPlayer:(TXVodPlayer *)player pictureInPictureStateDidChange:(TX_VOD_PLAYER_PIP_STATE)pipState withParam:(NSDictionary *)param
{
    
}

//画中画失败回调
- (void)onPlayer:(TXVodPlayer *)player pictureInPictureErrorDidOccur:(TX_VOD_PLAYER_PIP_ERROR_TYPE)errorType withParam:(NSDictionary *)param
{
    
}

@end
