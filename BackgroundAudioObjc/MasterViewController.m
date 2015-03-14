//
//  MasterViewController.m
//  BackgroundAudioObjc
//
//  Created by Jonathan Sagorin on 3/4/2015.
//
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MusicQuery.h"

@interface MasterViewController ()
@property(nonatomic,strong) NSArray *artists;
@end

@implementation MasterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self querySongs];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.artists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *artistAlbum = [self.artists objectAtIndex:section];
    return  [artistAlbum[@"songs"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *artistAlbum = [self.artists objectAtIndex:indexPath.section];
    NSDictionary *song = [artistAlbum[@"songs"] objectAtIndex:indexPath.row];
    cell.textLabel.text = song[@"title"];
    cell.detailTextLabel.text = artistAlbum[@"album"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *artistAlbum = [self.artists objectAtIndex:indexPath.section];
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.artistAlbum = artistAlbum;
        detailVC.songIndex = indexPath.row;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *artistAlbum = [self.artists objectAtIndex:section];
    return artistAlbum[@"artist"];
}

-(void)querySongs
{
    self.title = @"Querying...";
    [[MusicQuery new] queryForSongs:^(NSDictionary *result) {
        self.artists = result[@"artists"];
        self.title = [NSString stringWithFormat:@"Songs (%@)", result[@"songCount"]];
        [self.tableView reloadData];
    }];
    
}

@end
