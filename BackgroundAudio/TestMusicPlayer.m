//
//  MusicPlayer.m
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.
//

#import "TestMusicPlayer.h"
#import "MusicQuery.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TestMusicPlayer()
@property(nonatomic,strong) AVQueuePlayer *avQueuePlayer;
@end
@implementation TestMusicPlayer

@synthesize avQueuePlayer=_avQueuePlayer;

+(void)initSession
{
    
    // Registers this class as the delegate of the audio session.
    [[AVAudioSession sharedInstance] setDelegate: self];
    
    NSError *setCategoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];
    if (setCategoryError) {
        NSLog(@"Error setting category! %@", [setCategoryError localizedDescription]);
    }
    
    UInt32 doSetProperty = 0;
    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryMixWithOthers,
                             sizeof (doSetProperty),
                             &doSetProperty
                             );
    
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    if (activationError) {
        NSLog(@"Could not activate audio session. %@", [activationError localizedDescription]);
    }
    
}

-(AVPlayer *)avQueuePlayer
{
    if (!_avQueuePlayer) {
        _avQueuePlayer = [[AVQueuePlayer alloc]init];
    }
    
    return _avQueuePlayer;
}

-(void) playSongWithId:(NSNumber*)songId
{
    MPMediaItem *mediaItem = [[[MusicQuery alloc]init] queryForSongWithId:songId];
    if (mediaItem) {
        if (mediaItem) {
            NSURL *assetUrl = [mediaItem valueForProperty: MPMediaItemPropertyAssetURL];
            AVPlayerItem *avSongItem = [[AVPlayerItem alloc] initWithURL:assetUrl];
            if (avSongItem) {
                [[self avQueuePlayer] insertItem:avSongItem afterItem:nil];
                [self play];
            }
        }
    }
}

#pragma mark - player actions
-(void) pause
{
    [[self avQueuePlayer] pause];
}

-(void) play
{
    [[self avQueuePlayer] play];
}


-(void) clear
{
    [[self avQueuePlayer] removeAllItems];
}

#pragma mark - remote control events
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                if ([self avQueuePlayer].rate > 0.0) {
                    [[self avQueuePlayer] pause];
                } else {
                    [[self avQueuePlayer] play];
                }

                break;
            }
            default:
                break;
        }
    }
}

@end
