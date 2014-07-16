//
//  BuddyObject.h
//  BuddySDK
//
//  Created by Erik Kerber on 9/11/13.
//
//

#import <Foundation/Foundation.h>
#import "BPRestProvider.h"
#import "BPCoordinate.h"
#import "BPBase.h"
#import "BuddyCollection.h"

@interface BuddyObject : BPBase<BuddyObjectProperties>

@property (nonatomic, readonly, assign) BOOL deleted;
@property (nonatomic, readonly, assign) BOOL isDirty;


- (instancetype)initWithId:(NSString*)id;
- (instancetype)initWithId:(NSString*)id andClient:(id<BPRestProviderOld>)client;
- (void)registerProperty:(SEL)property;

+ (NSString *)requestPath;

- (void)destroy:(BuddyCompletionCallback)callback;
- (void)destroy;
- (void)refresh;
- (void)refresh:(BuddyCompletionCallback)callback;
- (void)save:(BuddyCompletionCallback)callback;

@end

@interface BPObjectSearch : NSObject<BuddyObjectProperties>

@property (nonatomic, strong) BPCoordinateRange *locationRange;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *pagingToken;
@property (nonatomic, copy) NSString *userID;

+(NSString*)pagingTokenFromPageSize:(unsigned long)pageSize;
+(NSString*)pagingTokenFromPageSize:(unsigned long)pageSize withSkip:(unsigned long)skipCount;
- (NSDictionary *)parametersFromDirtyProperties;

@end
