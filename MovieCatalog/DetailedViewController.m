//
//  DetailedViewController.m
//  MovieCatalog
//
//  Created by Gavrina Maria on 14.08.13.
//
//

#import "DetailedViewController.h"
#import "AddFilmViewController.h"

@interface DetailedViewController ()

@end

@implementation DetailedViewController

@synthesize genreLabel = _genreLabel, yearLabel = _yearLabel, descriptionTextView = _descriptionTextView, coverImage = _coverImage, editButton = _editButton, viewedFilm = _viewedFilm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.viewedFilm.name;
    self.yearLabel.text = [self.viewedFilm.year stringValue];
    self.genreLabel.text = self.viewedFilm.genre;
    self.descriptionTextView.text = self.viewedFilm.fdescription;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setAddFilm:self.viewedFilm];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.title = self.viewedFilm.name;
    if (![self.viewedFilm.year isEqualToNumber:[NSNumber numberWithInt:0]])
        self.yearLabel.text = [self.viewedFilm.year stringValue];
    else
        self.yearLabel.text = @"-";
    
    if ([self.viewedFilm.genre length] > 0)
        self.genreLabel.text = self.viewedFilm.genre;
    else
        self.genreLabel.text = @"-";
    
    if ([self.viewedFilm.fdescription length] > 0)
        self.descriptionTextView.text = self.viewedFilm.fdescription;
    else
        self.descriptionTextView.text = @"-";
    
    if ([self.viewedFilm.image_name length] > 0)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:self.viewedFilm.image_name];
        
        self.coverImage.image = [[UIImage alloc] initWithContentsOfFile:filePath];
    }
}

- (void)viewDidUnload
{
    [self setGenreLabel:nil];
    [self setYearLabel:nil];
    [self setDescriptionTextView:nil];
    [self setCoverImage:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
}

@end
