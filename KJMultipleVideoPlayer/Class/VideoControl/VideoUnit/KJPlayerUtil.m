//
//  KJPlayerUtil.m
//  KJMultipleVideoPlayer
//
//  Created by TigerHu on 2024/8/24.
//

#import "KJPlayerUtil.h"

@implementation KJPlayerUtil

+ (NSString *)getStringFromSeconds:(long long)seconds
{
    //format of hour
    NSString *str_hour = @"";
    if (seconds / 3600 >= 1) {
        str_hour = [NSString stringWithFormat:@"%02lld:", seconds / 3600];
    }
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02lld:",(seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02lld", seconds % 60];

    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@%@%@", str_hour, str_minute, str_second];
    return format_time;
}

@end
