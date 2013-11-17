#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ISManagedObject : NSManagedObject

@property (nonatomic, retain) NSNumber *identifier;
@property (nonatomic, retain) NSString *name;

+ (NSString *)entityName;

@end
