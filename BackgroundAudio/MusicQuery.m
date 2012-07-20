//
//  MusicQuery.m
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.
//

#import "MusicQuery.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MusicQuery()
-(NSDictionary*)queryForSongs;
@end

@implementation MusicQuery

-(void) queryForSongsWithBlock:(void (^)(NSDictionary* result))block {
	dispatch_queue_t callerQueue = dispatch_get_current_queue();
	dispatch_queue_t downloadQueue = dispatch_queue_create("musicQuery_queue", NULL);
	dispatch_async(downloadQueue, ^{
		NSDictionary *songResults = [self queryForSongs];
		dispatch_async(callerQueue, ^{
            block(songResults); 
		});
	});
	dispatch_release(downloadQueue);
}

-(NSDictionary*)queryForSongs
{
 
        MPMediaQuery *query = [MPMediaQuery artistsQuery];
        //groups all songs by artist, ordered by song name (across albums)
        NSArray *songsByArtist = [query collections];
        int songCount = 0;
        NSMutableArray *artists = [NSMutableArray array];
        NSMutableDictionary *songSortingArray = [NSMutableDictionary dictionary];
        for (MPMediaItemCollection *album in songsByArtist) {
            NSArray *albumSongs = [album items];
            for (MPMediaItem *songMediumItem in albumSongs) {
                NSString *albumName = [songMediumItem valueForProperty: MPMediaItemPropertyAlbumTitle];
                NSString *artistName = [songMediumItem valueForProperty: MPMediaItemPropertyArtist];
                NSString *songTitle =  [songMediumItem valueForProperty: MPMediaItemPropertyTitle];
                NSNumber *persistentSongItemId = [songMediumItem valueForProperty:MPMediaItemPropertyPersistentID];
                
                NSLog(@"artist %@ album %@ song %@", artistName, albumName, songTitle);
//                ArtistAlbum *artistAlbum = [songSortingArray objectForKey:albumName];
//                if (!artistAlbum) {
//                    artistAlbum = [[ArtistAlbum alloc] initWithArtistName:artistName albumName:albumName];
//                    [songSortingArray setObject:artistAlbum forKey:albumName];
//                    [artistAlbum release];
//                }
//                Song *song = [[[Song alloc] init] autorelease];
//                song.songTitle = songTitle;
//                song.songPersistenceId = persistentSongItemId;
//                [artistAlbum addSong:song];
//                songCount++;
            }
            
//            NSArray *albumKeys = [songSortingArray keysSortedByValueUsingComparator:^(id obj1, id obj2) {
//                ArtistAlbum *one = (ArtistAlbum*)obj1;
//                ArtistAlbum *two = (ArtistAlbum*)obj2;
//                
//                NSString *albumName1 = one.album.albumName;
//                NSString *albumName2 = two.album.albumName;
//                return [albumName1 localizedCaseInsensitiveCompare:albumName2];
//            }];
//            
//            for (NSString *albumKey in albumKeys) {
//                [artists addObject:[songSortingArray objectForKey:albumKey]];
//            }
//            
//            [songSortingArray removeAllObjects];
        }
        
        return [NSDictionary dictionaryWithObjectsAndKeys: artists, @"artists", [NSNumber numberWithInt:songCount], @"songCount", nil];
}
@end
