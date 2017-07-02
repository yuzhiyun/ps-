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
    

    NSMutableArray *allDataFromServer;
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
    NSLog(@"传递过来的dataSelectedLinkman的大小 %d",[dataSelectedParameters count]);
    flag=false;
    // Do any additional setup after loading the view.
    
    allDataFromServer=[[NSMutableArray alloc]init];
    //填充allDataFromServer
    for(int i=0;i<[dataSelectedParameters count];i++){
        NSMutableArray  *temp=[[NSMutableArray alloc]init];
        [allDataFromServer addObject:temp];
    }
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
        self.chartView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
        self.chartView.contentHeight = self.view.frame.size.height-150;
        [self.view addSubview:self.chartView];
    }
    NSArray *array1 = [NSArray arrayWithArray:mutableArray1]; // mutableArray为NSMutableArray类型
    NSArray *array2 = [NSArray arrayWithArray:mutableArray2]; // mutableArray为NSMutableArray类型
    NSArray *array3 = [NSArray arrayWithArray:mutableArray3]; // mutableArray为NSMutableArray类型
    NSArray *array4 = [NSArray arrayWithArray:mutableArray4]; // mutableArray为NSMutableArray类型
    
    NSArray *xAsixArray = [NSArray arrayWithArray:mutableXAsixArray]; // mutableArray为NSMutableArray类型
    

    //配置seriesSet
    NSMutableArray *mutableSeriesSet=[[NSMutableArray alloc]init];
    
    for(int i=0;i<[allDataFromServer count];i++){
        
        AASeriesElement *element=[[AASeriesElement alloc]init];
        element.name=[mutableKeysArray  objectAtIndex:i];
        element.data=[allDataFromServer objectAtIndex:i];
        
        [mutableSeriesSet addObject:element];
    }
    NSArray *seriesSet = [NSArray arrayWithArray:mutableSeriesSet];
    
    self.chartModel= AAObject(AAChartModel)
    .chartTypeSet(@"line")
    .animationTypeSet(AAChartAnimationTypeEaseOutBounce)
    .titleSet(@"台驾参数变化趋势")
    .subtitleSet(@"")
    .pointHollowSet(true)
    .categoriesSet(xAsixArray)
    .yAxisTitleSet(@" ")
    .markerRadiusSet(@1)
    .seriesSet(seriesSet);

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
                for(int i=0;i<[dataSelectedParameters count];i++){
                    Parameter *model = [dataSelectedParameters objectAtIndex:i];
                    for(NSDictionary *item in array){
                        if( [model.p_id isEqualToString: item[@"p_id"]]){
                            //记录需要的参数名称
                            [mutableKeysArray addObject:item[@"p_name"]];
                            //记录参数对应的数值
                            NSMutableArray *valueArray=[allDataFromServer objectAtIndex:i];
                            [valueArray addObject:[NSNumber numberWithInteger:[item[@"p_value"]integerValue]]];
                            
                            
                        }
                    }
                }
                //控制横坐标个数小于count
                NSMutableArray *valueArray=[allDataFromServer objectAtIndex:0];
                if([valueArray count]>=count){
                    for(int i=0;i<[allDataFromServer count];i++){
                        
                        NSMutableArray *valueArray=[allDataFromServer objectAtIndex:i];
                        [valueArray removeAllObjects];
                    }
                }

                [self configTheChartView];
                //模拟1秒后（
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
