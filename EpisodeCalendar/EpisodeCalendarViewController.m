//
//  EpisodeCalendarViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 27/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeCalendarViewController.h"
#import "CalendarCell.h"

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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    self.monthLabel.text = [dateFormatter stringFromDate:self.dateToDisplay];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.monthLabel setFont:[UIFont systemFontOfSize:22]];
    
    /* Set up year label */
    [dateFormatter setDateFormat:@"YYYY"];
    self.yearLabel.text = [dateFormatter stringFromDate:self.dateToDisplay];
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.yearLabel setFont:[UIFont systemFontOfSize:16]];
    self.yearLabel.textColor = [UIColor grayColor];
    
    /* Set up collection view cells */
    [self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"EpisodeCollectionCell"];
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
    static NSString *episodeCollectionIdentifier = @"EpisodeCollectionCell";
    CalendarCell *cell = [cv dequeueReusableCellWithReuseIdentifier:episodeCollectionIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CalendarCell alloc] init];
    }
    cell.dayLabel.text = @"Hii";
    return cell;
}


@end
