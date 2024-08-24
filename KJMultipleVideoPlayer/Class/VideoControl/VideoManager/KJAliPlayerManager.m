//
//  KJAliPlayerManager.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import "KJAliPlayerManager.h"
#import <AliyunPlayer/AliyunPlayer.h>

@interface KJAliPlayerManager () <AVPDelegate>

@property (nonatomic, strong) AliPlayer *player;
@property (nonatomic, strong) UIView *playerView;

@end

@implementation KJAliPlayerManager

static KJAliPlayerManager *aliPlayerSharedManager = nil;

+ (KJAliPlayerManager *)sharedInstance
{
    if (aliPlayerSharedManager == nil) {
        aliPlayerSharedManager = [[KJAliPlayerManager alloc] init];
    }
    return aliPlayerSharedManager;
}

- (void)initWithVideoUrl:(NSURL *)videoUrl superView:(UIView *)flashView {
    
    self.player = [[AliPlayer alloc] init];
    AVPUrlSource *urlSource = [[AVPUrlSource alloc] urlWithString:videoUrl.absoluteString];
    [self.player setUrlSource:urlSource];
    self.player.playerView = flashView;
    self.player.autoPlay = YES;
    self.player.delegate = self;
    
    //设置视频快速启动
    [self.player setFastStart:YES];
    
    [self.player prepare];
    [self.player start];
    self.playerView = flashView;
}

- (void)play {
    [self.player start];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player stop];
    [self.player destroy];
    
    self.player.playerView = nil;
    self.player = nil;
}

- (float)sliderSelectedEndWithValue:(float)value {
    
    [self.player seekToTime:value * self.player.duration seekMode:AVP_SEEKMODE_ACCURATE];
    return 0;
}

#pragma mark - AVPDelegate

- (void)onPlayerEvent:(AliPlayer*)player eventType:(AVPEventType)eventType
{
    switch (eventType)
    {
        case AVPEventPrepareDone://准备完成
        {
            if ([self.delegate respondsToSelector:@selector(playerItemStatusReadyToPlay)]) {
                [self.delegate playerItemStatusReadyToPlay];
            }
        }
            break;
        case AVPEventFirstRenderedStart://首帧显示
        {

        }
            break;
        case AVPEventCompletion://播放完成
        {
            if ([self.delegate respondsToSelector:@selector(playEnd)]) {
                [self.delegate playEnd];
            }
        }
            break;
        case AVPEventLoadingStart://缓冲开始
        {
           
        }
            break;
        case AVPEventLoadingEnd://缓冲完成
        {

        }
            break;
            
        default:
            break;
    }
}

- (void)onPlayerEvent:(AliPlayer*)player eventWithString:(AVPEventWithString)eventWithString description:(NSString *)description
{
    
}

- (void)onError:(AliPlayer*)player errorModel:(AVPErrorModel *)errorModel
{

}

- (void)onCurrentPositionUpdate:(AliPlayer*)player position:(int64_t)position
{
    [KJPlayerLogic sharedInstance].playerDuration = self.player.duration/1000.0;

    if ([self.delegate respondsToSelector:@selector(currentPlayUpdateWithCurrentTimeText:progress:)]) {
        [self.delegate currentPlayUpdateWithCurrentTimeText:[NSString stringWithFormat:@"%f",position/1000.0] progress:position / [KJPlayerLogic sharedInstance].playerDuration / 1000];
    }
}

- (void)onTrackChanged:(AliPlayer*)player info:(AVPTrackInfo*)info
{

}

- (void)onTrackReady:(AliPlayer*)player info:(NSArray<AVPTrackInfo*>*)info
{

}

@end
