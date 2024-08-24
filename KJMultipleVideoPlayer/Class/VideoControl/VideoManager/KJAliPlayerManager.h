//
//  KJAliPlayerManager.h
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KJPlayerLogic.h"

@interface KJAliPlayerManager : NSObject

@property (nonatomic, weak) id<KJVideoPlayerDelegate> delegate;


+ (KJAliPlayerManager *)sharedInstance;

- (void)initWithVideoUrl:(NSURL *)videoUrl superView:(UIView *)flashView;

- (void)play;
- (void)pause;
- (void)stop;

- (float)sliderSelectedEndWithValue:(float)value;

@end
