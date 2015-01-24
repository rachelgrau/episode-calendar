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

/*
 * Returns an array of all episodes (Episode objects) fetched from urlString
 */
+ (NSArray *)fetchAll
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    /* Fetch JSON data */
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:req returningResponse:0 error:nil];
    if (jsonData) {
        NSArray *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *episodeDictionary in objs) {
            /* Create episode object, fill out properties, and add it to array */
            Episode *ep = [[Episode alloc] init];
            ep.name = [episodeDictionary objectForKey:@"name"];
            ep.watched = [[episodeDictionary objectForKey:@"watched"] boolValue];
            ep.season = [[episodeDictionary objectForKey:@"season"] intValue];
            ep.show = [episodeDictionary objectForKey:@"show"];
            ep.number = [[episodeDictionary objectForKey:@"number"] intValue];
            ep.airDate = [Episode dateFromString:[episodeDictionary objectForKey:@"air_date"]];
            [ret addObject:ep];
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
