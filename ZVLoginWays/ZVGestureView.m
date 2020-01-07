//
//  ZVGestureView.m
//  ZVLoginWays
//
//  Created by victor on 2019/1/2.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "ZVGestureView.h"
#import "ZVPointBtn.h"

@interface ZVGestureView()
{
    ZVGestureDrawType _drawType;
    UILabel *_textLab;
    BOOL _hasAuthorize;
    NSString *_gestureFirstPassword;
}
@property (nonatomic, strong) NSMutableArray *pointArr;
@property (nonatomic, strong) NSMutableArray *selectedPointArr;
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation ZVGestureView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
//开始绘制按钮
-(void)startDrawWithType:(ZVGestureDrawType)type{
    _drawType = type;
    self.backgroundColor = [UIColor whiteColor];
    _textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.center = CGPointMake(self.bounds.size.width/2.0, ZVTOP_MARGIN);
    _textLab.text = @"请绘制手势密码";
    [self addSubview:_textLab];
    for (int i = 0 ; i < ZVPOINT_NUM; i++) {
        int row = i/ZVCOLUMN_NUM;
        int column = i%ZVCOLUMN_NUM;
        CGFloat point_x = ZVLEFT_MARGIN + (self.bounds.size.width-ZVLEFT_MARGIN-ZVRIGHT_MARGIN-ZVBTN_WIDTH)/(ZVCOLUMN_NUM-1)*column;
        CGFloat point_y = ZVTOP_MARGIN + 60 + (self.bounds.size.height-ZVTOP_MARGIN - 60 -ZVBOTTOM_MARGIN-ZVBTN_HEIGHT)/(ZVCOLUMN_NUM-1)*row;
        ZVPointBtn *btn = [ZVPointBtn buttonWithType:UIButtonTypeCustom Frame:CGRectMake(point_x, point_y, ZVBTN_WIDTH, ZVBTN_HEIGHT)];
        btn.enabled = false;
        btn.pointId = i;
        btn.strokeColor = self.strokeColor;
        btn.normalBtnColor = self.normalBtnColor;
        btn.selectedBtnColor = self.selectedBtnColor;
        btn.errorBtnColor = self.errorBtnColor;
        btn.outerCircleWidth = self.outerCircleWidth;
        btn.outerCircleRadius = self.outerCircleRadius;
        btn.innerCircleWidth = self.innerCircleWidth;
        [btn setPointState:ZVPointStateNormal];
        [self.pointArr addObject:btn];
        [self addSubview:btn];
    }
}
//绘制连接线以及修改按钮状态
-(void)drawRect:(CGRect)rect{
    if (self.selectedPointArr.count == 0) {
        return;
    }
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = 0 ; i<self.selectedPointArr.count; i++) {
        ZVPointBtn *btn = self.selectedPointArr[i];
        if (btn.center.x == 0 && btn.center.y == 0) {
            continue;
        }
        CGMutablePathRef outerPath = CGPathCreateMutable();
        CGPathAddEllipseInRect(outerPath, NULL, btn.frame);
        bool isInnerPoint = CGPathContainsPoint(outerPath, NULL, _currentPoint, false);
        if (isInnerPoint) {
            
        }
        if (i == 0) {
            CGPathMoveToPoint(path, NULL, btn.center.x,btn.center.y);
        }else{
            CGPathAddLineToPoint(path, NULL, btn.center.x, btn.center.y);
        }
        
    }
    
    if (!CGPointEqualToPoint(_currentPoint, CGPointZero)) {
        CGPathAddLineToPoint(path, NULL, _currentPoint.x, _currentPoint.y);
        CGContextAddPath(contex, path);
        CGContextSetLineCap(contex, kCGLineCapRound);
        CGContextSetLineJoin(contex, kCGLineJoinRound);
        CGContextSetLineWidth(contex, self.strokeWidth);
        CGColorRef strokecolor = [self.strokeColor CGColor];
        CGContextSetStrokeColorWithColor(contex, strokecolor);
        CGContextStrokePath(contex);
    }
    
    CGPathRelease(path);
    
}
//MARK: touches相关
//选择点的连接
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _currentPoint = point;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof ZVPointBtn * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([button isKindOfClass:[ZVPointBtn class]] && CGRectContainsPoint(button.frame, point) && button.selected == NO) {
            button.selected = YES;
            [button setPointState:ZVPointStateSelected];
            [self.selectedPointArr addObject:button];
        }
    }];
    [self setNeedsDisplay];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _currentPoint = point;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof ZVPointBtn * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([button isKindOfClass:[ZVPointBtn class]] && CGRectContainsPoint(button.frame, point) && button.selected == NO) {
            button.selected = YES;
            [button setPointState:ZVPointStateSelected];
            [self.selectedPointArr addObject:button];
        }
    }];
    [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //保存输入密码
    NSMutableString *passWord = [NSMutableString stringWithCapacity:0];
    for (ZVPointBtn *button in self.selectedPointArr) {
        [passWord appendFormat:@"%d",button.pointId];
    }
    //手势完成逻辑处理开始
    ZVGestureResult result;
    if (passWord.length < 4) {
        _textLab.text = @"密码过短";
        result = ZVGestureResultLenthError;
        [self cleanSelectedWithResult:result];
        if ([self.delegate respondsToSelector:@selector(ZVGestureView:drawType:gestureEndWithResult:)]) {
            [self.delegate ZVGestureView:self drawType:_drawType gestureEndWithResult:result];
        }
        return;
    }
    //不同的逻辑处理
    switch (_drawType) {
        case ZVGestureDrawTypeSetPassword:{
            result = [self setPassword:passWord];
            break;
        }
        case ZVGestureDrawTypeAuthorizedPassword:{
            result = [self authorizedPassword:passWord];
            break;
        }
        case ZVGestureDrawTypeResetPassword:{
            result = [self resetPassword:passWord];
            break;
        }
        default:
            break;
    }
    [self cleanSelectedWithResult:result];
    if ([self.delegate respondsToSelector:@selector(ZVGestureView:drawType:gestureEndWithResult:)]) {
        [self.delegate ZVGestureView:self drawType:_drawType gestureEndWithResult:result];
    }
}
-(void)resetFirstGesture{
    _gestureFirstPassword = nil;
    _textLab.text = @"请绘制手势密码";
}
//清空选择状态
-(void)cleanSelectedWithResult:(ZVGestureResult)result{
    NSTimeInterval time = 0;
    
    if (result == ZVGestureResultLenthError || result == ZVGestureResultAuthorizeError ||result == ZVGestureResultSetPasswordError || result == ZVGestureResultResetPasswordError  ||result == ZVGestureResultResetPasswordAuthorizeError) {
        //
        for (ZVPointBtn *button in self.selectedPointArr) {
            //修改选中错误状态
            button.selected = YES;
            [button setPointState:ZVPointStateError];
        }
        time = 0.5;
    }
    [self setNeedsDisplay];
    [self performSelector:@selector(cleanAllGestureState) withObject:nil afterDelay:time];
}
-(void)cleanAllGestureState{
    for (ZVPointBtn *button in self.selectedPointArr) {
        //移除选中状态
        button.selected = NO;
        [button setPointState:ZVPointStateNormal];
    }
    //移除d选择的点
    [self.selectedPointArr removeAllObjects];
    [self setNeedsDisplay];
}
//MARK: 设置密码-验证密码-修改密码 逻辑
//初始设置密码
-(ZVGestureResult)setPassword:(NSString *)password{
    ZVGestureResult result;
    if (_gestureFirstPassword == nil) {
        _gestureFirstPassword = password;
        result = ZVGestureResultSetPasswordFirstSuccess;
        _textLab.text = @"第一次设置密码成功";
    }else if ([_gestureFirstPassword isEqualToString:password]){
        [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"ZVGesturePassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        result = ZVGestureResultSetPasswordSecondSuccess;
        _textLab.text = @"设置成功";
    }else{
        result = ZVGestureResultSetPasswordError;
        _textLab.text = @"与上次输入不一致";
    }
    return result;
}
//验证密码
-(ZVGestureResult)authorizedPassword:(NSString *)password{
    NSString *oldPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZVGesturePassword"];
    ZVGestureResult result;
    if ([oldPassword isEqualToString:password]) {
        result = ZVGestureResultAuthorizeSuccess;
        _textLab.text = @"验证成功";
    }else{
        result = ZVGestureResultAuthorizeError;
        _textLab.text = @"验证失败，请重新输入";
    }
    return result;
}
//重置密码
-(ZVGestureResult)resetPassword:(NSString *)password{
    NSString *oldPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"ZVGesturePassword"];
    ZVGestureResult result;
    
    if ((_hasAuthorize == false && [oldPassword isEqualToString:password])) {
        result = ZVGestureResultResetPasswordAuthorizeSuccess;
        _hasAuthorize = true;
        _textLab.text = @"验证成功";
    }else if (_hasAuthorize == false && ![oldPassword isEqualToString:password]){
        result = ZVGestureResultResetPasswordAuthorizeError;
        _textLab.text = @"验证旧密码失败";
    }else if (_hasAuthorize == true && _gestureFirstPassword == nil){
        _gestureFirstPassword = password;
        _textLab.text = @"首次设置成功";
        result = ZVGestureResultResetPasswordFirstSuccess;
    }else if(_hasAuthorize == true && [_gestureFirstPassword isEqualToString:password]){
        [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"ZVGesturePassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        result = ZVGestureResultResetPasswordSecondSuccess;
        _textLab.text = @"设置成功";
    }else{
        result = ZVGestureResultResetPasswordError;
        _textLab.text = @"与第一次输入不一致";
    }
    return result;
}
//MARK: 懒加载以及设置默认值
-(NSMutableArray *)pointArr{
    if (_pointArr == nil) {
        _pointArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _pointArr;
}
-(NSMutableArray *)selectedPointArr{
    if (_selectedPointArr == nil) {
        _selectedPointArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedPointArr;
}
-(CGFloat)strokeWidth{
    if (_strokeWidth == 0) {
        _strokeWidth = 3;
    }
    return _strokeWidth;
}
//画笔颜色
-(UIColor *)strokeColor{
    if (_strokeColor == nil) {
        //画笔默认颜色
        _strokeColor = ZVRGB_COLOR(18, 216, 57, 1);
    }
    return _strokeColor;
}
-(UIColor *)normalBtnColor{
    if (_normalBtnColor == nil) {
        //默认颜色
        _normalBtnColor = [UIColor lightGrayColor];
    }
    return _normalBtnColor;
}
-(UIColor *)selectedBtnColor{
    if (_selectedBtnColor == nil) {
        //默认颜色
        _selectedBtnColor = ZVRGB_COLOR(18, 216, 57, 1);
    }
    return _selectedBtnColor;
}
-(UIColor *)errorBtnColor{
    if (_errorBtnColor == nil) {
        //默认颜色
        _errorBtnColor = ZVRGB_COLOR(18, 216, 57, 1);
    }
    return _errorBtnColor;
}
-(CGFloat)outerCircleWidth{
    if (_outerCircleWidth == 0) {
        _outerCircleWidth = 3;
    }
    return _outerCircleWidth;
}
-(CGFloat)outerCircleRadius{
    if (_outerCircleRadius == 0) {
        _outerCircleRadius = 35*ZVSHIPEI;
    }
    return _outerCircleRadius;
}
-(CGFloat)innerCircleWidth{
    if (_innerCircleWidth == 0) {
        _innerCircleWidth = 3;
    }
    return _innerCircleWidth;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
