//
//  TendencyChartViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/2/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "TendencyChartViewController.h"
#import "WSLineChartView.h"
#import "AppDelegate.h"
@interface TendencyChartViewController ()

@end

@implementation TendencyChartViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title=@"变化趋势";
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSMutableArray *xArray = [NSMutableArray array];
    NSMutableArray *yArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++) {
        [xArray addObject:@"06:35"];
        [yArray addObject:[NSString stringWithFormat:@"%.2lf",50.0+arc4random_uniform(50)]];
    }
    double  alignTop=self.navigationController.navigationBar.bounds.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    double  height=self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height-self.tabBarController.tabBar.bounds.size.height;
    
    
    WSLineChartView *wsLine = [[WSLineChartView alloc]initWithFrame:CGRectMake(0, alignTop, self.view.frame.size.width, height) xTitleArray:xArray yValueArray:yArray yMax:100 yMin:0];
    [self.view addSubview:wsLine];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
