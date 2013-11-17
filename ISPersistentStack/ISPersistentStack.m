#import "ISPersistentStack.h"

@implementation ISPersistentStack

@synthesize managedObjectContext = _managedObjectContext;

+ (instancetype)sharedStack
{
    static ISPersistentStack *stack;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[ISPersistentStack alloc] init];
    });
    
    return stack;
}

#pragma mark - accessors

- (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
}

- (NSURL *)storeURL
{
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentURL = [URLs lastObject];
    return [documentURL URLByAppendingPathComponent:@"Model.sqlite"];
}

- (BOOL)isCompatibleWithCurrentStore
{
    NSError *error = nil;
    NSDictionary *metaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:self.storeURL error:&error];
    if (error) {
        if (error.code == NSFileReadNoSuchFileError) {
            return YES;
        } else {
            NSLog(@"could not obtain metadata of persistent store: %@(%@)", error, [error userInfo]);
            return NO;
        }
    }
    
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    return [model isConfiguration:nil compatibleWithStoreMetadata:metaData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    
    return _managedObjectContext;
}

#pragma mark -

- (void)deleteCurrentStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self.storeURL path]]) {
        NSError *error = nil;
        if (![fileManager removeItemAtURL:self.storeURL error:&error]) {
            NSLog(@"error: %@", error);
            abort();
        }
    }
    
    _managedObjectContext = nil;
}

- (void)saveContext
{
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            [NSException raise:NSGenericException format:@"%@", error];
        }
    }];
}

@end
