//
//  MessageViewController.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2016/12/17.
//  Copyright © 2016年 dlz. All rights reserved.
//

#import "MessageViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "JsonUtil.h"
#import "MBProgressHUD.h"
#import "LinkMan.h"
#import "Alert.h"
#import "DataBaseNSUserDefaults.h"


@interface MessageViewController ()

@end

@implementation MessageViewController{
    NSMutableArray *allDataFromServer;
    NSString *selfPic;
    NSString *selfName;
    NSString *selfUserId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //MyLog(@"");
    selfPic=@"";
    selfUserId=@"";
    selfName=@"";
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    myDelegate.chatController=self;
    /**由于防止用户未进入联系人页面就直接点击群发，这样在群发页面就没有联系人信息了
     * 所以我在消息页面就把联系人信息获取下来
     */
    allDataFromServer= [[NSMutableArray alloc]init];
    [self loadData];
    /**
     *要显示用户信息和群组信息，首先需要实现两个协议，然后设置代理为这个类，然后实现两个函数
     *- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
     *- (void)getGroupInfoWithGroupId:(NSString *)groupId
     *completion:(void (^)(RCGroup *groupInfo))completion{
     */
    [RCIM sharedRCIM].userInfoDataSource=self;
    [RCIM sharedRCIM].groupInfoDataSource=self;
    
    //设置需要显示哪些类型的会话,加了这行代码，群的消息就显示出来了，否则默认只显示单聊消息（我的猜测吧！）
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*!
 获取用户信息
 @param userId                  用户ID
 @param completion              获取用户信息完成之后需要执行的Block
 @param userInfo(in completion) 该用户ID对应的用户信息
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    
    NSLog(@"getUserInfoWithUserId被调用几次");
    //这个是本人
    if([userId isEqualToString:selfUserId]){
        AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        NSString *picUrl=[NSString stringWithFormat:@"%@%@",myDelegate.ipString,selfPic];
        RCUserInfo *userInfo=[[RCUserInfo alloc]initWithUserId:userId name:selfName portrait:picUrl];
        completion(userInfo);
    }
    /*
    if([@"321" isEqualToString:userId]){
        RCUserInfo *userInfo2=[[RCUserInfo alloc]initWithUserId:userId name:@"俞志云" portrait:@"http://avatar.csdn.net/B/A/4/1_yuzhiyun3536.jpg"];
        completion(userInfo2);
    }
    */

    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    
    for(LinkMan *item in myDelegate.linkManArray){
        if([userId isEqualToString:item.LinkmanId  ]){
            
              NSString *picUrl=[NSString stringWithFormat:@"%@%@",myDelegate.ipString,item.picUrl];
            
            if(0==[item.picUrl length])
                picUrl=@"http://img.blog.csdn.net/20170316143418990?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveXV6aGl5dW4zNTM2/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast";
            RCUserInfo *userInfo=[[RCUserInfo alloc]initWithUserId:userId name:item.name portrait:picUrl];
            NSLog(picUrl);
            completion(userInfo);
        }
    }
}
/*!
 获取群组信息
 
 @param groupId                     群组ID
 @param completion                  获取群组信息完成之后需要执行的Block
 @param groupInfo(in completion)    该群组ID对应的群组信息
 @discussion SDK通过此方法获取用户信息并显示，请在completion的block中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    
//    //我自己建的群id就是1，所以
//    if([@"1" isEqualToString:groupId]){
//        RCGroup *groupInfo =[[RCGroup alloc] initWithGroupId:@"1" groupName:@"初二3班班群" portraitUri:@"http://img.blog.csdn.net/20170113192304511?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveXV6aGl5dW4zNTM2/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast"];
//        completion(groupInfo);
//    }
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
   

    
    for(LinkMan *model in myDelegate.linkManArray){
        if([model.LinkmanId isEqualToString:groupId]){
           RCGroup *groupInfo =[[RCGroup alloc] initWithGroupId:model.LinkmanId groupName:model.name portraitUri:@"http://img.blog.csdn.net/20170113192304511?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQveXV6aGl5dW4zNTM2/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast"];
            completion(groupInfo);
        }
    }
}
/*!
 点击会话列表中Cell的回调
 
 @param conversationModelType   当前点击的会话的Model类型
 @param model                   当前点击的会话的Model
 @param indexPath               当前会话在列表数据源中的索引值
 
 @discussion 您需要重写此点击事件，跳转到指定会话的聊天界面。
 如果点击聚合Cell进入具体的子会话列表，在跳转时，需要将isEnteredToCollectionViewController设置为YES。
 */
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    
    if([AppDelegate isVip]){
        //修改未读消息红色圆点的数字大小（我指的是在手机桌面上的圆点）
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber -   model.unreadMessageCount;
        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
        //设置隐藏底部栏
        conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else{
        [AppDelegate goToVip:self];
    }
//    
//    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
//    if([AppDelegate isTeacher]){
//        //修改未读消息红色圆点的数字大小（我指的是在手机桌面上的圆点）
//        [UIApplication sharedApplication].applicationIconBadgeNumber =
//        [UIApplication sharedApplication].applicationIconBadgeNumber -   model.unreadMessageCount;
//        
//        RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//        conversationVC.conversationType = model.conversationType;
//        conversationVC.targetId = model.targetId;
//        conversationVC.title = model.conversationTitle;
//        //设置隐藏底部栏
//        conversationVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:conversationVC animated:YES];
//        
//        
//        return;
//    
//    }
//    NSString *urlString= [NSString stringWithFormat:@"%@/api/sys/user/validateVip",myDelegate.ipString];
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
//    NSString *token=myDelegate.token;
//    // 请求参数
//    NSDictionary *parameters = @{ @"appId":@"03a8f0ea6a",
//                                  @"appSecret":@"b4a01f5a7dd4416c",
//                                  @"token":token
//                                  };
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        
//        
//        NSString *result=[JsonUtil DataTOjsonString:responseObject];
//        NSLog(@"***************返回结果***********************");
//        NSLog(result);
//        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error=[[NSError alloc]init];
//        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        if(doc!=nil){
//            NSLog(@"*****doc不为空***********");
//            //判断code 是不是0
//            NSNumber *zero=[NSNumber numberWithInt:(0)];
//            NSNumber *code=[doc objectForKey:@"code"];
//            if([zero isEqualToNumber:code])
//            {
//                //修改未读消息红色圆点的数字大小（我指的是在手机桌面上的圆点）
//                [UIApplication sharedApplication].applicationIconBadgeNumber =
//                [UIApplication sharedApplication].applicationIconBadgeNumber -   model.unreadMessageCount;
//                
//                RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
//                conversationVC.conversationType = model.conversationType;
//                conversationVC.targetId = model.targetId;
//                conversationVC.title = model.conversationTitle;
//                //设置隐藏底部栏
//                conversationVC.hidesBottomBarWhenPushed=YES;
//                [self.navigationController pushViewController:conversationVC animated:YES];
//               
//                
//            }
//            else{
//                if([@"token invalid" isEqualToString:[doc objectForKey:@"msg"]]){
//                    [AppDelegate reLogin:self];
//                }
//                else{
//                    NSString *msg=[NSString stringWithFormat:@"code是%d ： %@",[doc objectForKey:@"code"],[doc objectForKey:@"msg"]];
//                    NSNumber *zero=[NSNumber numberWithInt:(0)];
//                    if([[NSNumber numberWithInt:(-2)] isEqualToNumber:[doc objectForKey:@"code"]]){
//                        [AppDelegate goToVip:self];
//                    }
//                    
//                }
//            }
//        }
//        else
//            NSLog(@"*****doc空***********");
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
//        if(error.code==-1009)
//            errorUser=@"主人，似乎没有网络喔！";
//        [Alert showMessageAlert:errorUser view:self];
//    }];
}


