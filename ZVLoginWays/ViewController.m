//
//  ViewController.m
//  ZVLoginWays
//
//  Created by victor on 2018/12/28.
//  Copyright © 2018年 Victor. All rights reserved.
//

#import "ViewController.h"
#import "ZVBiometryManager.h"
#import "ZVGestureView.h"
#import "GestureViewController.h"
@interface ViewController ()<ZVGestureViewDelegate>
{
    Boolean showErrorAlert;
    GestureViewController *_vc;
}
@property (weak, nonatomic) IBOutlet UILabel *bioLab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([ZVBiometryManager manager].biometryType == ZVBiometryTypeFaceID) {
        _bioLab.text = @"面容识别";
    }else if ([ZVBiometryManager manager].biometryType == ZVBiometryTypeTouchID){
        _bioLab.text = @"指纹识别";
    }else if ([ZVBiometryManager manager].biometryType == ZVBiometryTypeNone){
        showErrorAlert = true;
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)bioSwitchClick:(id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    if (!switchBtn.isOn) {
        return;
    }
    if (showErrorAlert) {
        [switchBtn setOn:false];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您的设备不支持生物识别哦" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *act = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:act];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        
        [[ZVBiometryManager manager]startAuthResult:^(id  _Nullable error) {
            if (error) {
                [switchBtn setOn:false];
                NSError *tmpError = error;
                //生物识别锁住
                if (tmpError.code == ZVBiometryTypeLocked) {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您的生物识别已经锁住" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *act = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertVC addAction:act];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
            }else{
                [switchBtn setOn:true];
            }
            NSLog(@"%@",error);
        }];
    }
}
- (IBAction)gestureClick:(id)sender {
    _vc = [[GestureViewController alloc]init];
    _vc.type = ZVGestureDrawTypeAuthorizedPassword;
    [self presentViewController:_vc animated:YES completion:nil];
}
- (IBAction)gestureClickWithoutTrail:(id)sender {
    _vc = [[GestureViewController alloc]init];
    _vc.type = ZVGestureDrawTypeAuthorizedPassword;
    [self presentViewController:_vc animated:YES completion:nil];
}
- (IBAction)initGesture:(id)sender {
    _vc = [[GestureViewController alloc]init];
    _vc.type = ZVGestureDrawTypeSetPassword;
    [self presentViewController:_vc animated:YES completion:nil];
}
- (IBAction)resetGesture:(id)sender {
    _vc = [[GestureViewController alloc]init];
    _vc.type = ZVGestureDrawTypeResetPassword;
    [self presentViewController:_vc animated:YES completion:nil];
}

@end
