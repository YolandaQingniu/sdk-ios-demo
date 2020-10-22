//
//  QNWspUser.h
//  Pods
//
//  Created by donyau on 2019/7/27.
//

#import <Foundation/Foundation.h>
#import "QNWspTarget.h"

typedef NS_ENUM(NSUInteger, QNWspGender) {
    QNWspGenderMale = 0,
    QNWspGenderFemale,
};

typedef NS_ENUM(NSUInteger, QNWspMethod) {
    QNWspMehtodACV1 = 0, //交流V1
    QNWspMehtodACV2, //交流V2
    QNWspMehtodDCV1, //直流V1
    QNWspMehtodDCV2, //直流V2
    QNWspMehtodDCV3, //直流V3
    QNWspMehtodWeight, //体重秤算法
    QNWspMehtodEightEle, //8电极算
};


NS_ASSUME_NONNULL_BEGIN

@interface QNWspUser : NSObject
/** 是否是访客(访客无需设置秘钥、序列号)*/
@property(nonatomic, assign) BOOL visitFlag;
/** 秘钥*/
@property(nonatomic, assign) NSUInteger secretKey;
/** 序列号（注册时可不传，注册成功后会对该属性赋值） */
@property(nonatomic, strong, nullable) NSNumber *secretIndex;
/** 用户id */
@property(nonatomic, strong) NSString *userId;
/** 用户nick（当删除用户时，可不设置此值） */
@property(nonatomic, strong, nullable) NSString *nick;
/** 性别（当删除用户时，可不设置此值） */
@property(nonatomic, assign) QNWspGender gender;
/** 出生（当删除用户时，可不设置此值） */
@property(nonatomic, strong) NSDate *birthday;
/** 身高 cm（当删除用户时，可不设置此值） 80 ~ 240 */
@property(nonatomic, assign) NSUInteger height;
/** age（当删除用户时，可不设置此值） 3 ~ 80 */
@property(nonatomic, assign) NSUInteger age;
/** 算法（当删除用户时，可不设置此值） */
@property(nonatomic, assign) QNWspMethod method;
/** 指标控制显示（当删除用户时，可不设置此值） */
@property(nonatomic, strong) QNWspTarget *target;
/** 是否需要同步用户资料 */
@property(nonatomic, assign) BOOL synUserMesg;
/** 是否是运动员（当删除用户时，可不设置此值） */
@property(nonatomic, assign) BOOL sportFlag;

@end

NS_ASSUME_NONNULL_END
