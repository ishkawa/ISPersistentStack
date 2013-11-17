#import "ISAppDelegate.h"
#import "ISPersistentStack.h"

@implementation ISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ISPersistentStack *persistentStack = [ISPersistentStack sharedStack];
    if (!persistentStack.isCompatibleWithCurrentStore) {
        [persistentStack deleteCurrentStore];
    }
    
    return YES;
}

@end
