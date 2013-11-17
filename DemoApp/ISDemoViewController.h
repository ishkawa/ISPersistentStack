#import <UIKit/UIKit.h>

@interface ISDemoViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

- (IBAction)insertNewObject;

@end
