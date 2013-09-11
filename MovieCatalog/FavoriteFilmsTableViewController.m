//
//  FavoriteFilmsTableViewController.m
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FavoriteFilmsTableViewController.h"
#import "CatalogClient.h"

@implementation FavoriteFilmsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fetchedFilms = [[CatalogClient sharedInstance] fetchCatalogFavorites];
}

-(void) viewWillAppear:(BOOL)animated
{
    fetchedFilms = [[CatalogClient sharedInstance] fetchCatalogFavorites];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
