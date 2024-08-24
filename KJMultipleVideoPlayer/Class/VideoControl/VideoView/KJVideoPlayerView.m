//
//  KJVideoPlayerView.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/23.
//

#import "KJVideoPlayerView.h"
#import "KJPlayerUtil.h"

@interface KJVideoPlayerView ()

@property (nonatomic, strong) UIView *container; // 播放器容器
@property (nonatomic, strong) UIView *flashView;

@property (nonatomic, strong) UIButton *playOrPause;
@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *durationTime;
@property (nonatomic, strong) UISlider *slider;

@end

@implementation KJVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.container];
        [self.container addSubview:self.flashView];
        [self.container addSubview:self.playOrPause];
        [self.container addSubview:self.currentTime];
        [self.container addSubview:self.durationTime];
        [self.container addSubview:self.slider];
    }
    
    return self;
}

#pragma mark - set player
- (void)setVideoUrl:(NSURL *)url playerType:(KJVideoPlayerType)playerType {
    
    [KJPlayerLogic sharedInstance].playerType = playerType;
    [KJPlayerLogic sharedInstance].playerUrl = url;
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    [KJPlayerLogic initWithPlayerItem:playerItem superView:self.flashView delegate:self];
}


- (void)buttonClicked:(UIButton *)sender {
    
    if (sender.tag) {
        [KJPlayerLogic pause];
        self.playOrPause.tag = 0;
        [self.playOrPause setBackgroundImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
    } else {
        [KJPlayerLogic play];
        self.playOrPause.tag = 1;
        [self.playOrPause setBackgroundImage:[UIImage imageNamed:@"icon_video_pause"] forState:UIControlStateNormal];
    }
}

- (void)sliderSelected {
    
}

- (void)sliderTSelectedEnd {
    double dragTime = [KJPlayerLogic sliderSelectedEndWithValue:self.slider.value];
}

#pragma mark - KJVideoPlayerDelegate

- (void)currentPlayUpdateWithCurrentTimeText:(NSString *)currentTimeText progress:(float)progress {
    //当前播放时间
    self.currentTime.text = [KJPlayerUtil getStringFromSeconds:[currentTimeText doubleValue]];
    //总时长
    NSString *currentDurationTime = [KJPlayerUtil getStringFromSeconds:[KJPlayerLogic sharedInstance].playerDuration];
    if (![currentDurationTime isEqualToString:self.durationTime.text]) {
        self.durationTime.text = currentDurationTime;
    }
    //进度条滑杠
    [self.slider setValue:progress animated:NO];
}

- (void)playerItemStatusReadyToPlay {
    self.playOrPause.tag = 1;
    [self.playOrPause setBackgroundImage:[UIImage imageNamed:@"icon_video_pause"] forState:UIControlStateNormal];
}

- (void)playEnd {
    [KJPlayerLogic pause];
    self.playOrPause.tag = 0;
    [self.playOrPause setBackgroundImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
}



#pragma mark - UI Lazy Loading
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _container.backgroundColor = [UIColor blackColor];
    }
    return _container;
}

- (UIView *)flashView {
    if (!_flashView) {
        _flashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.container.frame), CGRectGetHeight(self.container.frame))];
        _flashView.backgroundColor = UIColor.clearColor;
    }
    return _flashView;
}

- (UIButton *)playOrPause {
    if (!_playOrPause) {
        _playOrPause = [[UIButton alloc] initWithFrame:CGRectMake(12, 250, 24, 24)];
        [_playOrPause setBackgroundImage:[UIImage imageNamed:@"icon_video_play"] forState:UIControlStateNormal];
        _playOrPause.tag = 0; //0:暂停 1:播放
        [_playOrPause addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playOrPause;
}

- (UILabel *)currentTime {
    if (!_currentTime) {
        _currentTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playOrPause.frame), CGRectGetMidY(self.playOrPause.frame), 60, 12)];
        [_currentTime setFont:[UIFont systemFontOfSize:12.0f]];
        _currentTime.textAlignment = NSTextAlignmentCenter;
        _currentTime.text = @"00:00";
        [_currentTime setTextColor:UIColor.whiteColor];
    }
    return _currentTime;
}

- (UILabel *)durationTime {
    if (!_durationTime) {
        _durationTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.container.frame) - 80, CGRectGetMidY(self.playOrPause.frame), 60, 12)];
        _durationTime.text = @"00:00";
        _durationTime.font = [UIFont systemFontOfSize:12.0f];
        _durationTime.textAlignment = NSTextAlignmentCenter;
        [_durationTime setTextColor:UIColor.whiteColor];
    }
    return _durationTime;
}

- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.currentTime.frame), CGRectGetMidY(self.playOrPause.frame), CGRectGetMinX(self.durationTime.frame) - CGRectGetMaxX(self.currentTime.frame), 18)];
        [_slider setThumbImage:[UIImage imageNamed:@"icon_videoPlayer_slider"] forState:UIControlStateNormal];
        [_slider setMaximumTrackTintColor:UIColor.lightGrayColor];
        [_slider setMinimumTrackTintColor:UIColor.grayColor];
        [_slider addTarget:self action:@selector(sliderSelected) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderTSelectedEnd) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(sliderTSelectedEnd) forControlEvents:UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(sliderTSelectedEnd) forControlEvents:UIControlEventTouchCancel];
    }
    return _slider;
}

@end
