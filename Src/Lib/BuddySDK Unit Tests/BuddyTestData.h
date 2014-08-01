

#pragma message ("Insert your own AppID and Key")
#ifdef CI_APP_ID
#define APP_ID CI_APP_ID
#define APP_KEY CI_APP_KEY
#else
#define APP_ID @"bbbbbc.jHbbbrsGgbrn"
#define APP_KEY @"05E38B90-7472-4DC1-9791-5C7771076100"
#endif

#define TEST_USERNAME @"testuser"
#define TEST_PASSWORD @"password"
#define TEST_EMAIL @"test@email.com"
