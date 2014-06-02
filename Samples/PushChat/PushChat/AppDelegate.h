//
//  AppDelegate.h
//  PushChat
//
//  Created by Nick Ambrose on 5/30/14.
//  Copyright (c) 2014 Buddy Platform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BuddySDK/Buddy.h>

@class MainViewController;
@class ChannelList;
@class ReceivedMessageTable;

#define CommonAppDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate,BPClientDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) UINavigationController *navController;
@property (nonatomic,strong) MainViewController *topController;
@property (nonatomic,assign) BOOL loginPresented;

@property (nonatomic,strong) ChannelList* channels;
@property (nonatomic,strong) ReceivedMessageTable *receivedMessages;

-(void) storeUsername:(NSString*)userName;
-(NSString*) fetchUsername;
-(BOOL) isUsernameSet;

/* Store this in a more secure place than User Preferences in a real App */

-(void) storePassword:(NSString*)userName;
-(NSString*) fetchPassword;
-(BOOL) isPasswordSet;

-(void) storeUsername:(NSString *)userName andPassword:(NSString*)password;

-(void) authorizationNeedsUserLogin;

@end
