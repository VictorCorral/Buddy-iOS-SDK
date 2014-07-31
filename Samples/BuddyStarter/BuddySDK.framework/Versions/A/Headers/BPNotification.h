//
//  BPNotification.h
//  BuddySDK
//
//  Created by Erik.Kerber on 3/26/14.
//
//

#import <Foundation/Foundation.h>

/*
 None  = 0,
 Raw   = 1<<0,
 Alert = 1<<1,
 Badge = 1<<2,
 Toast = 1<<3,
 Sync  = 1<<4
 
 */
typedef NS_ENUM(NSInteger, BPNotificationType) {
    BPNotificationType_None=0,
    BPNotificationType_Raw = 1,
    BPNotificationType_Badge = 2,
    BPNotificationType_Alert = 4,
    BPNotificationType_Custom = 8
};

@interface BPNotification : NSObject

@property (assign, nonatomic) BPNotificationType notificationType;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *payload;
@property (assign, nonatomic) NSInteger counterValue;
@property (strong, nonatomic) NSString *osCustomData;
@property (strong, nonatomic) NSArray *recipients;

@end
