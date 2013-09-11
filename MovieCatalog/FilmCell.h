//
//  FilmCell.h
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilmCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *coverImage;
@property(strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) IBOutlet UIButton *favouriteButton;


@end
