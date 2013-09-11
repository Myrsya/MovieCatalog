//
//  BaseTableViewController.h
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Film.h"

@interface BaseTableViewController : UITableViewController
{
    NSArray *fetchedFilms;
    Film *tempFilm;
}

@property (strong, nonatomic) IBOutlet UITableView *filmsTable;

@end
