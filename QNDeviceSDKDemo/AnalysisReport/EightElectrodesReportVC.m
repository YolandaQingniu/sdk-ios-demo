//
//  EightElectrodesReportVC.m
//  QNDeviceSDKDemo
//
//  Created by sumeng on 2021/7/6.
//  Copyright © 2021 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EightElectrodesReportVC.h"
#import "QNScaleItemData.h"

@interface NSDictionary (Extension)
- (NSString *)toJsonStr;
@end

@implementation NSDictionary (Extension)
- (NSString *)toJsonStr {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}
@end

@interface EightElectrodesReportVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation EightElectrodesReportVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *configJson = [self configDataParams];
    NSString *measureDataJson =  [self measureDataParams];
    NSString *urlStr = [NSString stringWithFormat:@"https://app-h5.yolanda.hk/h5-business-demo/eight_electrodes_report.html?measureData=%@&config=%@",measureDataJson,configJson];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //构建请求体
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:cachePolicy timeoutInterval:20];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
}

#pragma mark - 测量数据参数
- (NSString *)configDataParams {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //重量单位
    switch (self.config.unit) {
        case QNUnitLB: [dic setValue:@"lb" forKey:@"weightUnit"]; break;
        case QNUnitJIN:
            [dic setValue:@"jin" forKey:@"weightUnit"]; break;
        case QNUnitStLb:
            [dic setValue:@"st_lb" forKey:@"weightUnit"]; break;
        case QNUnitSt:
            [dic setValue:@"st" forKey:@"weightUnit"]; break;
        default:
            [dic setValue:@"kg" forKey:@"weightUnit"];
            break;
    }
    
    //语言
    [dic setValue:@"zh_CN" forKey:@"lang"];
    return [dic toJsonStr];
}

#pragma mark - 测量数据参数
- (NSString *)measureDataParams {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // 1.测量数据信息
    for (QNScaleItemData *item in self.scaleDataAry) {
        switch (item.type) {
            case QNScaleTypeWeight: [self weightWithItem:item dic:dic]; break;
            case QNScaleTypeBMI: [self bmiWithItem:item dic:dic]; break;
            case QNScaleTypeBodyFatRate: [self bodyFatWithItem:item dic:dic]; break;
            case QNScaleTypeSubcutaneousFat: [self subfatWithItem:item dic:dic]; break;
                
            case QNScaleTypeVisceralFat: [self visfatWithItem:item dic:dic]; break;
            case QNScaleTypeBodyWaterRate: [self waterWithItem:item dic:dic]; break;
            case QNScaleTypeMuscleRate: [self muscleWithItem:item dic:dic]; break;
            case QNScaleTypeBoneMass: [self boneWithItem:item dic:dic]; break;
                
            case QNScaleTypeBMR: [self bmrWithItem:item dic:dic]; break;
            case QNScaleTypeProtein: [self proteinWithItem:item dic:dic]; break;
            case QNScaleTypeLeanBodyWeight: [self lbmWithItem:item dic:dic]; break;
            case QNScaleTypeMuscleMass: [self sinewWithItem:item dic:dic]; break;
                
            case QNScaleTypeMetabolicAge: [self bodyAgeWithItem:item dic:dic]; break;
            case QNScaleTypeRightArmMucaleWeightIndex: [self sinewRightArmWithItem:item dic:dic]; break;
            case QNScaleTypeLeftArmMucaleWeightIndex: [self sinewLeftArmWithItem:item dic:dic]; break;
            case QNScaleTypeTrunkMucaleWeightIndex: [self sinewTrunkWithItem:item dic:dic]; break;
                
            case QNScaleTypeRightLegMucaleWeightIndex: [self sinewRightLegWithItem:item dic:dic]; break;
            case QNScaleTypeLeftLegMucaleWeightIndex: [self sinewLeftLegWithItem:item dic:dic]; break;
            case QNScaleTypeRightArmFatIndex: [self bodyfatRightArmWithItem:item dic:dic]; break;
            case QNScaleTypeLeftArmFatIndex: [self bodyfatLeftArmWithItem:item dic:dic]; break;
                
            case QNScaleTypeTrunkFatIndex: [self bodyfatTrunkWithItem:item dic:dic]; break;
            case QNScaleTypeRightLegFatIndex: [self bodyfatRightLegWithItem:item dic:dic]; break;
            case QNScaleTypeLeftLegFatIndex: [self bodyfatLeftLegWithItem:item dic:dic]; break;
            default:
                break;
        }
    }
    
    // 2.用户信息
    if ([self.user.gender isEqualToString:@"male"]) {
        [dic setValue:@1 forKey:@"gender"];
    }else {
        [dic setValue:@0 forKey:@"gender"];
    }
    
    [dic setValue:[self userBirthday] forKey:@"birthday"];
    [dic setValue:[NSNumber numberWithInt:self.user.height] forKey:@"height"];
    return [dic toJsonStr];
}

#pragma mark 用户生日
- (NSString *)userBirthday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale=[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:self.user.birthday];
}

#pragma mark 体重
- (void)weightWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"weight"];
}

#pragma mark BMI
- (void)bmiWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bmi"];
}

#pragma mark 体脂率
- (void)bodyFatWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bodyfat"];
}

#pragma mark 皮下脂肪
- (void)subfatWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"subfat"];
}

#pragma mark 内脏脂肪
- (void)visfatWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"visfat"];
}

#pragma mark 体水分
- (void)waterWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"water"];
}

#pragma mark 骨骼肌率
- (void)muscleWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"muscle"];
}

#pragma mark 骨量
- (void)boneWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bone"];
}

#pragma mark 基础代谢
- (void)bmrWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%0.0f",item.value];
    [dic setValue:valueStr forKey:@"bmr"];
}

#pragma mark 蛋白质
- (void)proteinWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"protein"];
}

#pragma mark 去脂体重
- (void)lbmWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"lbm"];
}

#pragma mark 肌肉量
- (void)sinewWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"sinew"];
}

#pragma mark 体年龄
- (void)bodyAgeWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"body_age"];
}

#pragma mark 右上肢肌肉量
- (void)sinewRightArmWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"sinew_right_arm"];
}

#pragma mark 左上肢肌肉量
- (void)sinewLeftArmWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"sinew_left_arm"];
}

#pragma mark 躯干肌肉量
- (void)sinewTrunkWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"sinew_trunk"];
}

#pragma mark 右下肢肌肉量
- (void)sinewRightLegWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"sinew_right_leg"];
}

#pragma mark 左下肢肌肉量
- (void)sinewLeftLegWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"sinew_left_leg"];
}

#pragma mark 右上肢体脂率
- (void)bodyfatRightArmWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bodyfat_right_arm"];
}

#pragma mark 左上肢体脂率
- (void)bodyfatLeftArmWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bodyfat_left_arm"];
}

#pragma mark 躯干体脂率
- (void)bodyfatTrunkWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bodyfat_trunk"];
}

#pragma mark 右下肢体脂率
- (void)bodyfatRightLegWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bodyfat_right_leg"];
}

#pragma mark 左下肢体脂率
- (void)bodyfatLeftLegWithItem:(QNScaleItemData *)item dic:(NSMutableDictionary *)dic {
    NSString *valueStr = [NSString stringWithFormat:@"%f",item.value];
    [dic setValue:valueStr forKey:@"bodyfat_left_leg"];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidesWhenStopped:YES];
}
@end
