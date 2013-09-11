//
//  BaseTableViewController.m
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BaseTableViewController.h"
#import "CatalogClient.h"
#import "DetailedViewController.h"
#import "FilmCell.h"

@implementation BaseTableViewController

@synthesize filmsTable = _FilmsTable;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
}

- (void)viewDidUnload
{
    [self setFilmsTable:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.filmsTable reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath)
    {
        Film *viewedFilm = [fetchedFilms objectAtIndex:indexPath.row];
        [segue.destinationViewController setViewedFilm:viewedFilm];
    }
}

#pragma mark - manage add to/remove from favorites
-(IBAction)favouriteButtonTapped:(id)sender
{
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [self.filmsTable indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    tempFilm = [fetchedFilms objectAtIndex:indexPath.row];
    if ([tempFilm.isFavourite boolValue])
    {
        [[CatalogClient sharedInstance] editFavoritesCategoryForFilmWithName:tempFilm.name withValue:NO];
    }
    else
    {
        [[CatalogClient sharedInstance] editFavoritesCategoryForFilmWithName:tempFilm.name withValue:YES];
    }
    
    if ([[[self class] description] isEqualToString:@"FavoriteFilmsTableViewController"])
    {
        fetchedFilms = [[CatalogClient sharedInstance] fetchCatalogFavorites];
    }
    
    [self.filmsTable reloadData];
    
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fetchedFilms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FilmCell";
    
    FilmCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FilmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([fetchedFilms count] >0)
    {
        tempFilm = [fetchedFilms objectAtIndex:indexPath.row];
        
        //name
        cell.titleLabel.text = tempFilm.name;
        
        //details
        NSString *detailString;
        if ([tempFilm.genre length] == 0)
        {
            if ([tempFilm.year isEqualToNumber:[NSNumber numberWithInt:0]])
                detailString = [NSString stringWithFormat:@" "];
            else
                detailString = [NSString stringWithFormat:@"%@", tempFilm.year];
        }
        else
        {
            if ([tempFilm.year isEqualToNumber:[NSNumber numberWithInt:0]])
                detailString = [NSString stringWithFormat:@"%@", tempFilm.genre];
            else
                detailString = [NSString stringWithFormat:@"%@, %@", tempFilm.genre, tempFilm.year];
        }
        cell.subtitleLabel.text = detailString;
        
        //favorite
        [cell.favouriteButton addTarget:self action:@selector(favouriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if ([tempFilm.isFavourite boolValue])
        {
            [cell.favouriteButton setImage:[UIImage imageNamed:@"yellowstar.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.favouriteButton setImage:[UIImage imageNamed:@"whitestar.png"] forState:UIControlStateNormal];
        }
                
        //cover_image
        if ([tempFilm.image_name length] > 0)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *filePath = [documentsPath stringByAppendingPathComponent:tempFilm.image_name];
            
            cell.coverImage.image = [[UIImage alloc] initWithContentsOfFile:filePath];
        }
        else
        {
            cell.coverImage.image = [UIImage imageNamed:@"empty_image.png"];
        }
    }
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[CatalogClient sharedInstance] deleteFilm:[fetchedFilms objectAtIndex:indexPath.row]];
        fetchedFilms = [[CatalogClient sharedInstance] fetchCatalogFeed];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
