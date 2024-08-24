//
//  KJVLCPlayerManager.h
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KJPlayerLogic.h"

@interface KJVLCPlayerManager : NSObject

@property (nonatomic, weak) id<KJVideoPlayerDelegate> delegate;

+ (KJVLCPlayerManager *)sharedInstance;
- (void)initWithVideoUrl:(NSURL *)videoUrl superView:(UIView *)flashView;

- (void)play;
- (void)pause;
- (void)stop;

- (float)sliderSelectedEndWithValue:(float)value;

@end
