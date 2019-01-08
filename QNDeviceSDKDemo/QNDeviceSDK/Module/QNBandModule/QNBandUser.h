//
//  QNBandUser.h
//  QNBandModule_iOS
//
//  Created by donyau on 2018/10/9.
//  Copyright © 2018 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QNBandGender) {
    QNBandGenderMale = 0,
    QNBandGenderFemale = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface QNBandUser : NSObject

@property (nonatomic, assign) float weight;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) NSTimeInterval birthdayTimeStamp;

@property (nonatomic, assign) QNBandGender gender;
@end

NS_ASSUME_NONNULL_END
