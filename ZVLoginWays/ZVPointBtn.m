//
//  ZVPointBtn.m
//  ZVLoginWays
//
//  Created by victor on 2019/1/2.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "ZVPointBtn.h"

@interface ZVPointBtn()
@property(nonatomic,strong)UIColor *currentColor;
@end

@implementation ZVPointBtn


+(instancetype)buttonWithType:(UIButtonType)buttonType Frame:(CGRect)frame{
    ZVPointBtn *btn = [ZVPointBtn buttonWithType:buttonType];
    btn.frame = frame;
    return btn;
}
- (void)drawRect:(CGRect)rect{
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGFloat centerX = self.bounds.size.width/2.0;
    CGFloat centerY = self.bounds.size.height/2.0;
    //外部圆环
    CGMutablePathRef outerPath = CGPathCreateMutable();
    CGPathAddArc(outerPath, NULL, centerX, centerY, self.outerCircleRadius, 0, M_PI*2.0, YES);
    CGContextSetLineWidth(contex, self.outerCircleWidth);
    CGContextSetStrokeColorWithColor(contex, self.currentColor.CGColor);
    CGContextAddPath(contex, outerPath);
    CGContextStrokePath(contex);
    CGPathRelease(outerPath);
    if (self.pointState != ZVPointStateNormal) {
        CGMutablePathRef innerPath = CGPathCreateMutable();
        CGPathAddArc(innerPath, NULL, centerX, centerY, self.innerCircleWidth, 0, M_PI*2.0, YES);
        CGContextSetFillColorWithColor(contex, self.currentColor.CGColor);
        CGContextAddPath(contex, innerPath);
        CGContextFillPath(contex);
        CGPathRelease(innerPath);
    }
}
-(void)setOuterCircleWidth:(CGFloat)outerCircleWidth{
    _outerCircleWidth = outerCircleWidth;
    self.layer.cornerRadius = outerCircleWidth;
    self.layer.masksToBounds = YES;
}
-(UIColor *)currentColor{
    if (_currentColor == nil) {
        _currentColor = _strokeColor;
    }
    return _currentColor;
}
-(void)setPointState:(ZVPointState)pointState{
    _pointState = pointState;
    switch (pointState) {
        case ZVPointStateNormal:{
            _currentColor = _normalBtnColor;
            break;
        }
        case ZVPointStateSelected:{
            _currentColor = _selectedBtnColor;
            break;
        }
        case ZVPointStateError:{
            _currentColor = _errorBtnColor;
            break;
        }
        default:{
            break;
        }
    }
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
