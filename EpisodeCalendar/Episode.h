/**
 * File: Episode.h
 * -------------------------
 * Model of an "Episode." An episode contains information about its name,
 * airDate, whether or not it has been watched, its season number, its 
 * show, and its number (episode number within season).
 */

#import <Foundation/Foundation.h>

@interface Episode : NSObject

@property NSString *name; /* Name of the episode */
@property NSDate *airDate; /* Date the episode aired */
@property BOOL watched; /*  */
@property int season; /* Season number */
@property NSString *show; /* Name of the show this episode belongs to */
@property int number; /* Episode number */

@end

