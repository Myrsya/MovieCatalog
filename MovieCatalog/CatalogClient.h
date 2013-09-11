//
//  CatalogClient.h
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Film.h"

@interface CatalogClient : NSObject

@property(retain, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property(retain, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property(retain, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (CatalogClient *)sharedInstance;

-(BOOL)createNewFilmWithName:(NSString *)paramName
                       genre:(NSString *)paramGenre
                        year:(NSNumber *)paramYear
                fdescription:(NSString *)paramFdescription
                  image_name:(NSString *)paramImage_name;

- (BOOL)editFilmWithID:(NSManagedObjectID *)filmId
                  name:(NSString *)paramName
                 genre:(NSString *)paramGenre
                  year:(NSNumber *)paramYear
          fdescription:(NSString *)paramFdescription
            image_name:(NSString *)paramImage_name;

-(NSArray *)fetchCatalogFeed;
-(NSArray *)fetchCatalogFavorites;

-(BOOL)checkIfExist:(Film *)film;
-(BOOL)checkIfNameIsFree:(NSString *)testName;

-(BOOL)editFavoritesCategoryForFilmWithName:(NSString *)name withValue:(BOOL)isFavorite;

-(BOOL)deleteFilm:(Film *)film;

@end
