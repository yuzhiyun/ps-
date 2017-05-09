//
//  MotorViewController.h
//  PS
//
//  Created by 秦启飞 on 2017/5/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUIImageViewP1;
@property (weak, nonatomic) IBOutlet UIImageView *mUIImageViewN1;
@property (weak, nonatomic) IBOutlet UITextField *mUITextFieldSlopeTime;
@property (weak, nonatomic) IBOutlet UILabel *mUILabelLoadPercent;

@property (weak, nonatomic) IBOutlet UISlider *mUISliderLoad;

@property (weak, nonatomic) IBOutlet UISwitch *mUISwitchReverse;

@end
