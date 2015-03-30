//
//  PictureViewController.h
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"

@interface PictureViewController : UIViewController

@property Picture *picture;
@property NSMutableArray *pictureArray;
@property NSMutableArray *imageArray;
@property NSMutableArray *nImageArray;
@property NSMutableArray *nPictureArray;

@end
