#import "ISDemoViewController.h"
#import "ISManagedObject.h"
#import "ISPersistentStack.h"

@implementation ISDemoViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSManagedObjectContext *context = [ISPersistentStack sharedStack].managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[ISManagedObject entityName]];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:NO]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        [NSException raise:NSInternalInconsistencyException format:@"%@", error];
    }
}

- (void)insertNewObject
{
    ISPersistentStack *persistentStack = [ISPersistentStack sharedStack];
    NSManagedObjectContext *context = persistentStack.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:[ISManagedObject entityName] inManagedObjectContext:context];
    ISManagedObject *object = [[ISManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    object.identifier = @([self.fetchedResultsController.fetchedObjects count]);
    object.name = [NSString stringWithFormat:@"Object %@", object.identifier];
    [persistentStack saveContext];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ISManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = object.name;
    
    return cell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
