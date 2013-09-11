//
//  CatalogClient.m
//  MovieCatalog
//
//  Created by Mary Gavrina on 8/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "CatalogClient.h"

@implementation CatalogClient

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator, managedObjectModel = _managedObjectModel, managedObjectContext = _managedObjectContext;

+ (CatalogClient *)sharedInstance
{
    static CatalogClient *sharedObject = nil;
    @synchronized(self) {
        if (sharedObject == nil) {
            sharedObject = [[self alloc] init];            
        }
    }
    
    return sharedObject;
}

-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSError *error;
    NSString *const databaseFileName = @"catalog.sqlite";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSURL *storeURL = [NSURL fileURLWithPath: [documentDirectory stringByAppendingPathComponent:databaseFileName]];
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error ];
    if (error)
    {
        NSLog(@"database %@ ", [error localizedDescription]);
    }
    
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    return self;
}

-(BOOL)createNewFilmWithName:(NSString *)paramName 
                       genre:(NSString *)paramGenre 
                        year:(NSNumber *)paramYear
                fdescription:(NSString *)paramFdescription 
                  image_name:(NSString *)paramImage_name
{    
    if ([paramName length] == 0)
    {
        NSLog(@"You did not type film name!");
        return NO;
    }
    
    
    Film *newFilm = (Film *)[NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:_managedObjectContext];
    if (newFilm == nil)
    {
        NSLog(@"Failed to create Film!");
        return NO;
    }
    
    newFilm.name = paramName;
    newFilm.genre = paramGenre;
    newFilm.year = paramYear;
    newFilm.fdescription = paramFdescription;
    newFilm.image_name = paramImage_name;
    newFilm.isFavourite = [NSNumber numberWithBool:NO];
    
    NSError *error = nil;
    [_managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"save %@ ", [error localizedDescription]);
        return NO;
    }
        
    return YES;
}

- (NSArray *)fetchCatalogFeed
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Film"];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error;
    NSArray *allFilms = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@" %@ ", [error localizedDescription]);
        return nil;
    }
    return allFilms;
}

- (NSArray *)fetchCatalogFavorites
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Film"];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    request.predicate = [NSPredicate predicateWithFormat:@"isFavourite = 1"];
    
    NSError *error;
    NSArray *favoriteFilms = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@" %@ ", [error localizedDescription]);
        return nil;
    }
    return favoriteFilms;
}

- (BOOL)editFilmWithID:(NSManagedObjectID *)filmId
                  name:(NSString *)paramName
                 genre:(NSString *)paramGenre
                  year:(NSNumber *)paramYear
          fdescription:(NSString *)paramFdescription
            image_name:(NSString *)paramImage_name
{
    NSArray *allFilms = [self fetchCatalogFeed];
    for (Film *thisFilm in allFilms)
    {
        //found edited Film
        if([thisFilm objectID] == filmId)
        {
            thisFilm.name = paramName;
            thisFilm.genre = paramGenre;
            thisFilm.year = paramYear;
            thisFilm.fdescription = paramFdescription;
            thisFilm.image_name = paramImage_name;
           
            NSError *error = nil;
            [_managedObjectContext save:&error];
            if (error)
            {
                NSLog(@"save %@ ", [error localizedDescription]);
                return NO;
            }
            return YES;
            break;
        }
    }
    return NO;
}

-(BOOL)editFavoritesCategoryForFilmWithName:(NSString *)name withValue:(BOOL)isFavorite
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Film"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error1;
    NSArray *fetchedFilms = [_managedObjectContext executeFetchRequest:request error:&error1];
    if (error1)
    {
        NSLog(@"fetch %@ ", [error1 localizedDescription]);
        return NO;
    }
    Film *editFilm = [fetchedFilms objectAtIndex:0];
    editFilm.isFavourite = [NSNumber numberWithBool: isFavorite];
    
    NSError *error2;
    [_managedObjectContext save:&error2];
    if (error2)
    {
        NSLog(@"save %@ ", [error2 localizedDescription]);
        return NO;
    }
    return YES;  
}

-(BOOL)checkIfNameIsFree:(NSString *)testName
{
    BOOL result = NO;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Film"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", testName];
    
    NSError *error;
    NSArray *fetchedFilms = [_managedObjectContext executeFetchRequest:request error:&error];
    if (error)
    {
        NSLog(@" %@ ", [error localizedDescription]);
    }
    else if ([fetchedFilms count] == 0)
    {
        result = YES;
    }
    return result;
}

-(BOOL)checkIfExist:(Film *)film
{
    BOOL result = NO;
    NSArray *allFilms = [self fetchCatalogFeed];
    for (Film *thisFilm in allFilms)
    {
        if([thisFilm objectID] == [film objectID])
        {
            result = YES;
            break;
        }
    }
    return result;
}

-(BOOL)deleteFilm:(Film *)film
{
    [self.managedObjectContext deleteObject:film];
    NSError *error = nil;
    [_managedObjectContext save:&error];
    if (error)
    {
        NSLog(@"delete %@ ", [error localizedDescription]);
        return NO;
    }
    return YES;
}

@end
