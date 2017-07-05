//
//  MeViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/2/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"
#import "DataBaseNSUserDefaults.h"
#import "LoginViewController.h"
#import "FileListTableViewController.h"
@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的";
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    // Do any additional setup after loading the view.
    self.mUILabelCurrentUser.text=[DataBaseNSUserDefaults getData:@"username"];
    self.mUILabelSelectedPsId.text=[DataBaseNSUserDefaults getData:@"selectedPS"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOut:(id)sender {
    
    LoginViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    nextPage.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nextPage animated:YES];
    
}
- (IBAction)enterFileList:(id)sender {
    
    FileListTableViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"FileListTableViewController"];
    
    nextPage.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nextPage animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
