//
//  ChangeTrendViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/6/24.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "ChangeTrendViewController.h"
#import "AAChartKit.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "Parameter.h"
#import "DataBaseNSUserDefaults.h"

@interface ChangeTrendViewController ()
@property(nonatomic,strong)AAChartModel *chartModel;
@property(nonatomic,strong)AAChartView *chartView;
@end
@implementation ChangeTrendViewController{
    NSMutableArray *mutableKeysArray;
    
    NSMutableArray *mutableArray1;
    NSMutableArray *mutableArray2;
    NSMutableArray *mutableArray3;
    NSMutableArray *mutableArray4;
    //横坐标
    NSMutableArray  *mutableXAsixArray;
    //标志图表视图是否已经添加到self
    Boolean flag;
    //横坐标数量
    int count;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    flag=false;
    // Do any additional setup after loading the view.
    mutableKeysArray=[[NSMutableArray alloc]init];
    
    mutableArray1=[[NSMutableArray alloc]init];
    mutableArray2=[[NSMutableArray alloc]init];
    mutableArray3=[[NSMutableArray alloc]init];
    mutableArray4=[[NSMutableArray alloc]init];
    
    mutableXAsixArray=[[NSMutableArray alloc]init];
    count=50;
    //横坐标固定为0-100
    for(int i=1;i<count+1;i++){
        [mutableXAsixArray addObject:[NSNumber numberWithInt:i]];
    }
    [self loadData];
    //[self configTheChartView];
}
-(void)configTheChartView{
    
    if(!flag){
        self.chartView = [[AAChartView alloc]init];
        self.view.backgroundColor = [UIColor whiteColor];
        self.chartView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-220);
        self.chartView.contentHeight = self.view.frame.size.height-220;
        [self.view addSubview:self.chartView];
    }
    NSArray *array1 = [NSArray arrayWithArray:mutableArray1]; // mutableArray为NSMutableArray类型
    NSArray *array2 = [NSArray arrayWithArray:mutableArray2]; // mutableArray为NSMutableArray类型
    NSArray *array3 = [NSArray arrayWithArray:mutableArray3]; // mutableArray为NSMutableArray类型
    NSArray *array4 = [NSArray arrayWithArray:mutableArray4]; // mutableArray为NSMutableArray类型
    
    NSArray *xAsixArray = [NSArray arrayWithArray:mutableXAsixArray]; // mutableArray为NSMutableArray类型
    /*
     typedef NS_ENUM(NSInteger,AAChartAnimationType){
     AAChartAnimationTypeLinear =0,
     AAChartAnimationTypeSwing,
     AAChartAnimationTypeEaseInQuad,
     AAChartAnimationTypeEaseOutQuad,
     AAChartAnimationTypeEaseInOutQuad,
     AAChartAnimationTypeEaseInCubic,
     AAChartAnimationTypeEaseOutCubic,
     AAChartAnimationTypeEaseInOutCubic,
     AAChartAnimationTypeEaseInQuart,
     AAChartAnimationTypeEaseOutQuart,
     AAChartAnimationTypeEaseInOutQuart,
     AAChartAnimationTypeEaseInQuint,
     AAChartAnimationTypeEaseOutQuint,
     AAChartAnimationTypeEaseInOutQuint,
     AAChartAnimationTypeEaseInExpo,
     AAChartAnimationTypeEaseOutExpo,
     AAChartAnimationTypeEaseInOutExpo,
     AAChartAnimationTypeEaseInSine,
     AAChartAnimationTypeEaseOutSine,
     AAChartAnimationTypeEaseInOutSine,
     AAChartAnimationTypeEaseInCirc,
     AAChartAnimationTypeEaseOutCirc,
     AAChartAnimationTypeEaseInOutCirc,
     AAChartAnimationTypeEaseInElastic,
     AAChartAnimationTypeEaseOutElastic,
     AAChartAnimationTypeEaseInOutElastic,
     AAChartAnimationTypeEaseInBack,
     AAChartAnimationTypeEaseOutBack,
     AAChartAnimationTypeEaseInOutBack,
     AAChartAnimationTypeEaseInBounce,
     AAChartAnimationTypeEaseOutBounce,
     AAChartAnimationTypeEaseInOutBounce,
     };
     

     */
    self.chartModel= AAObject(AAChartModel)
    .chartTypeSet(@"line")
    .animationTypeSet(AAChartAnimationTypeEaseOutBounce)
    .titleSet(@"台驾参数变化趋势")
    .subtitleSet(@"")
    .pointHollowSet(true)
    .categoriesSet(xAsixArray)
    .yAxisTitleSet(@"摄氏度")
    .markerRadiusSet(@1)
    .seriesSet(@[
                 AAObject(AASeriesElement)
                 .nameSet([mutableKeysArray objectAtIndex:0])
                 .dataSet(array1),
                 
                 AAObject(AASeriesElement)
                 .nameSet([mutableKeysArray objectAtIndex:1])
                 .dataSet(array2),
                 
                 AAObject(AASeriesElement)
                 .nameSet([mutableKeysArray objectAtIndex:2])
                 .dataSet(array3),
                 
                 AAObject(AASeriesElement)
                 .nameSet([mutableKeysArray objectAtIndex:3])
                 .dataSet(array4),
                 ]
               );
    if(!flag){
        [self.chartView aa_drawChartWithChartModel:_chartModel];
        flag=true;
    }
    else
        [self.chartView aa_refreshChartWithChartModel:_chartModel];
}

//获取参数
-(void) loadData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showParameter.html?psid=10
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
        NSLog(result);
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=[[NSError alloc]init];
        NSDictionary *doc= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(doc!=nil){
            NSLog(@"*****doc不为空***********");
            //判断code 是不是0
            if([@"0" isEqualToString:[doc objectForKey:@"code"]])
            {
            
                //[mAllDataFromServer removeAllObjects];
                NSArray *array=[doc objectForKey:@"data"];
                /*
                for(NSDictionary *item in array){
                    Parameter *model=[[Parameter alloc]init];
                    model.p_id=item[@"p_id"];
                    model.p_name=item [@"p_name"];
                    model.p_value=item[@"p_value"];
                    model.p_unit=item[@"p_unit"];
                    //[mAllDataFromServer addObject:model
                     ];
                }
                */
                for(int i=0;i<4;i++){
                    NSDictionary *item =[array objectAtIndex:i];
                    [mutableKeysArray addObject:item[@"p_name"]];
                }
                //NSNumber *intNumber = [NSNumber numberWithInteger:[a integerValue]];
                //NSNumber *intNumber = [NSNumber numberWithInteger:[a integerValue]];
                if([mutableArray1 count]>=count){
                    [mutableArray1 removeAllObjects];
                    [mutableArray2 removeAllObjects];
                    [mutableArray3 removeAllObjects];
                    [mutableArray4 removeAllObjects];
                    
                }
                    
                [mutableArray1 addObject:[NSNumber numberWithInteger:[[array objectAtIndex:0][@"p_value"] integerValue]]];
                [mutableArray2 addObject:[NSNumber numberWithInteger:[[array objectAtIndex:1][@"p_value"]integerValue]]];
                [mutableArray3 addObject:[NSNumber numberWithInteger:[[array objectAtIndex:2][@"p_value"]integerValue]]];
                [mutableArray4 addObject:[NSNumber numberWithInteger:[[array objectAtIndex:3][@"p_value"]integerValue]]];
                
                
                //}
                [self configTheChartView];
                //模拟1秒后（
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadData];
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
