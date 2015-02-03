/**
 * File: EpisodeManager.h
 * -------------------------
 * This class manages retrieving Episode objects. The idea is that clients will
 * call [EpisodeManager fetchAll] once to retrieve an NSArray of all episodes, and
 * then pass this NSArray into other EpisodeManager methods that get you a more
 * specific list of episodes based on what you want (e.g. episodes from a certain
 * show/season, or episodes between certain dates).
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
 * Method: getAllByDate
 * Usage:[EpisodeManager getAllByDate:resultDates fromEpisodes:episodes]
 * ---------------------------------------------------------------------
 * Given an array |episodes| of all the episodes you want to search from 
 * (probably returned from fetchAll at some point), returns an NSDictionary 
 * where the keys are NSDates and the values are an array of Episodes that 
 * occur on that date. Also, sets the array passed in as |resultDates| 
 * to contain a list of all the keys in the returned dictionary (so, a 
 * list of dates) in sorted order (latest date to earliest date).
 */
+ (NSDictionary *)getAllByDate:(NSMutableArray *)resultDates fromEpisodes:(NSArray *)episodes;

/**
 * Method: getAllEpisodesBetween date1 and date2
 * Usage:[EpisodeManager getAllEpisodesBetween:date1 and:date2 from:episodes]
 * -------------------------------------------------------------------------
 * Given an array of all the episodes you want to search from (probably returned
 * from fetchAll at some point), returns an NSDictionary where the keys are 
 * NSDates and the values are an array of Episodes that occur on that date.
 * Only includes dates that are later/equal to |date1| AND earlier/equal to 
 * |date2|.
 * Returns nil on error.
 */
+ (NSDictionary *) getAllEpisodesBetween:(NSDate *)date1 and:(NSDate *)date2 from:(NSArray *)episodes;

/**
 * Method: getEpisodesFromShow show season
 * Usage:[EpisodeManager getEpisodesFromShow:@"show name" season:1 fromEpisodes:[EpisodeManager fetchAll]]
 * -------------------------------------------------------------------------------------------------------
 * Given an array |episodes| of all the episodes you want to search from (this array should be returned
 * from [EpisodeManager fetchAll], this method returns an NSArray of Episodes from the show |show| and the 
 * season |season|. 
 */
+ (NSArray *)getEpisodesFromShow:(NSString *)show season:(int)season fromEpisodes:(NSArray *)episodes;

@end
