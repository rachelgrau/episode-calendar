/**
 * File: EpisodeCalendarViewController.m
 * -------------------------------------
 * Implementation of the view controller that displays a month view 
 * of a calendar with episodes that are playing on each day. It uses a 
 * label to display the month & year, and left and right arrows that 
 * allow the user to switch to the month before or after. It also contains
 * a month view calendar in the form of a UICollectionView (each cell
 * is a day in the calendar). So, this view controller serves as the 
 * delegate and data source for that collection view. Additionally, each 
 * collection view cell has a UITableView that displays a list of all 
 * the shows on that day, so this view controller also serves as the 
 * delegate & data source for those table views.
 */

#import "EpisodeCalendarViewController.h"
#import "CalendarDayCell.h"
#import "Episode.h"
#import "EpisodeManager.h"
#import "EpisodeDateUtility.h"
#import "SeasonViewController.h"

@interface EpisodeCalendarViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel; // Month we are showing
@property (strong, nonatomic) IBOutlet UILabel *yearLabel; // Year we are showing
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView; // Collection view of "days" in month
@property NSDictionary *episodes; // Episodes we need to show for this month
@property UITableView *selectedTableView; /* When user selects an episode, store the tableview
                                             it was in here so we can deselect it later */
@end

static NSString *landscapeDaysText = @"Sun                       Mon                      Tues                       Wed                      Thurs                       Fri                      Sat";
static NSString *portraitDaysText = @"Sun               Mon               Tues               Wed               Thurs               Fri               Sat";

@implementation EpisodeCalendarViewController

static int HEIGHT_PER_LINE = 15; // Cell height per line of text
static int MAX_CHARS_PER_LINE = 12; // Max # of chars that fit in a line of text on label
static int COLLECTION_VIEW_PADDING = 9; // Padding on sides of collection view

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/* Callback for when the left arrow is pressed. We want to reload this view controller
  with the month before instead. */
- (IBAction)leftArrowPressed:(id)sender
{
    self.dateToDisplay = [EpisodeDateUtility getDate:-1 monthsFrom:self.dateToDisplay];
    [self viewDidLoad];
    [self.collectionView reloadData];
}

/* Callback for when the right arrow is pressed. We want to reload this view controller
 with the month after instead. */
- (IBAction)rightArrowPressed:(id)sender
{
    self.dateToDisplay = [EpisodeDateUtility getDate:1 monthsFrom:self.dateToDisplay];
    [self viewDidLoad];
    [self.collectionView reloadData];
}

/* Adjusts collection view cell sizes and the label that holds days ("Sun Mon Tues" etc) 
   based on the screen dimensions, which you need to do after an orientation change */
