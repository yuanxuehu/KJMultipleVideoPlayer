# KJMultipleVideoPlayer
iOS 多视频播放器，支持AliPlayer/IJKPlayer/AVPlayer/VLCPlayer/TXPlayer

## AliPlayer
注意：集成AliPlayerSDK_iOS后，还需接入License鉴权方可播放视频
1、将License文件复制到Xcode项目中指定目录，并在Target Membership中选中当前项目
2、打开Info.plist，分别修改AlivcLicenseKey和AlivcLicenseFile为申请License时获取的License Key和License文件路径

## IJKPlayer
b站开源视频播放器

## AVPlayer
苹果原生视频播放器

## VLCPlayer
业内知名VLC视频播放器

## TXPlayer
注意：集成TXLiteAVSDK_Player后，还需接入License鉴权方可播放视频
腾讯云播放器SDK 10.7版本开始，需要通过 {@link TXLiveBase#setLicence} 设置 Licence 后方可成功播放， 否则将播放失败（黑屏）

