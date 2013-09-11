//
//  AllFilmsTableViewController.m
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AllFilmsTableViewController.h"
#import "CatalogClient.h"

@implementation AllFilmsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fetchedFilms = [[CatalogClient sharedInstance] fetchCatalogFeed];
}

-(void) viewWillAppear:(BOOL)animated
{
    fetchedFilms = [[CatalogClient sharedInstance] fetchCatalogFeed];
    
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
