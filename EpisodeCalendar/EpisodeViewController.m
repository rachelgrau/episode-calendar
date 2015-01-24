//
//  EpisodeViewController.m
//  EpisodeCalendar
//
//  Created by Rachel on 23/01/2015.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "EpisodeViewController.h"

@interface EpisodeViewController ()
@property NSArray *tvShows;
@end

@implementation EpisodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadJSON {
    NSString *urlString = @"https://s3.amazonaws.com/lab.nearpod.com/rachel/episodecalendar-data.json";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:req returningResponse:0 error:nil];
    
    if (jsonData) {
        NSDictionary *objs = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *obj in objs) {
            NSLog(@"%@", obj);
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadJSON];
    
    self.tvShows = [NSArray arrayWithObjects:@"Revenge", @"24", @"Parenthood", @"House", @"The Bachelor", @"New Girl", @"Grey's Anatomy", @"Scrubs", @"Jimmy Kimmel Live", @"Survivor", nil];
    // Do any additional setup after loading the view.
}

/* Datasource method */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tvShows count];
}

/* Datasource method */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *episodeTableIdentifier = @"EpisodeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:episodeTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:episodeTableIdentifier];
    }
    
    cell.textLabel.text = [self.tvShows objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
