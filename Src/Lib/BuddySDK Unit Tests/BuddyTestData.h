

#pragma message ("Go to http://buddyplatform.com to get an app ID and app key.")
#ifdef CI_APP_ID
#define APP_ID CI_APP_ID
#define APP_KEY CI_APP_KEY
#else
#define APP_ID @"Your App ID"
#define APP_KEY @"Your App Key"
#endif

#define TEST_USERNAME @"testuser"
#define TEST_PASSWORD @"password"
#define TEST_EMAIL @"test@email.com"
