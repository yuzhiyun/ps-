//
//  RecordedParameterTableViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/7/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "RecordedParameterTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "Parameter.h"
#import "DataBaseNSUserDefaults.h"
#import "RecordTableViewController.h"
@interface RecordedParameterTableViewController ()

@end

@implementation RecordedParameterTableViewController{

    NSMutableArray *createDateKeyArray;
    NSMutableArray *parameterArray;
    UITableView *mUITableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    createDateKeyArray=[[NSMutableArray alloc]init];
    parameterArray=[[NSMutableArray alloc]init];
    
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mUITableView=tableView;
    return [createDateKeyArray count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *array=[parameterArray objectAtIndex:indexPath.row];
    RecordTableViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"RecordTableViewController"];
    nextPage->parameters=array;
    nextPage.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nextPage animated:YES];
    

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString  *createDate=[createDateKeyArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=createDate;
    
    return cell;
}





//获取参数
-(void) loadData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showTestRecord.html?psid=10
    NSString *urlString= [NSString stringWithFormat:@"%@/showTestRecord.html",myDelegate.ipString];
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
                [createDateKeyArray removeAllObjects];
                [parameterArray removeAllObjects];
                NSArray *array=[doc objectForKey:@"data"];
                for(NSDictionary *item in array){
                    [createDateKeyArray addObject:item[@"create_date"]];
                    
                    NSMutableArray *tem=[[NSMutableArray alloc]init];
                    NSArray *parameters=[item objectForKey:@"parametes"];
                    for(NSDictionary *parameter in parameters){
                        Parameter *model=[[Parameter alloc]init];
                        model.p_name=parameter[@"p_name"];
                        model.p_value=parameter[@"p_value"];
                        [tem addObject:model];
                    }
                    [parameterArray addObject:tem];
                }
                [mUITableView reloadData];
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
