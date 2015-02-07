/**
 * File: EpisodeManager.m
 * -------------------------
 * Implementation of the EpisodeManager methods.
 */

#import "EpisodeManager.h"
#import "Episode.h"
#import "EpisodeDateUtility.h"

@implementation EpisodeManager

static NSString *const urlString = @"https://s3.amazonaws.com/lab.nearpod.com/rachel/episodecalendar-data.json";

/* 
 * Given a urlString, returns NSData.
 */
+ (NSData *)getJsonForUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:req returningResponse:0 error:nil];
    return jsonData;
}

/* 
 * Given a dictionary that represents an Episode object, returns an Episode object 
 * with its fields filled out based on what was in the dictionary
 */
+ (Episode *)getEpisodeFromDictionary:(NSDictionary *)dictionary {
    Episode *ep = [[Episode alloc] init];
    ep.name = [dictionary objectForKey:@"name"];
    ep.watched = [[dictionary objectForKey:@"watched"] boolValue];
    ep.season = [[dictionary objectForKey:@"season"] intValue];
    ep.show = [dictionary objectForKey:@"show"];
    ep.number = [[dictionary objectForKey:@"number"] intValue];
    ep.airDate = [EpisodeDateUtility dateFromString:[dictionary objectForKey:@"air_date"]];
    return ep;
}

/*
 * Returns an array of all episodes (Episode objects) fetched from urlString.
 * Returns nil on error
 */
+ (NSArray *)fetchAll
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    /* Fetch JSON data */
    NSData *jsonData = [EpisodeManager getJsonForUrlString:urlString];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            /* Create episode object, fill out properties, and add it to array */
            Episode *ep = [self getEpisodeFromDictionary:episodeDictionary];
            [ret addObject:ep];
        }
        return ret;
    }
    return nil;
}

/*
 * |episodes|: array that has all the episodes you want to search from
 * Returns a DICTIONARY where keys = dates and values = array of eps with that date, or nil on error.
 * Sets the array of dates to be all of the dates but in sorted order (latest date to earliest date).
 */
+ (NSDictionary *)getAllByDate:(NSMutableArray *)resultDates fromEpisodes:(NSArray *)episodes
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    for (Episode *episode in episodes) {
        /* Create episode object, fill out properties, and add it to array */
        if (![resultDates containsObject:episode.airDate]) {
            [resultDates addObject:episode.airDate];
        }
        NSMutableArray *epsWithThisDate = [ret objectForKey:episode.airDate];
        if (epsWithThisDate == nil) {
            epsWithThisDate = [[NSMutableArray alloc] init];
            [epsWithThisDate addObject:episode];
        } else {
            [epsWithThisDate addObject:episode];
        }
        [ret setObject:epsWithThisDate forKey:episode.airDate];
    }
    [resultDates sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj2 compare:obj1];
    }];
    return ret;
}

/* 
 * Gets all episodes in |episodes| that are between |date1| and |date2|. 
 * Returns them in a dictionary where keys = air dates and values = list 
 * of episodes with that date.
 */
+ (NSDictionary *) getAllEpisodesBetween:(NSDate *)date1 and:(NSDate *)date2 from:(NSArray *)episodes
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    for (Episode *episode in episodes)
    {
        /* Check if current episode is between the given dates. If so, add it to our dictionary. */
        NSDate *airDate = episode.airDate;
        if ([EpisodeDateUtility isDate:airDate betweenDate:date1 andDate:date2]) {
            NSMutableArray *epsWithThisDate = [ret objectForKey:episode.airDate];
            if (epsWithThisDate == nil) {
                epsWithThisDate = [[NSMutableArray alloc] init];
                [epsWithThisDate addObject:episode];
            } else{
                [epsWithThisDate addObject:episode];
            }
            [ret setObject:epsWithThisDate forKey:episode.airDate];
        }
    }
    return ret;
}

/* 
 * Given an array |episodes| of episodes you want to search from, return an array
 * of all the episodes that have the show named |show| and season |season|.
 * Returned array will be sorted by episode number.
 */
+ (NSArray *)getEpisodesFromShow:(NSString *)show season:(int)season fromEpisodes:(NSArray *)episodes
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (Episode *episode in episodes) {
        /* Check if current episode is from |season| of |show| */
        if ((episode.season == season) && ([episode.show isEqualToString:show])) {
            [ret addObject:episode];
        }
    }
    [ret sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         Episode *ep1 = (Episode *)obj1;
         Episode *ep2 = (Episode *)obj2;
         return (ep1.number > ep2.number);
     }];
    return ret;
}

@end
