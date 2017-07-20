//
//  DataBaseNSUserDefaults.h
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/12.
//  Copyright © 2017年 dlz. All rights reserved.
//

#import <Foundation/Foundation.h>
//如果不导入#import <UIKit/UIKit.h>，这里就报错，expected a type.
#import <UIKit/UIKit.h>

@interface  DataBaseNSUserDefaults:NSObject

+(void) setData:(id) object forkey:(NSString*) forkey;
+(id) getData:(NSString *) forkey;
+(void) removeData:(NSString *) forkey;
@end
