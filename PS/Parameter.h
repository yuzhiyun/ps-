//
//  Parameter.h
//  PS
//
//  Created by 秦启飞 on 2017/2/16.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface  Parameter:NSObject
@property (nonatomic,copy)NSString *p_name;
@property (nonatomic,copy)NSString *p_id;
@property (nonatomic,copy)NSString *ps_id;
@property (nonatomic,copy)NSString *p_unit;
@property (nonatomic,copy)NSString *p_format;
@property (nonatomic,copy)NSString *create_date;
@property (nonatomic,copy)NSNumber *p_value;
@property (nonatomic,copy)NSNumber *p_color;
@property (nonatomic,copy)NSNumber *update_date;
//查看报警那里用到的属性
@property (nonatomic,copy)NSString *de_state;

@end
