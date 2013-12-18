#import <SenTestingKit/SenTestingKit.h>
#import <CoreData/CoreData.h>
#import <OCMock/OCMock.h>
#import "ISPersistentStack.h"

@interface ISPersistentStackTests : SenTestCase {
    ISPersistentStack *persistentStack;
}

@end

@implementation ISPersistentStackTests

- (void)setUp
{
    [super setUp];
    
    persistentStack = [[ISPersistentStack alloc] init];
}

- (void)tearDown
{
    persistentStack = nil;
    
    [super tearDown];
}

- (void)testStacks
{
    STAssertNotNil(persistentStack.managedObjectContext, @"context should exist.");
    STAssertNotNil(persistentStack.managedObjectContext.persistentStoreCoordinator, @"coordinator should exist.");
    STAssertNotNil(persistentStack.managedObjectContext.persistentStoreCoordinator.managedObjectModel, @"model should exist.");
}

- (void)testIsCompatible
{
    id mock = [OCMockObject mockForClass:[NSPersistentStoreCoordinator class]];
    [[[mock stub] andReturn:@{@"key": @"value"}] metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                              URL:persistentStack.storeURL
                                                                            error:[OCMArg setTo:nil]];
    
    STAssertFalse(persistentStack.isCompatibleWithCurrentStore,
                  @"stack should be incompatible with current store if meta data is invalid.");
}

- (void)testDropDatabase
{
    NSManagedObjectContext *previousContext = persistentStack.managedObjectContext;
    NSPersistentStoreCoordinator *previousCoordinator = persistentStack.persistentStoreCoordinator;
    NSManagedObjectModel *previousModel = persistentStack.managedObjectModel;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    id mock = [OCMockObject partialMockForObject:fileManager];
    [[[mock stub] andReturnValue:@YES] fileExistsAtPath:persistentStack.storeURL.path];
    [[[mock expect] andReturnValue:@YES] removeItemAtURL:persistentStack.storeURL error:[OCMArg setTo:nil]];
    
    [persistentStack deleteCurrentStore];
    
    STAssertNoThrow([mock verify], @"item store URL was not removed.");
    STAssertTrue(persistentStack.managedObjectContext != previousContext, @"did not recreate context.");
    STAssertTrue(persistentStack.persistentStoreCoordinator != previousCoordinator, @"did not recreate coordinator.");
    STAssertTrue(persistentStack.managedObjectModel != previousModel, @"did not recreate model.");
}

- (void)testSaveContext
{
    id mock = [OCMockObject partialMockForObject:persistentStack.managedObjectContext];
    [[[mock expect] andReturnValue:@YES] save:[OCMArg setTo:nil]];
    
    [persistentStack saveContext];
    
    STAssertNoThrow([mock verify], @"save: was not invoked.");
}

@end
