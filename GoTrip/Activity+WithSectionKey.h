//
//  Activity+WithSectionKey.h
//  GoTrip
//
//  Created by Aldrich Huang on 06/10/2012.
//  Copyright (c) 2012 beacon. All rights reserved.
//

#import "Activity.h"

@interface Activity (WithSectionKey)
@property (nonatomic, strong, readonly) NSDate *sectionKey;
@end
