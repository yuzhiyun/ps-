//
//  GearViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/5/9.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "GearViewController.h"

@interface GearViewController ()

@end

@implementation GearViewController{
     UITableView *mTableView;
    NSMutableArray *allDataFromServer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    allDataFromServer=[[NSMutableArray alloc]init];
    [allDataFromServer addObject:@"换成1档"];
    [allDataFromServer addObject:@"换成2档"];
    [allDataFromServer addObject:@"换成3档"];
    [allDataFromServer addObject:@"换成4档"];
    [allDataFromServer addObject:@"换成5档"];
    [allDataFromServer addObject:@"换成6档"];
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





@end
