#import <Foundation/Foundation.h>

@interface ISPersistentStack : NSObject

@property (nonatomic, readonly) BOOL shouldDropDatabase;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedStack;
+ (NSURL *)modelURL;
+ (NSURL *)sqliteStoreURL;

- (void)dropDatabase;
- (void)saveContext;

@end
