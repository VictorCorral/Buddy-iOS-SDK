//
//  NSObject+ToJSON.h
//  BuddySDK
//
//  Created by Erik Kerber on 2/6/14.
//
//

#import <Foundation/Foundation.h>
#import "BuddyObject+Private.h"

@interface NSObject (ToJSON)

- (NSDictionary *)bp_parametersFromProtocol:(Protocol *)protocol;
- (NSDictionary *)bp_parametersFromProperties;
- (NSDictionary *)bp_parametersFromProperties:(NSArray *)keys;


@end
