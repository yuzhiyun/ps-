//
//  TemperatureControlViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/5/22.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "TemperatureControlViewController.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataBaseNSUserDefaults.h"
#import "JsonUtil.h"
#import "Alert.h"
@interface TemperatureControlViewController ()

@end

@implementation TemperatureControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获取当前档位
-(void) getCurrentGear{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showGearBoxOil.html?psid=10
    NSString *urlString= [NSString stringWithFormat:@"%@/showGearBoxOil.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    
    NSDictionary *parameters = @{
                                 @"psid":  [DataBaseNSUserDefaults getData:@"selectedPS"]
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
                
                
                // [Alert showMessageAlert:@"设置成功" view:self];
                
                NSArray *array=[doc objectForKey:@"data"];
                for(NSDictionary *item in array){
                    NSLog(item[@"p_value"]);
                    self.mUILabelCurrentTemperature.text=item[@"p_value"];
                }
                
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
    }];
    
    
}


@end
