//
//  KJVideoPlayerVC.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import "KJVideoPlayerVC.h"
#import "KJPlayerLogic.h"
#import "KJVideoPlayerView.h"

@interface KJVideoPlayerVC ()

@property (nonatomic, strong) KJVideoPlayerView *playerView;

@end

@implementation KJVideoPlayerVC

- (void)dealloc {
    NSLog(@"KJVideoPlayerVC-dealloc");
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self startPlay];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [KJPlayerLogic stop];
    [self.playerView removeFromSuperview];
    self.playerView = nil;
}

- (void)startPlay {
    
    //判断网络视频还是本地视频
    NSString *localPath = @"";
    if (localPath.length > 0) {
        [self playFromLocal];
    } else {
        [self playFromNetwork];
    }
}

- (void)playFromLocal {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"preloadVideoDemo" withExtension:@"mp4"];
    //NSURL *localUrl = [NSURL fileURLWithPath:localPath];
    [self.playerView setVideoUrl:fileURL playerType:KJVideoPlayerTypeLocalPlayer];
}

- (void)playFromNetwork {
    NSString *testStr = @"https://vd2.bdstatic.com/mda-mki7h67gag5wcev9/720p/h264/1637299107495714243/mda-mki7h67gag5wcev9.mp4";
    NSURL *onlineUrl = [NSURL URLWithString:testStr];
    [self.playerView setVideoUrl:onlineUrl playerType:KJVideoPlayerTypeNetworkPlayer];
}

- (KJVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[KJVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self.view addSubview:_playerView];
    }
    return _playerView;
}

@end
