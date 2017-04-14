
<p align="center">
    <img src="https://github.com/Geek-1001/Clue/raw/master/Images/clue-logo-with-text.png" width="300" max-width="50%" alt="Clue" />
</p>

<p align="center">    
    <a href="https://travis-ci.org/Geek-1001/Clue/branches">
        <img src="https://img.shields.io/travis/Geek-1001/Clue/master.svg" alt="Travis status" />
    </a>    
    <a href="https://cocoapods.org/pods/Clue">
        <img src="https://img.shields.io/cocoapods/p/Clue.svg" alt="CocoaPods platforms"/>
    </a>
    <a href="https://cocoapods.org/pods/Clue">
        <img src="https://img.shields.io/cocoapods/v/Clue.svg" alt="CocoaPods version" />
    </a>
    <a href="https://twitter.com/ahmed_sulajman">
        <img src="https://img.shields.io/badge/contact-%40ahmed__sulajman-orange.svg?style=flat" alt="Twitter: @ahmed__sulajman" />
    </a>
</p>

**Clue** is a simple smart-bug report framework for iOS, which allow your users to record full bug/crash report and send it to you as a single .clue file via email.  

(which includes full video of the screen, views structure, all network operations and user interactions during recording)
<br>

## 🕵️ Why
As soon as you get new bug report from your users - you're not software engineer anymore but a true detective. Trying to get a clue why something went wrong in your app. Especially it’s true if you’re working in company where you need to talk to users directly.

I believe it’s a problem. What if you can fix bug/crash without trying to reproduce it. What if you can see all required information and exact cause of the problem right away without wasting your time figuring it out.
<br>

## ℹ️ Description
<p align="center">
    <img src="https://github.com/Geek-1001/Clue/raw/master/Images/clue-framework-demo.gif" alt="Clue demo" />
</p>

Clue.framework records all required information so you’ll be able to fix bug or crash really fast. Just import and setup Clue.framework in your iOS application (Xcode project) and you'd be able to shake the device (or simulator) to start bug report recording. During that recording you can do whatever you want to reproduce the bug.

After you’re done you need to shake the device (or simulator) once again (or tap on recording indicator view) and Clue will save the .clue file with the following information:
* Device Information
* All network operations during recording
* All views structure changes (including view’s properties and subviews)
* All user touches and interactions
* Screen record video

Next Clue will open system mail window with your email (unfortunately on device only, simulator doesn’t support system mail client) — so the user can send .clue report file right to your inbox.  
<br>

## 📲 How to install

### Manually
If you prefer not to use dependency managers, you can integrate Clue into your project manually.
1. Clone the repo `git clone git@github.com:Geek-1001/Clue.git`
2. Open **Clue.xcodeproj** with Xcode
3. Choose `Clue` build schema and build it with Xcode
4. Drag and Drop **Clue.framework** file from Product folder right into your Xcode project
5. Make sure to select "Copy item if needed" in the dialog
6. Go to Project settings > Build Phases
7. Expand "Copy Files" section, choose "Frameworks" in the Destination dropdown
8. Click on the plus icon and add Clue.framework

### Using CocoaPods
1. To integrate Clue into your Xcode project using CocoaPods, add following line to your Podfile : `pod 'Clue', '~> 0.1.0'`
2. Then, run install command: `$ pod install`
<br>

## 💻 How to use

### Basic usage

* Import Clue framework wherever you need it

Objective-C :
```objective-c
@import Clue
```
Swift :
```swift
import Clue
```

* To setup Clue you need to enable it with launch configuration in your AppDelegate.

