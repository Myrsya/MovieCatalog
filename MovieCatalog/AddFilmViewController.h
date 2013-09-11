//
//  AddFilmViewController.h
//  MovieCatalog
//
//  Created by Gavrina Maria on 14.08.13.
//
//

#import <UIKit/UIKit.h>
#import "Film.h"

@interface AddFilmViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameInput;
@property (strong, nonatomic) IBOutlet UITextField *genreInput;
@property (strong, nonatomic) IBOutlet UITextField *yearInput;
@property (strong, nonatomic) IBOutlet UITextView *descInput;
@property (strong, nonatomic) IBOutlet UIImageView *imagePick;

@property (strong, nonatomic) Film *addFilm;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@end
