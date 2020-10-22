//
//  QNUser+QNAddition.h
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/31.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "QNUser.h"

@interface QNUser (QNAddition)

+ (int)getAgeWithBirthday:(NSDate *)date;

- (int)getHeight;

- (NSError *)checkUserInfo;

@end
