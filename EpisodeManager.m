//
//  EpisodeManager.m
//  EpisodeCalendar
//
//  Created by Rachel on 2/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeManager.h"
#import "Episode.h"
#import "EpisodeDateUtility.h"

@implementation EpisodeManager

static NSString *const urlString = @"https://s3.amazonaws.com/lab.nearpod.com/rachel/episodecalendar-data.json";


+ (NSData *)getJsonForUrlString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:req returningResponse:0 error:nil];
    return jsonData;
}

/* Given a dictionary that represents an Episode object, returns an Episode object with its fields filled out based on what was in the dictionary*/
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
 * Returns an array of all episodes (Episode objects) fetched from urlString, or nil on error
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

+ (void)insertSorted:(NSMutableArray *)arr withDateString:(NSString *)dateString
{
    NSDate *toInsert = [EpisodeDateUtility dateFromString:dateString];
    int i = 0;
    for (NSString *curr in arr) {
        NSDate *currDate = [EpisodeDateUtility dateFromString:curr];
        if ([currDate isEqualToDate:toInsert]) return;
        if ([[currDate laterDate:toInsert] isEqualToDate:toInsert]) {
            [arr insertObject:dateString atIndex:i];
            return;
        }
        i++;
    }
}

/*
 * Returns a DICTIONARY where keys = date string values = array of eps with that date, or nil on error
 * Sets the array of dates
 */
+ (NSDictionary *)fetchAllByDate:(NSMutableArray *)resultDates
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    /* Fetch JSON data */
    NSData *jsonData = [EpisodeManager getJsonForUrlString:urlString];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            /* Create episode object, fill out properties, and add it to array */
            Episode *ep = [EpisodeManager getEpisodeFromDictionary:episodeDictionary];
            if (![resultDates containsObject:ep.airDate]) {
                [resultDates addObject:ep.airDate];
            }
            
            NSMutableArray *epsWithThisDate = [ret objectForKey:ep.airDate];
            if (epsWithThisDate == nil) {
                epsWithThisDate = [[NSMutableArray alloc] init];
                [epsWithThisDate addObject:ep];
            } else {
                [epsWithThisDate addObject:ep];
            }
            [ret setObject:epsWithThisDate forKey:ep.airDate];
        }
        [resultDates sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             return [obj2 compare:obj1];
         }];
        return ret;
    }
    return nil;
}


+ (NSDictionary *) fetchAllBetween:(NSDate *)date1 and:(NSDate *)date2
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    NSData *jsonData = [EpisodeManager getJsonForUrlString:urlString];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            Episode *ep = [EpisodeManager getEpisodeFromDictionary:episodeDictionary];
            
            /* Check if current episode is between the given dates. If so, add it to our dictionary. */
            NSDate *airDate = ep.airDate;
            if ([EpisodeDateUtility isDate:airDate betweenDate:date1 andDate:date2]) {
                NSMutableArray *epsWithThisDate = [ret objectForKey:ep.airDate];
                if (epsWithThisDate == nil) {
                    epsWithThisDate = [[NSMutableArray alloc] init];
                    [epsWithThisDate addObject:ep];
                } else {
                    [epsWithThisDate addObject:ep];
                }
                
                [ret setObject:epsWithThisDate forKey:ep.airDate];
            }
        }
        return ret;
    }
    return nil;
}

+ (NSArray *)fetchEpisodesFromShow:(NSString *)show season:(int) season
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSData *jsonData = [EpisodeManager getJsonForUrlString:urlString];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            Episode *ep = [EpisodeManager getEpisodeFromDictionary:episodeDictionary];
            
            /* Check if current episode is from |season| of |show| */
            if ((ep.season == season) && ([ep.show isEqualToString:show])) {
                [ret addObject:ep];
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
    return nil;

}

@end
