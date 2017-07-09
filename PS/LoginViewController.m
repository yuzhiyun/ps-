//
//  LoginViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/2/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "DataBaseNSUserDefaults.h"
@interface LoginViewController ()

@end

@implementation LoginViewController{
    
     NSMutableArray *mDataPSList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    
    mDataPSList=[[NSMutableArray alloc]init];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)login:(id)sender {
    
 
    
    if(0==self.mUITextFieldPasswd.text.length || 0==self.mUITextFieldUsername.text.length)
        [Alert showMessageAlert:@"请确保输入框不为空" view:self];
    else
    [self httpLogin:self.mUITextFieldUsername.text :self.mUITextFieldPasswd.text];
    
    
}

//虽然viewDidLoad已经设置了隐藏，但是在进入下一个页面并返回此页面的时候，还是会出现，所以在这里再次隐藏
-(void) viewDidAppear:(BOOL)animated{
    //    隐藏返回按钮navigationController的navigationBar
    self.navigationController.navigationBarHidden=YES;
}
-(void) httpLogin:(NSString*) username: (NSString*) passwd{
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    ////http://ps.leideng.org/index.php/User/App/loginApp.html?
    //userid=admin&userpassword=123456
    NSString *urlString= [NSString stringWithFormat:@"%@/loginApp.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    // 请求参数
    NSDictionary *parameters = @{
                                 @"userid":username,
                                 @"userpassword":passwd,
                                 //@"psid":@"10"
                                 };
    
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            //判断code 是不是0
            if([@"0" isEqualToString:[doc objectForKey:@"code"]]){
                [DataBaseNSUserDefaults setData: username forkey:@"username"];
                [self getPSList];
            }
            else{
                [Alert showMessageAlert:@"用户名或密码不正确" view:self];
            }
        }
        else
            NSLog(@"*****doc空***********");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];

    
    
}
//获取台驾列表
-(void) getPSList{
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlString= [NSString stringWithFormat:@"%@/showPlatform.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];

    
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        //NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            //判断code 是不是0
            if([@"0" isEqualToString:[doc objectForKey:@"code"]]){
                NSArray *array=[doc objectForKey:@"data"];
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:@"请选择台驾"
                                                  delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
                actionSheet.actionSheetStyle = UIBarStyleDefault;
                
                for(NSDictionary *item in array){
                    [actionSheet addButtonWithTitle:item[@"ps_name"]];
                    [mDataPSList addObject:item[@"ps_id"]];
                }
                
                    [actionSheet showInView:self.view];

                

                

                
            }
            else{
                [Alert showMessageAlert:@"" view:self];
            }
        }
        else
            NSLog(@"*****doc空***********");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
    }];
    
    
    
}
//UIActionSheet对话框选择监听事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    //NSLog(@"选择对话框监听事件,您选择了%i",buttonIndex);
    
    //NSLog([grade objectAtIndex:buttonIndex]);
    //if(buttonIndex!=[mDataSemester count]-1)
    if(buttonIndex!=0){
        NSLog(@"%@", [mDataPSList objectAtIndex:buttonIndex-1]);
        [DataBaseNSUserDefaults setData: [mDataPSList objectAtIndex:buttonIndex-1] forkey:@"selectedPS"];
        //根据storyboard id来获取目标页面
        MainViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        //跳转
        [self.navigationController pushViewController:nextPage animated:YES];
    }
}

@end
