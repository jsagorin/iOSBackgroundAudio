//
//  DetailViewController.h
//  BackgroundAudio
//
//  Created by Jonathan Sagorin on 7/20/12.
//  Copyright (c) 2012 Jonathan Sagorin. All rights reserved.

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *artistName;
@property (strong, nonatomic) NSNumber *songId;
@property (strong, nonatomic) NSString *songTitle;
@property (strong, nonatomic) NSString *albumName;

@end
