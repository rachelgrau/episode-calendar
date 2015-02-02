//
//  EpisodeCalendarViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 27/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeCalendarViewController.h"
#import "CalendarDayCell.h"
#import "Episode.h"
#import "EpisodeManager.h"
#import "EpisodeDateUtility.h"

@interface EpisodeCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSDictionary *episodes;
@property NSInteger lastMonth;
@property NSInteger nextMonth;
@end

@implementation EpisodeCalendarViewController

static int HEIGHT_PER_LINE = 15; // Cell height per line of text
static int MAX_CHARS_PER_LINE = 12; // Max # of chars that fit in a line of text on label

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)leftArrowPressed:(id)sender {
    self.dateToDisplay = [EpisodeDateUtility getDate:-1 monthsFrom:self.dateToDisplay];
    [self viewDidLoad];
    [self.collectionView reloadData];
}

- (IBAction)rightArrowPressed:(id)sender {
    self.dateToDisplay = [EpisodeDateUtility getDate:1 monthsFrom:self.dateToDisplay];
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
    NSString *yearStr = [NSString stringWithFormat:@"%ld", (long)[components year]];
    self.yearLabel.text = yearStr;
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.yearLabel setFont:[UIFont systemFontOfSize:16]];
    self.yearLabel.textColor = [UIColor grayColor];
    
    /* Fetch all episodes between the first date we need to display (which might be from the previous month) and the
     last date we need to display (which might be from the next month) */
    NSDate *firstDateNeeded = [self getDateForIndex:0];
    NSInteger numRows = [self numberOfRowsInThisMonth];
    NSDate *lastDateNeeded = [self getDateForIndex:(numRows * 7) - 1];
    self.episodes = [EpisodeManager fetchAllBetween:firstDateNeeded and:lastDateNeeded];
    
    NSLog(@"%ld", (long)self.episodes.count);
    
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 0;
    
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

/* Given an index of the collection view, return which date should be displayed at that indexPath. */
- (NSDate *)getDateForIndex:(NSInteger )index {
    /* Get first day of month */
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSWeekdayCalendarUnit | NSWeekCalendarUnit) fromDate:self.dateToDisplay];
    comps.day = 1;
    NSInteger weekdayOfFirst = [EpisodeDateUtility getWeekDayOfFirstDayOfMonth:self.dateToDisplay];
    
    /* Use week day of first of month to find the date that should go at index */
    [comps setDay:index - weekdayOfFirst + 2];
    return [cal dateFromComponents:comps];
}

/* Returns the # of rows we need to display for the given month (4, 5, or 6 depending on how many days are in the month
 and what weekday the first of the month falls on) */
- (NSInteger) numberOfRowsInThisMonth {
    /* Get first day of month & what weekday it falls on */
    NSInteger weekdayOfFirst = [EpisodeDateUtility getWeekDayOfFirstDayOfMonth:self.dateToDisplay];
    /* Get number of days in month */
    NSCalendar *cal=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.dateToDisplay];
    NSUInteger numberOfDaysInMonth = rng.length;
    
    /* Return divide # of days to display by 7 and add an extra week if there's a remainder */
    NSInteger numRows = (weekdayOfFirst + numberOfDaysInMonth - 1)/7;
    if (((weekdayOfFirst + numberOfDaysInMonth - 1) % 7) > 0){
        numRows++;
    }
    return numRows;
}

#pragma mark - UICollectionView Datasource

/* Return 7*4=28 if only need to display 4 weeks, 7*5=35 if need to display 5 weeks, etc */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSInteger numRows = [self numberOfRowsInThisMonth];
    return numRows * 7;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


/* Return cell that should go at given indexpath */
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    
    NSDate *dateOnCell = [self getDateForIndex:indexPath.row];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dateOnCell];
    if ([components month] == 3) {
        
    }
    NSString *dateLabelString = [EpisodeDateUtility lexicalStringFromDate:dateOnCell];
    
    /* If not from this month, gray out text */
    if (![EpisodeDateUtility haveSameMonth:dateOnCell date2:self.dateToDisplay]) {
        cell.dateLabel.textColor = [UIColor grayColor];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
    }
    [cell setTableView];
    [cell setDateLabelText:dateLabelString];
    [cell setTableViewDataSourceDelegate:self index:indexPath.row];
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionViewWidth = self.view.bounds.size.width;
    CGFloat cellWidth = collectionViewWidth/7 - 9;
    
    NSInteger numRows = [self numberOfRowsInThisMonth];
    CGFloat collectionViewHeight = self.collectionView.bounds.size.height;
    CGFloat cellHeight = collectionViewHeight/numRows - 9;
    CGSize retval = CGSizeMake(cellWidth, cellHeight);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

#pragma mark - Orientation Change

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView reloadData];
}

#pragma mark - UITableViewDataSource Methods

/* Returns # of sections in the table view (number of dates) */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/* Returns cell that should go at given index path */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    NSDate *dateOnCell = [self getDateForIndex:tableView.tag];
    
    /* Check if there are episodes for this date */
    NSArray *arr = [self.episodes objectForKey:dateOnCell];
    if (arr) {
        Episode *ep = arr[indexPath.row];
        NSString *cellText = [NSString stringWithFormat:@"%@ (%dx%d)", ep.show, ep.season, ep.number];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /* Gray out if not from this month */
        if (![EpisodeDateUtility haveSameMonth:self.dateToDisplay date2:dateOnCell]) {
            cell.textLabel.textColor = [UIColor grayColor];
        }
        /* Strikethrough font if watched */
        if (ep.watched) {
            NSMutableAttributedString *strikeThroughString = [[NSMutableAttributedString alloc] initWithString:cellText];
            [strikeThroughString addAttribute:NSStrikethroughStyleAttributeName
                                        value:@2
                                        range:NSMakeRange(0, [strikeThroughString length])];
            cell.textLabel.attributedText = strikeThroughString;
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"• %@", cellText];
        }
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}

/* Returns number of rows in a certain section (# of episodes with a certain date) */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateOnCell = [self getDateForIndex:tableView.tag];
    NSArray *arr = [self.episodes objectForKey:dateOnCell];
    if (arr) {
        return (arr.count);
    } else {
        return 0;
    }
}

/* Returns the height for the table cell at indexPath. To calculate this, we need to find out how 
  long the text will be in that cell...if it's less than 12 chars, we only need 1 line to display it,
  so we can return HEIGHT_PER_LINE. If it's more than 12, we may need multiple lines. */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *dateOnCell = [self getDateForIndex:tableView.tag];
    NSArray *arr = [self.episodes objectForKey:dateOnCell];
    if (arr) {
        Episode *ep = arr[indexPath.row];
        NSString *cellText = [NSString stringWithFormat:@"%@ (%dx%d)", ep.show, ep.season, ep.number];
        NSInteger length = [cellText length];
        /* Add HEIGHT_PER_LINE to height for every 12 chars */
        CGFloat height = HEIGHT_PER_LINE + (length/MAX_CHARS_PER_LINE)*HEIGHT_PER_LINE;
        return height;
    }
    return 0;
}


@end

