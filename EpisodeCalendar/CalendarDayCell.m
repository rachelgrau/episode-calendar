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

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *episodeContentView;
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

- (void)setTableView
{
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

- (void)layoutSubviews
{
    CGRect backgroundFrame = self.frame;
    CGRect episodeContentFrame = self.episodeContentView.frame;
    episodeContentFrame.size.width = backgroundFrame.size.width;
    self.episodeContentView.frame = episodeContentFrame;
    self.tableView.frame = episodeContentFrame;
    
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
