//
//  AppDelegate.h
//  PS
//
//  Created by 秦启飞 on 2017/1/29.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    
    UIColor *navigationBarColor;
     NSString *ipString;
    NSMutableArray *allParamatersArray;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong)UIColor *navigationBarColor;

@property (nonatomic,strong)NSString *ipString;
@property (nonatomic,strong)NSMutableArray *allParamatersArray;
@end