Objective-C :
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ClueController sharedInstance] enableWithOptions:[CLUOptions optionsWithEmail:@"ahmed.sulajman@gmail.com"]];
    return YES;
}
```
Swift :
```swift
optional func application(_ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    ClueController.sharedInstance().enable(with: CLUOptions(email: "ahmed.sulajman@gmail.com"))
    return true
}
```

* Then you should handle shake gesture in `AppDelegate` (if you want to record bug reports from anywhere in the app on iOS 8, 9, 10) or in specific `UIViewController` (since `motionBegan` method doesn’t work in `AppDelegate` starting from iOS 10).

Objective-C :
```objective-c
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [[ClueController sharedInstance] handleShake:motion];
}
```
Swift :
```swift
func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
    ClueController.sharedInstance().handleShake(motion)
}
```

After that you can shake your device and start recording. Shake it again to stop it.


### Additional abilities

* If you want to use your own custom UI element to enable report recording you can call `startRecording()` and `stopRecording()` methods  from `ClueController` directly like in the example below.

Objective-C :
```objective-c
[[ClueController sharedInstance] startRecording];
...
[[ClueController sharedInstance] stopRecording];
```
Swift :
```swift
ClueController.sharedInstance().startRecording()
...
ClueController.sharedInstance().stopRecording()
```

* To disable ability to record bug reports just call `disable()` method from `ClueController`.

Objective-C :
```objective-c
[[ClueController sharedInstance] disable];
```
Swift :
```swift
ClueController.sharedInstance().disable()
```
<br>

## ✅ Platforms Support
Clue supports iOS 9+ devices.
The current version of Clue (and the `master` branch) is compatible with Xcode 8
<br>

## 🛠️ Hackable
Love this part. Clue designed in a way that you can tweak whatever you want and add more functionalities to report recording process (and I encourage you to do so) so it will fit into your custom needs. For example you want to track your custom logs during recording. Just create a separate module for that and plug it to recording process (I’ll explain this in details below)

Unfortunately Clue built with Objective-C (at least for the first iteration. I’m considering to rewrite some parts to Swift, for sure)  so all internals wasn’t design to be Swift compatible. (If you can fix it — contributions are welcome!)


### Basic architecture and structures:

<p align="center">
    <img src="https://github.com/Geek-1001/Clue/raw/master/Images/clue_structure.png" alt="Clue structure" />
</p>

There are two main concepts in Clue which you need to understand in order to build it by yourself:
* Modules
	* Recordable modules
	* Info modules
* Writers

**Modules** are responsible for actual data handling. Those classes observe some specific data during recording or collect this data just once during record launch. There are two module types: `CLURecordableModule` and `CLUInfoModule`.

`CLURecordableModule` —  is a protocol. It describes recordable module (like Video, View Structure, Network modules etc) which needs to track or inspect some specific information over time (like view structure for example) and record this information with specific timestamp using **Writers**

> Note : Every recordable modules have to implement this protocol to be able to work normally inside the system  

If your Recordable Module needs to observe new data instead of writing new data with every new frame you should use (subclass your new module from) `CLUObserveModule` which provide common interface to write new data as soon as data become available.

- - - -

`CLUInfoModule`  — is a protocol. It describes info modules (like Device Info module), static one-time modules which needs to write their data only once during whole recording also using **Writers**

> Note : Every info modules have to implement this protocol to be able to work normally inside the system  

**Writers** are responsible for writing some specific content (video, text etc) into the file.

`CLUWritable` — is a protocol. It describes writers (like `CLUDataWriter` or `CLUVideoWriter`) which needs to actually write new data to specific file (could be text file, video file etc.)


### New Recordable Module Example
Let’s assume you want to add module which will intercept logs and write them into json file with specific timestamp inside .clue report file.
First of you need to create new module class and subclass it from `CLUObserveModule` (we’re assuming here that we need to observe new logs and they are not available right away)

```objective-c
@interface CLULogsModule : CLUObserveModule
@end
```

Next we need to implement some methods from `CLURecordableModule` protocol:

```objective-c
@implementation CLULogsModule

- (instancetype)initWithWriter:(id <CLUWritable>)writer {
    // If you will write just text data into json file you can use CLUDataWriter as an argument for this method. CLUDataWriter implements CLUWritable protocol
}

- (void)startRecording {
    if (!self.isRecording) {
        [super startRecording];
         // Start logs interception    
    }
}

- (void)stopRecording {
    if (self.isRecording) {
        [super stopRecording];
        // Stop logs interception
    }
}

// This method will be called every time new frame with new timestamp is available.
// Since you subclass your module from CLUObserveModule you don't need to implement this method. CLUObserveModule takes care about it with data buffer.
// - (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp { }

