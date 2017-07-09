//
//  TemperatureControlViewController.m
//  PS
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
    [self getCurrentTemperature];
    [self getCurrentParameter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)setTemperature:(id)sender {
    
    if(0==self.mUITextFieldTemperature.text.length)
        [Alert showMessageAlert:@"温度不能为空" view:self];
    else
        [self setTemperature];
}
- (IBAction)setSP:(id)sender {
    if(0==self.mUITextFieldSP.text.length)
        [Alert showMessageAlert:@"SP不能为空" view:self];
    else
        [self setSP];
}



-(void) setSP{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *urlString= [NSString stringWithFormat:@"%@/submitGearboxoil.html",myDelegate.ipString];

    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    //pvalue=44&psid=10&pname=升速箱油温SP
    NSDictionary *parameters = @{
                                 @"psid":  [DataBaseNSUserDefaults getData:@"selectedPS"],
                                 @"tename":@"设定SP",
                                 @"tevalue":self.mUITextFieldSP.text,
                                 @"username":[DataBaseNSUserDefaults getData:@"username"]
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
                self.mUILabelSP.text=self.mUITextFieldSP.text;
                [Alert showMessageAlert:@"设置SP成功" view:self];
                
            }
            else{
                // [Alert showMessageAlert:[doc objectForKey:@"msg"] view:self];
                [Alert showMessageAlert:@" 设置失败"view:self];
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




//设置油温
-(void) setTemperature{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showGearBoxOil.html?psid=10
    NSString *urlString= [NSString stringWithFormat:@"%@/submitGearboxoil.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    NSDictionary *parameters = @{
                                 @"psid":  [DataBaseNSUserDefaults getData:@"selectedPS"],
                                 @"tename":@"设置温度",
                                 @"tevalue":self.mUITextFieldTemperature.text,
                                 @"username":[DataBaseNSUserDefaults getData:@"username"]
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
                self.mUILabelDestinationTemp.text=self.mUITextFieldTemperature.text;
                [Alert showMessageAlert:@"设置变速箱油温成功" view:self];
                
            }
            else{
               // [Alert showMessageAlert:[doc objectForKey:@"msg"] view:self];
                [Alert showMessageAlert:@" 设置失败"view:self];
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


//获取当前油温
-(void) getCurrentTemperature{
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
                
                NSDictionary *data=[doc objectForKey:@"data"];
                self.mUILabelCurrentTemperature.text=data[@"nowtemp"];
                self.mUILabelDestinationTemp.text=data[@"settemp"];
                
                //nowtemp":"55","settemp":"100
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


//获取当前pv sp 开度
-(void) getCurrentParameter{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlString= [NSString stringWithFormat:@"%@/showLiftBoxOil.html",myDelegate.ipString];
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
                NSDictionary *dic=[doc objectForKey:@"data"];
                self.mUILabelPV.text=dic[@"YW"];
                self.mUILabelSP.text=dic[@"SP"];
                self.mUILabelKaidu.text=dic[@"KD"];
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
