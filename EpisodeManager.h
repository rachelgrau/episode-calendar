/**
 * File: EpisodeManager.h
 * -------------------------
 * Manager class that has some class methods to fetch episodes.
 */

#import <Foundation/Foundation.h>

@interface EpisodeManager : NSObject

/**
 * Method: fetchAll
 * Usage:[EpisodeManager fetchAll]
 * --------------------------------
 * Returns an NSArray of all episodes in no particular order.
 * Returns nil on error.
 */
+ (NSArray *)fetchAll;

/**
 * Method: fetchAllByDate
 * Usage:[EpisodeManager fetchAllByDate:resultDates]
 * -------------------------------------------------
 * Returns an NSDictionary where the keys are NSDates and the values are
 * an array of Episodes that occur on that date. Also, sets the array 
 * passed in as |resultDates| to contain a list of all the keys in the 
 * returned dictionary (so, a list of dates) in sorted order (latest
 * date to earliest date).
 * Returns nil on error.
 */
+ (NSDictionary *) fetchAllByDate:(NSMutableArray *)resultDates;

/**
 * Method: fetchAllBetween date1 and date2
 * Usage:[EpisodeManager fetchAllBetween:date1 and:date2]
 * ------------------------------------------------------
 * Returns an NSDictionary where the keys are NSDates and the values are
 * an array of Episodes that occur on that date. Only includes dates 
 * that are later/equal to |date1| AND earlier/equal to |date2|.
 * Returns nil on error.
 */
+ (NSDictionary *) fetchAllBetween:(NSDate *)date1 and:(NSDate *)date2;

/**
 * Method: fetchEpisodesFromShow show season
 * Usage:[EpisodeManager fetchEpisodesFromShow:@"show name" season:1]
 * -------------------------------------------------------------------
 * Returns an NSArray of Episodes from the show |show| and the season 
 * |season|. 
 * Returns nil on error.
 */
+ (NSArray *)fetchEpisodesFromShow:(NSString *)show season:(int) season;

@end
