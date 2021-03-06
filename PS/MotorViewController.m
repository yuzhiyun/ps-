//
//  MotorViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/5/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "MotorViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "DataBaseNSUserDefaults.h"
@interface MotorViewController ()

@end

@implementation MotorViewController{
    //驱动控制模式 P1/P 还是 n1/P
    NSString *driverModel;
    Boolean *isReverse;
    int load;
    NSString *slopeTime;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    driverModel=@"P1/P";
    isReverse=false;
    load=0;
    //slopeTime=0;
    
    //P1/P单击事件
    self.mUIImageViewP1.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [ self.mUIImageViewP1 addGestureRecognizer:singleTap];
    //n1/P单击事件
    self.mUIImageViewN1.userInteractionEnabled = YES;//打开用户交互
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction2:)];
    [ self.mUIImageViewN1 addGestureRecognizer:singleTap2];

    //显示之前设置过的数据
    [self getData];

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
- (IBAction)ok:(id)sender {
    
    slopeTime=self.mUITextFieldSlopeTime.text;
    NSLog(driverModel);
    NSLog(slopeTime);
    NSLog(@"%d",load);
    //NSLog(@"%@", isReverse);
    
    if([slopeTime isEqualToString:@"0"] || load==0)
        [Alert showMessageAlert:@"斜坡时间或负载不能为0" view:self];
    else
        [self setData];
    
}

- (IBAction)mUISwitchReverseValueChanged:(id)sender {
    if(self.mUISwitchReverse.isOn)
        isReverse=true;
    else
        isReverse=false;
}

- (IBAction)mUISliderValueChanged:(id)sender {
    float value=self.mUISliderLoad.value;
    load=value;
    self.mUILabelLoadPercent.text=[NSString stringWithFormat:@"给定负载 %d %@", load,@"%"];
}

//设置驱动电机
-(void) setData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showParameter.html?psid=1
    NSString *urlString= [NSString stringWithFormat:@"%@/Submitdrive.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    /*
     ps_id：台架号
     user_name:用户名
     dr_name：驱动控制名称
     dr_value：驱动给定负载值
     dr_slopetime：驱动斜坡时间
     dr_reverse：反转
     */
    // 请求参数
    NSString *sReverse=@"0";
    if(isReverse)
        sReverse=@"1";
    NSDictionary *parameters = @{
                                 @"psid":[DataBaseNSUserDefaults getData:@"selectedPS"],
                                 @"drname":driverModel,
                                 @"drvalue":[NSString stringWithFormat:@"%d", load],
                                 @"drslopetime":slopeTime,
                                 @"drreverse":sReverse,
                                 @"username":@"admin"
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


//获取之前的驱动电机设置信息
-(void) getData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showParameter.html?psid=1
    NSString *urlString= [NSString stringWithFormat:@"%@/showDriveNumber.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    /*
     ps_id：台架号
     user_name:用户名
     dr_name：驱动控制名称
     dr_value：驱动给定负载值
     dr_slopetime：驱动斜坡时间
     dr_reverse：反转
     */
    // 请求参数
    NSString *sReverse=@"0";
    if(isReverse)
        sReverse=@"1";
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
                   NSLog(item[@"dr_name"]);
                   NSLog(item[@"dr_value"]);
                   NSLog(item[@"dr_slopetime"]);
                   NSLog(item[@"dr_reverse"]);
                   
                   if([@"P1/P" isEqualToString:item[@"dr_name"]]){
                       //self._mUIImageViewP1
                       self.mUIImageViewP1.image=[UIImage imageNamed:@"selected2.png"];
                       self.mUIImageViewN1.image=[UIImage imageNamed:@"un_selected.png"];
                       driverModel=@"P1/P";
                       
                   }else{
                       self.mUIImageViewP1.image=[UIImage imageNamed:@"un_selected.png"];
                       self.mUIImageViewN1.image=[UIImage imageNamed:@"selected2.png"];
                       driverModel=@"n1/P";
                   }
                   
                   self.mUITextFieldSlopeTime.text=item[@"dr_slopetime"];
                   slopeTime=item[@"dr_slopetime"];;
                   NSString *dr_value=item[@"dr_value"];
                   self.mUISliderLoad.value=[dr_value  floatValue];
                   load=[dr_value  floatValue];
                   self.mUILabelLoadPercent.text=[NSString stringWithFormat:@"给定负载 %@ %@",dr_value ,@"%"];
                   if([@"1" isEqualToString:item[@"dr_reverse"]]){
                       [self.mUISwitchReverse setOn:YES];
                       isReverse=YES;
                       

                   }
                   else{
                       [self.mUISwitchReverse setOn:FALSE];
                       isReverse=FALSE;
                   }
                   
                   
                   
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
