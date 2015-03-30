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
#import "PictureViewController.h"
#import <MapKit/MapKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface MainViewController () <MKMapViewDelegate, UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIButton *favouritesButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (weak, nonatomic) IBOutlet UITabBar *tabBar;

@property PictureDownloader *downloader;
@property NSMutableArray *favPicArray;
@property NSMutableArray *favImageArray;

@property MKPointAnnotation *photoAnnotation;

@property NSUInteger imageIndex;

@end

@implementation MainViewController

NSString * const kUserDefaultsDate = @"theDate";

- (void)viewDidLoad {
    [super viewDidLoad];

    self.favPicArray = [NSMutableArray new];
    
    self.favouritesButton.enabled = NO;
    self.favouritesButton.hidden = YES;
    self.mapView.hidden = YES;

    [self load];

}

- (IBAction)onSearchButtonTapped:(UIButton *)sender {

    self.downloader = [PictureDownloader new];
    [self.downloader pullPicturesFromAPIaccordingtoString:self.searchBar.text];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PictureViewController *pictureVC = [segue destinationViewController];
    self.downloader.delegate = pictureVC;
}

-(IBAction)unwindSegueFromPictureViewController:(UIStoryboardSegue *)segue
{
    PictureViewController *pictureVC = [segue sourceViewController];
    self.favPicArray = pictureVC.nPictureArray;
    self.favImageArray = pictureVC.nImageArray;

    self.imageIndex = self.favImageArray.count;

    self.photoAnnotation = [MKPointAnnotation new];

    for (Picture *picture in self.favPicArray)//why is this messing up ??
    {
        self.photoAnnotation.coordinate = picture.newCoordinate;
        self.photoAnnotation.title = picture.caption;
        [self.mapView addAnnotation:self.photoAnnotation];
    }

    [self save];

}
- (IBAction)onSegmentedControlTapped:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        self.searchBar.hidden = NO;
        self.imageView.hidden = YES;
        self.favouritesButton.hidden = YES;
        self.favouritesButton.enabled = NO;
        self.mapView.hidden = YES;

    }
    else if (sender.selectedSegmentIndex == 1)
    {
        self.searchBar.hidden = YES;
        self.imageView.hidden = NO;
        self.favouritesButton.hidden = NO;
        self.favouritesButton.enabled = YES;
        self.mapView.hidden = YES;
        self.imageView.image = self.favImageArray[0];
    }
    else if (sender.selectedSegmentIndex == 2)
    {
        self.searchBar.hidden = YES;
        self.imageView.hidden = YES;
        self.favouritesButton.hidden = YES;
        self.favouritesButton.enabled = NO;
        self.mapView.hidden = NO;


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
    self.imageIndex = (self.imageIndex < 0) ? (self.favImageArray.count-1):
    self.imageIndex % self.favImageArray.count;
    self.imageView.image = self.favImageArray[self.imageIndex];

}
- (IBAction)onRemoveButtonTapped:(UIButton *)sender
{
    [self.favImageArray removeObject:self.imageView.image];
    NSUInteger index = [self.favPicArray indexOfObject:self.imageView.image];
    [self.favPicArray removeObject:self.favPicArray[index]];
}

//SAVING THE FAVOURITE PHOTOS THROUGH APP RESTARTS

-(void)save
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory1 = [paths objectAtIndex:0];
//    NSString *documentDirectory2 = [paths objectAtIndex:1];
    NSString *fullFileName1 = [NSString stringWithFormat:@"%@/FavouritedPhotosOnInstagram", documentDirectory1];
//    NSString *fullFileName2 = [NSString stringWithFormat:@"%@/FavouritedPhotosOnInstagram", documentDirectory2];
    [NSKeyedArchiver archiveRootObject:self.favImageArray toFile:fullFileName1];
//    [NSKeyedArchiver archiveRootObject:self.favPicArray toFile:fullFileName2];
}
-(void)load
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory1 = [paths objectAtIndex:0];
//    NSString *documentDirectory2 = [paths objectAtIndex:1];
    NSString *fullFileName1 = [NSString stringWithFormat:@"%@/FavouritedPhotosOnInstagram", documentDirectory1];
//    NSString *fullFileName2 = [NSString stringWithFormat:@"%@/FavouritedPhotosOnInstagram", documentDirectory2];
    self.favImageArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullFileName1] ?: [NSMutableArray new];
//    self.favPicArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullFileName2] ?: [NSMutableArray new];

}

//MAPKIT

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pinAnnotation.canShowCallout = YES;

    return pinAnnotation;
}

//TWITTER

- (IBAction)tweetMe:(UIButton *)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Hey, look at my favourite image which I am tweeting from my own app!"];
        [tweetSheet addImage:self.imageView.image];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

//EMAIL

- (IBAction)mailMe:(UIButton *)sender
{
    NSString *emailTitle = @"";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:nil];

//    UIImage *attachmentImage = self.imageView.image;
//    NSData *imageData = UIImagePNGRepresentation(attachmentImage);

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
//    [mc addAttachmentData:imageData mimeType:@"image/png" fileName:@"favouriteImage"];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
