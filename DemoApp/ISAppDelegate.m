#import "ISAppDelegate.h"
#import "ISPersistentStack.h"

@implementation ISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ISPersistentStack *persistentStack = [ISPersistentStack sharedStack];
    if (!persistentStack.isCompatibleWithCurrentStore) {
        [persistentStack deleteCurrentStore];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
