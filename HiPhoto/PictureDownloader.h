//
//  PictureDownloader.h
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PictureDownloaderDelegate <NSObject>

-(void) gotPictures:(NSArray *)array;

@end

@interface PictureDownloader : NSObject

@property id<PictureDownloaderDelegate>delegate;

-(void)pullPicturesFromAPIaccordingtoString:(NSString *)string;

@end
