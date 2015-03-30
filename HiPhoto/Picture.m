//
//  Picture.m
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "Picture.h"

@interface Picture () <NSCoding>

@end

@implementation Picture

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    NSString *url = [[[dictionary objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
    NSURL *imageUrl = [NSURL URLWithString:url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    self.image = [UIImage imageWithData:imageData];
    self.caption = [[dictionary objectForKey:@"caption"] objectForKey:@"text"];

    if ([dictionary objectForKey:@"location"] != [NSNull null])
    {
        self.latitude = [[dictionary objectForKey:@"location"] objectForKey:@"latitude"];
        self.longitude = [[dictionary objectForKey:@"location"] objectForKey:@"longitude"];
        self.newCoordinate = CLLocationCoordinate2DMake(self.latitude.doubleValue, self.longitude.doubleValue);
    }

    return self;
}

//-(void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.image forKey:@"image"];
//    [encoder encodeObject:self.longitude forKey:@"longitude"];
//    [encoder encodeObject:self.latitude forKey:@"latitude"];
//    [encoder encodeObject:self.caption forKey:@"caption"];
//}
//
//-(instancetype)initWithCoder:(NSCoder *)decoder
//{
//    self = [super init];
//    if (self)
//    {
//        self.image = [decoder decodeObjectForKey:@"image"];
//        self.longitude = [decoder decodeObjectForKey:@"longitude"];
//        self.latitude = [decoder decodeObjectForKey:@"latitude"];
//        self.caption = [decoder decodeObjectForKey:@"caption"];
//    }
//    return self;
//}

@end
