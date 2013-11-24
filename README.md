XCode Version 4.x Python/Cocoa Template
=======================================
A "re-imagining" of an original template set provided by Apple during the XCode 3 days.
It's been so long since I had my hands on the original Apple provided templates that I cannot remember
how much of this came from Apple's templates and how much was (re-)created from scratch with no
obvious references. Safe to say it is a mix of sorts.

##Introduction##
[PyObjc] is a development library that bridges the Objective-C object model on to the Python
object model thus allowing Python classes to subclass NSObject (and ancestors of NSObject of course)
and call objc methods almost as though they were native Python objects (a few minor caveats are necessary
due to fundamental differences between the two) as well as allowing Python code to access some of the
native "Cocoa" primitives as though they were Python primitives (*NSString -> unicode, NSDictionary -> dict,
NSArray -> list, NSSet -> set, etc*). Additionally, glue is included for the common Apple frameworks such
as AppKit and Foundation, but it's also quite trivial to reference just about any type of Objective-C
object at runtime, even those without pre-determined signatures.

This tool makes it possible to write OSX applications natively in Python, which is something commonly
done (these days) with _py2app_, however what _py2app_ lacks is the ability to use Python for rapid
prototyping of (ultimately) native OSX apps. This is where the template comes in, it allows exactly this,
i.e. writing applications using XCode, just as most would in a completely native environment.

Apple originally provided template(s) very much like this in the XCode 3 days, but they were pulled
as of XCode 4 for unknown reasons. Some time after this happened I stumbled upon the need to port something
using the original templates to XCode 4 and thus this project was born, however some of it I had to do
from memory and this is why I dub it a "re-imagining" above.

##Installation##
Installation on XCode 4 is simple (sorry, prior versions of XCode are not supported for obvious
reasons):

1. Unzip into your __personal__ `Library/Developer` folder, creating `Developer` if it doesn't exist. _Unzipping into the system /Library folder is **not advised**_.

2. Start XCode and create a new project. You should see a new section and project type representing the template. Click this and everything will be layed out including an empty application delegate python object with a method for `awakeFromNib`.

###New Objects###
A file template is also included which will establish a new python file representing a class which inherits NSObject (*by default*).
This aligns well with the general OSX/IOS development philosophy of "one source file per class", although it isn't strictly required
by any means.

[PyObjc]: http://pythonhosted.org/pyobjc/