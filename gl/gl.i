typedef unsigned int	GLenum;
typedef unsigned char	GLboolean;
typedef unsigned int	GLbitfield;
typedef void		GLvoid;
typedef signed char	GLbyte;		
typedef short		GLshort;	
typedef int		GLint;		
typedef unsigned char	GLubyte;	
typedef unsigned short	GLushort;	
typedef unsigned int	GLuint;		
typedef int		GLsizei;	
typedef float		GLfloat;	
typedef float		GLclampf;	
typedef double		GLdouble;	
typedef double		GLclampd;	
 void  glClearIndex( GLfloat c );
 void  glClearColor( GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha );
 void  glClear( GLbitfield mask );
 void  glIndexMask( GLuint mask );
 void  glColorMask( GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha );
 void  glAlphaFunc( GLenum func, GLclampf ref );
 void  glBlendFunc( GLenum sfactor, GLenum dfactor );
 void  glLogicOp( GLenum opcode );
 void  glCullFace( GLenum mode );
 void  glFrontFace( GLenum mode );
 void  glPointSize( GLfloat size );
 void  glLineWidth( GLfloat width );
 void  glLineStipple( GLint factor, GLushort pattern );
 void  glPolygonMode( GLenum face, GLenum mode );
 void  glPolygonOffset( GLfloat factor, GLfloat units );
 void  glPolygonStipple( const GLubyte *mask );
 void  glGetPolygonStipple( GLubyte *mask );
 void  glEdgeFlag( GLboolean flag );
 void  glEdgeFlagv( const GLboolean *flag );
 void  glScissor( GLint x, GLint y, GLsizei width, GLsizei height);
 void  glClipPlane( GLenum plane, const GLdouble *equation );
 void  glGetClipPlane( GLenum plane, GLdouble *equation );
 void  glDrawBuffer( GLenum mode );
 void  glReadBuffer( GLenum mode );
 void  glEnable( GLenum cap );
 void  glDisable( GLenum cap );
 GLboolean  glIsEnabled( GLenum cap );
 void  glEnableClientState( GLenum cap );  
 void  glDisableClientState( GLenum cap );  
 void  glGetBooleanv( GLenum pname, GLboolean *params );
 void  glGetDoublev( GLenum pname, GLdouble *params );
 void  glGetFloatv( GLenum pname, GLfloat *params );
 void  glGetIntegerv( GLenum pname, GLint *params );
 void  glPushAttrib( GLbitfield mask );
 void  glPopAttrib( void );
 void  glPushClientAttrib( GLbitfield mask );  
 void  glPopClientAttrib( void );  
 GLint  glRenderMode( GLenum mode );
 GLenum  glGetError( void );
 const GLubyte *  glGetString( GLenum name );
 void  glFinish( void );
 void  glFlush( void );
 void  glHint( GLenum target, GLenum mode );
 void  glClearDepth( GLclampd depth );
 void  glDepthFunc( GLenum func );
 void  glDepthMask( GLboolean flag );
 void  glDepthRange( GLclampd near_val, GLclampd far_val );
 void  glClearAccum( GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha );
 void  glAccum( GLenum op, GLfloat value );
 void  glMatrixMode( GLenum mode );
 void  glOrtho( GLdouble left, GLdouble right,
                                 GLdouble bottom, GLdouble top,
                                 GLdouble near_val, GLdouble far_val );
 void  glFrustum( GLdouble left, GLdouble right,
                                   GLdouble bottom, GLdouble top,
                                   GLdouble near_val, GLdouble far_val );
 void  glViewport( GLint x, GLint y,
                                    GLsizei width, GLsizei height );
 void  glPushMatrix( void );
 void  glPopMatrix( void );
 void  glLoadIdentity( void );
 void  glLoadMatrixd( const GLdouble *m );
 void  glLoadMatrixf( const GLfloat *m );
 void  glMultMatrixd( const GLdouble *m );
 void  glMultMatrixf( const GLfloat *m );
 void  glRotated( GLdouble angle,
                                   GLdouble x, GLdouble y, GLdouble z );
 void  glRotatef( GLfloat angle,
                                   GLfloat x, GLfloat y, GLfloat z );
 void  glScaled( GLdouble x, GLdouble y, GLdouble z );
 void  glScalef( GLfloat x, GLfloat y, GLfloat z );
 void  glTranslated( GLdouble x, GLdouble y, GLdouble z );
 void  glTranslatef( GLfloat x, GLfloat y, GLfloat z );
 GLboolean  glIsList( GLuint list );
 void  glDeleteLists( GLuint list, GLsizei range );
 GLuint  glGenLists( GLsizei range );
 void  glNewList( GLuint list, GLenum mode );
 void  glEndList( void );
 void  glCallList( GLuint list );
 void  glCallLists( GLsizei n, GLenum type,
                                     const GLvoid *lists );
 void  glListBase( GLuint base );
 void  glBegin( GLenum mode );
 void  glEnd( void );
 void  glVertex2d( GLdouble x, GLdouble y );
 void  glVertex2f( GLfloat x, GLfloat y );
 void  glVertex2i( GLint x, GLint y );
 void  glVertex2s( GLshort x, GLshort y );
 void  glVertex3d( GLdouble x, GLdouble y, GLdouble z );
 void  glVertex3f( GLfloat x, GLfloat y, GLfloat z );
 void  glVertex3i( GLint x, GLint y, GLint z );
 void  glVertex3s( GLshort x, GLshort y, GLshort z );
 void  glVertex4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
 void  glVertex4f( GLfloat x, GLfloat y, GLfloat z, GLfloat w );
 void  glVertex4i( GLint x, GLint y, GLint z, GLint w );
 void  glVertex4s( GLshort x, GLshort y, GLshort z, GLshort w );
 void  glVertex2dv( const GLdouble *v );
 void  glVertex2fv( const GLfloat *v );
 void  glVertex2iv( const GLint *v );
 void  glVertex2sv( const GLshort *v );
 void  glVertex3dv( const GLdouble *v );
 void  glVertex3fv( const GLfloat *v );
 void  glVertex3iv( const GLint *v );
 void  glVertex3sv( const GLshort *v );
 void  glVertex4dv( const GLdouble *v );
 void  glVertex4fv( const GLfloat *v );
 void  glVertex4iv( const GLint *v );
 void  glVertex4sv( const GLshort *v );
 void  glNormal3b( GLbyte nx, GLbyte ny, GLbyte nz );
 void  glNormal3d( GLdouble nx, GLdouble ny, GLdouble nz );
 void  glNormal3f( GLfloat nx, GLfloat ny, GLfloat nz );
 void  glNormal3i( GLint nx, GLint ny, GLint nz );
 void  glNormal3s( GLshort nx, GLshort ny, GLshort nz );
 void  glNormal3bv( const GLbyte *v );
 void  glNormal3dv( const GLdouble *v );
 void  glNormal3fv( const GLfloat *v );
 void  glNormal3iv( const GLint *v );
 void  glNormal3sv( const GLshort *v );
 void  glIndexd( GLdouble c );
 void  glIndexf( GLfloat c );
 void  glIndexi( GLint c );
 void  glIndexs( GLshort c );
 void  glIndexub( GLubyte c );  
 void  glIndexdv( const GLdouble *c );
 void  glIndexfv( const GLfloat *c );
 void  glIndexiv( const GLint *c );
 void  glIndexsv( const GLshort *c );
 void  glIndexubv( const GLubyte *c );  
 void  glColor3b( GLbyte red, GLbyte green, GLbyte blue );
 void  glColor3d( GLdouble red, GLdouble green, GLdouble blue );
 void  glColor3f( GLfloat red, GLfloat green, GLfloat blue );
 void  glColor3i( GLint red, GLint green, GLint blue );
 void  glColor3s( GLshort red, GLshort green, GLshort blue );
 void  glColor3ub( GLubyte red, GLubyte green, GLubyte blue );
 void  glColor3ui( GLuint red, GLuint green, GLuint blue );
 void  glColor3us( GLushort red, GLushort green, GLushort blue );
 void  glColor4b( GLbyte red, GLbyte green,
                                   GLbyte blue, GLbyte alpha );
 void  glColor4d( GLdouble red, GLdouble green,
                                   GLdouble blue, GLdouble alpha );
 void  glColor4f( GLfloat red, GLfloat green,
                                   GLfloat blue, GLfloat alpha );
 void  glColor4i( GLint red, GLint green,
                                   GLint blue, GLint alpha );
 void  glColor4s( GLshort red, GLshort green,
                                   GLshort blue, GLshort alpha );
 void  glColor4ub( GLubyte red, GLubyte green,
                                    GLubyte blue, GLubyte alpha );
 void  glColor4ui( GLuint red, GLuint green,
                                    GLuint blue, GLuint alpha );
 void  glColor4us( GLushort red, GLushort green,
                                    GLushort blue, GLushort alpha );
 void  glColor3bv( const GLbyte *v );
 void  glColor3dv( const GLdouble *v );
 void  glColor3fv( const GLfloat *v );
 void  glColor3iv( const GLint *v );
 void  glColor3sv( const GLshort *v );
 void  glColor3ubv( const GLubyte *v );
 void  glColor3uiv( const GLuint *v );
 void  glColor3usv( const GLushort *v );
 void  glColor4bv( const GLbyte *v );
 void  glColor4dv( const GLdouble *v );
 void  glColor4fv( const GLfloat *v );
 void  glColor4iv( const GLint *v );
 void  glColor4sv( const GLshort *v );
 void  glColor4ubv( const GLubyte *v );
 void  glColor4uiv( const GLuint *v );
 void  glColor4usv( const GLushort *v );
 void  glTexCoord1d( GLdouble s );
 void  glTexCoord1f( GLfloat s );
 void  glTexCoord1i( GLint s );
 void  glTexCoord1s( GLshort s );
 void  glTexCoord2d( GLdouble s, GLdouble t );
 void  glTexCoord2f( GLfloat s, GLfloat t );
 void  glTexCoord2i( GLint s, GLint t );
 void  glTexCoord2s( GLshort s, GLshort t );
 void  glTexCoord3d( GLdouble s, GLdouble t, GLdouble r );
 void  glTexCoord3f( GLfloat s, GLfloat t, GLfloat r );
 void  glTexCoord3i( GLint s, GLint t, GLint r );
 void  glTexCoord3s( GLshort s, GLshort t, GLshort r );
 void  glTexCoord4d( GLdouble s, GLdouble t, GLdouble r, GLdouble q );
 void  glTexCoord4f( GLfloat s, GLfloat t, GLfloat r, GLfloat q );
 void  glTexCoord4i( GLint s, GLint t, GLint r, GLint q );
 void  glTexCoord4s( GLshort s, GLshort t, GLshort r, GLshort q );
 void  glTexCoord1dv( const GLdouble *v );
 void  glTexCoord1fv( const GLfloat *v );
 void  glTexCoord1iv( const GLint *v );
 void  glTexCoord1sv( const GLshort *v );
 void  glTexCoord2dv( const GLdouble *v );
 void  glTexCoord2fv( const GLfloat *v );
 void  glTexCoord2iv( const GLint *v );
 void  glTexCoord2sv( const GLshort *v );
 void  glTexCoord3dv( const GLdouble *v );
 void  glTexCoord3fv( const GLfloat *v );
 void  glTexCoord3iv( const GLint *v );
 void  glTexCoord3sv( const GLshort *v );
 void  glTexCoord4dv( const GLdouble *v );
 void  glTexCoord4fv( const GLfloat *v );
 void  glTexCoord4iv( const GLint *v );
 void  glTexCoord4sv( const GLshort *v );
 void  glRasterPos2d( GLdouble x, GLdouble y );
 void  glRasterPos2f( GLfloat x, GLfloat y );
 void  glRasterPos2i( GLint x, GLint y );
 void  glRasterPos2s( GLshort x, GLshort y );
 void  glRasterPos3d( GLdouble x, GLdouble y, GLdouble z );
 void  glRasterPos3f( GLfloat x, GLfloat y, GLfloat z );
 void  glRasterPos3i( GLint x, GLint y, GLint z );
 void  glRasterPos3s( GLshort x, GLshort y, GLshort z );
 void  glRasterPos4d( GLdouble x, GLdouble y, GLdouble z, GLdouble w );
 void  glRasterPos4f( GLfloat x, GLfloat y, GLfloat z, GLfloat w );
 void  glRasterPos4i( GLint x, GLint y, GLint z, GLint w );
 void  glRasterPos4s( GLshort x, GLshort y, GLshort z, GLshort w );
 void  glRasterPos2dv( const GLdouble *v );
 void  glRasterPos2fv( const GLfloat *v );
 void  glRasterPos2iv( const GLint *v );
 void  glRasterPos2sv( const GLshort *v );
 void  glRasterPos3dv( const GLdouble *v );
 void  glRasterPos3fv( const GLfloat *v );
 void  glRasterPos3iv( const GLint *v );
 void  glRasterPos3sv( const GLshort *v );
 void  glRasterPos4dv( const GLdouble *v );
 void  glRasterPos4fv( const GLfloat *v );
 void  glRasterPos4iv( const GLint *v );
 void  glRasterPos4sv( const GLshort *v );
 void  glRectd( GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2 );
 void  glRectf( GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2 );
 void  glRecti( GLint x1, GLint y1, GLint x2, GLint y2 );
 void  glRects( GLshort x1, GLshort y1, GLshort x2, GLshort y2 );
 void  glRectdv( const GLdouble *v1, const GLdouble *v2 );
 void  glRectfv( const GLfloat *v1, const GLfloat *v2 );
 void  glRectiv( const GLint *v1, const GLint *v2 );
 void  glRectsv( const GLshort *v1, const GLshort *v2 );
 void  glVertexPointer( GLint size, GLenum type,
                                       GLsizei stride, const GLvoid *ptr );
 void  glNormalPointer( GLenum type, GLsizei stride,
                                       const GLvoid *ptr );
 void  glColorPointer( GLint size, GLenum type,
                                      GLsizei stride, const GLvoid *ptr );
 void  glIndexPointer( GLenum type, GLsizei stride,
                                      const GLvoid *ptr );
 void  glTexCoordPointer( GLint size, GLenum type,
                                         GLsizei stride, const GLvoid *ptr );
 void  glEdgeFlagPointer( GLsizei stride, const GLvoid *ptr );
 void  glGetPointerv( GLenum pname, GLvoid **params );
 void  glArrayElement( GLint i );
 void  glDrawArrays( GLenum mode, GLint first, GLsizei count );
 void  glDrawElements( GLenum mode, GLsizei count,
                                      GLenum type, const GLvoid *indices );
 void  glInterleavedArrays( GLenum format, GLsizei stride,
                                           const GLvoid *pointer );
 void  glShadeModel( GLenum mode );
 void  glLightf( GLenum light, GLenum pname, GLfloat param );
 void  glLighti( GLenum light, GLenum pname, GLint param );
 void  glLightfv( GLenum light, GLenum pname,
                                 const GLfloat *params );
 void  glLightiv( GLenum light, GLenum pname,
                                 const GLint *params );
 void  glGetLightfv( GLenum light, GLenum pname,
                                    GLfloat *params );
 void  glGetLightiv( GLenum light, GLenum pname,
                                    GLint *params );
 void  glLightModelf( GLenum pname, GLfloat param );
 void  glLightModeli( GLenum pname, GLint param );
 void  glLightModelfv( GLenum pname, const GLfloat *params );
 void  glLightModeliv( GLenum pname, const GLint *params );
 void  glMaterialf( GLenum face, GLenum pname, GLfloat param );
 void  glMateriali( GLenum face, GLenum pname, GLint param );
 void  glMaterialfv( GLenum face, GLenum pname, const GLfloat *params );
 void  glMaterialiv( GLenum face, GLenum pname, const GLint *params );
 void  glGetMaterialfv( GLenum face, GLenum pname, GLfloat *params );
 void  glGetMaterialiv( GLenum face, GLenum pname, GLint *params );
 void  glColorMaterial( GLenum face, GLenum mode );
 void  glPixelZoom( GLfloat xfactor, GLfloat yfactor );
 void  glPixelStoref( GLenum pname, GLfloat param );
 void  glPixelStorei( GLenum pname, GLint param );
 void  glPixelTransferf( GLenum pname, GLfloat param );
 void  glPixelTransferi( GLenum pname, GLint param );
 void  glPixelMapfv( GLenum map, GLsizei mapsize,
                                    const GLfloat *values );
 void  glPixelMapuiv( GLenum map, GLsizei mapsize,
                                     const GLuint *values );
 void  glPixelMapusv( GLenum map, GLsizei mapsize,
                                     const GLushort *values );
 void  glGetPixelMapfv( GLenum map, GLfloat *values );
 void  glGetPixelMapuiv( GLenum map, GLuint *values );
 void  glGetPixelMapusv( GLenum map, GLushort *values );
 void  glBitmap( GLsizei width, GLsizei height,
                                GLfloat xorig, GLfloat yorig,
                                GLfloat xmove, GLfloat ymove,
                                const GLubyte *bitmap );
 void  glReadPixels( GLint x, GLint y,
                                    GLsizei width, GLsizei height,
                                    GLenum format, GLenum type,
                                    GLvoid *pixels );
 void  glDrawPixels( GLsizei width, GLsizei height,
                                    GLenum format, GLenum type,
                                    const GLvoid *pixels );
 void  glCopyPixels( GLint x, GLint y,
                                    GLsizei width, GLsizei height,
                                    GLenum type );
 void  glStencilFunc( GLenum func, GLint ref, GLuint mask );
 void  glStencilMask( GLuint mask );
 void  glStencilOp( GLenum fail, GLenum zfail, GLenum zpass );
 void  glClearStencil( GLint s );
 void  glTexGend( GLenum coord, GLenum pname, GLdouble param );
 void  glTexGenf( GLenum coord, GLenum pname, GLfloat param );
 void  glTexGeni( GLenum coord, GLenum pname, GLint param );
 void  glTexGendv( GLenum coord, GLenum pname, const GLdouble *params );
 void  glTexGenfv( GLenum coord, GLenum pname, const GLfloat *params );
 void  glTexGeniv( GLenum coord, GLenum pname, const GLint *params );
 void  glGetTexGendv( GLenum coord, GLenum pname, GLdouble *params );
 void  glGetTexGenfv( GLenum coord, GLenum pname, GLfloat *params );
 void  glGetTexGeniv( GLenum coord, GLenum pname, GLint *params );
 void  glTexEnvf( GLenum target, GLenum pname, GLfloat param );
 void  glTexEnvi( GLenum target, GLenum pname, GLint param );
 void  glTexEnvfv( GLenum target, GLenum pname, const GLfloat *params );
 void  glTexEnviv( GLenum target, GLenum pname, const GLint *params );
 void  glGetTexEnvfv( GLenum target, GLenum pname, GLfloat *params );
 void  glGetTexEnviv( GLenum target, GLenum pname, GLint *params );
 void  glTexParameterf( GLenum target, GLenum pname, GLfloat param );
 void  glTexParameteri( GLenum target, GLenum pname, GLint param );
 void  glTexParameterfv( GLenum target, GLenum pname,
                                          const GLfloat *params );
 void  glTexParameteriv( GLenum target, GLenum pname,
                                          const GLint *params );
 void  glGetTexParameterfv( GLenum target,
                                           GLenum pname, GLfloat *params);
 void  glGetTexParameteriv( GLenum target,
                                           GLenum pname, GLint *params );
 void  glGetTexLevelParameterfv( GLenum target, GLint level,
                                                GLenum pname, GLfloat *params );
 void  glGetTexLevelParameteriv( GLenum target, GLint level,
                                                GLenum pname, GLint *params );
 void  glTexImage1D( GLenum target, GLint level,
                                    GLint internalFormat,
                                    GLsizei width, GLint border,
                                    GLenum format, GLenum type,
                                    const GLvoid *pixels );
 void  glTexImage2D( GLenum target, GLint level,
                                    GLint internalFormat,
                                    GLsizei width, GLsizei height,
                                    GLint border, GLenum format, GLenum type,
                                    const GLvoid *pixels );
 void  glGetTexImage( GLenum target, GLint level,
                                     GLenum format, GLenum type,
                                     GLvoid *pixels );
 void  glGenTextures( GLsizei n, GLuint *textures );
 void  glDeleteTextures( GLsizei n, const GLuint *textures);
 void  glBindTexture( GLenum target, GLuint texture );
 void  glPrioritizeTextures( GLsizei n,
                                            const GLuint *textures,
                                            const GLclampf *priorities );
 GLboolean  glAreTexturesResident( GLsizei n,
                                                  const GLuint *textures,
                                                  GLboolean *residences );
 GLboolean  glIsTexture( GLuint texture );
 void  glTexSubImage1D( GLenum target, GLint level,
                                       GLint xoffset,
                                       GLsizei width, GLenum format,
                                       GLenum type, const GLvoid *pixels );
 void  glTexSubImage2D( GLenum target, GLint level,
                                       GLint xoffset, GLint yoffset,
                                       GLsizei width, GLsizei height,
                                       GLenum format, GLenum type,
                                       const GLvoid *pixels );
 void  glCopyTexImage1D( GLenum target, GLint level,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei width, GLint border );
 void  glCopyTexImage2D( GLenum target, GLint level,
                                        GLenum internalformat,
                                        GLint x, GLint y,
                                        GLsizei width, GLsizei height,
                                        GLint border );
 void  glCopyTexSubImage1D( GLenum target, GLint level,
                                           GLint xoffset, GLint x, GLint y,
                                           GLsizei width );
 void  glCopyTexSubImage2D( GLenum target, GLint level,
                                           GLint xoffset, GLint yoffset,
                                           GLint x, GLint y,
                                           GLsizei width, GLsizei height );
 void  glMap1d( GLenum target, GLdouble u1, GLdouble u2,
                               GLint stride,
                               GLint order, const GLdouble *points );
 void  glMap1f( GLenum target, GLfloat u1, GLfloat u2,
                               GLint stride,
                               GLint order, const GLfloat *points );
 void  glMap2d( GLenum target,
		     GLdouble u1, GLdouble u2, GLint ustride, GLint uorder,
		     GLdouble v1, GLdouble v2, GLint vstride, GLint vorder,
		     const GLdouble *points );
 void  glMap2f( GLenum target,
		     GLfloat u1, GLfloat u2, GLint ustride, GLint uorder,
		     GLfloat v1, GLfloat v2, GLint vstride, GLint vorder,
		     const GLfloat *points );
 void  glGetMapdv( GLenum target, GLenum query, GLdouble *v );
 void  glGetMapfv( GLenum target, GLenum query, GLfloat *v );
 void  glGetMapiv( GLenum target, GLenum query, GLint *v );
 void  glEvalCoord1d( GLdouble u );
 void  glEvalCoord1f( GLfloat u );
 void  glEvalCoord1dv( const GLdouble *u );
 void  glEvalCoord1fv( const GLfloat *u );
 void  glEvalCoord2d( GLdouble u, GLdouble v );
 void  glEvalCoord2f( GLfloat u, GLfloat v );
 void  glEvalCoord2dv( const GLdouble *u );
 void  glEvalCoord2fv( const GLfloat *u );
 void  glMapGrid1d( GLint un, GLdouble u1, GLdouble u2 );
 void  glMapGrid1f( GLint un, GLfloat u1, GLfloat u2 );
 void  glMapGrid2d( GLint un, GLdouble u1, GLdouble u2,
                                   GLint vn, GLdouble v1, GLdouble v2 );
 void  glMapGrid2f( GLint un, GLfloat u1, GLfloat u2,
                                   GLint vn, GLfloat v1, GLfloat v2 );
 void  glEvalPoint1( GLint i );
 void  glEvalPoint2( GLint i, GLint j );
 void  glEvalMesh1( GLenum mode, GLint i1, GLint i2 );
 void  glEvalMesh2( GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2 );
 void  glFogf( GLenum pname, GLfloat param );
 void  glFogi( GLenum pname, GLint param );
 void  glFogfv( GLenum pname, const GLfloat *params );
 void  glFogiv( GLenum pname, const GLint *params );
 void  glFeedbackBuffer( GLsizei size, GLenum type, GLfloat *buffer );
 void  glPassThrough( GLfloat token );
 void  glSelectBuffer( GLsizei size, GLuint *buffer );
 void  glInitNames( void );
 void  glLoadName( GLuint name );
 void  glPushName( GLuint name );
 void  glPopName( void );
 void  glDrawRangeElements( GLenum mode, GLuint start,
	GLuint end, GLsizei count, GLenum type, const GLvoid *indices );
 void  glTexImage3D( GLenum target, GLint level,
                                      GLint internalFormat,
                                      GLsizei width, GLsizei height,
                                      GLsizei depth, GLint border,
                                      GLenum format, GLenum type,
                                      const GLvoid *pixels );
 void  glTexSubImage3D( GLenum target, GLint level,
                                         GLint xoffset, GLint yoffset,
                                         GLint zoffset, GLsizei width,
                                         GLsizei height, GLsizei depth,
                                         GLenum format,
                                         GLenum type, const GLvoid *pixels);
 void  glCopyTexSubImage3D( GLenum target, GLint level,
                                             GLint xoffset, GLint yoffset,
                                             GLint zoffset, GLint x,
                                             GLint y, GLsizei width,
                                             GLsizei height );
