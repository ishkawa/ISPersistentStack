#import <Foundation/Foundation.h>

@interface ISPersistentStack : NSObject

@property (nonatomic, readonly, getter = isCompatibleWithCurrentStore) BOOL compatibleWithCurrentStore;

@property (nonatomic, readonly) NSURL *modelURL;
@property (nonatomic, readonly) NSURL *storeURL;

@property (nonatomic, readonly) NSManagedObjectModel         *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext       *managedObjectContext;

+ (instancetype)sharedStack;

- (void)deleteCurrentStore;
- (void)saveContext;

@end
