Python-Cocoa Bridge API
=======================

For details on the exact nature of the Objective-C object-model mapping to Python see the
[PyObjC Documentation].

In addition to the nuances documented elsewhere the XCode Python-Cocoa Application template
provides the following feature(s):

### Keyboard state at application launch time ###

The Objective-C glue code examines the
current keyboard state when the application is first launched and assigns a tuple to
the sys module named `__launch_kb_state__`. This tuple will contain one or more strings
mapping to a set of possible keys which are checked for, these strings are:

 - `capslock` (*The capslock key was toggled on, not merely depressed.*)
 - `shift` (*The left or right shift key was depressed.*)
 - `ctrl` (*The left or right control key was depressed.*)
 - `option` (*The left or right option key was depressed.*)
 - `command` (*The left or right command key was depressed.*)
 - `help` (*The help key was depressed -- if applicable.*)
 - `fn` (*The function key was depressed -- if applicable.*)

###PYTHONPATH environment variable modified.###

The Objective-C glue code modifies (or
creates) the `$PYTHONPATH` environment variable by appending two directories to the path.
Developers may use these to bundle Python modules or packages with their applications
(`$RESOURCE_PATH` is the resource path of the .app bundle as configured by the application's
`Info.plist` file):

 1. `$RESOURCE_PATH/PyObjC`
 1. `$RESOURCE_PATH/packages`

[PyObjC Documentation]: http://pythonhosted.org/pyobjc/