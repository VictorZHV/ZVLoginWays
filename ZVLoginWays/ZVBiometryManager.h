//
//  ZVBiometryManager.h
//  offline_test
//
//  Created by victor on 2018/11/15.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZVBiometryType) {
    ZVBiometryTypeNone,         //不支持生物识别
    ZVBiometryTypeFaceID,       //支持面容识别
    ZVBiometryTypeTouchID,      //支持指纹识别
    ZVBiometryTypeLocked, //生物识别被锁住
};

typedef void(^TouchIDAuthResult)(_Nullable id error);
@interface ZVBiometryManager : NSObject
@property (nonatomic,assign)ZVBiometryType biometryType;
+(instancetype)manager;
-(void)startAuthResult:(TouchIDAuthResult)result;
@end

NS_ASSUME_NONNULL_END
