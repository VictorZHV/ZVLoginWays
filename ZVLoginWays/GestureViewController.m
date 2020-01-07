//
//  GestureViewController.m
//  ZVLoginWays
//
//  Created by victor on 2019/1/7.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "GestureViewController.h"

@interface GestureViewController ()<ZVGestureViewDelegate>
{
    ZVGestureView *view;
}
@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setTitle:@"重绘" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    resetBtn.frame = CGRectMake(100, 64, 100, 50);
    [resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    view = [[ZVGestureView alloc]initWithFrame:CGRectMake(0, 130, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width+60.0)];
    view.delegate = self;
    view.strokeColor = [UIColor greenColor];
    view.normalBtnColor = [UIColor lightGrayColor];
    view.errorBtnColor = [UIColor redColor];
    view.selectedBtnColor = [UIColor greenColor];
    view.strokeWidth = 3;
    view.outerCircleWidth = 3;
    view.innerCircleWidth = 3;
    [view startDrawWithType:_type];
    [self.view addSubview:view];
    // Do any additional setup after loading the view.
}
-(void)resetAction{
    [view resetFirstGesture];
}
-(void)ZVGestureView:(ZVGestureView *)view drawType:(ZVGestureDrawType)drawType gestureEndWithResult:(ZVGestureResult)result{
    NSLog(@"victor-----result === %d",result);
    if (result == ZVGestureResultSetPasswordSecondSuccess || result == ZVGestureResultAuthorizeSuccess || result == ZVGestureResultResetPasswordSecondSuccess) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
