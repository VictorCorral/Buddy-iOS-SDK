//
//  BPUser.m
//  BuddySDK
//
//  Created by Erik Kerber on 11/15/13.
//
//

#import "BPUser.h"
#import "BuddyObject+Private.h"
#import "BPUser+Private.h"
#import "BPClient.h"
#import "BPEnumMapping.h"
#import "BPIdentityValue.h"
#import "BPPicture.h"
#import "BPSize.h"

@implementation BPSearchUsers

@synthesize firstName, lastName, userName, gender, dateOfBirth, profilePictureUrl, profilePictureID, email, locationFuzzing, celebMode,userListId;

@end

@interface BPUser()
@property (nonatomic, copy) NSString *profilePictureID;
@property (nonatomic, copy) NSString *profilePictureUrl;
@property (copy, nonatomic) NSString *accessToken;
@end

@implementation BPUser

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize userName = _userName;
@synthesize gender = _gender;
@synthesize dateOfBirth = _dateOfBirth;
@synthesize profilePictureUrl = _profilePictureUrl;
@synthesize profilePictureID = _profilePictureID;
@synthesize email = _email;
@synthesize locationFuzzing = _locationFuzzing;
@synthesize celebMode = _celebMode;

- (void)registerProperties
{
    [super registerProperties];
    
    [self registerProperty:@selector(firstName)];
    [self registerProperty:@selector(lastName)];
    [self registerProperty:@selector(userName)];
    [self registerProperty:@selector(gender)];
    [self registerProperty:@selector(dateOfBirth)];
    [self registerProperty:@selector(profilePictureUrl)];
    [self registerProperty:@selector(profilePictureID)];
    [self registerProperty:@selector(email)];
    [self registerProperty:@selector(locationFuzzing)];
    [self registerProperty:@selector(celebMode)];
}

+ (NSDictionary *)enumMap
{
    return [[[self class] baseEnumMap] dictionaryByMergingWith: @{
                                                                  NSStringFromSelector(@selector(gender)) : @{
                                                                          @(BPUserGender_Unknown) : @"Unknown",
                                                                          @(BPUserGender_Male) : @"Male",
                                                                          @(BPUserGender_Female) : @"Female",
                                                                          },
                                                                  }];
}

static NSString *users = @"users";
+(NSString *)requestPath
{
    return users;
}

-(NSInteger)age
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                               fromDate:self.dateOfBirth
                                                 toDate:[NSDate date]
                                                options:0];
    
    return components.year;
}

#pragma mark - Password

- (void)requestPasswordResetWithSubject:(NSString *)subject body:(NSString *)body callback:(BuddyObjectCallback)callback
{
    NSString *resource = @"users/password";
    NSDictionary *parameters = @{@"username": self.userName,
                                 @"subject": BOXNIL(subject),
                                 @"body": BOXNIL(body)};
                                 

    [self.client POST:resource parameters:parameters callback:^(id json, NSError *error) {
        callback ? callback(json, nil) : nil;
    }];
}

- (void)resetPassword:(NSString *)resetCode newPassword:(NSString *)newPassword callback:(BuddyCompletionCallback)callback
{
    NSString *resource = @"users/password";
    NSDictionary *parameters = @{@"username": self.userName,
                                 @"resetCode": BOXNIL(resetCode),
                                 @"newPassword": BOXNIL(newPassword)};
    
    [self.client PATCH:resource parameters:parameters callback:^(id json,  NSError *error) {
        callback ? callback(error) : nil;
    }];
}
@end
