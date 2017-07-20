//
//  DataBaseNSUserDefaults.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/12.
//  Copyright © 2017年 dlz. All rights reserved.
//

#import "DataBaseNSUserDefaults.h"
#import "MBProgressHUD.h"

@implementation DataBaseNSUserDefaults


//NSUserDefaults 存数据
+(void) setData:(id) object forkey:(NSString*) forkey{
    //取得定义
    NSUserDefaults *tUserDefaults=[NSUserDefaults standardUserDefaults];
    //存放数据
    [tUserDefaults setObject:object forKey:forkey];
    //确认数据
    [tUserDefaults synchronize];
}
//NSUserDefaults 取出数据
+(id) getData:(NSString *) forkey{
    id object;
    //取得定义
    NSUserDefaults *tUserDefaults=[NSUserDefaults standardUserDefaults];
    //取出数据
    object=[tUserDefaults objectForKey:forkey];
    return object;
}
//NSUserDefaults 清除数据
+(void) removeData:(NSString *) forkey{
    //取得定义
    NSUserDefaults *tUserDefaults=[NSUserDefaults standardUserDefaults];
    //清除数据
    [tUserDefaults removeObjectForKey:forkey];
    //确认数据
    [tUserDefaults synchronize];
}

@end
