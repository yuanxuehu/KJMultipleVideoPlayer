//
//  KJIJKPlayerManager.h
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "KJPlayerLogic.h"

@interface KJIJKPlayerManager : NSObject

@property (nonatomic, weak) id<KJVideoPlayerDelegate> delegate;

+ (KJIJKPlayerManager *)sharedInstance;

/// 构造IJKPlayer播放器
- (void)initWithPlayerItem:(AVPlayerItem *)playerItem superView:(UIView *)flashView;
- (void)initWithPlayerUrl:(NSURL *)playerUrl superView:(UIView *)flashView;

- (void)play;
- (void)pause;
- (void)stop;

- (float)sliderSelectedEndWithValue:(float)value;

@end
