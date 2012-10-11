//
//  Datetime+FormattedString.h
//  ezdesk
//
//  Created by 杨裕欣 on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(DateFormattedStrUtil)
- (NSString*) toFullDate;
- (NSString*) toFullDateTime;
- (NSString*) toFullTime;
- (NSString*) toShortDate;
- (NSString*) toShortDateTime;
- (NSString*) toShortTime;
- (NSString*) toNiceTime;

@end
