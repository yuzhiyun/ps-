//
//  LoadMotorViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/5/9.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//  负载电机
//

#import "LoadMotorViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"

@interface LoadMotorViewController ()

@end

@implementation LoadMotorViewController{
    //驱动控制模式 P1/P 还是 n1/P
    NSString *driverModel;
    
    NSString *slopeTime;
    
    Boolean *isReverse1;
    Boolean *isReverse2;
    
    int load1;
    int load2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    driverModel=@"P1/P";
    isReverse1=false;
    isReverse2=false;
    load1=0;
    load2=0;
    
    //P1/P单击事件
    self.mUIImageViewP1.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [ self.mUIImageViewP1 addGestureRecognizer:singleTap];
    //n1/P单击事件
    self.mUIImageViewN1.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction2:)];
    [ self.mUIImageViewN1 addGestureRecognizer:singleTap2];
    
}
//单选框P1/P
-(void)singleTapAction:(UIGestureRecognizer *) s{
    //NSLog(@"单击了头像");
    driverModel=@"P1/P";
    self.mUIImageViewP1.image=[UIImage imageNamed:@"selected2.png"];
    self.mUIImageViewN1.image=[UIImage imageNamed:@"un_selected.png"];
    //NSLog(driverModel);
}
//单选框n1/P
-(void)singleTapAction2:(UIGestureRecognizer *) s{
    //NSLog(@"单击了头像");
    driverModel=@"n1/P";
    self.mUIImageViewP1.image=[UIImage imageNamed:@"un_selected.png"];
    self.mUIImageViewN1.image=[UIImage imageNamed:@"selected2.png"];
    //NSLog(driverModel);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSlider1ValueChanged:(id)sender {
    float value=self.mUISlider1.value;
    load1=value;
    self.mUILabelLoad1Percent.text=[NSString stringWithFormat:@"给定负载 %d %@", load1,@"%"];

    
}
- (IBAction)onSwitch1ValueChanged:(id)sender {
    
    if(self.mUISwitch1.isOn)
        isReverse1=true;
    else
        isReverse1=false;
    
}
- (IBAction)onSlider2ValueChanged:(id)sender {
    float value=self.mUISlider2.value;
    load2=value;
    self.mUILabelLoad2Percent.text=[NSString stringWithFormat:@"给定负载 %d %@", load2,@"%"];
    
}
- (IBAction)onSwitch2ValueChanged:(id)sender {
    if(self.mUISwitch2.isOn)
        isReverse2=true;
    else
        isReverse2=false;
    
}

- (IBAction)ok:(id)sender {
    slopeTime=self.mUITextFieldSlopeTime.text;
    NSLog(driverModel);
    NSLog(slopeTime);
    NSLog(@"%d",load1);
    NSLog(@"%d",load2);
    //NSLog(@"%@", isReverse);
    
    if([slopeTime isEqualToString:@"0"]||load1==0 || load2==0)
        [Alert showMessageAlert:@"斜坡时间或负载不能为0" view:self];
    else
        [self setData];

    
}


//设置负载电机
-(void) setData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showParameter.html?psid=1
    NSString *urlString= [NSString stringWithFormat:@"%@/submitload.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    /*
     dr_id：驱动控制ID
     ps_id：台架号
     create_date：命令操作时间
     user_name:用户名
     dr_name：驱动控制名称
     dr_value：驱动给定负载值
     dr_slopetime：驱动斜坡时间
     dr_reverse：反转
     */
    // 请求参数
    NSString *sReverse1=@"0";
    NSString *sReverse2=@"0";
    if(isReverse1)
        sReverse1=@"1";
    if(isReverse2)
        sReverse2=@"1";
    NSDictionary *parameters = @{
                                 @"psid":@"10",
                                 @"dr_name":driverModel,

                                 @"lo_slopetime":slopeTime,
                                 @"lo1_reverse":sReverse1,
                                 @"lo2_reverse":sReverse2,
                                 @"lo1_value":[NSString stringWithFormat:@"%d", load1],
                                 @"lo2_value":[NSString stringWithFormat:@"%d", load2]
                                 
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
                [Alert showMessageAlert:@"设置成功" view:self];
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
