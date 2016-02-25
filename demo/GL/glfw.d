module GL.glfw;
import core.stdc.config;

extern (C):

alias _Anonymous_0 GLFWvidmode;
alias _Anonymous_1 GLFWimage;
alias int GLFWthread;
alias void* GLFWmutex;
alias void* GLFWcond;
alias void function (int, int) GLFWwindowsizefun;
alias int function () GLFWwindowclosefun;
alias void function () GLFWwindowrefreshfun;
alias void function (int, int) GLFWmousebuttonfun;
alias void function (int, int) GLFWmouseposfun;
alias void function (int) GLFWmousewheelfun;
alias void function (int, int) GLFWkeyfun;
alias void function (int, int) GLFWcharfun;
alias void function (void*) GLFWthreadfun;

struct _Anonymous_0
{
    int Width;
    int Height;
    int RedBits;
    int BlueBits;
    int GreenBits;
}

struct _Anonymous_1
{
    int Width;
    int Height;
    int Format;
    int BytesPerPixel;
    ubyte* Data;
}

int glfwInit ();
void glfwTerminate ();
void glfwGetVersion (int* major, int* minor, int* rev);
int glfwOpenWindow (int width, int height, int redbits, int greenbits, int bluebits, int alphabits, int depthbits, int stencilbits, int mode);
void glfwOpenWindowHint (int target, int hint);
void glfwCloseWindow ();
void glfwSetWindowTitle (const(char)* title);
void glfwGetWindowSize (int* width, int* height);
void glfwSetWindowSize (int width, int height);
void glfwSetWindowPos (int x, int y);
void glfwIconifyWindow ();
void glfwRestoreWindow ();
void glfwSwapBuffers ();
void glfwSwapInterval (int interval);
int glfwGetWindowParam (int param);
void glfwSetWindowSizeCallback (GLFWwindowsizefun cbfun);
void glfwSetWindowCloseCallback (GLFWwindowclosefun cbfun);
void glfwSetWindowRefreshCallback (GLFWwindowrefreshfun cbfun);
int glfwGetVideoModes (GLFWvidmode* list, int maxcount);
void glfwGetDesktopMode (GLFWvidmode* mode);
void glfwPollEvents ();
void glfwWaitEvents ();
int glfwGetKey (int key);
int glfwGetMouseButton (int button);
void glfwGetMousePos (int* xpos, int* ypos);
void glfwSetMousePos (int xpos, int ypos);
int glfwGetMouseWheel ();
void glfwSetMouseWheel (int pos);
void glfwSetKeyCallback (GLFWkeyfun cbfun);
void glfwSetCharCallback (GLFWcharfun cbfun);
void glfwSetMouseButtonCallback (GLFWmousebuttonfun cbfun);
void glfwSetMousePosCallback (GLFWmouseposfun cbfun);
void glfwSetMouseWheelCallback (GLFWmousewheelfun cbfun);
int glfwGetJoystickParam (int joy, int param);
int glfwGetJoystickPos (int joy, float* pos, int numaxes);
int glfwGetJoystickButtons (int joy, ubyte* buttons, int numbuttons);
double glfwGetTime ();
void glfwSetTime (double time);
void glfwSleep (double time);
int glfwExtensionSupported (const(char)* extension);
void* glfwGetProcAddress (const(char)* procname);
void glfwGetGLVersion (int* major, int* minor, int* rev);
GLFWthread glfwCreateThread (GLFWthreadfun fun, void* arg);
void glfwDestroyThread (GLFWthread ID);
int glfwWaitThread (GLFWthread ID, int waitmode);
GLFWthread glfwGetThreadID ();
GLFWmutex glfwCreateMutex ();
void glfwDestroyMutex (GLFWmutex mutex);
void glfwLockMutex (GLFWmutex mutex);
void glfwUnlockMutex (GLFWmutex mutex);
GLFWcond glfwCreateCond ();
void glfwDestroyCond (GLFWcond cond);
void glfwWaitCond (GLFWcond cond, GLFWmutex mutex, double timeout);
void glfwSignalCond (GLFWcond cond);
void glfwBroadcastCond (GLFWcond cond);
int glfwGetNumberOfProcessors ();
void glfwEnable (int token);
void glfwDisable (int token);
int glfwReadImage (const(char)* name, GLFWimage* img, int flags);
int glfwReadMemoryImage (const(void)* data, c_long size, GLFWimage* img, int flags);
void glfwFreeImage (GLFWimage* img);
int glfwLoadTexture2D (const(char)* name, int flags);
int glfwLoadMemoryTexture2D (const(void)* data, c_long size, int flags);
int glfwLoadTextureImage2D (GLFWimage* img, int flags);
