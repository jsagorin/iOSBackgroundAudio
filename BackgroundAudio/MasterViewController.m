//
//  MasterViewController.m
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MusicQuery.h"

@interface MasterViewController () {
    NSArray *_objects;
}
@end

@implementation MasterViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Query" style:UIBarButtonItemStylePlain target:self action:@selector(querySongs:)];
    self.navigationItem.rightBarButtonItem = addButton;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_objects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *artistAlbum = [_objects objectAtIndex:section];
    return  [[artistAlbum objectForKey:@"songs"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *artistAlbum = [_objects objectAtIndex:indexPath.section];
    NSDictionary *song = [[artistAlbum objectForKey:@"songs"] objectAtIndex:indexPath.row];
    cell.textLabel.text = [song objectForKey:@"title"];
    cell.detailTextLabel.text = [artistAlbum objectForKey:@"album"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *artistAlbum = [_objects objectAtIndex:indexPath.section];
        NSDictionary *song = [[artistAlbum objectForKey:@"songs"] objectAtIndex:indexPath.row];
        DetailViewController *detailVC = [segue destinationViewController];
        detailVC.artistName = [artistAlbum objectForKey:@"artist"];
        detailVC.albumName = [artistAlbum objectForKey:@"album"];
        detailVC.songTitle = [song objectForKey:@"title"];
        detailVC.songId = [song objectForKey:@"songId"];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     NSDictionary *artistAlbum = [_objects objectAtIndex:section];
    return [artistAlbum objectForKey:@"artist"];
}

#pragma mark - Action delegate
-(void)querySongs:(id)sender
{
    self.title = @"Querying...";
    MusicQuery *musicQuery = [[MusicQuery alloc]init];
    [musicQuery queryForSongsWithBlock:^(NSDictionary *result) {
        NSLog(@"results!");
        _objects = [result objectForKey:@"artists"];
        self.title = [NSString stringWithFormat:@"Songs (%@)", [result objectForKey:@"songCount"]];
        [self.tableView reloadData];
    }];
     
}

@end
