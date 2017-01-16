//
//  TestMusicPlayer.m
//  BackgroundAudioObjc
//
//  Created by Jonathan Sagorin on 7/20/12.
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

#import "TestMusicPlayer.h"
#import "MusicQuery.h"
#import <AVFoundation/AVFoundation.h>

@interface TestMusicPlayer()
@property(nonatomic,strong) AVQueuePlayer *avQueuePlayer;
@end

@implementation TestMusicPlayer
+(void)initSession
{
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:    @selector(audioSessionInterrupted:)
                                                 name:        AVAudioSessionInterruptionNotification
                                               object:      [AVAudioSession sharedInstance]]; 

    
    //set audio category with options - for this demo we'll do playback only
    NSError *categoryError = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&categoryError];
    
    if (categoryError) {
        NSLog(@"Error setting category! %@", [categoryError description]);
    }
    
    //activation of audio session
    NSError *activationError = nil;
    BOOL success = [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
    if (!success) {
        if (activationError) {
            NSLog(@"Could not activate audio session. %@", [activationError localizedDescription]);
        } else {
            NSLog(@"audio session could not be activated!");
        }
    }
    
}

-(AVPlayer *)avQueuePlayer
{
    if (!_avQueuePlayer) {
        _avQueuePlayer = [[AVQueuePlayer alloc]init];
    }
    
    return _avQueuePlayer;
}

-(void) playSongWithId:(NSNumber*)songId songTitle:(NSString*)songTitle artist:(NSString*)artist
{
    [[MusicQuery new] queryForSongWithId:songId completion:^(MPMediaItem *item) {
        if (item) {
            NSURL *assetUrl = [item valueForProperty: MPMediaItemPropertyAssetURL];
            if (assetUrl) {
                AVPlayerItem *avSongItem = [[AVPlayerItem alloc] initWithURL:assetUrl];
                if (avSongItem) {
                    [[self avQueuePlayer] insertItem:avSongItem afterItem:nil];
                    [self play];
                    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{MPMediaItemPropertyTitle: songTitle, MPMediaItemPropertyArtist: artist};
                    
                }
            } else {
                NSLog(@"ERROR: assetURL for song id %@ was not found: ", songId);
            }
        } else {
            NSLog(@"ERROR: item with song id %@ was not found: ", songId);
        }
    }];
}

-(void) songIsAvailable:(NSNumber*)songId completion:(void(^)(BOOL available))completion
{
    [[MusicQuery new] queryForSongWithId:songId completion:^(MPMediaItem *item) {
        if (item) {
            NSURL *assetUrl = [item valueForProperty: MPMediaItemPropertyAssetURL];
            completion(assetUrl!= nil);
        }
    }];
}

#pragma mark - notifications
+(void)audioSessionInterrupted:(NSNotification*)interruptionNotification
{
    NSLog(@"interruption received: %@", interruptionNotification);
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
            case UIEventSubtypeRemoteControlPlay: {
                [[self avQueuePlayer] play];
                break;
            }
            case UIEventSubtypeRemoteControlPause: {
                [[self avQueuePlayer] pause];
                break;
            }
            default:
                break;
        }
    }
}

@end
