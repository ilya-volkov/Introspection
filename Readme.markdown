s# Introspection Framework #

Introspection framework based on the [Objective-C 2.0 runtime library][runtime_reference].

# Requirements #

Due to the use of [Automatic Reference Counting][arc] (ARC) you need [Xcode 4.2][xcode] to build this project.

# Features #

* Mac OS X and iOS support
* High unit test code coverage
* Introspection of instance variables, methods, properties, protocols and classes
* Calling methods dynamically
* Get/set properties and instance variables dynamically
* Convenient `NSObject` extension methods

# How to Use #

All runtime entities like methods, protocols, properties, classes and instance variables 
have coressponding classes called descriptors.
You can work with descriptors directly or use `NSObject` extension methods.

Examples below show some common use cases of the Introspection framework.

// TODO: update examples using NSObject extensions
To find property for a class:
//TODO
To find method for a protocol:
//TODO
To list methods for a class:
//TODO
To list properties for a protocol:
//TODO
To get instance variable:

```objc
Person *jenny = [Person new];    
    
ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
    descriptorForName:@"age" 
    inClass:[Person class]
];
    
NSValue *value = [descriptor getValueFromObject:instance];
```

To set instance variable:

```objc
Person *jenny = [Person new];

ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
    descriptorForName:@"age" 
    inClass:[Person class]
];
    
int age = 20;
[descriptor setValue:[NSValue valueWithBytes:&age objCType:@encode(int)] inObject:jenny];
```

To call method:

```obc
ISMethodDescriptor *descriptor = [ISMethodDescriptor 
    descriptorForSelector:playMovie:skippingSeconds: 
    inClass:[Player class]
]

Player *player = [Player new];
int seconds = 120;
    
NSArray *args = [NSArray arrayWithObjects:
    [NSValue valueWithNonretainedObject:@"Forrest Gump"],
    [NSValue valueWithBytes:&seconds objCType:@encode(int)]    
    nil
];
    
NSValue *value =[descriptor invokeOnObject:player withArguments:args];
```

To get property:

```objc
Person *dan = [Person new];

ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
    descriptorForName:@"surname" 
    inClass:[Person class]
];    
    
NSValue *nameValue = [descriptor getValueFromObject:dan];
```
To set property:

```objc
Person *dan = [Person new];

ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
    descriptorForName:@"surname" 
    inClass:[Person class]
];    

[descriptor setValue:[NSValue valueWithNonretainedObject:@"Taylor"] inObject:dan];
```

# Known Issues #

* Calling methods with variable number of arguments not supported
* Calling methods with union parameters not supported
* Invalid implementation returned for the methods with a data-structure return value
* It’s impossible to distinguish between optional and required properties at runtime

# Links #

* [Objective-C 2.0 Runtime Reference][runtime_reference]

[runtime_reference]: http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html
[arc]: http://developer.apple.com/library/mac/#releasenotes/ObjectiveC/RN-TransitioningToARC/_index.html
[xcode]: http://developer.apple.com/xcode/