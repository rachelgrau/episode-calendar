//
//  Episode.m
//  EpisodeCalendar
//
//  Created by Rachel on 24/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "Episode.h"

@implementation Episode

static NSString *const urlString = @"https://s3.amazonaws.com/lab.nearpod.com/rachel/episodecalendar-data.json";

+ (NSDate *)dateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

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
    ep.airDate = [Episode dateFromString:[dictionary objectForKey:@"air_date"]];
    return ep;
}

/*
 * Returns an array of all episodes (Episode objects) fetched from urlString, or nil on error
 */
+ (NSArray *)fetchAll
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    /* Fetch JSON data */
    NSData *jsonData = [Episode getJsonForUrlString:urlString];
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
    NSDate *toInsert = [Episode dateFromString:dateString];
    int i = 0;
    for (NSString *curr in arr) {
        NSDate *currDate = [Episode dateFromString:curr];
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
    NSData *jsonData = [Episode getJsonForUrlString:urlString];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            /* Create episode object, fill out properties, and add it to array */
            Episode *ep = [Episode getEpisodeFromDictionary:episodeDictionary];
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

+ (NSDictionary *) fetchAllForMonth:(int) month andYear:(int)year{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    NSData *jsonData = [Episode getJsonForUrlString:urlString];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            Episode *ep = [Episode getEpisodeFromDictionary:episodeDictionary];
            
            /* Check if current episode's month and year match the given values, if so, add it to the dictionary we return */
            NSDate *airDate = ep.airDate;
             NSDateComponents *givenDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:airDate];
            if (([givenDateComponents month] == month) && ([givenDateComponents year] == year)) {
                [ret setObject:ep forKey:ep.airDate];
            }
        }
        return ret;
    }
    return nil;
}

/* Override description method to return a nice string describing this episode */
- (NSString *)description {
    return [NSString stringWithFormat:@"\n{\n\tShow: %@ \n\tSeason: %d\n\tEpisode name: %@\n\tEpisode number: %d\n\tWatched: %@\n\tAir date: %@\n}", self.show, self.season, self.name, self.number, (self.watched ? @"true" : @"false"), [Episode stringFromDate:self.airDate]];
}

@end
