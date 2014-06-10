//
//  BPPagingTokens.h
//  BuddySDK
//
//  Created by Erik.Kerber on 5/26/14.
//
//

@interface BPPagingTokens : NSObject

@property (strong, nonatomic) NSString *previousToken;
@property (strong, nonatomic) NSString *currentToken;
@property (strong, nonatomic) NSString *nextToken;

@end
