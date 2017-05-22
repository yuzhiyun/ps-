//
//  TemperatureControlViewController.h
//  PS
//
//  Created by 秦启飞 on 2017/5/22.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureControlViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *mUILabelCurrentTemperature;
@property (weak, nonatomic) IBOutlet UITextField *mUITextFieldTemperature;
@property (weak, nonatomic) IBOutlet UILabel *mUILabelPV;
@property (weak, nonatomic) IBOutlet UILabel *mUILabelSP;
@property (weak, nonatomic) IBOutlet UILabel *mUILabelKaidu;
@property (weak, nonatomic) IBOutlet UITextField *mUITextFieldSP;

@end
