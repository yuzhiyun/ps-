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
    
    mUILabelKey.text=model.p_name;
    mUILabelValue.text=model.p_value;
    mUILabelDate.text=model.create_date;
    
    return cell;
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
