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
                                                                              URL:[ISPersistentStack storeURL]
                                                                            error:[OCMArg setTo:nil]];
    
    STAssertTrue(persistentStack.isCompatibleWithCurrentStore,
                 @"stack should be incompatible with current store if meta data is invalid.");
}

- (void)testDropDatabase
{
    NSManagedObjectContext *previousContext = persistentStack.managedObjectContext;
    NSURL *storeURL = [ISPersistentStack storeURL];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    id mock = [OCMockObject partialMockForObject:fileManager];
    [[[mock stub] andReturnValue:@YES] fileExistsAtPath:storeURL.path];
    [[[mock expect] andReturnValue:@YES] removeItemAtURL:storeURL error:[OCMArg setTo:nil]];
    
    [persistentStack deleteCurrentStore];
    
    STAssertNoThrow([mock verify], @"item store URL was not removed.");
    STAssertTrue(persistentStack.managedObjectContext != previousContext, @"did not recreate context.");
}

- (void)testSaveContext
{
    id mock = [OCMockObject partialMockForObject:persistentStack.managedObjectContext];
    [[[mock expect] andReturnValue:@YES] save:[OCMArg setTo:nil]];
    
    [persistentStack saveContext];
    
    STAssertNoThrow([mock verify], @"save: was not invoked.");
}

@end