#pragma mark 加载联系人列表
-(void)loadData {
    //MBProgressHUD *hud;
    //hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //hud.color = [UIColor colorWithHexString:@"343637" alpha:0.5];
    //hud.labelText = @" 获取数据...";
    //[hud show:YES];
    //获取全局ip地址
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *urlString;
    
    urlString= [NSString stringWithFormat:@"%@/api/sys/user/contacts",myDelegate.ipString];
    
    
    //创建数据请求的对象，不是单例
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //设置响应数据的类型,如果是json数据，会自动帮你解析
    //注意setWithObjects后面的s不能少
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    NSString *token=myDelegate.token;
    // 请求参数
    NSDictionary *parameters = @{ @"appId":@"03a8f0ea6a",
                                  @"appSecret":@"b4a01f5a7dd4416c",
                                  
                                  //@"pageNumber":[NSString stringWithFormat:@"%d",pageIndex],
                                  @"token":token
                                  };
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //隐藏圆形进度条
       // [hud hide:YES];
       // NSLog(responseObject);
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            if([[doc objectForKey:@"code"] isKindOfClass:[NSNumber class]])
                NSLog(@"code 是 NSNumber");
            //判断code 是不是0
            NSNumber *zero=[NSNumber numberWithInt:(0)];
            NSNumber *code=[doc objectForKey:@"code"];
            if([zero isEqualToNumber:code])
            {
                if(nil!=[doc allKeys]){
                    NSArray *array=[doc objectForKey:@"data"];
                    if(0==[array count]){
                        [Alert showMessageAlert:@"抱歉,没有数据" view:self];
                    }
                    else{
                        //自己信息
                        NSDictionary *selfInfo=[[doc objectForKey:@"data"] objectForKey:@"self"];
                        //NSLog(selfInfo);
                        selfPic=selfInfo[@"picurl"];
                        selfUserId=selfInfo[@"useId"];
                        selfName=selfInfo[@"name"];
                        NSLog(selfPic);
                        NSLog(selfUserId);
                        //NSLog(selfName);
                        //单聊联系人信息
                        NSArray *contactsArray=[[doc objectForKey:@"data"] objectForKey:@"contacts"];
                        for(NSDictionary *item in  contactsArray ){
                            LinkMan *model=[[LinkMan alloc]init];
                            model.LinkmanId=item [@"userId"];
                            model.picUrl=item [@"picurl"];
                            model.introduction=item [@"remark"];
                            model.name=item [@"name"];
                            model.type= @"private";
                            NSNumber *parentOrTeacher=item [@"type"];
                            if([parentOrTeacher isEqualToNumber:[NSNumber numberWithInt:0]]){
                                model.parentOrTeacher=@"teacher";
                            }else{
                                model.parentOrTeacher=@"parent";
                            }
                            
                            [allDataFromServer addObject:model];
                        }
                        //群聊联系人信息
                        NSArray *groupsArray=[[doc objectForKey:@"data"] objectForKey:@"groups"];
                        for(NSDictionary *item in  groupsArray ){
                            LinkMan *model=[[LinkMan alloc]init];
                            model.LinkmanId=item [@"id"];
                            //model.picUrl=item [@"picurl"];
                            model.name=item [@"name"];
                            [allDataFromServer addObject:model];
                        }
                        //强制刷新界面
                        [self.conversationListTableView reloadData];
                        
                        //保存数据在群发页面使用
                        AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
                        myDelegate.linkManArray=allDataFromServer;
                        //去除掉最后一项，因为最后一项是班级群啊
                        //[myDelegate.linkManArray removeObjectAtIndex:[myDelegate.linkManArray count]-1];
                        
                        NSLog(@"allDataFromServer项数为%i",[allDataFromServer count]);
                        
                        
                        // [mTableView reloadData];
                    }
                    
                }
                else
                {
                    [Alert showMessageAlert:@"抱歉，尚无文章可以阅读" view:self];
                }
            }
            else{
                //判断code 是不是-1,如果是那么token失效，需要让用户重新登录
                //if([[NSNumber numberWithInt:(-1)] isEqualToNumber:[doc objectForKey:@"code"]]){
                if([@"token invalid" isEqualToString:[doc objectForKey:@"msg"]]){
                    [AppDelegate reLogin:self];
                }
                else{
                    NSString *msg=[NSString stringWithFormat:@"code是%d ： %@",[doc objectForKey:@"code"],[doc objectForKey:@"msg"]];
                    [Alert showMessageAlert:msg  view:self];
                }
            }
        }
        else
            NSLog(@"*****doc空***********");
        //        NSLog([self DataTOjsonString:responseObject]);
        //          NSLog([self convertToJsonData:dic]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //隐藏圆形进度条
       // [hud hide:YES];
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(-1009==error.code||-1016==error.code)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];
}

/**
 *用于在appDelegate那里点击本地通知的回调，跳转到聊天页面。
 */
-(void)enterChatView :(RCConversationViewController *)viewController{

    [self.navigationController pushViewController:viewController animated:YES];
    
}
@end
