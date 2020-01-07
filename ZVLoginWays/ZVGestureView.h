//
//  ZVGestureView.h
//  ZVLoginWays
//
//  Created by victor on 2019/1/2.
//  Copyright © 2019 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

//点的个数
#define ZVPOINT_NUM 9
//点的列数
#define ZVCOLUMN_NUM 3
#define ZVROW_NUM (ZVPOINT_NUM%ZVCOLUMN_NUM == 0?ZVPOINT_NUM/ZVCOLUMN_NUM:ZVPOINT_NUM/ZVCOLUMN_NUM+1)
//左侧间隙
#define ZVLEFT_MARGIN 30.0
//右侧间隙
#define ZVRIGHT_MARGIN 30.0
//顶部间隙
#define ZVTOP_MARGIN 30.0
//底部间隙
#define ZVBOTTOM_MARGIN 30.0
//屏幕宽
#define ZVSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高
#define ZVSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//适配
#define ZVSHIPEI (ZVSCREEN_WIDTH/375.0)
//按钮宽
#define ZVBTN_WIDTH (75.0*ZVSHIPEI)
//按钮高
#define ZVBTN_HEIGHT (75.0*ZVSHIPEI)
#define ZVRGB_COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZVGestureDrawType) {
    ZVGestureDrawTypeSetPassword,
    ZVGestureDrawTypeAuthorizedPassword,
    ZVGestureDrawTypeResetPassword,
};

typedef NS_ENUM(NSUInteger, ZVGestureResult) {
    ZVGestureResultSetPasswordFirstSuccess,      //设置密码时首次成功
    ZVGestureResultSetPasswordSecondSuccess,     //设置密码时第二次成功
    ZVGestureResultSetPasswordError,             //设置密码时第二次与第一次不一致
    ZVGestureResultAuthorizeSuccess,             //验证密码成功
    ZVGestureResultAuthorizeError,               //验证密码失败
    ZVGestureResultResetPasswordAuthorizeSuccess,//重设密码时验证旧密码成功
    ZVGestureResultResetPasswordAuthorizeError,  //重设密码时验证旧密码错误
    ZVGestureResultResetPasswordFirstSuccess,    //重设密码第一次成功
    ZVGestureResultResetPasswordSecondSuccess,   //重设密码第二次成功
    ZVGestureResultResetPasswordError,           //重设密码时第二次与第一次不一致
    ZVGestureResultLenthError,                   //手势长度不满足最小值
};

@class ZVGestureView;

@protocol  ZVGestureViewDelegate<NSObject>
//手势完成回调
-(void)ZVGestureView:(ZVGestureView *)view drawType:(ZVGestureDrawType)drawType gestureEndWithResult:(ZVGestureResult)result;

@end


@interface ZVGestureView : UIView
//均有默认，也可以手动设置
@property(nonatomic,copy)UIColor *strokeColor; //连接线的颜色
@property(nonatomic,copy)UIColor *normalBtnColor;//按钮未选中颜色
@property(nonatomic,copy)UIColor *selectedBtnColor;//按钮选中的颜色
@property(nonatomic,copy)UIColor *errorBtnColor;//失败的颜色
@property(nonatomic,assign)CGFloat strokeWidth;//连接线宽度
@property(nonatomic,assign)CGFloat outerCircleWidth;//外部圆环宽度
@property(nonatomic,assign)CGFloat outerCircleRadius;//外部圆环半径
@property(nonatomic,assign)CGFloat innerCircleWidth;//内部圆点半径
@property(nonatomic,weak)id <ZVGestureViewDelegate> delegate;
-(void)startDrawWithType:(ZVGestureDrawType)type;
-(void)resetFirstGesture;
@end

NS_ASSUME_NONNULL_END
