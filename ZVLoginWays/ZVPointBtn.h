//
//  ZVPointBtn.h
//  ZVLoginWays
//
//  Created by victor on 2019/1/2.
//  Copyright © 2019 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ZVPointState) {
    ZVPointStateNormal,
    ZVPointStateSelected,
    ZVPointStateError,
};
@interface ZVPointBtn : UIButton
@property(nonatomic,assign)NSInteger pointId;
@property(nonatomic,assign)ZVPointState pointState;
//均有默认，也可以手动设置
@property(nonatomic,copy)UIColor *strokeColor; //连接线的颜色
@property(nonatomic,copy)UIColor *normalBtnColor;//按钮未选中颜色
@property(nonatomic,copy)UIColor *selectedBtnColor;//按钮选中的颜色
@property(nonatomic,copy)UIColor *errorBtnColor;//失败的颜色
@property(nonatomic,assign)CGFloat outerCircleWidth;
@property(nonatomic,assign)CGFloat outerCircleRadius;
@property(nonatomic,assign)CGFloat innerCircleWidth;
+(instancetype)buttonWithType:(UIButtonType)buttonType Frame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
