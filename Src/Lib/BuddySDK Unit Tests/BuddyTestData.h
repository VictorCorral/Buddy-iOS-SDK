

#pragma message ("Insert your own AppID and Key")
#ifdef CI_APP_ID
#define APP_ID CI_APP_ID
#define APP_KEY CI_APP_KEY
#else
#define APP_ID @"bbbbbc.DrhbvdMmqhfh"
#define APP_KEY @"30704BF5-4BA5-4C7F-919F-BA1753689CE7"
#endif

#define TEST_USERNAME @"testuser"
#define TEST_PASSWORD @"password"
#define TEST_EMAIL @"test@email.com"