@end
```

Next let’s assume we have some kind of log delegate method which will be  called every time new log record is available. In this delegate method you should compose `NSDictionary` (if you want to write json) with all properties of this log data entity you want to record into final .clue report.

```objective-c
- (void)newLog:(NSString *)logText isAvailableWithDate:(NSDate *)date {
    // Let's build NSDictionary with data we need
    // You always should include timestamp property for every new data entry
    NSDictionary *logDictionary =
                    @{@"text" : logText,
                      @"date" : date,
                TIMESTAMP_KEY : self.currentTimeStamp}; // TIMESTAMP_KEY - is a #define with default name for timetamp declared in CLUObserveModule. self.currentTimeStamp – is a property declared in CLUObserveModule which is updates every [CLUObserveModule addNewFrameWithTimestamp:] method call. So you can use it to indicate current timestamp

    // Now we need to check validity of NSDictionary so we can convert it in to NSData as a json
    if ([NSJSONSerialization isValidJSONObject:touchDictionary]) {
        NSError *error;
        // Convert NSDictionary to NSData
        NSData *logData = [NSJSONSerialization dataWithJSONObject:logDictionary options:0 error:&error];

        // Add log data to data buffer from CLUObserveModule with [CLUObserveModule addData:]
        [self addData:logData];
    }  
}
```

To make it work you also need to plug your new module into the system of modules. The `CLUReportComposer` is exactly for this purposes.

> `CLUReportComposer` is a class responsible for composing final Clue report from many modules. This class initialize all recordable and info modules and actually start recording. Also this class is calling `addNewFrameWithTimestamp:` method for every recordable module during recording and `recordInfoData` method from `CLURecordableModule` protocol for every info module only once at record launch.  

So in `ClueController` you need to add your new module in this method

```objective-c
- (NSMutableArray *)configureRecordableModules {
    CLUVideoModule *videoModul = [self configureVideoModule];
    CLUViewStructureModule *viewStructureModule = [self configureViewStructureModule];
    CLUUserInteractionModule *userInteractionModule = [self configureUserInteractionModule];
    CLUNetworkModule *networkModule = [self configureNetworkModule];

    // Initialize your module just like other modules above
    CLULogsModule *logModule = [self configureLogsModule]

    NSMutableArray *modulesArray = [[NSMutableArray alloc] initWithObjects:videoModul, viewStructureModule, userInteractionModule, networkModule, /* HERE goes your module, */ nil];
    return modulesArray;
}
```

Here is configuration method example:

```objective-c
- (void)configureLogsModule {
    // Get directory URL for all recordable modules inside .clue file
    NSURL *recordableModulesDirectory = [[CLUReportFileManager sharedManager] recordableModulesDirectoryURL];

    // Specify URL for output json file
    NSURL *outputURL = [recordableModulesDirectory URLByAppendingPathComponent:@"module_logs.json"];

    // Initialize CLUDataWriter with specific output file URL
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:outputURL];

    // Initialize CLULogsModule with specific Writer
    CLULogsModule *logsModule = [[CLULogsModule alloc] initWithWriter:dataWriter];

    return logsModule;
}
```

That’s it. Now you have logs inside your .clue report file as well as other useful data for fast bug fixing.
You can literally build any module you want which can record any possible data inside your .clue bug report file.


### New Info Module Example
Now let’s assume you want to add info module which will collect some initial data at the beginning of report recording for current users's location and write in into json file inside .clue report file.
First of you need to create new info module class and declare `CLUInfoModule` protocol in the header file.

>`CLUInfoModule` protocol describe info modules (like Device Info module or Exception module), static one-time modules which needs to write their data only once during recording. Every info modules have to implement this protocol to be able to work normally inside the system

```objective-c
@interface CLULocationInfoModule : NSObject <CLUInfoModule>
@end
```

Next we need to implement some methods from `CLUInfoModule` protocol:

```objective-c
@interface CLULocationInfoModule()
@property (nonatomic) CLUDataWriter *writer; // Just keep reference to Writer object from initialization
@end

@implementation CLULocationInfoModule

// If you will write just text data into json file you can use CLUDataWriter as an argument for this method. CLUDataWriter implements CLUWritable protocol so you can write any NSData object into output file
- (instancetype)initWithWriter:(id <CLUWritable>)writer {    
    // Basic initialization stuff
    _writer = writer;
    return self;
}

// This method will be called once at recording startup. Here you can add all your required data (in our case user's location) into report file
- (void)recordInfoData {
    NSData *locationData = [self retrieveLocationData];

    // Add location data to the output file via Writer object
    [_writer startWriting];
    [_writer addData:locationData];
    [_writer finishWriting];
}

