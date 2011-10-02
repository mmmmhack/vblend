

#ifndef __glfw_h_
#define __glfw_h_

#ifdef __cplusplus
extern "C" {
#endif





#ifndef NULL
 #ifdef __cplusplus
  #define NULL 0
 #else
  #define NULL ((void *)0)
 #endif
#endif 





#if !defined(_WIN32) && (defined(__WIN32__) || defined(WIN32) || defined(__CYGWIN__))
 #define _WIN32
#endif 


#ifndef APIENTRY
 #ifdef _WIN32
  #define APIENTRY __stdcall
 #else
  #define APIENTRY
 #endif
 #define GL_APIENTRY_DEFINED
#endif 





#if !defined(WINGDIAPI) && defined(_WIN32)
 #if defined(_MSC_VER) || defined(__BORLANDC__) || defined(__POCC__)
  
  #define WINGDIAPI __declspec(dllimport)
 #elif defined(__LCC__)
  
  #define WINGDIAPI __stdcall
 #else
  
  #define WINGDIAPI extern
 #endif
 #define GL_WINGDIAPI_DEFINED
#endif 


#if !defined(CALLBACK) && defined(_WIN32)
 #if defined(_MSC_VER)
  
  #if (defined(_M_MRX000) || defined(_M_IX86) || defined(_M_ALPHA) || defined(_M_PPC)) && !defined(MIDL_PASS)
   #define CALLBACK __stdcall
  #else
   #define CALLBACK
  #endif
 #else
  
  #define CALLBACK __stdcall
 #endif
 #define GLU_CALLBACK_DEFINED
#endif 


#if defined(_WIN32) && (defined(_MSC_VER) || defined(__BORLANDC__) || defined(__POCC__)) && !defined(_WCHAR_T_DEFINED)
 typedef unsigned short wchar_t;
 #define _WCHAR_T_DEFINED
#endif 




#if defined(_WIN32) && defined(GLFW_BUILD_DLL)

 
 #define GLFWAPI      __declspec(dllexport)
 #define GLFWAPIENTRY __stdcall
 #define GLFWCALL     __stdcall

#elif defined(_WIN32) && defined(GLFW_DLL)

 
 #if defined(__LCC__)
  #define GLFWAPI      extern
 #else
  #define GLFWAPI      __declspec(dllimport)
 #endif
 #define GLFWAPIENTRY __stdcall
 #define GLFWCALL     __stdcall

#else

 
 #define GLFWAPIENTRY
 #define GLFWAPI
 #define GLFWCALL

#endif




#if defined(__APPLE_CC__)
 #include <OpenGL/gl.h>
 #ifndef GLFW_NO_GLU
  #include <OpenGL/glu.h>
 #endif
#else
 #include <GL/gl.h>
 #ifndef GLFW_NO_GLU
  #include <GL/glu.h>
 #endif
#endif




#define GLFW_VERSION_MAJOR    2
#define GLFW_VERSION_MINOR    7
#define GLFW_VERSION_REVISION 0





#define GLFW_RELEASE            0
#define GLFW_PRESS              1


#define GLFW_KEY_UNKNOWN      -1
#define GLFW_KEY_SPACE        32
#define GLFW_KEY_SPECIAL      256
#define GLFW_KEY_ESC          (GLFW_KEY_SPECIAL+1)
#define GLFW_KEY_F1           (GLFW_KEY_SPECIAL+2)
#define GLFW_KEY_F2           (GLFW_KEY_SPECIAL+3)
#define GLFW_KEY_F3           (GLFW_KEY_SPECIAL+4)
#define GLFW_KEY_F4           (GLFW_KEY_SPECIAL+5)
#define GLFW_KEY_F5           (GLFW_KEY_SPECIAL+6)
#define GLFW_KEY_F6           (GLFW_KEY_SPECIAL+7)
#define GLFW_KEY_F7           (GLFW_KEY_SPECIAL+8)
#define GLFW_KEY_F8           (GLFW_KEY_SPECIAL+9)
#define GLFW_KEY_F9           (GLFW_KEY_SPECIAL+10)
#define GLFW_KEY_F10          (GLFW_KEY_SPECIAL+11)
#define GLFW_KEY_F11          (GLFW_KEY_SPECIAL+12)
#define GLFW_KEY_F12          (GLFW_KEY_SPECIAL+13)
#define GLFW_KEY_F13          (GLFW_KEY_SPECIAL+14)
#define GLFW_KEY_F14          (GLFW_KEY_SPECIAL+15)
#define GLFW_KEY_F15          (GLFW_KEY_SPECIAL+16)
#define GLFW_KEY_F16          (GLFW_KEY_SPECIAL+17)
#define GLFW_KEY_F17          (GLFW_KEY_SPECIAL+18)
#define GLFW_KEY_F18          (GLFW_KEY_SPECIAL+19)
#define GLFW_KEY_F19          (GLFW_KEY_SPECIAL+20)
#define GLFW_KEY_F20          (GLFW_KEY_SPECIAL+21)
#define GLFW_KEY_F21          (GLFW_KEY_SPECIAL+22)
#define GLFW_KEY_F22          (GLFW_KEY_SPECIAL+23)
#define GLFW_KEY_F23          (GLFW_KEY_SPECIAL+24)
#define GLFW_KEY_F24          (GLFW_KEY_SPECIAL+25)
#define GLFW_KEY_F25          (GLFW_KEY_SPECIAL+26)
#define GLFW_KEY_UP           (GLFW_KEY_SPECIAL+27)
#define GLFW_KEY_DOWN         (GLFW_KEY_SPECIAL+28)
#define GLFW_KEY_LEFT         (GLFW_KEY_SPECIAL+29)
#define GLFW_KEY_RIGHT        (GLFW_KEY_SPECIAL+30)
#define GLFW_KEY_LSHIFT       (GLFW_KEY_SPECIAL+31)
#define GLFW_KEY_RSHIFT       (GLFW_KEY_SPECIAL+32)
#define GLFW_KEY_LCTRL        (GLFW_KEY_SPECIAL+33)
#define GLFW_KEY_RCTRL        (GLFW_KEY_SPECIAL+34)
#define GLFW_KEY_LALT         (GLFW_KEY_SPECIAL+35)
#define GLFW_KEY_RALT         (GLFW_KEY_SPECIAL+36)
#define GLFW_KEY_TAB          (GLFW_KEY_SPECIAL+37)
#define GLFW_KEY_ENTER        (GLFW_KEY_SPECIAL+38)
#define GLFW_KEY_BACKSPACE    (GLFW_KEY_SPECIAL+39)
#define GLFW_KEY_INSERT       (GLFW_KEY_SPECIAL+40)
#define GLFW_KEY_DEL          (GLFW_KEY_SPECIAL+41)
#define GLFW_KEY_PAGEUP       (GLFW_KEY_SPECIAL+42)
#define GLFW_KEY_PAGEDOWN     (GLFW_KEY_SPECIAL+43)
#define GLFW_KEY_HOME         (GLFW_KEY_SPECIAL+44)
#define GLFW_KEY_END          (GLFW_KEY_SPECIAL+45)
#define GLFW_KEY_KP_0         (GLFW_KEY_SPECIAL+46)
#define GLFW_KEY_KP_1         (GLFW_KEY_SPECIAL+47)
#define GLFW_KEY_KP_2         (GLFW_KEY_SPECIAL+48)
#define GLFW_KEY_KP_3         (GLFW_KEY_SPECIAL+49)
#define GLFW_KEY_KP_4         (GLFW_KEY_SPECIAL+50)
#define GLFW_KEY_KP_5         (GLFW_KEY_SPECIAL+51)
#define GLFW_KEY_KP_6         (GLFW_KEY_SPECIAL+52)
#define GLFW_KEY_KP_7         (GLFW_KEY_SPECIAL+53)
#define GLFW_KEY_KP_8         (GLFW_KEY_SPECIAL+54)
#define GLFW_KEY_KP_9         (GLFW_KEY_SPECIAL+55)
#define GLFW_KEY_KP_DIVIDE    (GLFW_KEY_SPECIAL+56)
#define GLFW_KEY_KP_MULTIPLY  (GLFW_KEY_SPECIAL+57)
#define GLFW_KEY_KP_SUBTRACT  (GLFW_KEY_SPECIAL+58)
#define GLFW_KEY_KP_ADD       (GLFW_KEY_SPECIAL+59)
#define GLFW_KEY_KP_DECIMAL   (GLFW_KEY_SPECIAL+60)
#define GLFW_KEY_KP_EQUAL     (GLFW_KEY_SPECIAL+61)
#define GLFW_KEY_KP_ENTER     (GLFW_KEY_SPECIAL+62)
#define GLFW_KEY_KP_NUM_LOCK  (GLFW_KEY_SPECIAL+63)
#define GLFW_KEY_CAPS_LOCK    (GLFW_KEY_SPECIAL+64)
#define GLFW_KEY_SCROLL_LOCK  (GLFW_KEY_SPECIAL+65)
#define GLFW_KEY_PAUSE        (GLFW_KEY_SPECIAL+66)
#define GLFW_KEY_LSUPER       (GLFW_KEY_SPECIAL+67)
#define GLFW_KEY_RSUPER       (GLFW_KEY_SPECIAL+68)
#define GLFW_KEY_MENU         (GLFW_KEY_SPECIAL+69)
#define GLFW_KEY_LAST         GLFW_KEY_MENU


#define GLFW_MOUSE_BUTTON_1      0
#define GLFW_MOUSE_BUTTON_2      1
#define GLFW_MOUSE_BUTTON_3      2
#define GLFW_MOUSE_BUTTON_4      3
#define GLFW_MOUSE_BUTTON_5      4
#define GLFW_MOUSE_BUTTON_6      5
#define GLFW_MOUSE_BUTTON_7      6
#define GLFW_MOUSE_BUTTON_8      7
#define GLFW_MOUSE_BUTTON_LAST   GLFW_MOUSE_BUTTON_8


#define GLFW_MOUSE_BUTTON_LEFT   GLFW_MOUSE_BUTTON_1
#define GLFW_MOUSE_BUTTON_RIGHT  GLFW_MOUSE_BUTTON_2
#define GLFW_MOUSE_BUTTON_MIDDLE GLFW_MOUSE_BUTTON_3



#define GLFW_JOYSTICK_1          0
#define GLFW_JOYSTICK_2          1
#define GLFW_JOYSTICK_3          2
#define GLFW_JOYSTICK_4          3
#define GLFW_JOYSTICK_5          4
#define GLFW_JOYSTICK_6          5
#define GLFW_JOYSTICK_7          6
#define GLFW_JOYSTICK_8          7
#define GLFW_JOYSTICK_9          8
#define GLFW_JOYSTICK_10         9
#define GLFW_JOYSTICK_11         10
#define GLFW_JOYSTICK_12         11
#define GLFW_JOYSTICK_13         12
#define GLFW_JOYSTICK_14         13
#define GLFW_JOYSTICK_15         14
#define GLFW_JOYSTICK_16         15
#define GLFW_JOYSTICK_LAST       GLFW_JOYSTICK_16





#define GLFW_WINDOW               0x00010001
#define GLFW_FULLSCREEN           0x00010002


#define GLFW_OPENED               0x00020001
#define GLFW_ACTIVE               0x00020002
#define GLFW_ICONIFIED            0x00020003
#define GLFW_ACCELERATED          0x00020004
#define GLFW_RED_BITS             0x00020005
#define GLFW_GREEN_BITS           0x00020006
#define GLFW_BLUE_BITS            0x00020007
#define GLFW_ALPHA_BITS           0x00020008
#define GLFW_DEPTH_BITS           0x00020009
#define GLFW_STENCIL_BITS         0x0002000A


#define GLFW_REFRESH_RATE         0x0002000B
#define GLFW_ACCUM_RED_BITS       0x0002000C
#define GLFW_ACCUM_GREEN_BITS     0x0002000D
#define GLFW_ACCUM_BLUE_BITS      0x0002000E
#define GLFW_ACCUM_ALPHA_BITS     0x0002000F
#define GLFW_AUX_BUFFERS          0x00020010
#define GLFW_STEREO               0x00020011
#define GLFW_WINDOW_NO_RESIZE     0x00020012
#define GLFW_FSAA_SAMPLES         0x00020013
#define GLFW_OPENGL_VERSION_MAJOR 0x00020014
#define GLFW_OPENGL_VERSION_MINOR 0x00020015
#define GLFW_OPENGL_FORWARD_COMPAT 0x00020016
#define GLFW_OPENGL_DEBUG_CONTEXT 0x00020017
#define GLFW_OPENGL_PROFILE       0x00020018


#define GLFW_OPENGL_CORE_PROFILE  0x00050001
#define GLFW_OPENGL_COMPAT_PROFILE 0x00050002


#define GLFW_MOUSE_CURSOR         0x00030001
#define GLFW_STICKY_KEYS          0x00030002
#define GLFW_STICKY_MOUSE_BUTTONS 0x00030003
#define GLFW_SYSTEM_KEYS          0x00030004
#define GLFW_KEY_REPEAT           0x00030005
#define GLFW_AUTO_POLL_EVENTS     0x00030006


#define GLFW_WAIT                 0x00040001
#define GLFW_NOWAIT               0x00040002


#define GLFW_PRESENT              0x00050001
#define GLFW_AXES                 0x00050002
#define GLFW_BUTTONS              0x00050003


#define GLFW_NO_RESCALE_BIT       0x00000001 
#define GLFW_ORIGIN_UL_BIT        0x00000002
#define GLFW_BUILD_MIPMAPS_BIT    0x00000004 
#define GLFW_ALPHA_MAP_BIT        0x00000008


#define GLFW_INFINITY 100000.0





typedef struct {
    int Width, Height;
    int RedBits, BlueBits, GreenBits;
} GLFWvidmode;


typedef struct {
    int Width, Height;
    int Format;
    int BytesPerPixel;
    unsigned char *Data;
} GLFWimage;


typedef int GLFWthread;


typedef void * GLFWmutex;


typedef void * GLFWcond;


typedef void (GLFWCALL * GLFWwindowsizefun)(int,int);
typedef int  (GLFWCALL * GLFWwindowclosefun)(void);
typedef void (GLFWCALL * GLFWwindowrefreshfun)(void);
typedef void (GLFWCALL * GLFWmousebuttonfun)(int,int);
typedef void (GLFWCALL * GLFWmouseposfun)(int,int);
typedef void (GLFWCALL * GLFWmousewheelfun)(int);
typedef void (GLFWCALL * GLFWkeyfun)(int,int);
typedef void (GLFWCALL * GLFWcharfun)(int,int);
typedef void (GLFWCALL * GLFWthreadfun)(void *);





GLFWAPI int  GLFWAPIENTRY glfwInit( void );
GLFWAPI void GLFWAPIENTRY glfwTerminate( void );
GLFWAPI void GLFWAPIENTRY glfwGetVersion( int *major, int *minor, int *rev );


GLFWAPI int  GLFWAPIENTRY glfwOpenWindow( int width, int height, int redbits, int greenbits, int bluebits, int alphabits, int depthbits, int stencilbits, int mode );
GLFWAPI void GLFWAPIENTRY glfwOpenWindowHint( int target, int hint );
GLFWAPI void GLFWAPIENTRY glfwCloseWindow( void );
GLFWAPI void GLFWAPIENTRY glfwSetWindowTitle( const char *title );
GLFWAPI void GLFWAPIENTRY glfwGetWindowSize( int *width, int *height );
GLFWAPI void GLFWAPIENTRY glfwSetWindowSize( int width, int height );
GLFWAPI void GLFWAPIENTRY glfwSetWindowPos( int x, int y );
GLFWAPI void GLFWAPIENTRY glfwIconifyWindow( void );
GLFWAPI void GLFWAPIENTRY glfwRestoreWindow( void );
GLFWAPI void GLFWAPIENTRY glfwSwapBuffers( void );
GLFWAPI void GLFWAPIENTRY glfwSwapInterval( int interval );
GLFWAPI int  GLFWAPIENTRY glfwGetWindowParam( int param );
GLFWAPI void GLFWAPIENTRY glfwSetWindowSizeCallback( GLFWwindowsizefun cbfun );
GLFWAPI void GLFWAPIENTRY glfwSetWindowCloseCallback( GLFWwindowclosefun cbfun );
GLFWAPI void GLFWAPIENTRY glfwSetWindowRefreshCallback( GLFWwindowrefreshfun cbfun );


GLFWAPI int  GLFWAPIENTRY glfwGetVideoModes( GLFWvidmode *list, int maxcount );
GLFWAPI void GLFWAPIENTRY glfwGetDesktopMode( GLFWvidmode *mode );


GLFWAPI void GLFWAPIENTRY glfwPollEvents( void );
GLFWAPI void GLFWAPIENTRY glfwWaitEvents( void );
GLFWAPI int  GLFWAPIENTRY glfwGetKey( int key );
GLFWAPI int  GLFWAPIENTRY glfwGetMouseButton( int button );
GLFWAPI void GLFWAPIENTRY glfwGetMousePos( int *xpos, int *ypos );
GLFWAPI void GLFWAPIENTRY glfwSetMousePos( int xpos, int ypos );
GLFWAPI int  GLFWAPIENTRY glfwGetMouseWheel( void );
GLFWAPI void GLFWAPIENTRY glfwSetMouseWheel( int pos );
GLFWAPI void GLFWAPIENTRY glfwSetKeyCallback( GLFWkeyfun cbfun );
GLFWAPI void GLFWAPIENTRY glfwSetCharCallback( GLFWcharfun cbfun );
GLFWAPI void GLFWAPIENTRY glfwSetMouseButtonCallback( GLFWmousebuttonfun cbfun );
GLFWAPI void GLFWAPIENTRY glfwSetMousePosCallback( GLFWmouseposfun cbfun );
GLFWAPI void GLFWAPIENTRY glfwSetMouseWheelCallback( GLFWmousewheelfun cbfun );


GLFWAPI int GLFWAPIENTRY glfwGetJoystickParam( int joy, int param );
GLFWAPI int GLFWAPIENTRY glfwGetJoystickPos( int joy, float *pos, int numaxes );
GLFWAPI int GLFWAPIENTRY glfwGetJoystickButtons( int joy, unsigned char *buttons, int numbuttons );


GLFWAPI double GLFWAPIENTRY glfwGetTime( void );
GLFWAPI void   GLFWAPIENTRY glfwSetTime( double time );
GLFWAPI void   GLFWAPIENTRY glfwSleep( double time );


GLFWAPI int   GLFWAPIENTRY glfwExtensionSupported( const char *extension );
GLFWAPI void* GLFWAPIENTRY glfwGetProcAddress( const char *procname );
GLFWAPI void  GLFWAPIENTRY glfwGetGLVersion( int *major, int *minor, int *rev );


GLFWAPI GLFWthread GLFWAPIENTRY glfwCreateThread( GLFWthreadfun fun, void *arg );
GLFWAPI void GLFWAPIENTRY glfwDestroyThread( GLFWthread ID );
GLFWAPI int  GLFWAPIENTRY glfwWaitThread( GLFWthread ID, int waitmode );
GLFWAPI GLFWthread GLFWAPIENTRY glfwGetThreadID( void );
GLFWAPI GLFWmutex GLFWAPIENTRY glfwCreateMutex( void );
GLFWAPI void GLFWAPIENTRY glfwDestroyMutex( GLFWmutex mutex );
GLFWAPI void GLFWAPIENTRY glfwLockMutex( GLFWmutex mutex );
GLFWAPI void GLFWAPIENTRY glfwUnlockMutex( GLFWmutex mutex );
GLFWAPI GLFWcond GLFWAPIENTRY glfwCreateCond( void );
GLFWAPI void GLFWAPIENTRY glfwDestroyCond( GLFWcond cond );
GLFWAPI void GLFWAPIENTRY glfwWaitCond( GLFWcond cond, GLFWmutex mutex, double timeout );
GLFWAPI void GLFWAPIENTRY glfwSignalCond( GLFWcond cond );
GLFWAPI void GLFWAPIENTRY glfwBroadcastCond( GLFWcond cond );
GLFWAPI int  GLFWAPIENTRY glfwGetNumberOfProcessors( void );


GLFWAPI void GLFWAPIENTRY glfwEnable( int token );
GLFWAPI void GLFWAPIENTRY glfwDisable( int token );


GLFWAPI int  GLFWAPIENTRY glfwReadImage( const char *name, GLFWimage *img, int flags );
GLFWAPI int  GLFWAPIENTRY glfwReadMemoryImage( const void *data, long size, GLFWimage *img, int flags );
GLFWAPI void GLFWAPIENTRY glfwFreeImage( GLFWimage *img );
GLFWAPI int  GLFWAPIENTRY glfwLoadTexture2D( const char *name, int flags );
GLFWAPI int  GLFWAPIENTRY glfwLoadMemoryTexture2D( const void *data, long size, int flags );
GLFWAPI int  GLFWAPIENTRY glfwLoadTextureImage2D( GLFWimage *img, int flags );


#ifdef __cplusplus
}
#endif

#endif 

