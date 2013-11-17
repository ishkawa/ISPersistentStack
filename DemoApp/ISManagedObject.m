#import "ISManagedObject.h"

@implementation ISManagedObject

@dynamic identifier;
@dynamic name;

+ (NSString *)entityName
{
    return NSStringFromClass([self class]);
}

@end
