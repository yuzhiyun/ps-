//
//  RecordTableViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/7/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "RecordTableViewController.h"
#import "Parameter.h"
@interface RecordTableViewController ()

@end

@implementation RecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return [parameters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    Parameter *model=[parameters objectAtIndex:indexPath.row];
    
    UILabel *mUILabelPName=[cell viewWithTag:1];
    UILabel *mUILabelPValue=[cell viewWithTag:2];
    mUILabelPName.text=model.p_name;
    mUILabelPValue.text=model.p_value;

    return cell;

}

@end
