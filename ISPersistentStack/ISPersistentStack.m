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

+ (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
}

+ (NSURL *)sqliteStoreURL
{
    NSArray *URLs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentURL = [URLs lastObject];
    return [documentURL URLByAppendingPathComponent:@"Model.sqlite"];
}

#pragma mark - accessors

- (BOOL)shouldDropDatabase
{
    NSURL *URL = [[self class] sqliteStoreURL];
    NSError *error = nil;
    NSDictionary *metaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:URL error:&error];
    if (error) {
        if (error.code == 260) {
            return NO;
        } else {
            NSLog(@"could not obtain metadata of persistent store: %@(%@)", error, [error userInfo]);
            return YES;
        }
    }
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
    return ![model isConfiguration:nil compatibleWithStoreMetadata:metaData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        NSURL *modelURL = [[self class] modelURL];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSURL *storeURL = [[self class] sqliteStoreURL];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error = nil;
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    
    return _managedObjectContext;
}

#pragma mark -

- (void)dropDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *storeURL = [[self class] sqliteStoreURL];
    
    if ([fileManager fileExistsAtPath:[storeURL path]]) {
        NSError *error = nil;
        if (![fileManager removeItemAtURL:storeURL error:&error]) {
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
