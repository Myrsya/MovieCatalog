//
//  DetailedViewController.h
//  MovieCatalog
//
//  Created by Gavrina Maria on 14.08.13.
//
//

#import <UIKit/UIKit.h>
#import "Film.h"

@interface DetailedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;

@property (strong, nonatomic) Film *viewedFilm;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
