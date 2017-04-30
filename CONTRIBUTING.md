# Contributing to Clue

First, thank you for your decision to make a contribution to Clue iOS framework. 🎉 🤘

The main goal of Clue is **to make bug fixing process easier for everyone**. We can achieve this goal with your contributions.

## How to contribute
Here are some ways you can contribute to Clue:
- Report any bugs by creating [new issue](https://github.com/Geek-1001/Clue/issues/new)
- [Submit an issue](https://github.com/Geek-1001/Clue/issues/new) for any new feature request
- Implement tasks from the roadmap. Please check out [Detailed Roadmap section](https://github.com/Geek-1001/Clue/blob/master/CONTRIBUTING.md#detailed-roadmap)
- Add your own recordable/info modules to separate Modules repository (I'll add link to the repository soon)
- Improve documentation of Clue's core structures. Please check out [full documentation here](https://geek-1001.github.io/Clue/) and [Documentation section](https://github.com/Geek-1001/Clue/blob/master/CONTRIBUTING.md#documentation)
- Add tests to Clue's core structures.
- Spread the word about Clue [via Twitter](https://twitter.com/intent/tweet?text=Clue%20is%20a%20flexible%20bug%20report%20framework%20for%20iOS.%20Check%20it%20out%20https://github.com/Geek-1001/Clue)

## Before You Start
Here is a list of useful resources which you might need before making any contribution.

### References
- [Here is Full Clue Documentation](https://geek-1001.github.io/Clue/)
- You can find overall class structure on [this diagram](https://github.com/Geek-1001/Clue/raw/master/Images/clue_structure.png)
- You can find code examples, how to build your own recordable/info module in the [Hackable section of README](https://github.com/Geek-1001/Clue#%EF%B8%8F-hackable)

### Setup the project for development
1. Clone the repo `git clone git@github.com:Geek-1001/Clue.git`
2. Open **Clue.xcodeproj** with Xcode
3. Choose `Clue` build schema and build it with Xcode

> You should have Xcode 8 at least

There are 4 schemas in the **Clue.xcodeproj**:
1. `Clue` – framework
2. `ClueExampleApp` – example objective-c iOS application
3. `ClueSwiftExampleApp` – example swift iOS application
4. `ClueTests` – tests target

### Git flow
There are two main branches in Clue: `master` and `develop`.
All development should be in `develop` branch.
Also please submit all pull requests into `develop` branch instead of `master`.
`master` will contain only stable versions of Clue releases.

If you have a separate task, please create new branch  `user/task-name` from `develop`. (for example: `geek-1001/skip-invalid-recordable-properties`)

### Commits
Try to keep it simple and more important – atomic.
If you created 3 files with different responsibilities — submit them as separate commits. Try to include what is the purpose of the specific file in the commit message.

For example:
```
Add CLUViewStructureWriter - writer for view structure which
will add in real-time view properties as a JSON (NSDictionary)
to the specific file (implementation of basic writer interface)
```

Also try to use `Add`, `Remove`, `Fix` etc. keywords as the first word of commit message instead of `Added`, `Removed`, `Fixed` etc.


## Architecture Overview
Here is the detailed description of Clue architecture. You can also read general overview in [README Hackable section](https://github.com/Geek-1001/Clue#%EF%B8%8F-hackable)

### Writers
Those are classes responsible for writing some specific data into some specific file. Recordable and Info Modules use those classes to record their data.

> All Writers should implement [`CLUWritable`](https://geek-1001.github.io/Clue/Protocols/CLUWritable.html) protocol

There are two main `Writers` in Clue right now:
- [`CLUDataWriter`](https://geek-1001.github.io/Clue/Classes/CLUDataWriter.html) – class which is responsible for all writing and saving process for regular data stream into final .json file or any other file (inside .clue report file) Used with all Recordable Modules (like View Structure, Network, and User Interactions) to add data while report recording is active
- [`CLUVideoWriter`](https://geek-1001.github.io/Clue/Classes/CLUVideoWriter.html) – class which is responsible for all writing and saving process for the video stream from device’s screen. Used with Video Module to record screen while report recording is active

### Modules
Modules are responsible for actual data handling. Those classes observe some specific data during recording or collect this data just once during record launch and record the data via `Writers`. There are two module types: `CLURecordableModule` and `CLUInfoModule`.

- [`CLURecordableModule`](https://geek-1001.github.io/Clue/Protocols/CLURecordableModule.html) — is a protocol. It describes recordable module (like Video, View Structure, Network modules etc) which needs to track or inspect some specific information over time (like view structure for example) and record this information with specific timestamp using Writers
- [`CLUInfoModule`](https://geek-1001.github.io/Clue/Protocols/CLUInfoModule.html) — is a protocol. It describes info modules (like Device Info module), static one-time modules which need to write their data only once during the whole recording also using Writers

Currently there are 4 recordable modules:
- [`CLUViewStructureModule`](https://geek-1001.github.io/Clue/Classes.html)
- [`CLUUserInteractionModule`](https://geek-1001.github.io/Clue/Classes.html)
- [`CLUVideoModule`](https://geek-1001.github.io/Clue/Classes.html)
- [`CLUNetworkModule`](https://geek-1001.github.io/Clue/Classes.html)

And 2 info modules:
- [`CLUDeviceInfoModule`](https://geek-1001.github.io/Clue/Classes.html)
- [`CLUExceptionInfoModule`](https://geek-1001.github.io/Clue/Classes.html)

### Extensions
Usually extensions and categories are used to parse specific properties of observable data.
There are two kinds of extensions: `View extensions` and `Other extensions`.

`Views extensions` used to be able to parse properties of specific `UIView` object and include it to view structure.

[`CLUViewRecordableProperties`](https://geek-1001.github.io/Clue/Protocols/CLUViewRecordableProperties.html) – protocol describes common interface for UIView’s (and all subclasses) properties parsing into the dictionary which will be used in JSON encoding of view structure.

There are 4 `View extensions` :
- [`UIView(CLUViewRecordableAdditions)`](https://geek-1001.github.io/Clue/Categories/UIView%28CLUViewRecordableAdditions%29.html)
- [`UITextField(CLUViewRecordableAdditions)`](https://geek-1001.github.io/Clue/Categories.html#/c:objc%28cy%29UITextField@CLUViewRecordableAdditions)
- [`UILabel (CLUViewRecordableAdditions)`](https://geek-1001.github.io/Clue/Categories.html)
- [`UIImageView(CLUViewRecordableAdditions)`](https://geek-1001.github.io/Clue/Categories.html)

There are 5 `Other extensions`:
- [`NSError(CLUNetworkAdditions)`](https://geek-1001.github.io/Clue/Categories/NSError%28CLUNetworkAdditions%29.html)
- [`NSException(CLUExceptionAdditions)`](https://geek-1001.github.io/Clue/Categories/NSException%28CLUExceptionAdditions%29.html)
- [`NSHTTPURLResponse(CLUNetworkAdditions)`](https://geek-1001.github.io/Clue/Categories/NSHTTPURLResponse%28CLUNetworkAdditions%29.html)
- [`NSURLRequest(CLUNetworkAdditions)`](https://geek-1001.github.io/Clue/Categories/NSURLRequest%28CLUNetworkAdditions%29.html)
- [`NSURLResponse(CLUNetworkAdditions)`](https://geek-1001.github.io/Clue/Categories/NSURLResponse%28CLUNetworkAdditions%29.html)

### Modules Utils
Those classes are mostly helpers for `Modules`. It could be network requests/response interception class or user interactions handler. They have delegate method which is reports about new entity (interaction or network request, for example) right to `Module` and `Module` decided what to do with it.

### Composer
It a single class [`CLUReportComposer`](https://geek-1001.github.io/Clue/Classes/CLUReportComposer.html) which is responsible for composing final Clue report file from different recordable/info modules. This class initialize all recordable and info modules and actually start recording.

`CLUReportComposer` also calling `addNewFrameWithTimestamp:` method from `CLURecordableModule` protocol for every recordable module and `recordInfoData` method from `CLUInfoModule` protocol for every info module.


## Detailed Roadmap
You can explore all tasks which you can implement [as issues here](https://github.com/Geek-1001/Clue/issues?q=is%3Aopen+is%3Aissue+label%3Atask+label%3Aready-to-implementation).
All tasks currently in development [here](https://github.com/Geek-1001/Clue/issues?utf8=✓&q=is%3Aopen%20is%3Aissue%20label%3Atask%20label%3Ain-development).
And all implemented tasks [here](https://github.com/Geek-1001/Clue/issues?utf8=✓&q=is%3Aopen%20is%3Aissue%20label%3Atask).

Here is general roadmap :
- [ ] Skip invalid recordable properties instead of recording of empty string [Issue #4](https://github.com/Geek-1001/Clue/issues/4)
- [ ] Fix possible memory leak in `CLUUserInteractionModule` because of connected gesture recognizer [Issue #5](https://github.com/Geek-1001/Clue/issues/5)
- [ ] Fail utils method in `UIView (CLUViewRecordableAdditions)` if arguments are invalid [Issue #6](https://github.com/Geek-1001/Clue/issues/6)
- [ ] Parse attributed string properties in `UIView(CLUViewRecordableAdditions)` [Issue #7](https://github.com/Geek-1001/Clue/issues/7)
- [ ] Fix architectural issue with `+[CLURecordIndicatorViewManager currentViewController]` [Issue #8](https://github.com/Geek-1001/Clue/issues/8)
- [ ] Add better error handling in `CLUVideoModule`
- [ ] Save image from `ImageView` in `UIImageView(CLUViewRecordableAdditions)`
- [ ] Add layer data parsing for `UIView(CLUViewRecordableAdditions)`
- [ ] Create `JSONDataWriter` which will validate JSON before writing it to the file. And use it in modules for JSON writing instead of `CLUDataWriter`
- [ ] Migrate some part of the Clue iOS framework to Swift


## Documentation
Documentation was generated with [`Jazzy`](https://github.com/realm/jazzy) – Soulful docs for Swift & Objective-C by Realm.

I tried to cover everything in the documentation but I'm sure there are a lot of places for improvements.
If you want to add your suggestion to header docs – feel free to do it right in header files. Create your pull request, then I'll regenerate documentation locally and update the documentation on site.

For now, I need to do it manually because of unknown issues with `Jazzy` but soon I'll put docs generator script in the repository, so you can generate docs as well.

You can find full documentation site in the root repository, in `docs/` folder.

---

Many thanks for your interest to Clue.
Happy contributing! 🎉
