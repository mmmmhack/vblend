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
 int   glfwInit( void );
 void  glfwTerminate( void );
 void  glfwGetVersion( int *major, int *minor, int *rev );
 int   glfwOpenWindow( int width, int height, int redbits, int greenbits, int bluebits, int alphabits, int depthbits, int stencilbits, int mode );
 void  glfwOpenWindowHint( int target, int hint );
 void  glfwCloseWindow( void );
 void  glfwSetWindowTitle( const char *title );
 void  glfwGetWindowSize( int *width, int *height );
 void  glfwSetWindowSize( int width, int height );
 void  glfwSetWindowPos( int x, int y );
 void  glfwIconifyWindow( void );
 void  glfwRestoreWindow( void );
 void  glfwSwapBuffers( void );
 void  glfwSwapInterval( int interval );
 int   glfwGetWindowParam( int param );
 void  glfwSetWindowSizeCallback( GLFWwindowsizefun cbfun );
 void  glfwSetWindowCloseCallback( GLFWwindowclosefun cbfun );
 void  glfwSetWindowRefreshCallback( GLFWwindowrefreshfun cbfun );
 int   glfwGetVideoModes( GLFWvidmode *list, int maxcount );
 void  glfwGetDesktopMode( GLFWvidmode *mode );
 void  glfwPollEvents( void );
 void  glfwWaitEvents( void );
 int   glfwGetKey( int key );
 int   glfwGetMouseButton( int button );
 void  glfwGetMousePos( int *xpos, int *ypos );
 void  glfwSetMousePos( int xpos, int ypos );
 int   glfwGetMouseWheel( void );
 void  glfwSetMouseWheel( int pos );
 void  glfwSetKeyCallback( GLFWkeyfun cbfun );
 void  glfwSetCharCallback( GLFWcharfun cbfun );
 void  glfwSetMouseButtonCallback( GLFWmousebuttonfun cbfun );
 void  glfwSetMousePosCallback( GLFWmouseposfun cbfun );
 void  glfwSetMouseWheelCallback( GLFWmousewheelfun cbfun );
 int  glfwGetJoystickParam( int joy, int param );
 int  glfwGetJoystickPos( int joy, float *pos, int numaxes );
 int  glfwGetJoystickButtons( int joy, unsigned char *buttons, int numbuttons );
 double  glfwGetTime( void );
 void    glfwSetTime( double time );
 void    glfwSleep( double time );
 int    glfwExtensionSupported( const char *extension );
 void*  glfwGetProcAddress( const char *procname );
 void   glfwGetGLVersion( int *major, int *minor, int *rev );
 GLFWthread  glfwCreateThread( GLFWthreadfun fun, void *arg );
 void  glfwDestroyThread( GLFWthread ID );
 int   glfwWaitThread( GLFWthread ID, int waitmode );
 GLFWthread  glfwGetThreadID( void );
 GLFWmutex  glfwCreateMutex( void );
 void  glfwDestroyMutex( GLFWmutex mutex );
 void  glfwLockMutex( GLFWmutex mutex );
 void  glfwUnlockMutex( GLFWmutex mutex );
 GLFWcond  glfwCreateCond( void );
 void  glfwDestroyCond( GLFWcond cond );
 void  glfwWaitCond( GLFWcond cond, GLFWmutex mutex, double timeout );
 void  glfwSignalCond( GLFWcond cond );
 void  glfwBroadcastCond( GLFWcond cond );
 int   glfwGetNumberOfProcessors( void );
 void  glfwEnable( int token );
 void  glfwDisable( int token );
 int   glfwReadImage( const char *name, GLFWimage *img, int flags );
 int   glfwReadMemoryImage( const void *data, long size, GLFWimage *img, int flags );
 void  glfwFreeImage( GLFWimage *img );
 int   glfwLoadTexture2D( const char *name, int flags );
 int   glfwLoadMemoryTexture2D( const void *data, long size, int flags );
 int   glfwLoadTextureImage2D( GLFWimage *img, int flags );
