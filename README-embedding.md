README-embedding

Embedding Python
================

It's entirely possible to embed `Python.framework` into an application, and in fact it provides at least two main benefits:

1. Isolation. Changes to the system `Python.framework` cannot unexpectedly impact an application.
1. Permits usage of the macos10.9 sdk (and, possibly, future versions). Apple chose not to bundle `Python.framework` in the 10.9 sdk, however `/System/Library/Frameworks/Python.framework` is still present and quite functional on all normal 10.9 systems. Apple even suggests the work-around of linking directly to libpythonX.X.dylib and altering the header search paths in one's project. While this will in fact work, I suggest that this is ultimately less beneficial than full embedding as it still results in linking to an external framework whose future, apparently, is uncertain.

Benefits being stated, there are also some drawbacks to this approach.

### Caveats ###

1. `Python.framework` is very *very* large, about 100 megabytes on my system. Partly this is due to the fact that it actually contains numerous minor versions of Python; a problem which is trivially solved by stripping out unneeded versions after copying into one's project (**which is definitely adviseable**) and it's also partly because the framework contains the entire python standard library (modules and packages). Again, the potential exists to strip out unnecessary packages or modules but this must be done with great care.
1. Unfortunately, it doesn't _currently_ seem terribly viable to produce an XCode template which can yank in all of `Python.framework`. It is, at least partially, possible to do this but, during the process of "realizing" the template, XCode quite laboriously copies all of `/System/Library/Frameworks/Python.framework` into the new project. This consumes massive amounts of cpu and will appear to hang for a substantial period of time. It also ignores all symlinks and thus results in huge data duplication -- ballooning the final copied framework to over 400 megabytes!
1. Simply copying in the framework and linking to it is insufficient. One must also perform some fixups on the built "glue binaries" in order to ensure that the system `Python.framework` is not used. _Fortunately however, this can be scripted (_see below_)._

Thus, because it's currently untennable to actually template an embedded project, I will present exact instructions for
accomplishing this. These instructions pertain to XCode 5.0.2 (currently the latest).

## Instructions for embedding Python.framework ##

_(**Note**: Either after or before following these instructions one can remove the `macosx10.8` SDK and SDKROOT settings as there should be no issues with using the "current" [`macosx`] sdk with an embedded framework.)_

1. Create a new project using this template.
1. From a Terminal window, `$ open /System/Library/Frameworks/`
1. Drag `Python.framework` into your project, _make sure you select the option to copy the source folder into your project_.
1. Under either the _General_ or _Build Phases_ tab of your project target drag `Python.framework` from the navigator sidebar into the '_Linked Frameworks and Libraries_' (General) or '_Link Binary With Libraries_' (Build Phases) section.
1. Add a new _Copy Files_ build phase. Set the destination to `Frameworks` and add `Python.framework` by clicking the `+` button. This will cause the output application bundle to include its own Python framework.
1. Add a new "Run Script" build phase via the Editor menu, set the shell to `/bin/bash` and paste the following script into the (very tiny) script editor control (you can name the phase whatever you like, I suggest "Prune Python.framework"):
    <code><pre>py_framework="$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/Python.framework"
    py_ver=$(readlink "$py_framework/Versions/Current")
    for ver in "$py_framework"/Versions/*; do
    if [ -d "$ver" -a ! -L "$ver" -a "$(basename $ver)" != "$py_ver" ]; then
      echo "REMOVE: $ver" >&2
      rm -r "$ver" || exit $?
    fi
    done</code></pre>
1. Add yet another "Run Script" build phase, again setting the shell to `/bin/bash` and paste the following script (again, name it whatever you like ... I would use "Ensure linkage to bundled Python.framework") in:
    <pre><code>py_framework="$TARGET_BUILD_DIR/$FRAMEWORKS_FOLDER_PATH/Python.framework"
    py_ver=$(readlink "$py_framework/Versions/Current")
    dylib_bin="$py_framework/Versions/$py_ver/Python"
    dylib_id=$(otool -D "$dylib_bin" | awk '!/:$/ { print $1; }')
    loader_id="@loader_path/../Frameworks/Python.framework/Versions/$py_ver/Python"
    if [ "${dylib_id%@loader_path/*}" != "" ]; then
      install_name_tool -id "$loader_id" "$dylib_bin"
    fi
    if [ "$dylib_id" != "$loader_id" ]; then
      echo "changing '$dylib_id' to '$loader_id' in $EXECUTABLE_PATH"
      install_name_tool -change "$dylib_id" "$loader_id" \
        "$TARGET_BUILD_DIR/$EXECUTABLE_PATH"
    fi</code></pre>

### Explanation of additional Build Phases ###

The second to last step will remove any additional python versions included in your Python.framework other than the one actually needed.

The last step will set your output executable to load Python.framework from inside your application bundle and ignore any system frameworks that may be installed named `Python.framework`.

Good luck!
