//
//  CalendarDayCell.m
//  EpisodeCalendar
//
//  Created by Rachel on 1/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "CalendarDayCell.h"
#import "EpisodeListTableView.h"

@interface CalendarDayCell ()
@property EpisodeListTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *episodeContentView;
@end

@implementation CalendarDayCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setTableView
{
    self.tableView = [[EpisodeListTableView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"EpisodeTableCell"];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.episodeContentView.frame;
}

- (void)setDateLabelText:(NSString *)dateString
{
    self.dateLabel.text = dateString;
    self.dateLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setShowsArray:(NSMutableArray *)shows {
    
}

-(void)setTableViewDataSourceDelegate:(id<UITableViewDataSource, UITableViewDelegate>)dataSourceDelegate index:(NSInteger)index
{
    self.tableView.dataSource = dataSourceDelegate;
    self.tableView.delegate = dataSourceDelegate;
    self.tableView.tag = index;
    [self.tableView reloadData];
}

@end
