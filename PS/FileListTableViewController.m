//
//  FileListTableViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/7/5.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "FileListTableViewController.h"
#import "File.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "DataBaseNSUserDefaults.h"
@interface FileListTableViewController ()

@end

@implementation FileListTableViewController{
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
    File *model=[allDataFromServer objectAtIndex:indexPath.row];
    
    
    UILabel *mUILabelFileName=  [cell viewWithTag:1];
    UILabel *mUILabelFileType=[cell viewWithTag:2];
    
    mUILabelFileName.text=model.docu_name;
    mUILabelFileType.text=model.docu_test;
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    File *model=[allDataFromServer objectAtIndex:indexPath.row];
    
    //[self asureAlarm:model.docu_name indexPath.row];
    
    [self selectFile:model.docu_name position:indexPath.row];
    
}


//选择文件
-(void) selectFile:(NSString *) docuname position:(NSInteger *)position{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/checkDeviveAlarm.html?psid=10&pname=油温&destate=1
    
    NSString *urlString= [NSString stringWithFormat:@"%@/selectDocument.html",myDelegate.ipString];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    // manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html", nil];
    // 请求参数
    NSDictionary *parameters = @{
    @"psid": [DataBaseNSUserDefaults getData:@"selectedPS"],
        @"docuname":docuname
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
                
               
                [Alert showMessageAlert:@"您已成功选择该文件" view:self];
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



//获取文件列表
-(void) loadData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showDocument.html?psid=10
    
    NSString *urlString= [NSString stringWithFormat:@"%@/showDocument.html",myDelegate.ipString];
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
                    File *model=[[File alloc]init];
                    //model.p_id=item[@"p_id"];
                    model.docu_name=item [@"docu_name"];
                    model.docu_test=item[@"docu_test"];
                   
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
