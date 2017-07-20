//
//  Token.h
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/12.
//  Copyright © 2017年 dlz. All rights reserved.
//

#import <Foundation/Foundation.h>
//如果不导入#import <UIKit/UIKit.h>，这里就报错，expected a type.
#import <UIKit/UIKit.h>

@interface  Toast:NSObject


+(void)showToast:(NSString *)str view:(UIView*) view;
@end
