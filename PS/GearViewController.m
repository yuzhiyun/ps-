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
@interface GearViewController ()

@end

@implementation GearViewController{
     UITableView *mTableView;
    NSMutableArray *allDataFromServer;
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

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self submitCommand:[allDataFromServer objectAtIndex:indexPath.row]] ;
                         
    
}
//获取参数
-(void) submitCommand:(NSString *)command{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    ///ps.leideng.org/index.php/User/App/submitCMD.html?comname=Alarm&username=lei
    NSString *urlString= [NSString stringWithFormat:@"%@/submitCMD.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    
    // 请求参数
    NSDictionary *parameters = @{
                                 @"username":@"lei",
                                 @"comname":command,
                                 @"psid":@"10"
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
                    
                    [Alert showMessageAlert:@"执行命令成功" view:self];
                else
                    [Alert showMessageAlert:@"执行失败" view:self];
                
                
                
                
                
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
