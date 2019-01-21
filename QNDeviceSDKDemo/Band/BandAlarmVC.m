//
//  BandAlarmVC.m
//  QNDeviceSDKDemo
//
//  Created by donyau on 2019/1/7.
//  Copyright © 2019 Yolanda. All rights reserved.
//

#import "BandAlarmVC.h"
#import "PickerView.h"
#import "BandAlarmCell.h"

typedef NS_ENUM(NSUInteger, BandAlarmPickerType) {
    BandAlarmPickerHour,
    BandAlarmPickerMinture,
};

#define QNAlarmItemCellIdentifier @"alarmItemCellIdentifier"

@interface BandAlarmVC ()<PickerViewDelegate,UITableViewDelegate,UITableViewDataSource,BandAlarmDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (nonatomic, weak) PickerView *pickerView;
@property (nonatomic, assign) BandAlarmPickerType pickType;

@property (nonatomic, strong) QNAlarm *alarmTemp;
@end

@implementation BandAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topContstraint.constant = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44 + 10;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BandAlarmCell" bundle:nil] forCellReuseIdentifier:QNAlarmItemCellIdentifier];
    self.addBtn.enabled = [BandMessage sharedBandMessage].alarms.count < 10;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [BandMessage sharedBandMessage].alarms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BandAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:QNAlarmItemCellIdentifier];
    cell.delegate = self;
    cell.alarm = [BandMessage sharedBandMessage].alarms[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (void)selectedAlarmMintureNum:(QNAlarm *)alarm {
    self.alarmTemp = alarm;
    self.pickType = BandAlarmPickerMinture;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:alarm.minture maxNum:59 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)selectedAlarmHourNum:(QNAlarm *)alarm {
    self.alarmTemp = alarm;
    self.pickType = BandAlarmPickerHour;
    PickerView *pickerView = (PickerView *)([[UINib nibWithNibName:@"PickerView" bundle:nil] instantiateWithOwner:nil options:nil].firstObject);
    pickerView.frame = self.view.bounds;
    pickerView.pickerViewDelegate = self;
    pickerView.type = PickerViewTypeNumber;
    [pickerView defaultNum:alarm.hour maxNum:23 minNum:0 intervalNum:1];
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)updateAlarm:(QNAlarm *)alarm {
    self.alarmTemp = alarm;
    [self syncAlarmWithDeleteFlag:NO];
}

- (void)deleteAlarm:(QNAlarm *)alarm {
    self.alarmTemp = alarm;
    self.alarmTemp.openFlag = NO;
    [self syncAlarmWithDeleteFlag:YES];
}

- (void)confirmNumber:(NSInteger)num {
    if (self.pickType == BandAlarmPickerHour) {
        self.alarmTemp.hour = (int)num;
    }else {
        self.alarmTemp.minture = (int)num;
    }
    [self syncAlarmWithDeleteFlag:NO];
}

- (void)dismissPickView {
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}

- (IBAction)addAlarm:(UIButton *)sender {
    NSMutableArray<NSNumber *> *alarmIds = [@[@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO,@NO] mutableCopy];
    for (QNAlarm *alarm in [BandMessage sharedBandMessage].alarms) {
        alarmIds[alarm.alarmId - 1] = @YES;
    }
    QNAlarm *alarm = [[QNAlarm alloc] init];
    alarm.hour = 8;
    alarm.minture = 0;
    alarm.openFlag = NO;
    QNWeek *week = [[QNWeek alloc] init];
    week.mon = YES;
    week.tues = YES;
    week.wed = YES;
    week.thur = YES;
    week.fri = YES;
    alarm.week = week;
    int index = 0;
    for (int i = 0; i < 10; i ++) {
        if ([alarmIds[i] boolValue] == NO) {
            index = i + 1;
            break;
        }
    }
    alarm.alarmId = index;
    self.alarmTemp = alarm;
    [self syncAlarmWithDeleteFlag:NO];
}

- (void)syncAlarmWithDeleteFlag:(BOOL)deleteFlag {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在同步...";
    [[BLETool sharedBLETool].bandManager syncAlarm:self.alarmTemp callback:^(NSError *error) {
        if (error) {
            hud.label.text = @"同步失败...";
        }else {
            hud.label.text = @"同步成功";
            NSMutableArray<QNAlarm *> *alarms = [BandMessage sharedBandMessage].alarms;
            int index = - 1;
            for (int i = 0; i < alarms.count; i ++) {
                QNAlarm *item = alarms[i];
                if (item.alarmId == self.alarmTemp.alarmId) {
                    index = i;
                    break;
                }
            }
            if (deleteFlag == NO) {
                if (index == -1) {
                    [alarms addObject:self.alarmTemp];
                }else {
                    [alarms replaceObjectAtIndex:index withObject:self.alarmTemp];
                }
            }else {
                [alarms removeObject:alarms[index]];
            }
            [BandMessage sharedBandMessage].alarms = alarms;
            self.alarmTemp = nil;
        }
        [self.tableView reloadData];
        self.addBtn.enabled = [BandMessage sharedBandMessage].alarms.count < 10;
        [hud hideAnimated:YES afterDelay:1];
    }];
    
}

@end
