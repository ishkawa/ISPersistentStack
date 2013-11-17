#import <Foundation/Foundation.h>

@interface ISPersistentStack : NSObject

@property (nonatomic, readonly, getter = isCompatibleWithCurrentStore) BOOL compatibleWithCurrentStore;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (instancetype)sharedStack;
+ (NSURL *)modelURL;
+ (NSURL *)storeURL;

- (void)deleteCurrentStore;
- (void)saveContext;

@end
