//
//  KJPlayerLogic.h
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KJVideoPlayerType) {
    KJVideoPlayerTypeLocalPlayer = 0,     //本地视频
    KJVideoPlayerTypeNetworkPlayer = 1,   //在线视频
};

@protocol KJVideoPlayerDelegate <NSObject>

- (void)currentPlayUpdateWithCurrentTimeText:(NSString *)currentTimeText progress:(float)progress;

- (void)playerItemStatusReadyToPlay;

- (void)playEnd;

@end

@interface KJPlayerLogic : NSObject

@property (nonatomic, assign) KJVideoPlayerType playerType;
@property (nonatomic, strong) NSURL *playerUrl;
@property (nonatomic, assign) NSTimeInterval playerDuration;

+ (KJPlayerLogic *)sharedInstance;

+ (void)initWithPlayerItem:(AVPlayerItem *)playerItem superView:(UIView *)flashView delegate:(id)delegate;

+ (BOOL)onLocalPlayer;

+ (void)play;
+ (void)pause;
+ (void)stop;

+ (float)sliderSelectedEndWithValue:(float)value;

@end
