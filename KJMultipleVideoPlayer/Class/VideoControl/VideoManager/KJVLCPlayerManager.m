//
//  KJVLCPlayerManager.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import "KJVLCPlayerManager.h"
#import <MobileVLCKit/MobileVLCKit.h>

@interface KJVLCPlayerManager ()

@property (nonatomic, strong) VLCMediaPlayer *player;
@property (nonatomic, assign) float lastTime;

@end

@implementation KJVLCPlayerManager

static KJVLCPlayerManager *vlcPlayerSharedManager = nil;

+ (KJVLCPlayerManager *)sharedInstance
{
    if (vlcPlayerSharedManager == nil) {
        vlcPlayerSharedManager = [[KJVLCPlayerManager alloc] init];
    }
    return vlcPlayerSharedManager;
}

- (void)initWithVideoUrl:(NSURL *)videoUrl superView:(UIView *)flashView {
    
    self.lastTime = 0;
    
    VLCMedia *media = [VLCMedia mediaWithURL:videoUrl];
    self.player.media = media;
    self.player.libraryInstance.debugLoggingTarget = self;
    NSMutableDictionary *mediaDicts = [[NSMutableDictionary alloc] init];
    [mediaDicts setObject:@"100"  forKey:@"network-caching"];
    [mediaDicts setObject:@"24"  forKey:@"fps"];
    [mediaDicts setObject:@"opensles"  forKey:@"--aout"];
    [mediaDicts setObject:@"1"  forKey:@"--deinterlace"];
    [mediaDicts setObject:@"blend"  forKey:@"--deinterlace-mode"];
    [self.player.media addOptions:mediaDicts];
    
    self.player.drawable = flashView;
    
    [self.player play];
    
}

- (void)pause {
    [self.player pause];
}

- (void)play {
    [self.player play];
}

- (void)stop {
    [self.player stop];
    self.player = nil;
}

- (float)sliderSelectedEndWithValue:(float)value {
    
    [self.player setPosition:value];
    return 0;
}

#pragma mark - VLCMediaPlayerDelegate

//播放状态改变的回调
- (void)mediaPlayerStateChanged:(NSNotification *)aNotification
{
    VLCMediaPlayer *current = aNotification.object;
    switch (current.state) {
        case VLCMediaPlayerStateStopped:
        {

        }
            break;
        case VLCMediaPlayerStateOpening:
        {

        }
            break;
        case VLCMediaPlayerStateBuffering:
        {

        }
            break;
        case VLCMediaPlayerStateEnded:
        {
            if ([self.delegate respondsToSelector:@selector(playEnd)]) {
                [self.delegate playEnd];
            }
        }
            break;
        case VLCMediaPlayerStateError:
        {
            
        }
            break;
        case VLCMediaPlayerStatePlaying:
        {
            if ([self.delegate respondsToSelector:@selector(playerItemStatusReadyToPlay)]) {
                [self.delegate playerItemStatusReadyToPlay];
            }
        }
            break;
        case VLCMediaPlayerStatePaused:
        {
            
        }
            break;
            
        default:
            break;
    }
}

//播放时间改变的回调
- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification
{
    
    VLCTime *currentTime = self.player.time;
    VLCTime *durantionTime = self.player.media.length;

    float currentTimeValue = currentTime.intValue / 1000 + self.lastTime;

    [KJPlayerLogic sharedInstance].playerDuration = durantionTime.value.integerValue/1000;
    if ([self.delegate respondsToSelector:@selector(currentPlayUpdateWithCurrentTimeText:progress:)]) {
        [self.delegate currentPlayUpdateWithCurrentTimeText:[NSString stringWithFormat:@"%f",currentTimeValue] progress:currentTimeValue / [KJPlayerLogic sharedInstance].playerDuration];
    }
}

- (VLCMediaPlayer *)player
{
    if (!_player) {
        NSArray *options = @[@"--audio-time-stretch", @"-vvv", @"--no-skip-frames",@"--extraintf=ios_dialog_provider"];
        _player = [[VLCMediaPlayer alloc] initWithOptions:options];
        _player.delegate = self;
    }
    return _player;
}

@end
