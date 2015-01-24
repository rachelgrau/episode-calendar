//
//  Episode.h
//  EpisodeCalendar
//
//  Created by Rachel on 24/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject

@property NSString *name; /* Name of the episode */
@property NSDate *airDate; /* Date the episode aired */
@property BOOL watched; /*  */
@property int season; /* Season number */
@property NSString *show; /* Name of the show this episode belongs to */
@property int number; /* Episode number */

+ (NSArray *)fetchAll;
@end
