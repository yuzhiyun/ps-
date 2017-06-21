//
//  TestViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/6/19.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "TestViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "Parameter.h"
#import "ParameterInImageViewController.h"
#import "DataBaseNSUserDefaults.h"
#import "TestViewController.h"
@interface TestViewController ()

@end

@implementation TestViewController{
    
   // NSMutableArray *mAllDataFromServer;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"请横屏查看，以免图像变形"];
    [self loadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

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
                //[mAllDataFromServer removeAllObjects];
                NSArray *array=[doc objectForKey:@"data"];
                for(NSDictionary *item in array){
                    Parameter *model=[[Parameter alloc]init];
                    model.p_name=item [@"p_name"];
                    model.p_value=item[@"p_value"];
                    model.p_unit=item[@"p_unit"];
                    if([model.p_name isEqualToString:@"负载1功率"]){
                        self.mUILablePower1.text=model.p_value;
                    }
                    
                    //把用到的字符串参数放到一个数组里
                    NSArray *keys = [NSArray arrayWithObjects:@"负载1功率",@"负载1扭矩",@"负载1转速",@"负载2功率",@"负载2扭矩",@"负载2转速",@"驱动电机功率",@"驱动电机扭矩",@"驱动电机转速",@"档位",@"升速箱开度",nil];
                    
                    //比如我们要把@"stormer"作为switch的参数，则取到它在数组中的下标，然后在switch中根据下标来进行处理。
                    int index = [keys  indexOfObject:model.p_name];
                    switch(index)
                    {
                        case 0:
                            self.mUILablePower1.text=model.p_value;
                            break;
                        case 1:
                            self.mUILabelTwist1.text=model.p_value;
                            break;
                        case 2:
                            self.mUILabelRotationRate1.text=model.p_value;
                            break;
                        case 3:
                            self.mUILablePower2.text=model.p_value;
                            break;
                        case 4:
                            self.mUILabelTwist2.text=model.p_value;
                            break;
                        case 5:
                            self.mUILabelRotationRate2.text=model.p_value;
                            break;
                            
                        case 6:
                            self.mUILabelDriverPower.text=model.p_value;
                            break;
                        case 7:
                            self.mUILabelDriverTwist.text=model.p_value;
                            break;
                        case 8:
                            self.mUILabelDriverRotationRate.text=model.p_value;
                            break;
                            
                        case 9:
                            self.mUILabelGear.text=model.p_value;
                            break;
                        case 10:
                            self.mUILabelkaidu.text=model.p_value;
                            break;

                            
                            
                            
                            
                            

                    }
                    //[mAllDataFromServer addObject:model
                    
                }
                //[mUITableView reloadData];
                
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

- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated: YES completion: nil];
}



@end
