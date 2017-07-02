//
//  SelectParametersTableViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/7/2.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "SelectParametersTableViewController.h"
#import "AppDelegate.h"
#import "Parameter.h"
#import "Alert.h"
#import "ChangeTrendViewController.h"
@interface SelectParametersTableViewController ()

@end

@implementation SelectParametersTableViewController{
    AppDelegate *myDelegate;
    NSMutableArray *allDataFromServer;
    //被勾选的用户
    NSMutableArray *indexOfSelectedUser;
    //用于刷新tableView
    UITableView *mTableView;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"选择参数"];
    myDelegate = [[UIApplication sharedApplication]delegate];
    
    [self.navigationController.navigationBar setBarTintColor:myDelegate.navigationBarColor];
    //      navigationBar标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    //    返回箭头和文字的颜色，只要写一次就行了，是全局的
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //    修改下一个界面返回按钮的title，注意这行代码每个页面都要写一遍，不是全局的
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    allDataFromServer=[[NSMutableArray alloc]init];
    allDataFromServer=myDelegate.allParamatersArray;
    
    indexOfSelectedUser=[[NSMutableArray alloc]init];
    //初始化勾选记录的数组,用yes或者 no来判断参数是不是被勾选
    for(NSInteger i=0;i<[allDataFromServer count];i++){
        [indexOfSelectedUser addObject:@"no"];
    }
    //自定义导航左右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed:)];
    
    [rightButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=rightButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  重载右边导航按钮的事件
 *
 *  @param sender <#sender description#>
 */
-(void)rightBarButtonItemPressed:(id)sender
{
    NSMutableArray *dataSelectedParameters=[[NSMutableArray alloc]init];
    
    for(NSInteger i=0;i<[allDataFromServer count];i++)
        if([@"yes" isEqualToString: [indexOfSelectedUser objectAtIndex:i]])
            [ dataSelectedParameters addObject:[allDataFromServer objectAtIndex:i]];
    
    if([dataSelectedParameters count]==0){
        [Alert showMessageAlert:@"请选择至少一个参数" view:self];
    }else if ([dataSelectedParameters count]<=4){
    
        ChangeTrendViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeTrendViewController"];
        nextPage.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:nextPage animated:YES];
    }else{
        [Alert showMessageAlert:@"参数个数必须不多于4个" view:self];
    }
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
    
    
    UILabel *mUILabelTitle=[cell viewWithTag:1];
    UIImageView *mUIImageView=[cell viewWithTag:2];
    
    NSString *index=[indexOfSelectedUser objectAtIndex:indexPath.row];
    
    if(![ index isEqualToString:@"no"]){
        
        mUIImageView.image=[UIImage imageNamed:@"selected2.png"];
    }
    else
        mUIImageView.image=[UIImage imageNamed:@"un_selected.png"];
    
    
    //image.image=[UIImage imageNamed:@"notice1.png"];
    mUILabelTitle.text = model.p_name;
    //image.image=[UIImage imageNamed:@""];
    return cell;
}

//把checkbox的图标改成被选中的
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[indexOfSelectedUser objectAtIndex:indexPath.row]isEqualToString:@"no"]){
        
        [indexOfSelectedUser insertObject:@"yes" atIndex:indexPath.row];
        [indexOfSelectedUser removeObjectAtIndex: indexPath.row+1];
    }
    else
    {
        [indexOfSelectedUser insertObject:@"no" atIndex:indexPath.row];
        [indexOfSelectedUser removeObjectAtIndex: indexPath.row+1];
    }
    [mTableView reloadData];
    //    NSLog(@"点击事件");
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

@end
