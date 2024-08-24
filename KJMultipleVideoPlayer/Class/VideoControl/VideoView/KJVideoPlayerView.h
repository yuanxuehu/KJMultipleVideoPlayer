//
//  KJVideoPlayerView.h
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import <UIKit/UIKit.h>
#import "KJPlayerLogic.h"

@interface KJVideoPlayerView : UIView

// 获取url的播放信息
- (void)setVideoUrl:(NSURL *)url playerType:(KJVideoPlayerType)playerType;

@end
