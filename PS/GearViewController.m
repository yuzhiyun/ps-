//
//  GearViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/5/9.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "GearViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "DataBaseNSUserDefaults.h"
@interface GearViewController ()

@end

@implementation GearViewController{
     UITableView *mTableView;
    NSMutableArray *allDataFromServer;
    //用于判断是否可以复位
    Boolean isWrong;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    allDataFromServer=[[NSMutableArray alloc]init];
    [allDataFromServer addObject:@"R档"];
    [allDataFromServer addObject:@"N档"];
    [allDataFromServer addObject:@"1档"];
    [allDataFromServer addObject:@"2档"];
    [allDataFromServer addObject:@"3档"];
    [allDataFromServer addObject:@"4档"];
    [allDataFromServer addObject:@"5档"];
    [allDataFromServer addObject:@"6档"];

    isWrong=false;
    [self getCurrentGear];
    [self getCurrentIndicatorLight];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//故障复位
- (IBAction)errorRecover:(id)sender {
    if(isWrong)
        [self httpErrorRecover];
    else
        [Alert showMessageAlert:@"当前无故障，无需复位" view:self];
}

#pragma mark - Table view data source
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    mTableView=tableView;
    return [allDataFromServer count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text=[allDataFromServer objectAtIndex:indexPath.row];

    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"确定选择该档位？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确认"
                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                   [self setGear:[allDataFromServer objectAtIndex:indexPath.row]] ;
                                                   
                                                   
                                                   
                                               }];
    
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消"
                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    //        信息框添加按键
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    

    
                         
    
}

//设置档位
-(void) setGear:(NSString *)command{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //App/submitGear.html?gearname=1档&username=ycx&psid=2&gearstate=1

    NSString *urlString= [NSString stringWithFormat:@"%@/submitGear.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    // 请求参数
    NSDictionary *parameters = @{
                                 @"username":[DataBaseNSUserDefaults getData:@"username"],
                                 @"gearname":command,
                                 @"psid":[DataBaseNSUserDefaults getData:@"selectedPS"],
                                 @"gearstate":@"1"
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
                
                if([@"1" isEqualToString:[[doc objectForKey:@"data"]objectForKey:@"tag" ]])
                {
                    
                    [Alert showMessageAlert:@"更换档位成功" view:self];
                    self.mUILabelCurrentGear.text=[NSString stringWithFormat:@"当前档位：  %@",command];
                }
                else
                    [Alert showMessageAlert:@"更换档位失败" view:self];
                
                
                
                
                
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


//获取当前档位
-(void) getCurrentGear{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showGear.html?psid=2
    NSString *urlString= [NSString stringWithFormat:@"%@/showGear.html",myDelegate.ipString];
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
                    NSLog(item[@"gear_name"]);
                    self.mUILabelCurrentGear.text=[NSString stringWithFormat:@"当前档位：  %@",item[@"gear_name"] ];
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



//获取当前故障指示灯状态，选择还是未选择
-(void) getCurrentIndicatorLight{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showFault.html?psid=1
    NSString *urlString= [NSString stringWithFormat:@"%@/showFault.html",myDelegate.ipString];
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
                    NSLog(item[@"fault_state"]);
                    if([@"1" isEqualToString:item[@"fault_state"]]){
                        self.mUIImageViewLight.image=[UIImage imageNamed:@"selected2.png"];
                        isWrong=true;
                    }
                    else{
                        self.mUIImageViewLight.image=[UIImage imageNamed:@"un_selected.png"];
                        isWrong=false;
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


//故障复位
-(void) httpErrorRecover{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showGear.html?psid=2
    NSString *urlString= [NSString stringWithFormat:@"%@/submitFault.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
   // faultname=FaultIndication&username=ycx&
    //faultstate=1&psid=1
    NSDictionary *parameters = @{
                                 @"psid":  [DataBaseNSUserDefaults getData:@"selectedPS"],
                                 @"faultname":@"FaultIndication",
                                 @"faultstate":@"0",
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
            
            self.mUIImageViewLight.image=[UIImage imageNamed:@"un_selected.png"];
              [Alert showMessageAlert:@"故障复位成功" view:self];
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
