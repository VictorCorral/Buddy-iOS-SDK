//
//  BPCheckinCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BuddyCollection.h"
#import "BPLocation.h"
#import "BPCoordinate.h"

@interface BPLocationCollection : BuddyCollection

- (void)addLocation:(BPLocation *)location
           callback:(BuddyCompletionCallback)callback;
- (void)getLocation:(NSString *)locationId callback:(BuddyObjectCallback)callback;
- (void)searchLocation:(BPSearchLocation *)searchLocations callback:(BuddyCollectionCallback)callback;

@end
