//
//  ViewController.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/22.
//

#import "ViewController.h"
#import "KJVideoPlayerVC.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *localPlayButton;
@property (nonatomic, strong) UIButton *onlinePlayButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.localPlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.localPlayButton.frame = CGRectMake((self.view.frame.size.width-100)/2, 300, 100, 50);
    [self.localPlayButton setTitle:@"本地视频" forState:UIControlStateNormal];
    [self.localPlayButton addTarget:self action:@selector(localPlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.localPlayButton];
    
    self.onlinePlayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.onlinePlayButton.frame = CGRectMake((self.view.frame.size.width-100)/2, 380, 100, 50);
    [self.onlinePlayButton setTitle:@"在线视频" forState:UIControlStateNormal];
    [self.onlinePlayButton addTarget:self action:@selector(onlinePlayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.onlinePlayButton];
    
}

- (void)localPlayButtonClick:(UIButton *)sender {
    KJVideoPlayerVC *vc = [[KJVideoPlayerVC alloc] init];
    [vc playFromLocal];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onlinePlayButtonClick:(UIButton *)sender {
    KJVideoPlayerVC *vc = [[KJVideoPlayerVC alloc] init];
    [vc playFromNetwork];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
