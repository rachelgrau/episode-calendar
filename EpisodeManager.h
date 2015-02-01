//
//  EpisodeManager.h
//  EpisodeCalendar
//
//  Created by Rachel on 2/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EpisodeManager : NSObject
+ (NSArray *)fetchAll;
+ (NSDictionary *) fetchAllByDate:(NSMutableArray *)resultDates;
+ (NSDictionary *) fetchAllBetween:(NSDate *)date1 and:(NSDate *)date2;

@end
