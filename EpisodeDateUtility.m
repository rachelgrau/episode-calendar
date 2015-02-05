/**
 * File: EpisodeDateUtility.m
 * -------------------------
 * Implementation of class methods that perform operations on NSDates.
 */

#import "EpisodeDateUtility.h"

@implementation EpisodeDateUtility

/* |dateString| of the form yyyy-MM-dd */
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
}

/* Returns string of the form yyyy-MM-dd */
+ (NSString *)numericalStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

/* Given a date, return a string in the form "MMM. d'st'". For example, "Jan. 28th," "Feb. 1st" or "Mar. 3rd" */
+ (NSString *)lexicalStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    /* Get components so we can get day in int form */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    /* Make sure we display "1st" "2nd" "3rd" and "nth" for all n > 3 */
    if ([components day] == 1) {
        [dateFormat setDateFormat:@"MMM. d'st' '"];
    } else if ([components day] == 2) {
        [dateFormat setDateFormat:@"MMM. d'nd'"];
    } else if ([components day] == 3) {
        [dateFormat setDateFormat:@"MMM. d'rd'"];
    } else {
        [dateFormat setDateFormat:@"MMM. d'th'"];
    }
    return [dateFormat stringFromDate:date];
}

/* Returns YES if |firstDate| <= |date| <= |lastDate| */
+ (BOOL)isDate:(NSDate *)date betweenDate:(NSDate *)firstDate andDate:(NSDate *)lastDate
{
    if ([date compare:lastDate] == NSOrderedDescending) {
        /* Given date is after last date --> out of bounds */
        return NO;
    } else if ([date compare:firstDate] == NSOrderedAscending) {
        /* Given date is before first date --> out of bounds */
        return NO;
    } else {
        return YES;
    }
}

/* Returns YES if the two given dates have the same month, and NO otherwise. */
+ (BOOL)haveSameMonth:(NSDate *)date1 date2:(NSDate *)date2
{
    NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    
    NSDateComponents *comps2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    
    if ([comps1 month] == [comps2 month]) return YES;
    else return NO;
}


/* Given a number of months (probably 1 or -1), returns an NSDate * with adding that # of months from the given date DATE. */
+ (NSDate *)getDate:(int)monthsAway monthsFrom:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:monthsAway];
    NSDate *ret = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    return ret;
}

/* Returns the weekday (Sunday = 1, Saturday = 7) that the first day of the month we're displaying falls on. */
+ (NSInteger)getWeekDayOfFirstDayOfMonth:(NSDate *)date;
{
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSWeekdayCalendarUnit | NSWeekCalendarUnit) fromDate:date];
    comps.day = 1;
    NSDate *firstOfMonth = [cal dateFromComponents:comps];
    NSDateComponents *comps2 = [cal components:NSWeekdayCalendarUnit fromDate:firstOfMonth];
    NSInteger weekdayOfFirst = [comps2 weekday];
    if (weekdayOfFirst == 8) weekdayOfFirst = 1;
    return weekdayOfFirst;
}

/* Returns true YES and only if |date1| and |date2| occur on the same day, month, and year. Returns NO otherwise. */
+ (BOOL)date:(NSDate *)date1 isSameDayAsDate:(NSDate *)date2
{
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps1 = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit ) fromDate:date1];
    NSDateComponents *comps2 = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit ) fromDate:date2];
    if ([comps1 day] != [comps2 day]) return NO;
    else if ([comps1 month] != [comps2 month]) return NO;
    else if ([comps1 year] != [comps2 year]) return NO;
    else return YES;
}

@end
