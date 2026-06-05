//
//  SlimVoiceConfig.h
//  QNDeviceSDK
//
//  Created by yolanda on 2025/10/24.
//  Copyright © 2025 Yolanda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QNSlimVoiceSource) {
    QNSlimVoiceSourceNoModify = 0, // 不修改音源
    QNSlimVoiceSource1 = 1,       // 音源1
    QNSlimVoiceSource2 = 2,       // 音源2
    QNSlimVoiceSource3 = 3,       // 音源3
    QNSlimVoiceSource4 = 4,       // 音源4
    QNSlimVoiceSource5 = 5,       // 音源5
    QNSlimVoiceSource6 = 6,       // 音源6
    QNSlimVoiceSource7 = 7,       // 音源7
    QNSlimVoiceSource8 = 8,       // 音源8
};

typedef NS_ENUM(NSUInteger, QNSlimVoiceOperation) {
    QNSlimVoiceOperationNoModify = 0, // 不修改
    QNSlimVoiceOperationClose = 1,    // 关闭
    QNSlimVoiceOperationOpen = 2,     // 打开
};

@interface QNSlimVoiceConfig : NSObject
// 提示音音源
@property (nonatomic, assign) QNSlimVoiceSource  voiceSource;
// 提示音开关状态
@property (nonatomic, assign) QNSlimVoiceOperation  voiceOperation;

@end

NS_ASSUME_NONNULL_END
