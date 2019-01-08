//
//  NSError+QNAPI.m
//  QNDeviceSDK
//
//  Created by Yolanda on 2018/3/7.
//  Copyright © 2018年 Yolanda. All rights reserved.
//

#import "NSError+QNAPI.h"
#include "QNDebug.h"

#define QNDeviceSDKErrorDomain @"QNDeviceSDkDomain"

@implementation NSError (QNAPI)

+ (NSError *)errorCode:(QNBleErrorCode)code {
    NSDictionary *userInfo = nil;
    switch (code) {
            //1001
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
            
            
            //1101
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
            
            case QNBleErrorCodeNoneScan:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"No bluetooth device has been scanned"};
            break;
            
            case QNBleErrorCodeConnectOverTime:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"Connect device timeout"};
            break;
            
            case QNBleErrorCodeResponseOverTime:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"response device timeout"};
            break;
            
            case QNBleErrorCodeUnconnectedDevice:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"unconnected device,please connected device first"};
            break;
            
            //1201
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
            
            case QNBleErrorCodeUserWeight:
            userInfo = @{NSLocalizedFailureReasonErrorKey : @"the weight params value not allow 0"};
            break;
            
        default:
            break;
    }
    if (userInfo) {
        NSError *error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:code userInfo:userInfo];
        if (QNDebugLogIsVail) [[QNDebug sharedDebug] log:[error description]];
        return error;
    }else {
        return nil;
    }
}


+ (NSError *)transformModuleError:(NSError *)bleModuleError {
    NSError *error = nil;
    switch (bleModuleError.code) {
            //QNCentralModule
            case QNCentralStateUnknownError: error = [self errorCode:QNBleErrorCodeBluetoothUnknow]; break;

            case QNCentralStateResettingError: error = [self errorCode:QNBleErrorCodeBluetoothResetting]; break;
            
            case QNCentralStateUnsupportedError: error = [self errorCode:QNBleErrorCodeBluetoothUnsupported]; break;
            
            case QNCentralStateUnauthorizedError: error = [self errorCode:QNBleErrorCodeBluetoothUnauthorized]; break;
            
            case QNCentralStatePoweredOffError: error = [self errorCode:QNBleErrorCodeBluetoothClosed]; break;
            
            case QNCentralStateConnectFailError: error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectFail userInfo:bleModuleError.userInfo]; break;
            
            case QNCentralStatePeripheralHasConnectError: error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectWhenConnected userInfo:bleModuleError.userInfo]; break;
            
            //QNPScaleModule
            case QNScaleDeviceDiscoverServiceError:
            case QNScaleDeviceDiscoverCharacteristicsError:
            error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectFail userInfo:bleModuleError.userInfo];
            break;
            
            case QNScaleDeviceUnconnectedDeviceError: error = [self errorCode:QNBleErrorCodeUnconnectedDevice]; break;
            
            case QNScaleDeviceHasDeviceConnectError: error = [self errorCode:QNBleErrorCodeConnectWhenConnected]; break;
            
            case QNScaleDeviceScaleDeviceParamsError:
            case QNScaleDeviceUserParamsError:
            case QNScaleDeviceWifiConfigParamsError:
            error = [self errorCode:QNBleErrorCodeIllegalArgument];
            break;
            
            //QNBandModule
            case QNBandDeviceBandConnectDeviceParamsError: error = [self errorCode:QNBleErrorCodeIllegalArgument]; break;
            case QNBandDeviceUnconnectedDeviceError: error = [self errorCode:QNBleErrorCodeUnconnectedDevice]; break;
            case QNBandDeviceFindWriteCharacteristicsError: break;
            case QNBandDeviceHasDeviceConnectError: [self errorCode:QNBleErrorCodeConnectWhenConnected]; break;
            
            case QNBandDeviceDiscoverServiceError:
            case QNBandDeviceDiscoverCharacteristicsError:
            error = [NSError errorWithDomain:QNDeviceSDKErrorDomain code:QNBleErrorCodeConnectFail userInfo:bleModuleError.userInfo];
            break;
            
            case QNBandDeviceWaitOverTimeError: [self errorCode:QNBleErrorCodeResponseOverTime]; break;
            case QNBandDeviceReceiveDatatError:  break;
        default:
            break;
    }
    return error;
}

@end
