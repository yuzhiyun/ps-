//
//  ChoosePsParameterViewController.m
//  PS
//
//  Created by 秦启飞 on 2017/6/22.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import "ChoosePsParameterViewController.h"
#import "TendencyChartViewController.h"
#import "AppDelegate.h"
#import "Parameter.h"
#import "Alert.h"
@interface ChoosePsParameterViewController ()

@end

@implementation ChoosePsParameterViewController{
    UIActionSheet *actionSheet;
    NSString *flag;
    AppDelegate *myDelegate;
    NSString *p_id1;
    NSString *p_id2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    p_id1=@"";
    p_id2=@"";
    myDelegate = [[UIApplication sharedApplication]delegate];
    //弹出列表
    actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择台驾"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIBarStyleDefault;

       // NSLog(@"%i", a);
    // Do any additional setup after loading the view.
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
#pragma mark 更换参数1
- (IBAction)changeParameter1:(id)sender {
    
    flag=@"1";

    for(Parameter *model in myDelegate.allParamatersArray){
        [actionSheet addButtonWithTitle:model.p_name];
    }
    [actionSheet showInView:self.view];
}
#pragma mark UIActionSheet对话框选择监听事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if(buttonIndex!=0){
        NSLog(@"%i", buttonIndex-1);
        Parameter *model=[myDelegate.allParamatersArray objectAtIndex:buttonIndex-1];
        if([@"1" isEqualToString:flag]){
            self.mUILabelParameter1.text=model.p_name;
            p_id1=model.p_id;
        }
        else{
            self.mUILabelParameter2.text=model.p_name;
            p_id2=model.p_id;
        }
    }
}

#pragma mark 更换参数2
- (IBAction)changeParameter2:(id)sender {
    flag=@"2";
    
    for(Parameter *model in myDelegate.allParamatersArray){
        [actionSheet addButtonWithTitle:model.p_name];
    }
    [actionSheet showInView:self.view];
    

}

#pragma mark 确认参数
- (IBAction)ok:(id)sender {
    if([@"" isEqualToString:p_id1]||[@"" isEqualToString:p_id2]){
        [Alert showMessageAlert:@"请选好两个参数" view:self];
    }
    else{
        TendencyChartViewController *nextPage= [self.storyboard instantiateViewControllerWithIdentifier:@"TendencyChartViewController"];
        nextPage->p_id1=p_id1;
        nextPage->p_id2=p_id2;
        [self presentViewController:nextPage animated:YES completion:^{
            NSLog(@"第二个页面跳转成功！");
        }];

    }
}

@end
