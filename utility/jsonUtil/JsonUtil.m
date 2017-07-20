//
//  JsonUtil.m
//  RongCloudDemo
//
//  Created by 秦启飞 on 2017/1/12.
//  Copyright © 2017年 dlz. All rights reserved.
//
#import "JsonUtil.h"


@implementation JsonUtil

+(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
