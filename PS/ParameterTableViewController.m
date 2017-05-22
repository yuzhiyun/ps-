//
//  ParameterTableViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/1/29.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "ParameterTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "JsonUtil.h"
#import "Alert.h"
#import "Parameter.h"
#import "ParameterInImageViewController.h"
#import "DataBaseNSUserDefaults.h"
@interface ParameterTableViewController ()

@end

@implementation ParameterTableViewController{
    NSMutableArray *keyArray;
    NSMutableArray *valueArray;
    NSMutableArray *mAllDataFromServer;
    UITableView *mUITableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查看参数";
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.contentInset=UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    //自定义导航左右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"示意图" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
    
    [rightButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    keyArray=[[NSMutableArray alloc]init];
    mAllDataFromServer=[[NSMutableArray alloc]init];
    
    [keyArray addObject:@"驱动电机转速"];
    [keyArray addObject:@"驱动电机扭矩"];
    [keyArray addObject:@"驱动电机功率"];
    
    [keyArray addObject:@"负载1转速"];
    [keyArray addObject:@"负载1扭矩"];
    [keyArray addObject:@"负载1功率"];
    
    [keyArray addObject:@"负载2转速"];
    [keyArray addObject:@"负载2扭矩"];
    [keyArray addObject:@"负载2功率"];
    
    [keyArray addObject:@"档位"];
    [keyArray addObject:@"实际速比"];
    [keyArray addObject:@"理论速比"];
    
    
    [keyArray addObject:@"变速箱油温"];
    [keyArray addObject:@"升速箱油温"];
    [keyArray addObject:@"升速箱开度"];
    
    [keyArray addObject:@"T1"];
    [keyArray addObject:@"T2"];
    [keyArray addObject:@"T3"];
    [keyArray addObject:@"T4"];
    [keyArray addObject:@"T5"];
    [keyArray addObject:@"T6"];
    
    valueArray=[[NSMutableArray alloc]init];
    [valueArray addObject:@"0 rpm"];
    [valueArray addObject:@"0.0 N.m"];
    [valueArray addObject:@"0.00 kW"];
    
    [valueArray addObject:@"0 rpm"];
    [valueArray addObject:@"0.0 N.m"];
    [valueArray addObject:@"0.00 kW"];
    
    [valueArray addObject:@"0 rpm"];
    [valueArray addObject:@"0.0 N.m"];
    [valueArray addObject:@"0.00 kW"];
    
    [valueArray addObject:@"null"];
    [valueArray addObject:@"0.000"];
    [valueArray addObject:@"-1.000"];
    
    [valueArray addObject:@"14.5 ºC"];
    [valueArray addObject:@"12.6 ºC"];
    [valueArray addObject:@"100.0 %"];
    
    [valueArray addObject:@"13.50 ºC"];
    [valueArray addObject:@"13.34 ºC"];
    [valueArray addObject:@"13.42 ºC"];
    [valueArray addObject:@"13.51 ºC"];
    [valueArray addObject:@"11.57 ºC"];
    [valueArray addObject:@"13.42 ºC"];

    
    [self loadData];
    
}
/**
 *  重载右边导航按钮的事件
 *
 *  @param sender <#sender description#>
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    
    ParameterInImageViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"ParameterInImageViewController"];
    nextPage.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nextPage animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mUITableView=tableView;
    return [mAllDataFromServer count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    Parameter *model=[mAllDataFromServer objectAtIndex:indexPath.row];
    
    UILabel *mUILabelKey=[cell viewWithTag:0];
    mUILabelKey.text=model.p_name;
    UILabel *mUILabelValue=[cell viewWithTag:1];
    mUILabelValue.text=model.p_value;
    UILabel *mUILabelUnit=[cell viewWithTag:2];
    mUILabelUnit.text=model.p_unit;
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//获取参数
-(void) loadData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    //http://ps.leideng.org/index.php/User/App/showParameter.html?psid=1
    NSString *urlString= [NSString stringWithFormat:@"%@/showParameter.html",myDelegate.ipString];
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
                [mAllDataFromServer removeAllObjects];
                NSArray *array=[doc objectForKey:@"data"];
                for(NSDictionary *item in array){
                    Parameter *model=[[Parameter alloc]init];
                    model.p_name=item [@"p_name"];
                    model.p_value=item[@"p_value"];
                    model.p_unit=item[@"p_unit"];
                    [mAllDataFromServer addObject:model
                     ];
                }
                [mUITableView reloadData];
                
                //模拟1秒后（
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadData];
                });
                
                
                
                
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
