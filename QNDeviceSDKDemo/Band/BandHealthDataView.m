//
//  BandHealthDataView.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2019/1/19.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandHealthDataView.h"

@interface BandHealthDataView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BandHealthDataView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.editable = NO;
    self.topConstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *detail = @"";
    for (QNHealthData *healthData in self.healthDatas) {
        detail = [[detail stringByAppendingString:[dateFormatter stringFromDate:[healthData date]]] stringByAppendingString:@"\n"];
        if (healthData.sport) {
            detail = [NSString stringWithFormat:@"%@总步数: %ld\n卡路里: %ld\n运动距离: %ld\n运动时间: %ld\n\n",detail,(long)healthData.sport.sumStep,(long)healthData.sport.sumCalories,(long)healthData.sport.sumDistance,(long)healthData.sport.sumActiveTime];
            for (QNSportItem *item in healthData.sport.sportItems) {
                detail = [NSString stringWithFormat:@"%@开始时间: %@\n结束时间: %@\n运动步数: %ld\n运动时间: %ld\n卡路里: %ld\n距离: %ld\n\n",detail,[dateFormatter stringFromDate:item.startDate],[dateFormatter stringFromDate:item.endDate],(long)item.step,(long)item.activeTime,(long)item.calories,(long)item.distance];
            }
        }
        if (healthData.sleep) {
            detail = [NSString stringWithFormat:@"%@总睡眠时间: %ld\n深睡时间: %ld\n浅睡时间: %ld\n清醒时间: %ld\n运动时间: %ld\n\n",detail,(long)healthData.sleep.sumSleepMinute,(long)healthData.sleep.sumDeepSleepMinute,(long)healthData.sleep.sumLightSleepMinute,(long)healthData.sleep.sumSoberMinute,(long)healthData.sleep.sumSportMinute];
            for (QNSleepItem *item in healthData.sleep.sleepItems) {
                NSString *type = @"";
                switch (item.sleepType) {
                    case QNSleepSober: type = @"清醒"; break;
                    case QNSleepLight: type = @"浅睡"; break;
                    case QNSleepDeep: type = @"深睡"; break;
                    case QNSleepSport: type = @"运动"; break;
                    default:
                        break;
                }
                detail = [NSString stringWithFormat:@"%@开始时间: %@\n结束时间: %@\n睡眠类型: %@\n时间: %ld\n\n",detail,[dateFormatter stringFromDate:item.startDate],[dateFormatter stringFromDate:item.endDate],type,(long)item.sleepTime];
            }
        }
        
        if (healthData.heartRate) {
            detail = [NSString stringWithFormat:@"%@平稳心率: %ld\n脂肪燃烧: %ld\n有氧锻炼: %ld\n极限锻炼: %ld\n\n",detail,(long)healthData.heartRate.slientHeartRate,(long)healthData.heartRate.burnFatThreshold,(long)healthData.heartRate.aerobicThreshold,(long)healthData.heartRate.limitThreshold];
            for (QNHeartRateItem *item in healthData.heartRate.heartRateItems) {
                detail = [NSString stringWithFormat:@"%@测量时间: %@\n心率值: %ld\n\n",detail,[dateFormatter stringFromDate:item.date],(long)item.heartRate];
            }
        }
    }
    
    self.textView.text = detail;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
