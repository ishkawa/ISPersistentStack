# ISPersistentStack

a reliable helper for CoreData.

## Requirements

- iOS 5.0 or later
- ARC

## Usage

### Access main NSManagedObjectContext

```objectivec
NSManagedObjectContext *context = [ISPersistentStack sharedStack].managedObjectContext;
```

### Check compatibility

```objectivec
ISPersistentStack *persistentStack = [ISPersistentStack sharedStack];
if (!persistentStack.isCompatibleWithCurrentStore) {
    // perform migaration or drop current persistent store
}
```

### Drop current persistent store

```objectivec
[[ISPersistentStack sharedStack] deleteCurrentStore];
```

## Installing

Add files under `ISPersistentStack/` to your Xcode project.

### CocoaPods

If you use CocoaPods, you can install ISPersistentStack by inserting config below.

```
pod 'ISPersistentStack', :git => 'git@github.com:ishkawa/ISPersistentStack.git'
```

## License

Copyright (c) 2013 Yosuke Ishikawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

