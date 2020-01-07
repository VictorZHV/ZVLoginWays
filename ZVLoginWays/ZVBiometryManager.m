//
//  ZVBiometryManager.m
//  offline_test
//
//  Created by victor on 2018/11/15.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "ZVBiometryManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
NSString * const touchIDDescStr = @"请按Home键验证指纹";
NSString * const faceIDDescStr = @"请验证面容";

@implementation ZVBiometryManager
+(instancetype)manager{
    static dispatch_once_t onceToken;
    static ZVBiometryManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ZVBiometryManager alloc]init];
    });
    return manager;
}
-(ZVBiometryType)biometryType{
    LAContext * context = [[LAContext alloc] init];
    NSError * error = nil;
    //验证是否具有指纹认证功能，不建议使用版本判断方式实现
    BOOL canEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    NSString *myLocalizedReasonString;
    // MARK: 判断设备是否支持指纹识别
    if (canEvaluatePolicy){
        //系统给的系统判断API
        if (@available(iOS 11.0, *)) {
            if(context.biometryType == LABiometryTypeTouchID) {
                _biometryType = ZVBiometryTypeTouchID;
            }else if (context.biometryType == LABiometryTypeFaceID){
                
                _biometryType = ZVBiometryTypeFaceID;
            }else{
                _biometryType = ZVBiometryTypeNone;
            }
        }
        //iOS 11以前没有面容
        else{
            myLocalizedReasonString = touchIDDescStr;
            _biometryType = ZVBiometryTypeTouchID;
        };
    }else{
        switch (error.code) {
            case -6:{
                _biometryType = ZVBiometryTypeNone;//不支持生物识别
                break;
            }
            case -8:{
                _biometryType = ZVBiometryTypeLocked;//生物识别被锁住
                
                break;
            }
            default:{
                _biometryType = ZVBiometryTypeNone;
                break;
            }
        }
    }
    return _biometryType;
}
-(void)startAuthResult:(TouchIDAuthResult)result{
    LAContext * context = [[LAContext alloc] init];
    NSError * error = nil;
    BOOL canEvaluatePolicy = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    context.localizedFallbackTitle = @"";
    NSString *myLocalizedReasonString;
    if (canEvaluatePolicy){
        
        //系统给的系统判断API
        if (@available(iOS 11.0, *)) {
            if(context.biometryType == LABiometryTypeTouchID) {
                myLocalizedReasonString = touchIDDescStr;
            }else if (context.biometryType == LABiometryTypeFaceID){
                myLocalizedReasonString = faceIDDescStr;
            }else{
                myLocalizedReasonString = touchIDDescStr;
            }
        }
        //iOS 11以前没有面容
        else{
            myLocalizedReasonString = touchIDDescStr;
        };
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalizedReasonString reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    result(nil);
                });
            }else if(error){
                result(error);
            }
        }];
    }else{
        switch (error.code) {
            case -6:{
                error = [NSError errorWithDomain:@"com.victor.victorAuth" code:ZVBiometryTypeNone userInfo:nil];
                result(error);
                break;
            }
            case -8:{
                error = [NSError errorWithDomain:@"com.victor.victorAuth" code:ZVBiometryTypeLocked userInfo:nil];
                result(error);
                break;
            }
            default:{
                error = [NSError errorWithDomain:@"com.victor.victorAuth" code:ZVBiometryTypeNone userInfo:nil];
                result(error);
                break;
            }
        }
    }
}
@end
