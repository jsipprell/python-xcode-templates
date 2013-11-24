/* This header was created via the Python Cocoa xcode template.
 * The purpose is to check the current build environment's garbage collection and set macros in a
 * portable fashion:

 * - If compiling as objective-C USING_GC is set to 1 otherwise 0 (all objc technically has some form of gc)
 * - If Automatic Reference Counting (ARC) is on, USING_ARC is set to 1 otherwise 0.
 * - If ARC is off, Manual Reference Counting is assumed to be on and USING_MRC is set to 1.
 * - If any macros has been elsewhere defined it is assumed to be 1 if empty (ala via #define FOO)
 */

#define PREFIX_ONE(a) 1##a
#define EMPTY_DEFINE (PREFIX_ONE(a) == 1)

#if !defined(USING_GC)
# if defined(__OBJ_C__)
#   define USING_GC 1
# else
#   define USING_GC 0
# endif
#elif EMPTY_DEFINE(USING_GC)
# undef USING_GC
# define USING_GC 1
#endif

#if !defined(USING_ARC)
# if __has_feature(objc_arc)
#   define USING_ARC 1
# else
#   define USING_ARC 0
# endif
#elif EMPTY_DEFINE(USING_ARC)
# undef USING_ARC
# define USING_ARC 1
#endif

#if USING_GC && !USING_ARC
# if !defined(USING_MRC)
#   define USING_MRC 1
# elif EMPTY_DEFINE(USING_MRC)
#   undef USING_MRC
#   define USING_MRC 1
# endif
#else
# if !defined(USING_MRC)
#   define USING_MRC 0
# endif
#endif

#undef EMPTY_DEFINE
#undef PREFIX_ONE

#if USING_GC
# if USING_ARC || USING_MRC
#   error "Cannot specify GC and RC memory management"
# endif
#elif USING_ARC
# if USING_MRC
#   error "Cannot specify ARC and MRC memory management"
# endif
#elif !USING_MRC
# error "Must specify GC, ARC or MRC memory management"
#endif

#if USING_ARC
# if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_6
#   error "ARC requires at least 10.6"
# endif
#endif
