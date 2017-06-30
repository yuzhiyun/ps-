//
//  ChangeTrendViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/6/24.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "ChangeTrendViewController.h"
//#import "AAChartKit.h"
@interface ChangeTrendViewController ()

@end

@implementation ChangeTrendViewController{
    //AAChartModel *chartModel;
    //AAChartView *chartView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
/*
-(void)configTheChartView:(NSString *)chartType{
    self.chartView = [[AAChartView alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.chartView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-220);
    self.chartView.contentHeight = self.view.frame.size.height-220;
    [self.view addSubview:self.chartView];
    self.chartModel= AAObject(AAChartModel)
    .chartTypeSet(chartType)
    .titleSet(@"编程语言热度")
    .subtitleSet(@"虚拟数据")
    .pointHollowSet(true)
    .categoriesSet(@[@"Java",@"Swift",@"Python",@"Ruby", @"PHP",@"Go",@"C",@"C#",@"C++",@"Perl",@"R",@"MATLAB",@"SQL",@"100"])
    .yAxisTitleSet(@"摄氏度")
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet(@"2017")
                 .dataSet(@[@45,@88,@49,@43,@65,@56,@47,@28,@49,@44,@89,@55]),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"2018")
                 .dataSet(@[@31,@22,@33,@54,@35,@36,@27,@38,@39,@54,@41,@29]),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"2019")
                 .dataSet(@[@11,@12,@13,@14,@15,@16,@17,@18,@19,@33,@56,@39]),
                 
                 AAObject(AASeriesElement)
                 .nameSet(@"2020")
                 .dataSet(@[@21,@22,@24,@27,@25,@26,@37,@28,@49,@56,@31,@11]),
                 ]
               )
    //    //标示线的设置
    //    .yPlotLinesSet(@[AAObject(AAPlotLinesElement)
    //                     .colorSet(@"#F05353")//颜色值(16进制)
    //                     .dashStyleSet(@"Dash")//样式：Dash,Dot,Solid等,默认Solid
    //                     .widthSet(@(1)) //标示线粗细
    //                     .valueSet(@(20)) //所在位置
    //                     .zIndexSet(@(1)) //层叠,标示线在图表中显示的层叠级别，值越大，显示越向前
    //                     .labelSet(@{@"text":@"标示线1",@"x":@(0),@"style":@{@"color":@"#33bdfd"}})//这里其实也可以像AAPlotLinesElement这样定义个对象来赋值（偷点懒直接用了字典，最会终转为js代码，可参考https://www.hcharts.cn/docs/basic-plotLines来写字典）
    //                     ,AAObject(AAPlotLinesElement)
    //                     .colorSet(@"#33BDFD")
    //                     .dashStyleSet(@"Dash")
    //                     .widthSet(@(1))
    //                     .valueSet(@(40))
    //                     .labelSet(@{@"text":@"标示线2",@"x":@(0),@"style":@{@"color":@"#33bdfd"}})
    //                     ,AAObject(AAPlotLinesElement)
    //                     .colorSet(@"#ADFF2F")
    //                     .dashStyleSet(@"Dash")
    //                     .widthSet(@(1))
    //                     .valueSet(@(60))
    //                     .labelSet(@{@"text":@"标示线3",@"x":@(0),@"style":@{@"color":@"#33bdfd"}})
    //                     ]
    //                   )
    //    //Y轴最大值
    //    .yMaxSet(@(100))
    //    //Y轴最小值
    //    .yMinSet(@(1))
    //    //是否允许Y轴坐标值小数
    //    .yAllowDecimalsSet(NO)
    //    //指定y轴坐标
    //    .yTickPositionsSet(@[@(0),@(25),@(50),@(75),@(100)])
    ;
    [self.chartView aa_drawChartWithChartModel:_chartModel];
}
*/
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

@end
