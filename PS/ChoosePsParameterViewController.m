//
//  ChoosePsParameterViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/6/22.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "ChoosePsParameterViewController.h"
#import "TendencyChartViewController.h"
@interface ChoosePsParameterViewController ()

@end

@implementation ChoosePsParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)enter:(id)sender {
    TendencyChartViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"TendencyChartViewController"];
    [self presentViewController:nextPage animated:YES completion:^{
        NSLog(@"第二个页面跳转成功！");
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
