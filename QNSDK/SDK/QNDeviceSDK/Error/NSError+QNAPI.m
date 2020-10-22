//
//  NSError+QNAPI.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "NSError+QNAPI.h"
#include "QNDebug.h"

@implementation NSError (QNAPI)

+ (NSError *)errorCode:(QNBleErrorCode)code callBack:(QNResultCallback)block {
    NSError *error = [NSError errorCode:code];
    if (QNDebugLogIsVail) {
        [[QNDebug sharedDebug] log:[error description]];
    }
    if (block) {
        block(error);
    }
    return error;
}

+ (NSError *)errorCode:(QNBleErrorCode)code {
    NSDictionary *userInfo = nil;
    switch (code) {
        //10
        case QNBleErrorCodeInvalidateAppId:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"app id is invalidate", NSLocalizedDescriptionKey : @"Please contact the official"};
            break;
            
        case QNBleErrorCodeNotInitSDK:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"please call the method \"initSdk\" first"};
            break;
            
        case QNBleErrorCodeFirstDataFileURL:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the first data file uri is error, please provide the correct one"};
            break;
            
        case QNBleErrorCodePackageName:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the Android Package Name is Error ,Please Check it Or Contact the SDK Provider"};
            break;
            
        case QNBleErrorCodeBundleID:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the IOS APP Bundle Id is Error ,Please Check it Or Contact the SDK Provider"};
            break;
            
        case QNBleErrorCodeInitFile:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"The config file content is wrong ,Please provide the correct one"};
            break;
            
        //11
        case QNBleErrorCodeBluetoothClosed:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"Bluetooth state is off", NSLocalizedDescriptionKey : @"please open Bluetooth"};
            break;
            
        case QNBleErrorCodeLocationPermission:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"your app need the android authorize the location permission"};
            break;
            
        case QNBleErrorCodeBLEError:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"bluetooth internal error occurred"};
            break;
            
        case QNBleErrorCodeConnectWhenConnecting:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"connect device is connecting"};
            break;
            
        case QNBleErrorCodeConnectWhenConnected:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"connect device is connected"};
            break;
            
        case QNBleErrorCodeBluetoothUnknow:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"Bluetooth state is unknow"};
            break;
            
        case QNBleErrorCodeBluetoothResetting:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"Bluetooth state is resetting"};
            break;
            
        case QNBleErrorCodeBluetoothUnsupported:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"current iphone is unsupported Bluetooth"};
            break;
            
        case QNBleErrorCodeBluetoothUnauthorized:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"current iphone is unauthorized use Bluetooth", NSLocalizedDescriptionKey : @"please authorized use Bluetooth"};
            break;
            
        case QNBleErrorCodeConnectFail:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"connect device overtime", NSLocalizedDescriptionKey : @"please reset try"};
            break;
            
        case QNBleErrorCodePeripheralDisconnecting:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the device disconnecting"};
            break;
            
        case QNBleErrorCodeBleNoneScan:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"No bluetooth device has been scanned"};
            break;
            
        case QNBleErrorBleConnectOvertime:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"Connect device timeout"};
            break;
            
        //12
        case QNBleErrorCodeIllegalArgument:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"illegal argument,please check the api documen"};
            break;
            
        case QNBleErrorCodeMissDiscoveryListener:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"miss the discovery listener, please set the listener first", NSLocalizedDescriptionKey : @"please set the first listeners" };
            break;
            
        case QNBleErrorCodeMissDataListener:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"miss the data listener, please set the listener first", NSLocalizedDescriptionKey : @"please set the first listeners" };
            break;
            
        case QNBleErrorCodeUserIdEmpty:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the user id argument is null or empty or isn't kind of NSString"};
            break;
            
        case QNBleErrorCodeUserGender:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the gender argument is wrong, please pass the \"male\" or \"female\""};
            break;
            
        case QNBleErrorCodeUserHeight:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the height argument is wrong, please pass the value within 40 and 240 cm"};
            break;
            
        case QNBleErrorCodeUserBirthday:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the birthday argument is wrong, please pass the date before today"};
            break;
            
        case QNBleErrorCodeUserAthleteType:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the athleteType argument is wrong, only allow  0 or 1"};
            break;
            
        case QNBleErrorCodeUserShapeGoalType:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the shape or goal argument is wrong"};
            break;
            
        case QNBleErrorCodeDeviceType:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the device type is wrong"};
            break;
            
        case QNBleErrorCodeWiFiParams:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the WiFi params is wrong"};
            break;
            
        case QNBleErrorCodeRegisterDevice:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"register device is fail"};
            break;
            
        case QNBleErrorCodeNoComoleteMeasure:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"you can get data when measurement complete"};
            break;
            
        case QNBleErrorCodeNoSupportModify:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"not supported modifying units"};
            break;
            
        //13
        case QNBleErrorCoder:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"coder error"};
            break;
            
        case QNBleErrorCoderInvalid:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"coder invalid"};
            break;
            
        default:
            break;
    }
    NSError *error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:code userInfo:userInfo];
    return error;
}


+ (NSError *)errorForQNBLEModuleError:(NSError *)bleModuleError {
    NSError *error = nil;
    switch (bleModuleError.code) {
        case QNCentralStateUnknownError:
            error = [self errorCode:QNBleErrorCodeBluetoothUnknow];
            break;
        case QNCentralStateResettingError:
            error = [self errorCode:QNBleErrorCodeBluetoothResetting];
            break;
        case QNCentralStateUnsupportedError:
            error = [self errorCode:QNBleErrorCodeBluetoothUnsupported];
            break;
        case QNCentralStateUnauthorizedError:
            error = [self errorCode:QNBleErrorCodeBluetoothUnauthorized];
            break;
        case QNCentralStatePoweredOffError:
            error = [self errorCode:QNBleErrorCodeBluetoothClosed];
            break;
        case QNCentralStateConnectFailError:
            error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectFail userInfo:bleModuleError.userInfo];
            break;
        case QNCentralStatePeripheralHasConnectError:
            error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectFail userInfo:bleModuleError.userInfo];
            break;
            
        case QNScaleDeviceDiscoverServiceError:
        case QNScaleDeviceDiscoverCharacteristicsError:
            error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectFail userInfo:bleModuleError.userInfo];
            break;
        case QNScaleDeviceHasDeviceConnectError:
            error = [self errorCode:QNBleErrorCodeConnectWhenConnected];
            break;
        case QNScaleDeviceScaleDeviceParamsError:
            error = [self errorCode:QNBleErrorCodeConnectWhenConnected];
            break;
        case QNScaleDeviceUserParamsError:
            error = [self errorCode:QNBleErrorCodeIllegalArgument];
            break;
        case QNScaleDeviceWifiConfigParamsError:
            error = [self errorCode:QNBleErrorCodeIllegalArgument];
            break;
            
        case QNAdvertScaleHasDeviceConnectError:
            error = [self errorCode:QNBleErrorCodeConnectWhenConnected];
            break;
            
        case QNAdvertScaleParamsError:
            error = [self errorCode:QNBleErrorCodeIllegalArgument];
            break;
            
        case QNAdvertScaleConnectOverTime:
            error = [self errorCode:QNBleErrorBleConnectOvertime];
            break;
            
        default:
            break;
    }
    return error;
}

@end
