//
//  main.m
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___PROJECTNAMEASIDENTIFIER___-gc.h"
#import <Python/Python.h>
#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

static void setKeyFlags(void)
{
    PyObject *flags = NULL;
    CGEventRef event = CGEventCreate(NULL);
    CGEventFlags mods = CGEventGetFlags(event);
    Py_ssize_t count = 0;
    
    flags = PyTuple_New(7);
    
    if (mods & kCGEventFlagMaskAlphaShift)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("capslock"));
    if (mods & kCGEventFlagMaskShift)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("shift"));
    if (mods & kCGEventFlagMaskControl)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("ctrl"));
    if (mods & kCGEventFlagMaskAlternate)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("option"));
    if (mods & kCGEventFlagMaskCommand)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("command"));
    if (mods & kCGEventFlagMaskHelp)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("help"));
    if (mods & kCGEventFlagMaskSecondaryFn)
        PyTuple_SET_ITEM(flags,count++,PyString_FromString("fn"));
    
    if (count < 7) _PyTuple_Resize(&flags,count);
    CFRelease(event);
    
    PySys_SetObject("__launch_kb_state__", flags);
}

int main(int argc, char *argv[])
{
#if !USING_ARC
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *resourcePath = [mainBundle resourcePath];
    NSArray *pythonPathArray = [NSArray arrayWithObjects: resourcePath, [resourcePath stringByAppendingPathComponent:@"PyObjC"],
                                                                        [resourcePath stringByAppendingPathComponent:@"packages"], nil];
    
    setenv("PYTHONPATH", [[pythonPathArray componentsJoinedByString:@":"] UTF8String], 1);
    
    NSArray *possibleMainExtensions = [NSArray arrayWithObjects: @"py", @"pyc", @"pyo", nil];
    NSString *mainFilePath = nil;
    
    for (NSString *possibleMainExtension in possibleMainExtensions) {
        mainFilePath = [mainBundle pathForResource: @"main" ofType: possibleMainExtension];
        if ( mainFilePath != nil ) break;
    }
    
	if ( !mainFilePath ) {
        [NSException raise: NSInternalInconsistencyException format: @"%s:%d main() Failed to find the Main.{py,pyc,pyo} file in the application wrapper's Resources directory.", __FILE__, __LINE__];
    }
    
    Py_SetProgramName("/usr/bin/python");
    Py_Initialize();
    PySys_SetArgv(argc, (char **)argv);
    
    setKeyFlags();
    const char *mainFilePathPtr = [mainFilePath UTF8String];
    FILE *mainFile = fopen(mainFilePathPtr, "r");
    int result = PyRun_SimpleFile(mainFile, (char *)[[mainFilePath lastPathComponent] UTF8String]);
    
    if ( result != 0 )
        [NSException raise: NSInternalInconsistencyException
                    format: @"%s:%d main() PyRun_SimpleFile failed with file '%@'.  See console for errors.", __FILE__, __LINE__, mainFilePath];
    
#if !USING_ARC
    [pool drain];
#endif
    
    return result;
}
