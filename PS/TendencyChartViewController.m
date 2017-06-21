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

@interface TendencyChartViewController ()

@property (strong, nonatomic) ARLineChartView *lineChartView;
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
    /*
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
    */
    [self setCharts];
    
}
#pragma mark 使用ARLineChart
- (void)setCharts{
    //************* Test: Create Data Source *************
    NSMutableArray *dataSource = [NSMutableArray array];
    // rand() /((double)(RAND_MAX)/100) //取0-100中间的浮点数
    double distanceMin = 0, distanceMax = 100;
    double altitudeMin = 5.0, altitudeMax = 50;
    double speedMin = 0.5, speedMax = 15;
    
    srand(time(NULL)); //Random seed
    
    for (int i=0; i< 11; i++) {
        
        RLLineChartItem *item = [[RLLineChartItem alloc] init];
        double randVal;
        
        randVal = rand() /((double)(RAND_MAX)/distanceMax) + distanceMin;
        item.xValue = randVal;
        
        randVal = rand() /((double)(RAND_MAX)/altitudeMax) + altitudeMin;
        item.y1Value = randVal;
        
        randVal = rand() /((double)(RAND_MAX)/speedMax) + speedMin;
        item.y2Value = randVal;
        
        NSLog(@"Random: item.xValue=%.2lf, item.y1Value=%.2lf, item.y2Value=%.2lf", item.xValue, item.y1Value, item.y2Value);
        [dataSource addObject:item];
    }
    //************ End Test *********************
    
    ////////////// Create Line Char //////////////////////////
    CGRect rect = CGRectMake(5, 40,
                             self.view.frame.size.width - 5 - 5,
                             300);
    //    self.lineChartView = [[ARLineChartView alloc] initWithFrame:rect dataSource:dataSource xTitle:@"千米" y1Title:@"海拔（米）" y2Title:@"速度（千米/小时）" desc1:@"海拔" desc2:@"速度"];
    self.lineChartView = [[ARLineChartView alloc] initWithFrame:rect dataSource:dataSource xTitle:@"Kilometre" y1Title:@"Altitude (meters)" y2Title:@"Speed (km/h)" desc1:@"Altitude" desc2:@"Speed"];
    [self.view addSubview:self.lineChartView];
    

    
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
