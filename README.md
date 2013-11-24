XCode Version 5.x Python/Cocoa Template
=======================================
A "re-imagining" of an original template set provided by Apple during the XCode 3 days.
It's been so long since I had my hands on the original Apple provided templates that I cannot remember
how much of this came from Apple's templates and how much was (re-)created from scratch with no
obvious references. Safe to say it is a mix of sorts.

#Important XCode 5 Notes#
The templates have been updated to work with XCode 5 with one major caveat:

  * __Only the OSX 10.8 SDK is currently supported!__ This is because, at least when developing on 10.8, the 10.9
    SDK available in the latest XCode doesn't include `Python.framework`, without which one cannot link to Python and
    thus the glue code cannot be compiled. This will be examined in more detail once I have the opportunity to work
    with 10.9 more fully, but for now the template will force the SDK to `macos10.8` and `MACOSX_DEPLOYMENT_TARGET`
    to 10.8. Versions older than 10.8, obviously, are not supported by this branch (XCode 5 requires at least 10.8).

##Installation##
Installation on XCode 5 is simple:

1. Unzip into your __personal__ `Library/Developer` folder, creating `Developer` if it doesn't exist. _Unzipping into the system /Library folder is **not advised**_.

2. Start XCode and create a new project. You should see a new section under "OS X" named _Python Cocoa_ and a new application type named _Python-Cocoa Application_ under this section. Click this, fill out the relevant info, and everything will be layed out including an empty application delegate python object with a method for `applicationDidFinishLaunching`.

###New Objects###
A file template is also included which will establish a new python file representing a class which inherits NSObject (*by default*).
This aligns well with the general OSX/IOS development philosophy of "one source file per class", although it isn't strictly required
by any means.

[PyObjc]: http://pythonhosted.org/pyobjc/