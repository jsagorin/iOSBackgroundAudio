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


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAuth];
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

-(void)requestAuth
{
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        switch (status) {
            case MPMediaLibraryAuthorizationStatusNotDetermined:
                [self requestAuth];
                break;
            case MPMediaLibraryAuthorizationStatusAuthorized:
                [self querySongs];
                break;
            default:
                [self displayPermissionsError];
        }
    }];
}

-(void)querySongs
{
    self.title = @"Querying...";
    [[MusicQuery new] queryForSongs:^(NSDictionary *result) {
        self.artists = result[@"artists"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = [NSString stringWithFormat:@"Songs (%@)", result[@"songCount"]];
            [self.tableView reloadData];
        });
    }];
    
}

-(void) displayPermissionsError {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"This is a demo" message:@"Unauthorized or restricted access. Cannot play media. Fix in Settings?" preferredStyle:UIAlertControllerStyleAlert];
    //cancel
    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (settingsURL && [[UIApplication sharedApplication] canOpenURL:settingsURL]) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:settingsURL];
        }];
        [alertVC addAction:settingsAction];
    } else {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    }
    
    [self presentViewController:alertVC animated:true completion:nil];
}

@end
