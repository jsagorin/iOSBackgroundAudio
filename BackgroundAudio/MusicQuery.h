//
//  MusicQuery.h
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicQuery : NSObject

//query music collection for all songs
-(void) queryForSongsWithBlock:(void (^)(NSDictionary* result))block;
@end
