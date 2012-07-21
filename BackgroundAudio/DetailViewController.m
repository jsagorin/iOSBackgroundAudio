//
//  DetailViewController.m
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.


#import "DetailViewController.h"
#import "TestMusicPlayer.h"

@interface DetailViewController ()
- (void)configureView;
@property (strong, nonatomic) TestMusicPlayer *musicPlayer;
@property (strong, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *songIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@end

@implementation DetailViewController

@synthesize artistName = _artistName;
@synthesize albumName = _albumName;
@synthesize songId = _songId;
@synthesize songTitle = _songTitle;
@synthesize songIdLabel = _songIdLabel;
@synthesize artistNameLabel = _artistNameLabel;
@synthesize albumNameLabel = _albumNameLabel;
@synthesize songTitleLabel = _songTitleLabel;
@synthesize playPauseButton = _playPauseButton;

@synthesize musicPlayer = _musicPlayer;

#pragma mark - Managing the detail item

- (void)configureView
{
    self.artistNameLabel.text = self.artistName;
    self.albumNameLabel.text = self.albumName;
    self.songTitleLabel.text = self.songTitle;
    self.songIdLabel.text = [NSString stringWithFormat :@"%@",self.songId];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    [TestMusicPlayer initSession];
    self.musicPlayer = [[TestMusicPlayer alloc]init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.artistNameLabel = nil;
    self.albumNameLabel = nil;
    self.songIdLabel = nil;
    self.songTitleLabel = nil;
    self.playPauseButton = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //play song
    [self.musicPlayer playSongWithId:self.songId];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.musicPlayer clear];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

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

#pragma mark - audio session management
- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    [self.musicPlayer remoteControlReceivedWithEvent:receivedEvent];
}
@end
