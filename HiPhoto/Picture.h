//
//  Picture.h
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Picture : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary onImageView:(UIImage *)image;

@end
