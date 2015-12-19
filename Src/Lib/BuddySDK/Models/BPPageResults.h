#import "BPModelBase.h"

#define BPSearch BPPageResults

@interface BPPageResults : NSObject

@property (nonatomic,strong) NSString *currentToken;
@property (nonatomic,strong) NSString *previousToken;
@property (nonatomic,strong) NSString *nextToken;

@property (nonatomic,strong) NSArray *pageResults;

-(NSArray*) convertPageResultsToType:(Class)clazz;
@end
