//
//  KJPlayerLogic.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import "KJPlayerLogic.h"
#import "KJAliPlayerManager.h"
#import "KJIJKPlayerManager.h"
#import "KJAVPlayerManager.h"
#import "KJVLCPlayerManager.h"
#import "KJTXPlayerManager.h"

@implementation KJPlayerLogic

static KJPlayerLogic *playerLogicSharedManager = nil;

+ (KJPlayerLogic *)sharedInstance
{
    if (playerLogicSharedManager == nil) {
        playerLogicSharedManager = [[KJPlayerLogic alloc] init];
    }
    return playerLogicSharedManager;
}

+ (void)initWithPlayerItem:(AVPlayerItem *)playerItem superView:(UIView *)flashView delegate:(id)delegate {
    
    //切换不同播放器
    if ([KJPlayerLogic onLocalPlayer]) {
        //IJKPlayer
        [[KJIJKPlayerManager sharedInstance] initWithPlayerItem:playerItem superView:flashView];
        [KJIJKPlayerManager sharedInstance].delegate = delegate;
        
        //AliPlayer
        //[[KJAliPlayerManager sharedInstance] initWithVideoUrl:((AVURLAsset *)playerItem.asset).URL superView:flashView];
        //[KJAliPlayerManager sharedInstance].delegate = delegate;
        
        //AVPlayer
        //[[KJAVPlayerManager sharedInstance] initWithPlayerItem:playerItem superView:flashView];
        //[KJAVPlayerManager sharedInstance].delegate = delegate;
        
        //VLCPlayer
        //[[KJVLCPlayerManager sharedInstance] initWithVideoUrl:((AVURLAsset *)playerItem.asset).URL superView:flashView];
        //[KJVLCPlayerManager sharedInstance].delegate = delegate;
        
        //TXPlayer
        //[[KJTXPlayerManager sharedInstance] initWithVideoUrl:((AVURLAsset *)playerItem.asset).URL superView:flashView];
        //[KJTXPlayerManager sharedInstance].delegate = delegate;
    } else {
        //IJKPlayer
        //[[KJIJKPlayerManager sharedInstance] initWithPlayerItem:playerItem superView:flashView];
        //[KJIJKPlayerManager sharedInstance].delegate = delegate;
        
        //AliPlayer
        //[[KJAliPlayerManager sharedInstance] initWithVideoUrl:((AVURLAsset *)playerItem.asset).URL superView:flashView];
        //[KJAliPlayerManager sharedInstance].delegate = delegate;
        
        //AVPlayer
        [[KJAVPlayerManager sharedInstance] initWithPlayerItem:playerItem superView:flashView];
        [KJAVPlayerManager sharedInstance].delegate = delegate;
        
        //VLCPlayer
        //[[KJVLCPlayerManager sharedInstance] initWithVideoUrl:((AVURLAsset *)playerItem.asset).URL superView:flashView];
        //[KJVLCPlayerManager sharedInstance].delegate = delegate;
        
        //TXPlayer
        //[[KJTXPlayerManager sharedInstance] initWithVideoUrl:((AVURLAsset *)playerItem.asset).URL superView:flashView];
        //[KJTXPlayerManager sharedInstance].delegate = delegate;
    }
}

+ (BOOL)onLocalPlayer {
    return ([KJPlayerLogic sharedInstance].playerType == KJVideoPlayerTypeLocalPlayer);
}

+ (void)play {
    //切换不同播放器
    if ([KJPlayerLogic onLocalPlayer]) {
        [[KJIJKPlayerManager sharedInstance] play];
        //[[KJAliPlayerManager sharedInstance] play];
        //[[KJAVPlayerManager sharedInstance] play];
        //[[KJVLCPlayerManager sharedInstance] play];
        //[[KJTXPlayerManager sharedInstance] play];
    } else {
        //[[KJIJKPlayerManager sharedInstance] play];
        //[[KJAliPlayerManager sharedInstance] play];
        [[KJAVPlayerManager sharedInstance] play];
        //[[KJVLCPlayerManager sharedInstance] play];
        //[[KJTXPlayerManager sharedInstance] play];
    }
}

+ (void)pause {
    //切换不同播放器
    if ([KJPlayerLogic onLocalPlayer]) {
        [[KJIJKPlayerManager sharedInstance] pause];
        //[[KJAliPlayerManager sharedInstance] pause];
        //[[KJAVPlayerManager sharedInstance] pause];
        //[[KJVLCPlayerManager sharedInstance] pause];
        //[[KJTXPlayerManager sharedInstance] pause];
    } else {
        //[[KJIJKPlayerManager sharedInstance] pause];
        //[[KJAliPlayerManager sharedInstance] pause];
        [[KJAVPlayerManager sharedInstance] pause];
        //[[KJVLCPlayerManager sharedInstance] pause];
        //[[KJTXPlayerManager sharedInstance] pause];
    }
}

+ (void)stop {
    //切换不同播放器
    if ([KJPlayerLogic onLocalPlayer]) {
        [[KJIJKPlayerManager sharedInstance] stop];
        //[[KJAliPlayerManager sharedInstance] stop];
        //[[KJAVPlayerManager sharedInstance] stop];
        //[[KJVLCPlayerManager sharedInstance] stop];
        //[[KJTXPlayerManager sharedInstance] stop];
    } else {
        //[[KJIJKPlayerManager sharedInstance] stop];
        //[[KJAliPlayerManager sharedInstance] stop];
        [[KJAVPlayerManager sharedInstance] stop];
        //[[KJVLCPlayerManager sharedInstance] stop];
        //[[KJTXPlayerManager sharedInstance] stop];
    }
}

+ (float)sliderSelectedEndWithValue:(float)value {
    //切换不同播放器
    if ([KJPlayerLogic onLocalPlayer]) {
        return [[KJIJKPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJAliPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJAVPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJVLCPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJTXPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
    } else {
        //return [[KJIJKPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJAliPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        return [[KJAVPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJVLCPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
        //return [[KJTXPlayerManager sharedInstance] sliderSelectedEndWithValue:value];
    }
}

@end
