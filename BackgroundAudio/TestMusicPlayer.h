//
//  TestMusicPlayer.h
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TestMusicPlayer : NSObject 

//initialize the audio session
+(void) initSession;

-(void) playSongWithId:(NSNumber*)songId;
-(void) pause;
-(void) play;
-(void) clear;
@end
