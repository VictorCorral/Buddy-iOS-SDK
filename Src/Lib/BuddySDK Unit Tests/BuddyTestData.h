

#pragma message ("Insert your own AppID and Key")
#ifdef CI_APP_ID
#define APP_ID CI_APP_ID
#define APP_KEY CI_APP_KEY
#else
#define APP_ID @"YOUR_APP_ID"
#define APP_KEY @"YOUR_APP_KEY"
#endif

#define TEST_USERNAME @"testuser"
#define TEST_PASSWORD @"password"
#define TEST_EMAIL @"test@email.com"
