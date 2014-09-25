

#pragma message ("Insert your own AppID and Key")
#ifdef CI_APP_ID
#define APP_ID CI_APP_ID
#define APP_KEY CI_APP_KEY
#else
#define APP_ID @"bbbbbc.gcbbbBJhtHLl"
#define APP_KEY @"17BA5947-4568-48B5-B835-B2D3AB732782"
#endif

#define TEST_USERNAME @"testuser"
#define TEST_PASSWORD @"password"
#define TEST_EMAIL @"test@email.com"
