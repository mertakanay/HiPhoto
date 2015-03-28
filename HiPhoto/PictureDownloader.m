//
//  PictureDownloader.m
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "PictureDownloader.h"
#import "MainViewController.h"

@implementation PictureDownloader

-(void)pullPicturesFromAPI
{
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=280154677.df48347.c9d771689060439897d32367dbbca723",self.searchText];
    NSURL *newUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:newUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *photoDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *photosArray = [photoDictionary objectForKey:@"data"];

        [self.delegate gotPictures:photosArray];
    }];
}

@end
