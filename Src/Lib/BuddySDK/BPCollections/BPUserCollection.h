//
//  BPUserCollection.h
//  BuddySDK
//
//  Created by Erik Kerber on 1/20/14.
//
//

#import "BuddyCollection.h"
#import "BPUser.h"

@interface BPUserCollection : BuddyCollection

- (void)getUser:(NSString *)userId callback:(BuddyObjectCallback)callback;
- (void)searchUsers:(BPSearchUsers *)searchUsers callback:(BPSearchCallback)callback;
- (void)getUserIdForIdentityProvider:(NSString *)identityProvider identityProviderId:(NSString *)identityProviderId callback:(BuddyIdCallback)callback;

@end
