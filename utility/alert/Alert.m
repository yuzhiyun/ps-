//
//  Alert.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/18.
//  Copyright © 2017年 dlz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Alert.h"
#import "MBProgressHUD.h"

@implementation Alert

+(void)showMessageAlert:(NSString *)msg view:(UIViewController *)viewController{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                               style:UIAlertActionStyleDefault handler:nil];
    
    //        信息框添加按键
    [alert addAction:ok];
    [viewController presentViewController:alert animated:YES completion:nil];
    
}
@end