-(void)adjustForOrientation:(UIInterfaceOrientation)deviceOrientation
{
    [self.collectionView reloadData];
    if (UIInterfaceOrientationIsPortrait(deviceOrientation)) {
        self.daysLabel.text = portraitDaysText;
    } else {
        self.daysLabel.text = landscapeDaysText;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self adjustForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.selectedTableView deselectRowAtIndexPath:[self.selectedTableView indexPathForSelectedRow] animated:YES];
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

    /* Set up collection view's layout */
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


/* Given an index of the collection view, return which date should be displayed at that indexPath. */
- (NSDate *)getDateForIndex:(NSInteger )index
{
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
- (NSInteger) numberOfRowsInThisMonth
{
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

/* Return number of days we need to display (number of rows * 7). */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    NSInteger numRows = [self numberOfRowsInThisMonth];
    return numRows * 7;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

/* Return cell that should go at given indexpath */
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarDayCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    
    /* Set date string */
    NSDate *dateOnCell = [self getDateForIndex:indexPath.row];
    NSString *dateLabelString = [EpisodeDateUtility lexicalStringFromDate:dateOnCell];
    /* If not from this month, gray out date string text */
    if (![EpisodeDateUtility haveSameMonth:dateOnCell date2:self.dateToDisplay]) {
        cell.dateLabel.textColor = [UIColor grayColor];
    } else {
        cell.dateLabel.textColor = [UIColor blackColor];
    }
    [cell setDateLabelText:dateLabelString];
    
    /* Set up table view. Make this view controller its delegate/data source. */
    [cell setTableView];
    /* Pass in indexPath.row as index, so we can figure out which date this tableview
     is on at any point by looking at its index. */
    [cell setTableViewDataSourceDelegate:self index:indexPath.row];
    return cell;
}

#pragma mark – UICollectionViewDelegateFlowLayout

/* Return size of the collection view cell that goes at indexPath. We need to calculate the size
  based on how many rows we are displaying (more rows = smaller height). We also need to calculate
  the width of the cell based on the width of the entire collection view (which changes depending
  on orientation of iPad). */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /* Width = collection view width / 7 minus some padding. */
    CGFloat collectionViewWidth = self.view.bounds.size.width;
    CGFloat cellWidth = collectionViewWidth/7 - COLLECTION_VIEW_PADDING;
    
    /* Height = collection view height / number of rows minus some padding. */
    NSInteger numRows = [self numberOfRowsInThisMonth];
    CGFloat collectionViewHeight = self.collectionView.bounds.size.height;
    CGFloat cellHeight = collectionViewHeight/numRows - COLLECTION_VIEW_PADDING;
    CGSize retval = CGSizeMake(cellWidth, cellHeight);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/* Don't want space between cells, so return 0. */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

#pragma mark - Orientation Change

/* Reload our collection view if orientation changes so we can recalculate the size of all the cells and their 
  subviews. */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustForOrientation:toInterfaceOrientation];
}

#pragma mark - UITableViewDataSource Methods
/* This view controller serves as the delegate and data source for all the table views (each
 collection cell has its own tableview listing the episodes that occur on that day). */

/* Returns # of sections in the table view, which is just 1. */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTableView = tableView;
    [self performSegueWithIdentifier:@"toSeasonViewController" sender:tableView];
}

/* Returns cell that should go at given index path. We need to get the date that this tableView is 
  displaying episodes for, and then retrieve a list of all the episodes for that date. Then, we just
  return the |indexPath.row|th episode in that list. */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Get a cell. */
    static NSString *episodeTableIdentifier = @"EpisodeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    /* Get the date for this cell, which we figure out by looking at the tag on the tableview. The tag is the index
      of the collection view cell that this table view belongs to. */
    NSDate *dateOnCell = [self getDateForIndex:tableView.tag];
    
    /* Check if there are episodes for this date */
    NSArray *arr = [self.episodes objectForKey:dateOnCell];
    if (arr) {
        /* Get the cell text. */
        Episode *ep = arr[indexPath.row];
        NSString *cellText = [NSString stringWithFormat:@"%@ (%dx%d)", ep.show, ep.season, ep.number];
        /* Gray out if it's from last month or next month. */
        if (![EpisodeDateUtility haveSameMonth:self.dateToDisplay date2:dateOnCell]) {
            cell.textLabel.textColor = [UIColor grayColor];
        }
        /* Strikethrough font if watched. */
        if (ep.watched) {
            NSMutableAttributedString *strikeThroughString = [[NSMutableAttributedString alloc] initWithString:cellText];
            [strikeThroughString addAttribute:NSStrikethroughStyleAttributeName
                                        value:@2
                                        range:NSMakeRange(0, [strikeThroughString length])];
            cell.textLabel.attributedText = strikeThroughString;
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"• %@", cellText];
        }
        /* Make words wrap onto multiple lines so they don't get cut off. */
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

#pragma mark prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSeasonViewController"])
    {
        SeasonViewController *destViewController = segue.destinationViewController;
        /* Get the selected episode based on index path */
        UITableView *tableView = (UITableView *)sender;
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSDate *dateOnCell = [self getDateForIndex:tableView.tag];
        NSArray *arr = [self.episodes objectForKey:dateOnCell];
        Episode *ep = arr[indexPath.row];
        /* Set destination view controller's episode */
        destViewController.episode = ep;
    }
}


@end