@end
```

To make it work you also need to plug your new info module into the system of modules (just like recordable module) using `CLUReportComposer`.

> `CLUReportComposer` is a class responsible for composing final Clue report from many modules. This class initialize all recordable and info modules and actually start recording. Also this class is calling `addNewFrameWithTimestamp:` method for every recordable module during recording and `recordInfoData` method from `CLURecordableModule` protocol for every info module only once at record launch.  

So in `ClueController` you need to add your new info module in this method

```objective-c
- (NSMutableArray *)configureInfoModules {
    CLUDeviceInfoModule *deviceModule = [self configureDeviceInfoModule];

    // Initialize your info module just like other info modules above
    CLULocationInfoModule *locationModule = [self configureLocationModule];

    NSMutableArray *modulesArray = [[NSMutableArray alloc] initWithObjects:deviceModule, /* HERE goes your info module ,*/  nil];
    return modulesArray;
}
```

Here is configuration method example:

```objective-c
- (void)configureLocationModule {
    // Get directory URL for all info modules inside .clue file
    NSURL *infoModulesDirectory = [[CLUReportFileManager sharedManager] infoModulesDirectoryURL];

    // Specify URL for output json file
    NSURL *outputURL = [infoModulesDirectory URLByAppendingPathComponent:@"info_location.json"];

    // Initialize CLUDataWriter with specific output file URL
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:outputURL];

    // Initialize CLULocationInfoModule with specific Writer
    CLULocationInfoModule *locationModule = [[CLULogsModule alloc] initWithWriter:dataWriter];

    return locationModule;
}
```

That’s it. Now you have location information inside your .clue report file.


### How to add custom View object parsing
Clue records views' structure. This means that Clue needs to parse all properties and subviews for every visible View (and invisible as well) on the screen to be able to represent whole views' structure at the current time.

UIView categories are used for this purposes. There are following categories for UIView related classes:
* `UIView (CLUViewRecordableAdditions)`
* `UILabel (CLUViewRecordableAdditions)`
* `UIImageView (CLUViewRecordableAdditions)`
* `UITextField (CLUViewRecordableAdditions)`

**UIView (CLUViewRecordableAdditions)** category has methods to parse basic view properties (this is general for every view object) and recursively parse subviews.

Other categories made to parse View specific properties (like `text` property for `UITextField`, for example).
If you want to parse some specific view properties and add them to final report you have to create separate category like this

```objective-c
@interface AHCustomView (CLUViewRecordableAdditions) <CLUViewRecordableProperties>
@end
```

> Every new  View category always have to implement  method from `CLUViewRecordableProperties` protocol to be able to use root properties from base view class (`UIView`, for example) so all properties would be in place for your custom view object as well.  

Now we need to implement actual property parsing

```objective-c
// Method from CLUViewRecordableProperties protocol
- (NSMutableDictionary *)clue_viewPropertiesDictionary {
    // First of you need to get property dictionary from view's superclass
    NSMutableDictionary *rootDictionary = [super clue_viewPropertiesDictionary];

    // Change class name, so it would be real instead of superclass' class name
    [rootDictionary setObject:NSStringFromClass([self class]) forKey:@"class"];

    // Next you want to add some view specific properties into root dictionary.  
    NSMutableDictionary *propertiesDictionary = [rootDictionary objectForKey:@"properties"];

    // Let's add text property just for example
    [propertiesDictionary setObject:self.text ?: @""
                             forKey:@"text"];
    …

    // Add new properties dictionary to root dictionary
    [rootDictionary setObject:propertiesDictionary
                       forKey:@"properties"];

    // Return root dictionary as a result
    return rootDictionary;
}
```

That’s it, now even your custom view classes will show specific properties in final .clue report.


### What is .clue file
It’s basically just a package file with json data from network, view structure, user interactions modules and device info module and .mp4 video file from video module.

Here is tree representation of `Report.clue` file:
```
Report.clue
        ├── Info
        │     └── info_device.json
        └── Modules
            ├── module_interaction.json
            ├── module_network.json
            ├── module_video.mp4
            └── module_view.json
```
<br>

## 🖥️ macOS Companion Application
<p align="center">
    <img src="https://github.com/Geek-1001/Clue/raw/master/Images/clue-macOS-app.png" alt="Clue macOS app" />
</p>

I also made [macOS companion app](https://github.com/Geek-1001/Clue-macOS-application) (open source as well) which allow you to view .clue report files in a nice and simple way. It shows full timeline with all event so you can inspect dependencies between user actions and actual app’s responses pretty easily.

Obviously you can view .clue report files with whatever method you want since it’s just json files and mp4 video file combined inside single entity.


## 🛣️ Roadmap
- [x] Build basic modules for Network, View Structure, User Interactions and Video
- [x] Send final report file via email
- [ ] Integrate Nonnull and Nullable annotations
- [ ] Migrate some parts of the framework to Swift
- [ ] Add more useful recordable/info modules
- [ ] Slack integration
- [ ] macOS version of the framework to use in macOS apps
- [ ] Suggestions are welcome!
<br>

## 👩‍💻👨‍💻 Contribution
Contributions are welcome! That's why Open Source is cool!
Also **Contributions Guide** will be ready soon, but you can create an issue with your improvements or suggestion right now and we'll discuss it.
<br>

## ☎️ Contacts
Feel free to reach me on twitter [@ahmed_sulajman](https://twitter.com/ahmed_sulajman) or drop me a line on ahmed.sulajman@gmail.com
I Hope Clue framework will help you with your bug reports!
<br>

## 📄 Licence
Clue is released under the MIT License. See the LICENSE file.
