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
#import "ARLineChartView.h"
#import "ARLineChartCommon.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "Parameter.h"
#import "ParameterInImageViewController.h"
#import "DataBaseNSUserDefaults.h"

#define ARC4RANDOM_MAX      0x100000000
@interface TendencyChartViewController ()

@property (strong, nonatomic) ARLineChartView *lineChartView;
@end

@implementation TendencyChartViewController{
    NSMutableArray *dataSource;
    int index;
    CGRect rect;
    Boolean isChartAddedToSuperView;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    index=0;
    isChartAddedToSuperView=false;
    self.title=@"变化趋势";
    dataSource = [NSMutableArray array];
    rect = CGRectMake(5, 40,
                      self.view.frame.size.width - 5 - 5,
                      self.view.frame.size.height - 30-20-self.tabBarController.tabBar.frame.size.height);
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self loadData];
    
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

//获取参数
-(void) loadData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showParameter.html?psid=1
    NSString *urlString= [NSString stringWithFormat:@"%@/showParameter.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    // 请求参数
    NSDictionary *parameters = @{ @"psid": [DataBaseNSUserDefaults getData:@"selectedPS"]
                                  };
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSString *result=[JsonUtil DataTOjsonString:responseObject];
        NSLog(@"***************返回结果***********************");
        //NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            //判断code 是不是0
            if([@"0" isEqualToString:[doc objectForKey:@"code"]])
            {
                
                //[self.lineChartView removeFromSuperview];
                
                if(!isChartAddedToSuperView){

                    for(int i=0;i<101;i++){
                        RLLineChartItem *item = [[RLLineChartItem alloc] init];
                        item.xValue = i;
                        //item.y1Value = nil;
                        //item.y2Value = nil;
                        [dataSource addObject:item];
                    }
                    self.lineChartView = [[ARLineChartView alloc] initWithFrame:rect dataSource:dataSource xTitle:@"Kilometre" y1Title:@"Altitude (meters)" y2Title:@"Speed (km/h)" desc1:@"Altitude" desc2:@"Speed"];
                    [self.view addSubview:self.lineChartView];
                    isChartAddedToSuperView=true;
                }else{
                    
                    if(index>100){
                        index=0;
                        [dataSource removeAllObjects];
                        for(int i=0;i<101;i++){
                            RLLineChartItem *item = [[RLLineChartItem alloc] init];
                            item.xValue = i;
                            //item.y1Value = nil;
                            //item.y2Value = nil;
                            [dataSource addObject:item];
                        }
                    }
                    double val1 = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f);
                    double val2 = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 10.0f);
                    for(int i=index;i<101;i++){
                        
                        RLLineChartItem *item=[dataSource objectAtIndex:i];
                        item.y1Value=2*val1;
                        //取0-100中间的浮点数;
                        item.y2Value=val2;
                    }
                    [self.lineChartView refreshData:dataSource];
                    
                    index++;
                }
                //模拟1秒后（
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadData];
                    //index++;
                });
            }
            else{
                [Alert showMessageAlert:[doc objectForKey:@"msg"] view:self];
            }
        }
        else
            NSLog(@"*****doc空***********");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorUser=[error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if(error.code==-1009)
            errorUser=@"主人，似乎没有网络喔！";
        [Alert showMessageAlert:errorUser view:self];
        //模拟1秒后（
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
        });
        
    }];
    
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
