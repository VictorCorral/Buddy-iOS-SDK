# Buddy iOS SDK

## Overview

The Buddy iOS SDK helps you get up and running in seconds.

For the most part, the Buddy iOS SDK takes care of all the housekeeping of making requests against the Buddy REST API:

  * Building and formatting requests
  * Managing authentication
  * Parsing responses
  * Loading and saving credentials 

With that handled, all you have to do is initialize the SDK and start making some calls!

## Getting Started
To get started with the Buddy Platform SDK, please reference the Getting Started series of documents at [Intro To Buddy](doc:intro-to-buddy). You will need an App ID and Key before you can use the SDK. The Getting Started documents will walk you through obtaining everything you need and show you where to find the SDK for your platform.

Application IDs and Keys are obtained at the Buddy Developer Dashboard at [buddyplatform.com](https://buddyplatform.com).

Full documentation for Buddy's services are available at [docs.buddy.com](https://docs.buddy.com).

## Installing the SDK

### Prerequisites

  * iOS 6.0 or greater
  * Xcode 6.4 or greater

The Buddy iOS SDK can be accessed via [Cocoapods](http://cocoapods.org/). Cocoapods version of at least 0.39.0 is required to install the Buddy SDK and sample apps.

### Install with Cocoapods

We highly recommend using Cocoapods to install the Buddy SDK. It's fast and makes it much easier to keep up to date with the latest SDK release. If you're new to Cocoapods, see install instructions [here](https://guides.cocoapods.org/using/getting-started.html). Cocoapods depends on Ruby, and depending on your Ruby version the Cocoapods installer may give you trouble; you may need to upgrade Ruby (we recommend using [RVM](https://rvm.io)). (For more Cocoapods troubleshooting steps see [here](https://guides.cocoapods.org/using/troubleshooting#installing-cocoapods)).

#### To create a new project using the Buddy SDK:

1\.  Create a new Xcode project.

2\.  In a Terminal window run:

```
cd <project-dir>
```

3\. Create a Podfile:

```
touch Podfile
```

4\. Open the file with your favorite editor and add:

```
platform :ios, '6.0'
target '<project name>' do
    pod 'BuddySDK'
end
```
\<project name> should be the name of your Xcode project.

5\. If you created a Swift-based project, add:

```
use_frameworks!
```

6\. Save the Podfile.

7\. In your Terminal window run:

```
pod install
```

8\. **In Xcode open the just-generated `.xcworkspace` file for your project (not the `.xcodeproj` file).**

#### To integrate the Buddy SDK into an existing project:

1\. In a Terminal window run:

```
cd <project-dir>
```

2\. Create a Podfile:

```
touch Podfile
```

3\. Open the file with your favorite editor and add:

```
platform :ios, '6.0'
target '<project name>' do
    pod 'BuddySDK'
end
```
\<project name> should be the name of your Xcode project.

4\. If your project is Swift-based, add:

```
use_frameworks!
```

5\. Integrating CocoaPods with an existing workspace requires one extra line in your Podfile. Simply specify the relative path and `.xcworkspace` root filename like so:

```
workspace '../MyWorkspace.xcworkspace'
```

6\. Save the Podfile.

7\. Make sure your workspace is closed in Xcode. Then in your Terminal window run:

```
pod install
```

8\. **Re-open your `.xcworkspace` file in Xcode.**

### Install from Source

Buddy hosts our SDK source on GitHub. To access it, you need to have a GitHub account, and you will also need [Git](http://git-scm.com/download) installed. If you'd like to contribute SDK modifications or additions to Buddy, you'll want to [fork the repository](https://help.github.com/articles/fork-a-repo) so you can issue [pull requests](https://help.github.com/articles/be-social#pull-requests). See the "Contributing Back" section below for details.

1\. In a Terminal window run:

```
git clone https://github.com/BuddyPlatform/Buddy-iOS-SDK.git
```

This will clone the latest version of the SDK into a directory called **Buddy-iOS-SDK.**

2\. Navigate to the **Buddy-iOS-SDK** directory that was created when you cloned the Buddy GitHub repository.

The iOS source is in the **Buddy-iOS-SDK\Src** directory.

#### Build the GitHub Source

To reference the local SDK in your project:

1\. Follow the "Install with Cocoapods" steps above to create a Podfile.

2\. You must add a `:path` parameter to your Podfile to indicate the relative path from your project to the Buddy SDK. It should look something like this:

```
platform :ios, '6.0'
target '<project name>' do
    pod 'BuddySDK', :path => '../../BuddySDK.podspec'
end
```
<project name> should be the name of your Xcode project.

3\. Then in your Terminal window run the following. It's ok to do this again if you have already done it:

```
pod install
```

Now any changes you make to the local Buddy SDK source will be picked up by your project when you build it in Xcode. If you add or remove files to the Buddy SDK, you will need to do a `pod update` for your project in a Terminal window.

## Using the iOS SDK

Visit the [Buddy Dashboard](https://buddyplatform.com/) to obtain an application ID and key, which are needed for your app to communicate with Buddy.

Both Objective-C and Swift-based projects are supported.

### Initialize the SDK

To reference the Buddy SDK in your source file, you need to put an import keyword at the top of the file that contains your AppDelegate:

Objective-C: Open the `AppDelegate.m` file and import the BuddySDK:

    #import "BuddySDK/Buddy.h"

Swift: Open the `AppDelegate.swift` and import the BuddySDK:

    import BuddySDK
    
Before you can call any methods in the SDK, it must be initialized. The best place to do this is inside your `AppDelegate`. Initialize your client in the `didFinishLaunchingWithOptions` method:

    Objective-C: [Buddy init:@"YOUR_APP_ID" appKey:@"YOUR_APP_KEY"];
    
    Swift: Buddy.init("YOUR_APP_ID", appKey: "YOUR_APP_KEY");

Replace "YOUR_APP_ID" and "YOUR_APP_KEY" above with your Buddy app's ID and key from the [Buddy Dashboard](https://buddyplatform.com).

### User Flow

The Buddy iOS SDK handles user creation, login, and logout. Here are some example Objective C calls.

#### Create A User

    [Buddy createUser:self.signupUsername.text
           password:self.signupPassword.text
           firstName:self.signupFirstName.text
           lastName:self.signupLastName.text
           email:self.signupEmail.text
           dateOfBirth:nil 
           gender:nil 
           tag:nil 
           callback:^(id newBuddyObject, NSError *error)
    {
      if (!error)
      {
        // Greet the user
      }
    }];

#### User Login

    [Buddy loginUser:@"username" password:@"password" callback:^(id newBuddyObject, NSError *error)
    {
      if (!error)
      {
        // Greet the user
      }
    }];

#### User Logout

    [Buddy logoutUser:^(NSError *error) {
        // Perform some action on logout
    }];
  
#### User Authorization selector

You can implement a selector named `authorizationNeedsUserLogin` on your AppDelegate that gets called whenever a Buddy call is made that requires a logged-in user. That way, you won't have to manage user login state. Here's an example:

    -(void)authorizationNeedsUserLogin
    {    
        // To ensure that login UI is not shown twice if the selector is called multiple times
        if (self.loginPresented == TRUE)
        {
            return;
        }
        self.loginPresented = TRUE;
        
        LoginViewController *loginVC = [[LoginViewController alloc]
                                    initWithNibName:@"LoginViewController" bundle:nil];
    
       [self.navController.topViewController presentViewController:loginVC animated:NO completion:nil];
    }

### REST Interface
    
Each SDK provides wrappers that make REST calls to Buddy. Responses can be handled in two ways: you can create your own wrapper classes, similar to those found in the `Models` folder, or you can use a basic `[NSDictionary class]`.

#### POST

In this example we'll create a checkin. Take a look at the [create checkin documentation](https://buddyplatform.com/docs/Checkins#CreateCheckin) then:
     
    BPCoordinate *coord = BPCoordinateMake(47.1, -121.292);
    
    NSDictionary *params = @{@"location": coord,
                             @"comment": @"A comment about this awesome place!"};
    
    [Buddy POST:@"/checkins" parameters:params class:[NSDictionary class] callback:^(id checkin, NSError *error) {
        if (!error) {
          NSLog(@"Checkin post went as planned");
        } else {
          NSLog(@"%@", error);
        }
    }];

#### GET

We now can call GET to search for the checkin we just created!

    BPCoordinateRange *range = BPCoordinateRangeMake(47.1, -121.292, 2500);
    
    NSDictionary *params = @{@"locationRange": range};
    
    [Buddy GET:@"/checkins" parameters:params class:[BPPageResults class] callback:^(id results, NSError *error) {
        if (!error) {
          NSArray *checkins = [(BPPageResults*)results convertPageResultsToType:[BPCheckin class] ];
          NSLog(@"%@", checkins); // Log or do something with the response
        } else {
          NSLog(@"GET checkins was unsuccessful.");
          NSLog(@"%@", error);
        }
    }];

If we wanted to search for the specific checkin, by ID, we can do that too:

    NSString* path = [NSString stringWithFormat:@"/checkins/%@", checkinId];
    [Buddy GET:path parameters:nil class:[BPCheckin class] callback:^(id checkin, NSError *error) {
        if (!error) {
          BPCheckin *checkin = (BPCheckin*)checkin;
          // do something with the response
        } else {
          NSLog(@"GET checkin was unsuccessful.");
          NSLog(@"%@", error);
        }
    }];


#### PUT/PATCH/DELETE

Each remaining REST verb is available through the Buddy SDK using the same pattern as the POST example.
     
### Working With Files

Buddy offers support for binary files. The iOS SDK works with files through our REST interface similarly to other API calls. The key class is `BPFile`, which is a wrapper around NSData along with a MIME content type.

**Note:** Responses for files deviate from the standard Buddy response templates. See the [Buddy Platform documentation](https://buddyplatform.com/docs) for more information.

#### Upload A File

Here we demonstrate uploading a picture. All binary files use the same pattern with a different path and different parameters. To upload a picture POST to `"/pictures"`:

    BPFile *file = [[BPFile alloc] init];
    file.contentType = @"image/jpg";
    file.fileData = UIImageJPEGRepresentation(koi, .75);
    
    NSDictionary *parameters = @{@"data": file,
                                 @"caption": @"Koi are awesome fish."};
    
    [Buddy POST:@"/pictures" parameters:parameters class:[NSDictionary class] callback:^(id picture, NSError *error) {
        if (!error) {
          NSLog(@"Image uploaded successfully");
        } else {
          NSLog(@"Image upload went wrong");
          NSLog(@"%@", error);
        }
    }];

#### Download A File

To download a file send a GET request with BPFile as the operation type. This sample downloads the picture we uploaded in the "Upload File" example:

    // Don't forget to store the picture ID in pictureId!

    [Buddy GET:[NSString stringWithFormat:@"/pictures/%@/file", pictureId] parameters:nil class:[BPFile class] callback:^(id obj, NSError *error) {     
        if (!error)
        {
          BPFile *file = (BPFile*)obj;
            
          UIImage* image = [UIImage imageWithData:file.fileData];
          // Do something with the image!
            
          NSLog(@"Image download successful");
        } else {
          NSLog(@"Something went wrong");
        }
        
    }];

### Advanced Usage

#### Automatically report location for each Buddy call

If you set the current location in the Buddy client, each time a Buddy call is made that location will be passed in the call. Most calls that send data to Buddy have a location parameter; if a call is made that doesn't take location, the parameter will be ignored.

    BPCoordinate *location = BPCoordinateMake(47.1, -121.292);
    
    [Buddy setLastLocation: location];

#### Multiple concurrent users

If you need to have multiple clients (for example if you need to interact with multiple users concurrently from your app), you can capture clients created from `Buddy.init` and use those clients individually:

    id<BuddyClientProtocol> client1 = [Buddy init:@"Your App ID 1" appKey:@"Your App Key1"];
    
    id<BuddyClientProtocol> client2 = [Buddy init:@"Your App ID 2" appKey:@"Your App Key2"];
    
    [client1 loginUser:@"user1" password:@"password1" callback:<#^(id newBuddyObject, NSError *error)callback#>
    {
         if (!error)
         {
             // Greet user1
         }
    }];

    [client2 loginUser:@"user2" password:@"password2" callback:<#^(id newBuddyObject, NSError *error)callback#>
     {
         if (!error)
         {
             // Greet user2
         }
     }];
    
#### Handling connectivity

You can implement a selector named `connectivityChanged` on your AppDelegate if you would like to be notified if your device loses and regains ability to communicate to the Buddy servers for whatever reason. Here's an example that notifies the user:

    - (void)connectivityChanged:(NSNumber *)level
    {
        BPConnectivityLevel connectivityLevel = [level intValue];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Connectivity Alert"
                                                        message: level == BPConnectivityNone ? @"No connectivity..." : @"Connected!"
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

### Sample Apps

The Buddy Platform iOS SDK ships with a number of sample apps to get you started. These can be modified to fit your needs, or just used to guide you through the basics. The sample apps are located in the *Samples* directory.

The Buddy SDK is installed into these Apps using CocoaPods. In a Terminal window, `cd` to the sample project root and type: `pod install`

#### BuddyStarter

Demonstrates simple login and logout. This app implements the authorizationNeedsUserLogin & connectivityChanged selectors on the App Delegate.

#### RegisterLogin

Demonstrates another way to implement user registration and login with Buddy. This app implements the authorizationNeedsUserLogin selector on the App Delegate.

#### Photo Gallery

This implements a simple Photo Gallery app where a user can add photos and give them captions and tags. This app is intended to be used in the iOS Simulator.

Before running the app, verify that you have some photos in your gallery (on the simulator). If not, you can add some using Safari (search for some images, long-click on them and then save them).

#### PushChat

This implements a simple chat app, using Buddy messaging and push notification APIs.

### Contributing Back: Pull Requests

We'd love to have your help making the Buddy SDK as good as it can be!

To submit a change to the Buddy SDK please do the following:

1. Create your own fork of the Buddy SDK.
2. Make the change to your fork.
3. Before creating your pull request, please sync your repository to the current state of the parent repository: git pull origin master.
4. Commit your changes, then [submit a pull request](https://help.github.com/articles/using-pull-requests) for just that commit.
## Questions or need help?

This should have given you the basics of how to work with the Buddy iOS SDK. If you have further questions or are stuck, send an email to [support@buddy.com](mailto:support@buddy.com).
