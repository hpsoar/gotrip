//
//  Activity+WithSectionKey.m
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "Activity+WithSectionKey.h"

@implementation Activity (WithSectionKey)

- (NSDate *)sectionKey {
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:self.date];

    return [calendar dateFromComponents:components];
}


@end
