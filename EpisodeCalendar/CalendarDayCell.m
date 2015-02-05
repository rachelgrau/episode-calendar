/**
 * File: CalendarDayCell.m
 * -------------------------
 * Implementation of a Calendar Day Cell.
 */

#import "CalendarDayCell.h"

@interface CalendarDayCell ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *episodeContentView;
@property (strong, nonatomic) IBOutlet UIView *labelBackgroundView;
@end

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (void)highlightDateLabel
{
    self.labelBackgroundView.backgroundColor = [UIColor lightGrayColor];
}

- (void)unhighlightDateLabel
{
    self.labelBackgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

/* If this cell doesn't yet have a tableview, make one and set up its look (white background,
  no separator, scroll enabled. Otherwise just make sure the frame of the tableview is correct. */
- (void)setTableView
{
    self.labelBackgroundView.backgroundColor = [UIColor blueColor];
    CGRect tableViewFrame = self.episodeContentView.frame;
    if (!self.tableView){
        self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EpisodeTableCell"];
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tableView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = YES;
    }
    else {
        self.tableView.frame = tableViewFrame;
    }
}

/* Set episodeContentView and tableView's frames */
- (void)layoutSubviews
{
    CGRect backgroundFrame = self.frame;
    CGRect episodeContentFrame = self.episodeContentView.frame;
    episodeContentFrame.size.width = backgroundFrame.size.width;
    self.episodeContentView.frame = episodeContentFrame;
    self.tableView.frame = episodeContentFrame;
    self.tableView.frame = self.episodeContentView.frame;
    
    [super layoutSubviews];
}

/* Sets the date label text to be |dateString| with font 12 */
- (void)setDateLabelText:(NSString *)dateString
{
    self.dateLabel.text = dateString;
    self.dateLabel.font = [UIFont systemFontOfSize:12];
}

/* Set table view's data source, delegate, and tag. Reload tableview. */
-(void)setTableViewDataSourceDelegate:(id<UITableViewDataSource, UITableViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.tableView.dataSource = dataSourceDelegate;
    self.tableView.delegate = dataSourceDelegate;
    self.tableView.tag = index;
    [self.tableView reloadData];
}

@end
