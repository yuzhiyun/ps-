//
//  MessageViewController.h
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/17.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "ChatListViewController.h"
//实现这两个协议，可以用于显示用户、群组头像昵称等信息
@interface MessageViewController :ChatListViewController<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

-(void)enterChatView :(RCConversationViewController *)viewController;
@end
