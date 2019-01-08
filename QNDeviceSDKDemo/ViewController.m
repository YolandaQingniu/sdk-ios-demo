//
//  ViewController.m
//  QNDeviceSDKDemo
//
//  Created by Yolanda on 2018/1/9.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "ViewController.h"
#import "PickerView.h"
#import "DetectionViewController.h"
#import "BandVC.h"

@interface ViewController ()<PickerViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userIdTF;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *bandBtn;

@property (weak, nonatomic) IBOutlet UIButton *everyBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *jinBtn;
@property (weak, nonatomic) IBOutlet UIButton *stBtn;
@property (weak, nonatomic) IBOutlet UIButton *kgBtn;
@property (weak, nonatomic) IBOutlet UIButton *lbBtn;

@property (nonatomic, strong) PickerView *pickerView;
@property (nonatomic, strong) QNBleApi *bleApi;
@property (nonatomic, strong) QNConfig *config;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) NSDate *birthdayDate;

@end

@implementation ViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleApi = [QNBleApi sharedBleApi];
    self.config = [self.bleApi getConfig];
    
    [self setDefaultValue];
    
}

- (void)setDefaultValue {
    self.userIdTF.text = @"123456";
    self.maleBtn.selected = YES;
    self.heightLabel.text = @"170cm";
    self.birthdayLabel.text = @"1990-01-01";
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = 1990;
    dateComponents.month = 1;
    dateComponents.day = 1;
    self.birthdayDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    self.birthdayLabel.text = [self.pickerView.dateFormatter stringFromDate:self.birthdayDate];
    
    self.pickerView.defaultHeight = [[self.heightLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""] intValue];
    self.pickerView.defaultBirthday = self.birthdayDate;
    
    [self selectUnit:self.config.unit];

    if (self.config.allowDuplicates) {
        [self selectEveryBtn:self.everyBtn];
    }else {
        [self selectFirstBtn:self.firstBtn];
    }
    
    if ([BandMessage sharedBandMessage].mac.length == 0) {
        self.bandBtn.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self.bandBtn setTitle:@"未绑定手环" forState:UIControlStateNormal];
        [self.bandBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.bandBtn.enabled = NO;
    }else {
        self.bandBtn.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        [self.bandBtn setTitle:@"已绑定手环" forState:UIControlStateNormal];
        [self.bandBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.bandBtn.enabled = YES;
    }
}

- (IBAction)turnToBandVC:(UIButton *)sender {
    BandVC *bandVc = [[BandVC alloc] init];
    [self.navigationController pushViewController:bandVc animated:YES];
}

#pragma mark - 确认用户ID
#pragma mark 点击键盘Return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 选择身高
- (IBAction)selectHeight:(UITapGestureRecognizer *)sender {
    self.pickerView.type = PickerViewTypeHeight;
    self.pickerView.hidden = NO;
}

- (void)confirmHeight:(NSInteger)height {
    self.heightLabel.text = [NSString stringWithFormat:@"%ldcm",height];
}

#pragma mark 选择生日
- (IBAction)selectBirthday:(UITapGestureRecognizer *)sender {
    self.pickerView.type = PickerViewTypeBirthday;
    self.pickerView.defaultBirthday = self.birthdayDate;
    self.pickerView.hidden = NO;
}

- (void)confirmBirthday:(NSDate *)birthday {
    self.birthdayDate = birthday;
    self.birthdayLabel.text = [self.pickerView.dateFormatter stringFromDate:birthday];
}

#pragma mark - 选中性别
#pragma mark 选中性别-女
- (IBAction)selectFemaleBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.maleBtn.selected = NO;
}

#pragma mark 选中性别-男
- (IBAction)selectMaleBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.femaleBtn.selected = NO;
}

#pragma mark - 选中扫描模式-每次
- (IBAction)selectEveryBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.firstBtn.selected = NO;
    self.config.allowDuplicates = YES;
}

#pragma mark 选中扫描模式-首次
- (IBAction)selectFirstBtn:(UIButton *)sender {
    if (sender.isSelected) return;
    sender.selected = YES;
    self.everyBtn.selected = NO;
    self.config.allowDuplicates = NO;
}

#pragma mark - 选中称量单位-斤
- (IBAction)selectJinBtn:(UIButton *)sender {
    [self selectUnit:QNUnitJIN];
}

#pragma mark 选中称量单位-st
- (IBAction)selectStBtn:(UIButton *)sender {
    [self selectUnit:QNUnitST];
}

#pragma mark 选中称量单位-kg
- (IBAction)selectKgBtn:(UIButton *)sender {
    [self selectUnit:QNUnitKG];
}

#pragma mark 选中称量单位-lb
- (IBAction)selectLbBtn:(UIButton *)sender {
    [self selectUnit:QNUnitLB];
}

- (void)selectUnit:(QNUnit)unit {
    self.config.unit = unit;
    switch (unit) {
            case QNUnitLB:
            self.kgBtn.selected = NO;
            self.jinBtn.selected = NO;
            self.stBtn.selected = NO;
            self.lbBtn.selected = YES;
            break;
            
            case QNUnitJIN:
            self.kgBtn.selected = NO;
            self.jinBtn.selected = YES;
            self.stBtn.selected = NO;
            self.lbBtn.selected = NO;
            break;
            
            case QNUnitST:
            self.kgBtn.selected = NO;
            self.jinBtn.selected = NO;
            self.stBtn.selected = YES;
            self.lbBtn.selected = NO;
            break;
            
        default:
            self.kgBtn.selected = YES;
            self.jinBtn.selected = NO;
            self.stBtn.selected = NO;
            self.lbBtn.selected = NO;
            break;
    }
}


#pragma mark - 点击确认跳转扫描
- (IBAction)clickConfirm:(UIButton *)sender {
    int height = [[self.heightLabel.text stringByReplacingOccurrencesOfString:@"cm" withString:@""] intValue];
    QNUser *user = [_bleApi buildUser:self.userIdTF.text height:height gender:self.femaleBtn.selected ? @"female" : @"male" birthday:self.birthdayDate callback:^(NSError *error) {
        
    }];
    DetectionViewController *detectionVC = [[DetectionViewController alloc] init];
    detectionVC.user = user;
    detectionVC.config = self.config;
    [self.navigationController pushViewController:detectionVC animated:YES];
}

- (PickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [PickerView secPickerView];
        _pickerView.frame = self.view.bounds;
        _pickerView.hidden = YES;
        _pickerView.pickerViewDelegate = self;
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}

@end
