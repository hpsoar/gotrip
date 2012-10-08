//
//  Datetime+FormattedString.m
//  ezdesk
//
//  Created by 杨裕欣 on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Datetime+FormattedString.h"

@implementation NSDate(DateFormattedStrUtil)


-(NSString*)toFullDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:self];
}


- (NSString*)toFullDateTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:self];    
}
- (NSString*)toFullTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    return [dateFormatter stringFromDate:self]; 
}
- (NSString*)toShortDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*)toShortDateTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*)toShortTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:self];
}


- (NSString*)toNiceTime
{
    NSDate* now = [[NSDate alloc]init];
    NSTimeInterval delta = [now timeIntervalSince1970] - [self timeIntervalSince1970];
    if (delta <= 60) {
        return@"刚刚";
    }else if (delta <= 60 * 60) {
        
        return [NSString stringWithFormat:@"%d 分钟前", div(delta, 60).quot];
        
    }else if (delta <= 60 * 60 * 24){
        
        return [NSString stringWithFormat:@"%d 小时前", div(delta, 60 * 60).quot];
        
    }else if (delta <= 60 * 60 * 24 * 3){
        
        return [NSString stringWithFormat:@"%d 天前", div(delta, 60 * 60 * 24).quot];
        
    }else {        
        return [self toShortDateTime];
        
    }
    
}

@end
