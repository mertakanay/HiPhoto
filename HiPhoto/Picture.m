//
//  Picture.m
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "Picture.h"

@implementation Picture

-(instancetype)initWithDictionary:(NSDictionary *)dictionary onImageView:(UIImage *)image
{
    NSDictionary *dictionary2 = [dictionary objectForKey:@"images"];
    NSURL *imageUrl = [dictionary2 objectForKey:@"standard_resolution"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    image = [UIImage imageWithData:imageData];

    return self;
}

@end
