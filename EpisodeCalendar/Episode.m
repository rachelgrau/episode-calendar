/**
 * File: Episode.m
 * -------------------------
 * Implementation of an Episode model object.
 */

#import "Episode.h"
#import "EpisodeDateUtility.h"

@implementation Episode

/* Override description method to return a nice string describing this episode */
- (NSString *)description {
    return [NSString stringWithFormat:@"\n{\n\tShow: %@ \n\tSeason: %d\n\tEpisode name: %@\n\tEpisode number: %d\n\tWatched: %@\n\tAir date: %@\n}", self.show, self.season, self.name, self.number, (self.watched ? @"true" : @"false"), [EpisodeDateUtility numericalStringFromDate:self.airDate]];
}

@end


