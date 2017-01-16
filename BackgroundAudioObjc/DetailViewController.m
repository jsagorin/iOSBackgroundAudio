//
//  DetailViewController.m
//  BackgroundAudioObjc
//
//  Created by Jonathan Sagorin on 3/4/2015.
//
//

#import "DetailViewController.h"
#import "TestMusicPlayer.h"

@interface DetailViewController ()
@property (strong, nonatomic) TestMusicPlayer *musicPlayer;

@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *songIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

-(void)setArtistAlbum:(NSDictionary *)newArtistAlbum {
    if (_artistAlbum != newArtistAlbum) {
        _artistAlbum = newArtistAlbum;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.artistAlbum) {
        self.artistNameLabel.text = self.artistAlbum[@"artist"];
        self.albumNameLabel.text = self.artistAlbum[@"album"];
        NSDictionary *song = [self.artistAlbum[@"songs"] objectAtIndex:self.songIndex];
        self.songTitleLabel.text = song[@"title"];
        self.songIdLabel.text = [NSString stringWithFormat:@"%@", song[@"songId"]];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [TestMusicPlayer initSession];
    self.musicPlayer = [[TestMusicPlayer alloc]init];

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //play song
    NSDictionary *song = [self.artistAlbum[@"songs"] objectAtIndex:self.songIndex];
    [self.musicPlayer songIsAvailable:song[@"songId"] completion:^(BOOL available) {
        if (available) {
            [self.musicPlayer playSongWithId:song[@"songId"] songTitle:song[@"title"] artist:self.artistAlbum[@"artist"]];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            [self becomeFirstResponder];
        } else {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Song is not available. It may not be downloaded" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertVC animated:true completion:nil];
        }
    }];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
    [self.musicPlayer clear];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - user actions
-(IBAction)playPauseButtonTapped:(UIButton*)button
{
    if ([button.titleLabel.text isEqualToString:@"Pause"]) {
        [self.musicPlayer pause];
        [button setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [self.musicPlayer play];
        [button setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

#pragma mark - remote control events
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    [self.musicPlayer remoteControlReceivedWithEvent:receivedEvent];
}

#pragma mark - audio session management
- (BOOL) canBecomeFirstResponder {
    return YES;
}

@end



