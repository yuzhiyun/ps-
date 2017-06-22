//
//  TendencyChartViewController.h
//  PS
//
//  Created by 秦启飞 on 2017/2/8.
//  Copyright © 2017年 yuzhiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TendencyChartViewController : UIViewController{
//参数1的id
@public
    NSString *p_id1;
//参数2的id
@public
    NSString *p_id2;
}
@property (weak, nonatomic) IBOutlet UILabel *mUILabelP1Key;
@property (weak, nonatomic) IBOutlet UILabel *mUILabelP1Value;

@property (weak, nonatomic) IBOutlet UILabel *mUILabelP2Key;

@property (weak, nonatomic) IBOutlet UILabel *mUILabelP2Value;

@end
