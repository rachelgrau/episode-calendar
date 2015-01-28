//
//  EpisodeCalendarViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 27/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeCalendarViewController.h"
#import "CalendarDayCell.h"

@interface EpisodeCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation EpisodeCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Returns true if the two given dates have the same month, and false otherwise. */
- (BOOL)haveSameMonth:(NSDate *)date1 date2:(NSDate *)date2 {
     NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    
    NSDateComponents *comps2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    
    if ([comps1 month] == [comps2 month]) return true;
    else return false;
}

/* Given a number of months (probably 1 or -1), returns an NSDate * with adding that # of months from the date currently being displayed.
   For example, if we are currently displaying January 22, 2015, and you call getDate:-1, will return an NSDate * with the date December 22, 2014.*/
- (NSDate *)getDate:(int)monthsAway {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:monthsAway];
    NSDate *ret = [gregorian dateByAddingComponents:offsetComponents toDate:self.dateToDisplay options:0];
    return ret;
}

- (IBAction)leftArrowPressed:(id)sender {
    self.dateToDisplay = [self getDate:-1];
    [self viewDidLoad];
    [self.collectionView reloadData];
}

- (IBAction)rightArrowPressed:(id)sender {
    self.dateToDisplay = [self getDate:1];
    [self viewDidLoad];
    [self.collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.dateToDisplay) {
        self.dateToDisplay = [NSDate date];
    }
    
    /* Set up month label */
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMMM"];
    self.monthLabel.text = [monthFormatter stringFromDate:self.dateToDisplay];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.monthLabel setFont:[UIFont systemFontOfSize:22]];
    
    /* Set up year label */
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.dateToDisplay];
    NSString *yearStr = [NSString stringWithFormat:@"%ld", [components year]];
    self.yearLabel.text = yearStr;
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.yearLabel setFont:[UIFont systemFontOfSize:16]];
    self.yearLabel.textColor = [UIColor grayColor];
    
    /* Set up collection view cells */
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CalendarCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/* Given an indexPath of the collection view, return which date should be displayed at that indexPath. */
- (NSDate *)getDateForIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSLog(@"%ld\n", row);
    
    NSDate *ret = self.dateToDisplay;
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSWeekdayCalendarUnit | NSWeekCalendarUnit) fromDate:self.dateToDisplay];
    
    NSInteger weekdayOfFirst = [comps weekday] + 1;
    [comps setDay:[indexPath row] - weekdayOfFirst + 2];
    ret = [cal dateFromComponents:comps];
    /*
     get weekdayOfFirstDay (if jan 1 is on a thurs, get 5)
     get dateToDisplay = row - weekdayOfFirstDay + 2
     */
    
    return ret;
}

/* Given a date, return a string in the form "MMM. d'st'". For example, "Jan. 28th," "Feb. 1st" or "Mar. 3rd" */
+ (NSString *)getDateString:(NSDate *)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    /* Get components so we can get day in int form */
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
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

#pragma mark - UICollectionView Datasource

/* Return 7*4=28 if only need to display 4 weeks, or 7*5=35 if need to display 5 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
//    /* get the first day of the month we are trying to display */
//    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSWeekdayCalendarUnit | NSWeekCalendarUnit) fromDate:self.dateToDisplay];
//    [comps setDay:1];
//    
//    /* calculate whether or not we need 4 or 5 rows */
//    NSInteger dayOfWeek = [comps weekday] + 1;
//    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.dateToDisplay];
//    NSUInteger numberOfDaysInMonth = rng.length;
//    NSInteger numRows = (dayOfWeek + numberOfDaysInMonth) / 7;
//    
//    if (numRows == 6) {
//        return 42;
//    } else if (numRows == 5) {
//        return 35;
//    } else if (numRows == 4) {
//        return 28;
//    }
//    return 0;
    
    return 42;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


/* Return cell that should go at given indexpath */
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDate *dateOnCell = [self getDateForIndexPath:indexPath];
    NSString *dateLabelString = [EpisodeCalendarViewController getDateString:dateOnCell];
    
    /* If not from this month, gray out text */
    if (![self haveSameMonth:dateOnCell date2:self.dateToDisplay]) {
        cell.dateLabel.textColor = [UIColor grayColor];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
    }
    cell.dateLabel.text = dateLabelString;
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval = CGSizeMake(85, 85);
    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


@end
