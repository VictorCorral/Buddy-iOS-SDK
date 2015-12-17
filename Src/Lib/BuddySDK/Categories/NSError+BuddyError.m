#import "Macro.h"
#import "NSError+BuddyError.h"

@implementation NSError (BuddyError)

static NSString *NoInternetError = @"NoInternetError";

+ (NSError *)bp_buildError:(NSInteger)httpResponseCode result:(id)result;
{
    NSError *buddyError;
    
    switch (httpResponseCode) {
        case 400:
        case 401:
        case 402:
        case 403:
        case 404:
        case 405:
        case 500:
            buddyError = [NSError buildBuddyError:result];
            break;
        default:
            buddyError = [NSError bp_noInternetError:httpResponseCode message:result];
            break;
    }
    
    return buddyError;
}

+ (NSError *)bp_noInternetError:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:NoInternetError
                               code:code
                           userInfo:@{@"message": BOXNIL(message)}];
}

+ (NSError *)buildBuddyError:(id)buddyJSON
{
    id json;
    if (![buddyJSON isKindOfClass:[NSDictionary class]]) {
        id jsonData = [buddyJSON dataUsingEncoding:NSUTF8StringEncoding]; //if input is NSString
        json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    } else {
        json = buddyJSON;
    }
    
    if (![NSJSONSerialization isValidJSONObject:json]) {
        return [NSError errorWithDomain:@"UnknownError" code:-1 userInfo:nil];
    }
    
    NSInteger buddyErrorCode = [json[@"errorNumber"] ?: @"0" integerValue];
    id buddyErrorDomain = json[@"error"] ?: @"";
    id message = json[@"message"] ?: @"";
    
    return [NSError errorWithDomain:buddyErrorDomain code:buddyErrorCode userInfo:@{@"message": message}];
}

- (BOOL)needsLogin
{
    return self.code == BPErrorAuthUserAccessTokenRequired;
}

- (BOOL)credentialsInvalid
{
    return  self.code == BPErrorAuthAppCredentialsInvalid ||
            self.code == BPErrorAuthAccessTokenInvalid;
}

- (BOOL)noInternet
{
    return [self.domain isEqualToString:NoInternetError];
}


+ (NSError *)invalidObjectOperationError
{
    NSDictionary *info = @{@"message": @"This operation is not allowed for objects not registered with the server.  Please add the object first via the appropriate create method."};
    return [NSError errorWithDomain:@"UnregisteredObjectError" code:1 userInfo:info];
}

@end
