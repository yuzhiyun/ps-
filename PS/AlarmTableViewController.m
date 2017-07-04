//
//  AlarmTableViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/7/2.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "AlarmTableViewController.h"
#import "Parameter.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "DataBaseNSUserDefaults.h"
@interface AlarmTableViewController ()

@end

@implementation AlarmTableViewController{

    //用于刷新tableView
    UITableView *mTableView;
    NSMutableArray *allDataFromServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    allDataFromServer=[[NSMutableArray alloc]init];
    
    [self loadData];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mTableView=tableView;
    return [allDataFromServer count];
}

//Parameter *model in myDelegate.allParamatersArray



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    Parameter *model=[allDataFromServer objectAtIndex:indexPath.row];
    
    
    UILabel *mUILabelKey=  [cell viewWithTag:1];
    UILabel *mUILabelValue=[cell viewWithTag:2];
    UILabel *mUILabelDate= [cell viewWithTag:3];
    UILabel *mUILabelReadState= [cell viewWithTag:4];
    
    mUILabelKey.text=model.p_name;
    mUILabelValue.text=model.p_value;
    mUILabelDate.text=model.create_date;
    if([@"0" isEqualToString:model.de_state]){
        mUILabelReadState.text=@"未确认";
        mUILabelReadState.textColor=[UIColor colorWithRed:235/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }else{
        mUILabelReadState.text=@"已确认";
        mUILabelReadState.textColor=[UIColor colorWithRed:0/255.0 green:235/255.0 blue:0/255.0 alpha:1];
    }
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Parameter *model=[allDataFromServer objectAtIndex:indexPath.row];
    [self asureAlarm:model.p_name position:indexPath.row];
   // [self asureAlarm:model.p_name,indexPath.row];
    
    
}


//确认报警信息
-(void) asureAlarm:(NSString *) pname position:(NSInteger *)position{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/checkDeviveAlarm.html?psid=10&pname=油温&destate=1
    
    NSString *urlString= [NSString stringWithFormat:@"%@/checkDeviveAlarm.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    // 请求参数
    NSDictionary *parameters = @{ @"psid": [DataBaseNSUserDefaults getData:@"selectedPS"],
                                  @"destate":@"1",
                                  @"pname":pname
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
                Parameter *model=[allDataFromServer objectAtIndex:position];
                model.de_state=@"1";
                [Alert showMessageAlert:@"您已确认该报警信息" view:self];
                [mTableView reloadData];
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



//获取参数
-(void) loadData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showDeviceAlarm.html?psid=10
    
    NSString *urlString= [NSString stringWithFormat:@"%@/showDeviceAlarm.html",myDelegate.ipString];
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
                [allDataFromServer removeAllObjects];
                NSArray *array=[doc objectForKey:@"data"];
                for(NSDictionary *item in array){
                    Parameter *model=[[Parameter alloc]init];
                    //model.p_id=item[@"p_id"];
                    model.p_name=item [@"p_name"];
                    model.p_value=item[@"p_value"];
                    model.de_state=item[@"de_state"];
                    model.create_date=item[@"create_date"];
                    [allDataFromServer addObject:model];
                }
                [mTableView reloadData];
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
