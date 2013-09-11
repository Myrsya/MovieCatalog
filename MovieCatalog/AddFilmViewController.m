//
//  AddFilmViewController.m
//  MovieCatalog
//
//  Created by Gavrina Maria on 14.08.13.
//
//

#import <QuartzCore/QuartzCore.h>
#import "AddFilmViewController.h"
#import "CatalogClient.h"

@interface AddFilmViewController ()

@end


@implementation AddFilmViewController
{
    bool keyboardIsShown;
    NSString *imageName;
    NSArray *genresForPicker;
}

@synthesize nameInput = _nameInput, genreInput = _genreInput, yearInput = _yearInput, descInput = _descInput, imagePick = _imagePick, saveButton = _saveButton, cancelButton = _cancelButton, contentView = _contentView, scrollView = _scrollView, addFilm = _addFilm;


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![self.addFilm.name isEqual: @""])
    {
        self.nameInput.text = self.addFilm.name;
        self.genreInput.text = self.addFilm.genre;
        
        if (![self.addFilm.year isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            self.yearInput.text = [self.addFilm.year stringValue];
        }
        
        self.descInput.text = self.addFilm.fdescription;
        
        if ([self.addFilm.image_name length] > 0)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:self.addFilm.image_name];
            
            self.imagePick.image = [[UIImage alloc] initWithContentsOfFile:filePath];
            imageName = self.addFilm.image_name;
        }
    }
    
    //autosize scrollview
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    [self.scrollView setContentSize:(CGSizeMake(self.scrollView.contentSize.width, scrollViewHeight))];
    
    //backgroundTap
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    //imageTap
    self.imagePick.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imagePick addGestureRecognizer:imageTap];
    
    //genre show picker
    genresForPicker =[NSArray arrayWithObjects:@"-", @"Comedy", @"Drama", @"Thriller", @"Detective", @"Mystery",@"Fantasy", nil];
    [self.genreInput addTarget:self action:@selector(showPicker)forControlEvents:UIControlEventEditingDidBegin];
    
    //year picker toolbar
    [self.yearInput addTarget:self action:@selector(showToolbar)forControlEvents:UIControlEventEditingDidBegin];
    
    //textView
    self.descInput.layer.cornerRadius = 8.0;
    
    //for keyboard
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [self setNameInput:nil];
    [self setGenreInput:nil];
    [self setYearInput:nil];
    [self setDescInput:nil];
    [self setImagePick:nil];
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setSaveButton:nil];
    [self setCancelButton:nil];
    [super viewDidUnload];
}

#pragma mark - Keyboard and scrollview handle
-(void) keyboardDidShow:(NSNotification *) notification {
    if (keyboardIsShown) return;
    
    NSDictionary* info = [notification userInfo];
    
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height -= keyboardRect.size.height;
    self.scrollView.frame = viewFrame;
    
    keyboardIsShown = YES;
}

-(void) keyboardDidHide:(NSNotification *) notification {
    NSDictionary* info = [notification userInfo];
    

    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect =[self.view convertRect:[aValue CGRectValue] fromView:nil];
    
    CGRect viewFrame = [self.scrollView frame];
    viewFrame.size.height += keyboardRect.size.height;
    self.scrollView.frame = viewFrame;
    
    keyboardIsShown = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-60) animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.nameInput resignFirstResponder];
    [self.genreInput resignFirstResponder];
    [self.yearInput resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.scrollView setContentOffset:CGPointMake(0,textView.center.y-100) animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }
    return YES;
}

- (IBAction)backgroundTap:(id)sender {
    [self.nameInput resignFirstResponder];
    [self.genreInput resignFirstResponder];
    [self.yearInput resignFirstResponder];
    [self.descInput resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - image picker
- (IBAction)imageTapped:(id)sender {
    UIImagePickerController *picker; 
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    UIImage *pickedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSData *pngData = UIImagePNGRepresentation(pickedImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];

    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    imageName = [NSString stringWithFormat:@"%@.png", guid];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
    [pngData writeToFile:filePath atomically:YES];
    
    self.imagePick.image = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    return;
}

#pragma mark - Year textfield toolbar
-(void) showToolbar
{
    UIToolbar* buttonToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    buttonToolbar.barStyle = UIBarStyleBlackTranslucent;
    buttonToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumpadToolbar)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneNumpadToolbar)],
                           nil];
    [buttonToolbar sizeToFit];
    self.yearInput.inputAccessoryView = buttonToolbar;
}

-(void)cancelNumpadToolbar
{
    [self.yearInput resignFirstResponder];
    self.yearInput.text = @"";
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)doneNumpadToolbar
{
    [self.yearInput resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - Genre textfield + picker

-(void) showPicker
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,240,220,0)];
    
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;    
    [self.genreInput setInputView:pickerView];
    
    UIToolbar* buttonToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    buttonToolbar.barStyle = UIBarStyleBlackTranslucent;
    buttonToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPickerToolbar)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(donePickerToolbar)],
                           nil];
    [buttonToolbar sizeToFit];
    self.genreInput.inputAccessoryView = buttonToolbar;
}

-(void)cancelPickerToolbar
{
    [self.genreInput resignFirstResponder];
    self.genreInput.text = @"";
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)donePickerToolbar
{
    [self.genreInput resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [genresForPicker count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.genreInput.text=[genresForPicker objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [genresForPicker objectAtIndex:row];
    [pickerView removeFromSuperview];
}


#pragma mark - Buttons handle
- (IBAction)cancelPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)savePressed:(id)sender {
    // name is nesesary
    if ([self.nameInput.text length] == 0)
    {
        UIAlertView *alertName = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Вы не указали название!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertName show];
    }
    //everything is OK
    else
    {
        //new Entry
        if (![[CatalogClient sharedInstance] checkIfExist:self.addFilm])
        {
            if ([[CatalogClient sharedInstance] checkIfNameIsFree:self.nameInput.text])
            {
                [[CatalogClient sharedInstance] createNewFilmWithName:self.nameInput.text
                                                                genre:([self.genreInput.text isEqual: @"-"] ? @"" : self.genreInput.text)
                                                                 year:[NSNumber numberWithInt:[self.yearInput.text intValue]]
                                                         fdescription:self.descInput.text
                                                           image_name:imageName];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alertYear = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Такое название уже существует!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertYear show];
            }
        }
        //edit Entry
        else
        {
            //name must be unique
            bool nameCheck = ([[CatalogClient sharedInstance] checkIfNameIsFree:self.nameInput.text]) || ([self.addFilm.name isEqual:self.nameInput.text] );
            if (nameCheck)
            {
                [[CatalogClient sharedInstance] editFilmWithID:[self.addFilm objectID]
                                                          name:self.nameInput.text
                                                         genre:([self.genreInput.text isEqual: @"-"] ? @"" : self.genreInput.text)
                                                          year:[NSNumber numberWithInt:[self.yearInput.text intValue]]
                                                  fdescription:(NSString *)self.descInput.text
                                                    image_name:imageName];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alertYear = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Такое название уже существует!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertYear show];
            }
        }
    }
}

@end