typedef void (APIENTRYP PFNGLDRAWRANGEELEMENTSPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices);
typedef void (APIENTRYP PFNGLTEXIMAGE3DPROC) (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (APIENTRYP PFNGLTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const GLvoid *pixels);
typedef void (APIENTRYP PFNGLCOPYTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
 void  glColorTable( GLenum target, GLenum internalformat,
                                    GLsizei width, GLenum format,
                                    GLenum type, const GLvoid *table );
 void  glColorSubTable( GLenum target,
                                       GLsizei start, GLsizei count,
                                       GLenum format, GLenum type,
                                       const GLvoid *data );
 void  glColorTableParameteriv(GLenum target, GLenum pname,
                                              const GLint *params);
 void  glColorTableParameterfv(GLenum target, GLenum pname,
                                              const GLfloat *params);
 void  glCopyColorSubTable( GLenum target, GLsizei start,
                                           GLint x, GLint y, GLsizei width );
 void  glCopyColorTable( GLenum target, GLenum internalformat,
                                        GLint x, GLint y, GLsizei width );
 void  glGetColorTable( GLenum target, GLenum format,
                                       GLenum type, GLvoid *table );
 void  glGetColorTableParameterfv( GLenum target, GLenum pname,
                                                  GLfloat *params );
 void  glGetColorTableParameteriv( GLenum target, GLenum pname,
                                                  GLint *params );
 void  glBlendEquation( GLenum mode );
 void  glBlendColor( GLclampf red, GLclampf green,
                                    GLclampf blue, GLclampf alpha );
 void  glHistogram( GLenum target, GLsizei width,
				   GLenum internalformat, GLboolean sink );
 void  glResetHistogram( GLenum target );
 void  glGetHistogram( GLenum target, GLboolean reset,
				      GLenum format, GLenum type,
				      GLvoid *values );
 void  glGetHistogramParameterfv( GLenum target, GLenum pname,
						 GLfloat *params );
 void  glGetHistogramParameteriv( GLenum target, GLenum pname,
						 GLint *params );
 void  glMinmax( GLenum target, GLenum internalformat,
				GLboolean sink );
 void  glResetMinmax( GLenum target );
 void  glGetMinmax( GLenum target, GLboolean reset,
                                   GLenum format, GLenum types,
                                   GLvoid *values );
 void  glGetMinmaxParameterfv( GLenum target, GLenum pname,
					      GLfloat *params );
 void  glGetMinmaxParameteriv( GLenum target, GLenum pname,
					      GLint *params );
 void  glConvolutionFilter1D( GLenum target,
	GLenum internalformat, GLsizei width, GLenum format, GLenum type,
	const GLvoid *image );
 void  glConvolutionFilter2D( GLenum target,
	GLenum internalformat, GLsizei width, GLsizei height, GLenum format,
	GLenum type, const GLvoid *image );
 void  glConvolutionParameterf( GLenum target, GLenum pname,
	GLfloat params );
 void  glConvolutionParameterfv( GLenum target, GLenum pname,
	const GLfloat *params );
 void  glConvolutionParameteri( GLenum target, GLenum pname,
	GLint params );
 void  glConvolutionParameteriv( GLenum target, GLenum pname,
	const GLint *params );
 void  glCopyConvolutionFilter1D( GLenum target,
	GLenum internalformat, GLint x, GLint y, GLsizei width );
 void  glCopyConvolutionFilter2D( GLenum target,
	GLenum internalformat, GLint x, GLint y, GLsizei width,
	GLsizei height);
 void  glGetConvolutionFilter( GLenum target, GLenum format,
	GLenum type, GLvoid *image );
 void  glGetConvolutionParameterfv( GLenum target, GLenum pname,
	GLfloat *params );
 void  glGetConvolutionParameteriv( GLenum target, GLenum pname,
	GLint *params );
 void  glSeparableFilter2D( GLenum target,
	GLenum internalformat, GLsizei width, GLsizei height, GLenum format,
	GLenum type, const GLvoid *row, const GLvoid *column );
 void  glGetSeparableFilter( GLenum target, GLenum format,
	GLenum type, GLvoid *row, GLvoid *column, GLvoid *span );
typedef void (APIENTRYP PFNGLBLENDCOLORPROC) (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
typedef void (APIENTRYP PFNGLBLENDEQUATIONPROC) (GLenum mode);
typedef void (APIENTRYP PFNGLCOLORTABLEPROC) (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, const GLvoid *table);
typedef void (APIENTRYP PFNGLCOLORTABLEPARAMETERFVPROC) (GLenum target, GLenum pname, const GLfloat *params);
typedef void (APIENTRYP PFNGLCOLORTABLEPARAMETERIVPROC) (GLenum target, GLenum pname, const GLint *params);
typedef void (APIENTRYP PFNGLCOPYCOLORTABLEPROC) (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
typedef void (APIENTRYP PFNGLGETCOLORTABLEPROC) (GLenum target, GLenum format, GLenum type, GLvoid *table);
typedef void (APIENTRYP PFNGLGETCOLORTABLEPARAMETERFVPROC) (GLenum target, GLenum pname, GLfloat *params);
typedef void (APIENTRYP PFNGLGETCOLORTABLEPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (APIENTRYP PFNGLCOLORSUBTABLEPROC) (GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, const GLvoid *data);
typedef void (APIENTRYP PFNGLCOPYCOLORSUBTABLEPROC) (GLenum target, GLsizei start, GLint x, GLint y, GLsizei width);
typedef void (APIENTRYP PFNGLCONVOLUTIONFILTER1DPROC) (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, const GLvoid *image);
typedef void (APIENTRYP PFNGLCONVOLUTIONFILTER2DPROC) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *image);
typedef void (APIENTRYP PFNGLCONVOLUTIONPARAMETERFPROC) (GLenum target, GLenum pname, GLfloat params);
typedef void (APIENTRYP PFNGLCONVOLUTIONPARAMETERFVPROC) (GLenum target, GLenum pname, const GLfloat *params);
typedef void (APIENTRYP PFNGLCONVOLUTIONPARAMETERIPROC) (GLenum target, GLenum pname, GLint params);
typedef void (APIENTRYP PFNGLCONVOLUTIONPARAMETERIVPROC) (GLenum target, GLenum pname, const GLint *params);
typedef void (APIENTRYP PFNGLCOPYCONVOLUTIONFILTER1DPROC) (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
typedef void (APIENTRYP PFNGLCOPYCONVOLUTIONFILTER2DPROC) (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height);
typedef void (APIENTRYP PFNGLGETCONVOLUTIONFILTERPROC) (GLenum target, GLenum format, GLenum type, GLvoid *image);
typedef void (APIENTRYP PFNGLGETCONVOLUTIONPARAMETERFVPROC) (GLenum target, GLenum pname, GLfloat *params);
typedef void (APIENTRYP PFNGLGETCONVOLUTIONPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (APIENTRYP PFNGLGETSEPARABLEFILTERPROC) (GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span);
typedef void (APIENTRYP PFNGLSEPARABLEFILTER2DPROC) (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *row, const GLvoid *column);
typedef void (APIENTRYP PFNGLGETHISTOGRAMPROC) (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
typedef void (APIENTRYP PFNGLGETHISTOGRAMPARAMETERFVPROC) (GLenum target, GLenum pname, GLfloat *params);
typedef void (APIENTRYP PFNGLGETHISTOGRAMPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (APIENTRYP PFNGLGETMINMAXPROC) (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
typedef void (APIENTRYP PFNGLGETMINMAXPARAMETERFVPROC) (GLenum target, GLenum pname, GLfloat *params);
typedef void (APIENTRYP PFNGLGETMINMAXPARAMETERIVPROC) (GLenum target, GLenum pname, GLint *params);
typedef void (APIENTRYP PFNGLHISTOGRAMPROC) (GLenum target, GLsizei width, GLenum internalformat, GLboolean sink);
typedef void (APIENTRYP PFNGLMINMAXPROC) (GLenum target, GLenum internalformat, GLboolean sink);
typedef void (APIENTRYP PFNGLRESETHISTOGRAMPROC) (GLenum target);
typedef void (APIENTRYP PFNGLRESETMINMAXPROC) (GLenum target);
 void  glActiveTexture( GLenum texture );
 void  glClientActiveTexture( GLenum texture );
 void  glCompressedTexImage1D( GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const GLvoid *data );
 void  glCompressedTexImage2D( GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid *data );
 void  glCompressedTexImage3D( GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const GLvoid *data );
 void  glCompressedTexSubImage1D( GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const GLvoid *data );
 void  glCompressedTexSubImage2D( GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid *data );
 void  glCompressedTexSubImage3D( GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const GLvoid *data );
 void  glGetCompressedTexImage( GLenum target, GLint lod, GLvoid *img );
 void  glMultiTexCoord1d( GLenum target, GLdouble s );
 void  glMultiTexCoord1dv( GLenum target, const GLdouble *v );
 void  glMultiTexCoord1f( GLenum target, GLfloat s );
 void  glMultiTexCoord1fv( GLenum target, const GLfloat *v );
 void  glMultiTexCoord1i( GLenum target, GLint s );
 void  glMultiTexCoord1iv( GLenum target, const GLint *v );
 void  glMultiTexCoord1s( GLenum target, GLshort s );
 void  glMultiTexCoord1sv( GLenum target, const GLshort *v );
 void  glMultiTexCoord2d( GLenum target, GLdouble s, GLdouble t );
 void  glMultiTexCoord2dv( GLenum target, const GLdouble *v );
 void  glMultiTexCoord2f( GLenum target, GLfloat s, GLfloat t );
 void  glMultiTexCoord2fv( GLenum target, const GLfloat *v );
 void  glMultiTexCoord2i( GLenum target, GLint s, GLint t );
 void  glMultiTexCoord2iv( GLenum target, const GLint *v );
 void  glMultiTexCoord2s( GLenum target, GLshort s, GLshort t );
 void  glMultiTexCoord2sv( GLenum target, const GLshort *v );
 void  glMultiTexCoord3d( GLenum target, GLdouble s, GLdouble t, GLdouble r );
 void  glMultiTexCoord3dv( GLenum target, const GLdouble *v );
 void  glMultiTexCoord3f( GLenum target, GLfloat s, GLfloat t, GLfloat r );
 void  glMultiTexCoord3fv( GLenum target, const GLfloat *v );
 void  glMultiTexCoord3i( GLenum target, GLint s, GLint t, GLint r );
 void  glMultiTexCoord3iv( GLenum target, const GLint *v );
 void  glMultiTexCoord3s( GLenum target, GLshort s, GLshort t, GLshort r );
 void  glMultiTexCoord3sv( GLenum target, const GLshort *v );
 void  glMultiTexCoord4d( GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q );
 void  glMultiTexCoord4dv( GLenum target, const GLdouble *v );
 void  glMultiTexCoord4f( GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q );
 void  glMultiTexCoord4fv( GLenum target, const GLfloat *v );
 void  glMultiTexCoord4i( GLenum target, GLint s, GLint t, GLint r, GLint q );
 void  glMultiTexCoord4iv( GLenum target, const GLint *v );
 void  glMultiTexCoord4s( GLenum target, GLshort s, GLshort t, GLshort r, GLshort q );
 void  glMultiTexCoord4sv( GLenum target, const GLshort *v );
 void  glLoadTransposeMatrixd( const GLdouble m[16] );
 void  glLoadTransposeMatrixf( const GLfloat m[16] );
 void  glMultTransposeMatrixd( const GLdouble m[16] );
 void  glMultTransposeMatrixf( const GLfloat m[16] );
 void  glSampleCoverage( GLclampf value, GLboolean invert );
typedef void (APIENTRYP PFNGLACTIVETEXTUREPROC) (GLenum texture);
typedef void (APIENTRYP PFNGLCLIENTACTIVETEXTUREPROC) (GLenum texture);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1DPROC) (GLenum target, GLdouble s);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1DVPROC) (GLenum target, const GLdouble *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1FPROC) (GLenum target, GLfloat s);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1FVPROC) (GLenum target, const GLfloat *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1IPROC) (GLenum target, GLint s);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1IVPROC) (GLenum target, const GLint *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1SPROC) (GLenum target, GLshort s);
typedef void (APIENTRYP PFNGLMULTITEXCOORD1SVPROC) (GLenum target, const GLshort *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2DPROC) (GLenum target, GLdouble s, GLdouble t);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2DVPROC) (GLenum target, const GLdouble *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2FPROC) (GLenum target, GLfloat s, GLfloat t);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2FVPROC) (GLenum target, const GLfloat *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2IPROC) (GLenum target, GLint s, GLint t);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2IVPROC) (GLenum target, const GLint *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2SPROC) (GLenum target, GLshort s, GLshort t);
typedef void (APIENTRYP PFNGLMULTITEXCOORD2SVPROC) (GLenum target, const GLshort *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3DPROC) (GLenum target, GLdouble s, GLdouble t, GLdouble r);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3DVPROC) (GLenum target, const GLdouble *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3FPROC) (GLenum target, GLfloat s, GLfloat t, GLfloat r);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3FVPROC) (GLenum target, const GLfloat *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3IPROC) (GLenum target, GLint s, GLint t, GLint r);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3IVPROC) (GLenum target, const GLint *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3SPROC) (GLenum target, GLshort s, GLshort t, GLshort r);
typedef void (APIENTRYP PFNGLMULTITEXCOORD3SVPROC) (GLenum target, const GLshort *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4DPROC) (GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4DVPROC) (GLenum target, const GLdouble *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4FPROC) (GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4FVPROC) (GLenum target, const GLfloat *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4IPROC) (GLenum target, GLint s, GLint t, GLint r, GLint q);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4IVPROC) (GLenum target, const GLint *v);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4SPROC) (GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
typedef void (APIENTRYP PFNGLMULTITEXCOORD4SVPROC) (GLenum target, const GLshort *v);
typedef void (APIENTRYP PFNGLLOADTRANSPOSEMATRIXFPROC) (const GLfloat *m);
typedef void (APIENTRYP PFNGLLOADTRANSPOSEMATRIXDPROC) (const GLdouble *m);
typedef void (APIENTRYP PFNGLMULTTRANSPOSEMATRIXFPROC) (const GLfloat *m);
typedef void (APIENTRYP PFNGLMULTTRANSPOSEMATRIXDPROC) (const GLdouble *m);
typedef void (APIENTRYP PFNGLSAMPLECOVERAGEPROC) (GLclampf value, GLboolean invert);
typedef void (APIENTRYP PFNGLCOMPRESSEDTEXIMAGE3DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const GLvoid *data);
typedef void (APIENTRYP PFNGLCOMPRESSEDTEXIMAGE2DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid *data);
typedef void (APIENTRYP PFNGLCOMPRESSEDTEXIMAGE1DPROC) (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const GLvoid *data);
typedef void (APIENTRYP PFNGLCOMPRESSEDTEXSUBIMAGE3DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const GLvoid *data);
typedef void (APIENTRYP PFNGLCOMPRESSEDTEXSUBIMAGE2DPROC) (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid *data);
typedef void (APIENTRYP PFNGLCOMPRESSEDTEXSUBIMAGE1DPROC) (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const GLvoid *data);
typedef void (APIENTRYP PFNGLGETCOMPRESSEDTEXIMAGEPROC) (GLenum target, GLint level, void *img);
