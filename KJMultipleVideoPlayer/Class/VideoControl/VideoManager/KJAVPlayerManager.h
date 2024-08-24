//
//  KJAVPlayerManager.h
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "KJPlayerLogic.h"

@interface KJAVPlayerManager : NSObject

@property (nonatomic, weak) id<KJVideoPlayerDelegate> delegate;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

+ (KJAVPlayerManager *)sharedInstance;

- (void)initWithPlayerItem:(AVPlayerItem *)playerItem superView:(UIView *)flashView;

- (void)play;
- (void)pause;
- (void)stop;

- (float)sliderSelectedEndWithValue:(float)value;

@end
