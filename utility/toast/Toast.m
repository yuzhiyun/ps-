//
//  Token.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/12.
//  Copyright © 2017年 dlz. All rights reserved.
//

#import "Toast.h"
#import "MBProgressHUD.h"

@implementation Toast


+(void)showToast:(NSString *)str view:(UIView*) view{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = str;
    HUD.mode = MBProgressHUDModeText;
    [HUD showAnimated:YES whileExecutingBlock:^{
        
        sleep(1);
        
    } completionBlock:^{
        
        [HUD removeFromSuperview];
    }];
}
@end
