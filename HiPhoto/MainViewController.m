//
//  ViewController.m
//  HiPhoto
//
//  Created by Mert Akanay on 3/28/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "MainViewController.h"
#import "PictureDownloader.h"
#import "Picture.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *favouritesButton;

@property PictureDownloader *downloader;
@property NSArray *picturesArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.favouritesButton.enabled = NO;

}
- (IBAction)onSearchButtonTapped:(UIButton *)sender {

    self.downloader = [PictureDownloader new];
    self.downloader.delegate = self;
    [self.downloader pullPicturesFromAPIaccordingtoString:self.searchBar.text];
}

-(void)pictureArrayIsEqualTo:(NSArray *)array
{
    self.picturesArray = array;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
