//
//  LoadMotorViewController.h
//  PS
//
//  Created by 秦启飞 on 2017/5/9.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMotorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *mUIImageViewP1;
@property (weak, nonatomic) IBOutlet UIImageView *mUIImageViewN1;
@property (weak, nonatomic) IBOutlet UITextField *mUITextFieldSlopeTime;

//负载1
@property (weak, nonatomic) IBOutlet UILabel *mUILabelLoad1Percent;
@property (weak, nonatomic) IBOutlet UISlider *mUISlider1;
@property (weak, nonatomic) IBOutlet UISwitch *mUISwitch1;


//负载2
@property (weak, nonatomic) IBOutlet UILabel *mUILabelLoad2Percent;
@property (weak, nonatomic) IBOutlet UISlider *mUISlider2;
@property (weak, nonatomic) IBOutlet UISwitch *mUISwitch2;



@end
