/**
 * File: EpisodeDateUtility.h
 * -------------------------
 * Defines some class methods to help with operations on NSDates specific
 * to this project.
 */

#import <Foundation/Foundation.h>

@interface EpisodeDateUtility : NSObject

/**
 * Method: dateFromString
 * Usage: NSDate *date = [EpisodeDateUtility dateFromString:@"2014-12-31"
 * ----------------------------------------------------------------------
 * Given a string |dateString| of the format yyyy-MM-dd, returns an NSDate
 * object with the given date. Undefined behavior on error, so make sure
 * to pass in a correctly formatted string.
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/**
 * Method: numericalStringFromDate
 * Usage: NSString *datestring = [EpisodeDateUtility numericalStringFromDate:date];
 * -------------------------------------------------------------------------------
 * Given an NSDate * |date|, returns a string of the form yyyy-MM-dd representing
 * that date.
 */
+ (NSString *)numericalStringFromDate:(NSDate *)date;

/**
 * Method: lexicalStringFromDate
 * Usage: NSString *datestring = [EpisodeDateUtility lexicalStringFromDate:date];
 * -------------------------------------------------------------------------------
 * Given an NSDate * |date|, returns a string of the form "MMM. d'st'". For 
 * example, "Jan. 28th," "Feb. 1st" or "Mar. 3rd".
 */
+ (NSString *)lexicalStringFromDate:(NSDate *)date;

/**
 * Method: isDateBetweenDate
 * Usage: BOOL *between = [EpisodeDateUtility isDate:date betweenDate:firstDate andDate: lastDate];
 * -------------------------------------------------------------------------------
 * Returns YES if |date| is between |firstDate| and |lastDate|.
 * Returns YES if |date| is equal to |firstDate| or |lastDate|.
 * Returns NO otherwise.
 */
+ (BOOL)isDate:(NSDate *)date betweenDate:(NSDate *)firstDate andDate:(NSDate *)lastDate;

/**
 * Method: haveSameMonth
 * Usage: BOOL *sameMonth = [EpisodeDateUtility haveSameMonth:date1 date2:date2];
 * -------------------------------------------------------------------------------
 * Returns YES if |date1| is in the same month as |date2| and NO otherwise.
 * Does not take the dates' years into consideration, so if |date1| is January 1, 2014 and |date2| is January 23, 1994, this method will return YES.
 */
+ (BOOL)haveSameMonth:(NSDate *)date1 date2:(NSDate *)date2;

/**
 * Method: getDateMonthsFrom
 * Usage: NSDate *date = [EpisodeDateUtility getDate:1 monthsFrom:[NSDate date]];
 * -------------------------------------------------------------------------------
 * Returns an NSDate * |monthsAway| months from the given date |date|. For example, if |date| is March 3, 2014 and |monthsAway| is 3, this method will return the date June 3, 2014. 
 * To get an older date, use a negative number (e.g. if |date| is January 1, 2014 and |monthsAway| is -1, this method returns December 1, 2013).
 */
+ (NSDate *)getDate:(int)monthsAway monthsFrom:(NSDate *)date;

/**
 * Method: getWeekdayOfFirstDayOfMonth
 * Usage: NSInteger *weekday = [EpisodeDateUtility getWeekdayOfFirstDayOfMonth:date];
 * -------------------------------------------------------------------------------
 * Returns the weekday (Sunday = 1, Saturday = 7) that the first day of the month of |date| occurs on.
 * For example, if |date| is January 22, 2015, this method will return 5 because January 1, 2015 occurred on a Thursday.
 */
+ (NSInteger)getWeekDayOfFirstDayOfMonth:(NSDate *)date;

/**
 * Method: isDate sameDayAsDate
 * Usage: BOOL sameDate = [EpisodeDateUtility isDate:date1 sameDayAsDate:date2];
 * -------------------------------------------------------------------------------
 * Returns YES if the 2 given dates have the same day, month, and year. Returns NO
 * otherwise.
 */
+ (BOOL)isDate:(NSDate *)date1 sameDayAsDate:(NSDate *)date2;
@end
