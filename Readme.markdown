# Introspection Framework #

Introspection framework based on the [Objective-C 2.0 runtime library][runtime_reference].

# Requirements #

Due to the use of [Automatic Reference Counting][arc] (ARC) you need [Xcode 4.2][xcode] to build this project.

# Features #

* Mac OS X and iOS support
* High unit test code coverage
* Introspection of instance variables, properties, methods, protocols and classes
* Calling methods dynamically
* Get/set properties and instance variables dynamically
* Convenient `NSObject` extension methods

# How to Use #

All runtime entities (methods, protocols, properties, classes and instance variables) 
have corresponding descriptors.
You can create descriptors directly or via `NSObject` extension methods.
For example, if you want to create a descriptor for the property with name `surname` from the class `Person`
you can create it using `ISPropertyDescriptor` class:

```objc
ISPropertyDescriptor *descriptor = [ISPropertyDescriptor descriptorForName:@"surname" inClass:[Person class]];
```

or via `NSObject` extension method `propertyWithName:`:

```objc
Person *forrest = [Person new];
ISPropertyDescriptor *descriptor = [forrest propertyWithName:@"surname"];
```

The following examples demonstrate some common use cases of the Introspection framework.

To find instance variable for a class:

```objc
ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
    descriptorForName:@"age" inClass:[Person class]
];    
```

To find method for a protocol:

```objc
ISMethodDescirptor *descriptor = [ISMethodDescirptor 
    descriptorForSelector:@selector(playMovie:skippingSeconds:) 
               inProtocol:@protocol(Player)
]
```

To list instance methods for a class:

```objc
ISClassDescriptor *descriptor = [ISClassDescriptor descriptorForClass:[Person class]]
NSArray *methods = [descriptor methodsInstance:YES];
```

To list properties for a protocol:

```objc
ISProtocolDescriptor *descriptor = [ISProtocolDescriptor descriptorForProtocol:@protocol(Player)];
NSArray *properties = descriptor.properties;
```

To get instance variable value:

```objc
Person *jenny = [Person new];    
    
ISInstanceVariableDescriptor *descriptor = [ISInstanceVariableDescriptor 
    descriptorForName:@"age" 
    inClass:[Person class]
];
    
NSValue *value = [descriptor getValueFromObject:instance];
```

To set instance variable value:

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

```objc
ISMethodDescriptor *descriptor = [ISMethodDescriptor 
    descriptorForSelector:@selector(playMovie:skippingSeconds:) 
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

To get property value:

```objc
Person *dan = [Person new];

ISPropertyDescriptor *descriptor = [ISPropertyDescriptor 
    descriptorForName:@"surname" 
    inClass:[Person class]
];    
    
NSValue *nameValue = [descriptor getValueFromObject:dan];
```
To set property value:

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