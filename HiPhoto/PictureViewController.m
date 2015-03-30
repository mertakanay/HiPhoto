//
//  PictureViewController.m
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "PictureViewController.h"
#import "Picture.h"
#import "PictureDownloader.h"
#import <MapKit/MapKit.h>


@interface PictureViewController () <PictureDownloaderDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImageView *animatedImageView;
@property NSUInteger imageIndex;

@property NSDictionary *aDictionary;
@property NSString *caption;
@property NSNumber *latitude;
@property NSNumber *longitude;

@property (weak, nonatomic) IBOutlet UIButton *AddButton;
@property (weak, nonatomic) IBOutlet UIImageView *favImageView;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pictureArray = [NSMutableArray new]; //otherwise the value will be nil !!
    self.imageArray = [NSMutableArray new];
    self.nPictureArray = [NSMutableArray new];
    self.nImageArray = [NSMutableArray new];

    self.imageIndex = self.imageArray.count-1;
}

-(void) gotPictures:(NSArray *)array
{
    for (NSDictionary *dictionary in array)
    {
        self.picture = [[Picture alloc]initWithDictionary:dictionary];

        [self.pictureArray addObject:self.picture];
        [self.imageArray addObject:self.picture.image];

        self.imageView.image = self.imageArray[0];
    }

}

- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *)sender direction];

    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            self.imageIndex++;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            self.imageIndex--;
            break;
        default:
            break;
    }
    self.imageIndex = (self.imageIndex < 0) ? (self.imageArray.count-1):
    self.imageIndex % self.imageArray.count;
    self.imageView.image = self.imageArray[self.imageIndex];

}
- (IBAction)onAddButtonTapped:(UIButton *)sender
    {

//        if ([self.AddButton.titleLabel.text isEqualToString:@"Add Photos to Favourites"])
//        {
//            self.AddButton.tintColor = [UIColor redColor];
//            self.AddButton.backgroundColor = [UIColor orangeColor];
            [self.nImageArray addObject:self.imageView.image];
            NSUInteger index = [self.imageArray indexOfObject:self.imageView.image];
            [self.nPictureArray addObject:self.pictureArray[index]];
//            self.AddButton. = @"Remove from Favourites";
//        }

            if ([self.nImageArray containsObject:self.imageView.image])
            {
                self.favImageView.image = [UIImage imageNamed:@"Super_Star_NSMB2"];
            }
            else if (![self.nImageArray containsObject:self.imageView.image])
            {
                self.favImageView.image = nil;
            }

        
//        if([self.AddButton.titleLabel.text isEqualToString:@"Remove from Favourites"])
//        {
//            self.AddButton.titleLabel.textColor = [UIColor blueColor];
//            self.AddButton.titleLabel.backgroundColor = [UIColor cyanColor];
//            [self.nPictureArray removeObject:self.imageView.image];
//            self.AddButton.titleLabel.text = @"Add Photos to Favourites";
//        }
    }


@end
