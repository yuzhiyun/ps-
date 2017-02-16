//
//  CmdHistory.h
//  PS
//
//  Created by 秦启飞 on 2017/2/16.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface  CmdHistory:NSObject
@property (nonatomic,copy)NSString *com_id;
@property (nonatomic,copy)NSString *com_name;
@property (nonatomic,copy)NSString *user_name;
@property (nonatomic,copy)NSString *com_time;
@property (nonatomic,copy)NSString *com_state;

@end
