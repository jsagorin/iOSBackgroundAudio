//
//  MasterViewController.m
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MusicQuery.h"

@interface MasterViewController ()
@property(nonatomic,strong) NSArray *artists;
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
    return [self.artists count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *artistAlbum = [self.artists objectAtIndex:section];
    return  [[artistAlbum objectForKey:@"songs"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    NSDictionary *artistAlbum = [self.artists objectAtIndex:indexPath.section];
    NSDictionary *song = [[artistAlbum objectForKey:@"songs"] objectAtIndex:indexPath.row];
    cell.textLabel.text = [song objectForKey:@"title"];
    cell.detailTextLabel.text = [artistAlbum objectForKey:@"album"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *artistAlbum = [self.artists objectAtIndex:indexPath.section];
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
     NSDictionary *artistAlbum = [self.artists objectAtIndex:section];
    return [artistAlbum objectForKey:@"artist"];
}

#pragma mark - Action delegate
-(void)querySongs:(id)sender
{
    self.title = @"Querying...";
    MusicQuery *musicQuery = [[MusicQuery alloc]init];
    [musicQuery queryForSongs:^(NSDictionary *result) {
        self.artists = [result objectForKey:@"artists"];
        self.title = [NSString stringWithFormat:@"Songs (%@)", [result objectForKey:@"songCount"]];
        [self.tableView reloadData];
    }];
     
}

@end
