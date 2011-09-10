// font.c : text drawing in opengl (adapted from plib font lib)
/*
     PLIB - A Suite of Portable Game Libraries
     Copyright (C) 1998,2002  Steve Baker
 
     This library is free software; you can redistribute it and/or
     modify it under the terms of the GNU Library General Public
     License as published by the Free Software Foundation; either
     version 2 of the License, or (at your option) any later version.
 
     This library is distributed in the hope that it will be useful,
     but WITHOUT ANY WARRANTY; without even the implied warranty of
     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
     Library General Public License for more details.
 
     You should have received a copy of the GNU Library General Public
     License along with this library; if not, write to the Free Software
     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 
     For further information visit http://plib.sourceforge.net

     $Id: fnt.h 1923 2004-04-06 12:53:17Z sjbaker $
*/


#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//#include <GL/gl.h>
//#include <GL/glu.h>

#include "GL/glfw.h"

#include "../util/win.h"
#include "font.h"

#define FNTMAX_CHAR 256
#define FNT_BYTE_FORMAT		0
#define FNT_BITMAP_FORMAT	1

typedef float sgVec2[2];
typedef float sgVec3[3];

typedef struct _TXF_Glyph
{
  unsigned short ch ;
  unsigned char  w  ;
  unsigned char  h  ;
  signed char x_off ;
  signed char y_off ;
  signed char step  ;
  signed char unknown ;
  short x ;
  short y ;

  sgVec2 tx0 ; sgVec2 vx0 ;
  sgVec2 tx1 ; sgVec2 vx1 ;
  sgVec2 tx2 ; sgVec2 vx2 ;
  sgVec2 tx3 ; sgVec2 vx3 ;
} TXF_Glyph;

static GLuint _texture_id = 0;
static sgVec3 _curpos;
static float _font_color[4] = {0, 0, 0, 0};

//static int _char_width;

// fntTexFont data members
typedef struct _TexFont
{
  int bound;
  int fixed_pitch;
  float width;      /* The width of a character in fixed-width mode */
  float gap;        /* Set the gap between characters */
  int exists [FNTMAX_CHAR]; /* TRUE if character exists in tex-map */
  /*
    The quadrilaterals that describe the characters
    in the font are drawn with the following texture
    and spatial coordinates. The texture coordinates
    are in (S,T) space, with (0,0) at the bottom left
    of the image and (1,1) at the top-right.

    The spatial coordinates are relative to the current
    'cursor' position. They should be scaled such that
    1.0 represent the height of a capital letter. Hence,
    characters like 'y' which have a descender will be
    given a negative v_bot. Most capitals will have
    v_bot==0.0 and v_top==1.0.
  */

  /* Nominal baseline widths */
  float widths[FNTMAX_CHAR] ;

  /* Texture coordinates */

  float t_top   [ FNTMAX_CHAR ] ; /* Top    edge of each character [0..1] */
  float t_bot   [ FNTMAX_CHAR ] ; /* Bottom edge of each character [0..1] */
  float t_left  [ FNTMAX_CHAR ] ; /* Left   edge of each character [0..1] */
  float t_right [ FNTMAX_CHAR ] ; /* Right  edge of each character [0..1] */

  /* Vertex coordinates. */

  float v_top   [ FNTMAX_CHAR ] ;
  float v_bot   [ FNTMAX_CHAR ] ;
  float v_left  [ FNTMAX_CHAR ] ;
  float v_right [ FNTMAX_CHAR ] ;
} TexFont;

TexFont* _tex_font = NULL;

// load_font() data
static int _fntIsSwapped = 0;
static const char* _font_fname = "res/Courier-Bold.txf";
static int _pointsize = 16;
static int _italic = 0;

static FILE* _fntCurrImageFd = NULL;

static void _fnt_swap_short(unsigned short* x)
{
  if ( _fntIsSwapped )
    *x = (( *x >>  8 ) & 0x00FF ) | 
         (( *x <<  8 ) & 0xFF00 ) ;
}

static void _fnt_swap_int(unsigned int* x)
{
  if ( _fntIsSwapped )
    *x = (( *x >> 24 ) & 0x000000FF ) | 
         (( *x >>  8 ) & 0x0000FF00 ) | 
         (( *x <<  8 ) & 0x00FF0000 ) | 
         (( *x << 24 ) & 0xFF000000 ) ;
}

static unsigned char _fnt_readByte ()
{
  unsigned char x ;
  fread ( & x, sizeof(unsigned char), 1, _fntCurrImageFd ) ;
  return x ;
}

static unsigned short _fnt_readShort ()
{
  unsigned short x ;
  fread ( & x, sizeof(unsigned short), 1, _fntCurrImageFd ) ;
  _fnt_swap_short ( & x ) ;
  return x ;
}

static unsigned int _fnt_readInt ()
{
  unsigned int x ;
  fread ( & x, sizeof(unsigned int), 1, _fntCurrImageFd ) ;
  _fnt_swap_int ( & x ) ;
  return x ;
}

static void set_glyph(TexFont* f,
  char c, float wid,
  float tex_left, float tex_right,
  float tex_bot , float tex_top  ,
  float vtx_left, float vtx_right,
  float vtx_bot , float vtx_top  )
{
  unsigned int cc = (unsigned char) c ;

  f->exists[cc] = 1;

  f->widths[cc] = wid;

  f->t_left[cc] = tex_left ; f->t_right[cc] = tex_right ;
  f->t_bot [cc] = tex_bot  ; f->t_top  [cc] = tex_top   ;

  f->v_left[cc] = vtx_left ; f->v_right[cc] = vtx_right ;
  f->v_bot [cc] = vtx_bot  ; f->v_top  [cc] = vtx_top   ;
}

static int tex_make_mip_maps(GLubyte *image, int xsize, int ysize, int zsize)
{
  GLubyte* texels[20];   /* One element per level of MIPmap */
  int lev;
  int map_level;
  int l;
  int i;

  for(l = 0; l < 20; l++)
    texels [ l ] = NULL ;

  texels [ 0 ] = image ;

  for ( lev = 0 ; (( xsize >> (lev+1) ) != 0 ||
                   ( ysize >> (lev+1) ) != 0 ) ; lev++ )
  {
    /* Suffix '1' is the higher level map, suffix '2' is the lower level. */
    int l1 = lev   ;
    int l2 = lev+1 ;
    int w1 = xsize >> l1 ;
    int h1 = ysize >> l1 ;
    int w2 = xsize >> l2 ;
    int h2 = ysize >> l2 ;
    int x2, y2, c;

    if ( w1 <= 0 ) w1 = 1 ;
    if ( h1 <= 0 ) h1 = 1 ;
    if ( w2 <= 0 ) w2 = 1 ;
    if ( h2 <= 0 ) h2 = 1 ;

    texels[l2] = malloc(sizeof(GLubyte) * w2 * h2 * zsize);

    for ( x2 = 0 ; x2 < w2 ; x2++ )
      for ( y2 = 0 ; y2 < h2 ; y2++ )
        for ( c = 0 ; c < zsize ; c++ )
        {
          int x1   = x2 + x2 ;
          int x1_1 = ( x1 + 1 ) % w1 ;
          int y1   = y2 + y2 ;
          int y1_1 = ( y1 + 1 ) % h1 ;

          int t1 = texels [ l1 ] [ (y1   * w1 + x1  ) * zsize + c ] ;
          int t2 = texels [ l1 ] [ (y1_1 * w1 + x1  ) * zsize + c ] ;
          int t3 = texels [ l1 ] [ (y1   * w1 + x1_1) * zsize + c ] ;
          int t4 = texels [ l1 ] [ (y1_1 * w1 + x1_1) * zsize + c ] ;

          texels [ l2 ] [ (y2 * w2 + x2) * zsize + c ] =
                                           ( t1 + t2 + t3 + t4 ) / 4 ;
        }
  }

  texels [ lev+1 ] = NULL ;

  if ( ! ((xsize & (xsize-1))==0) ||
       ! ((ysize & (ysize-1))==0) )
  {
/*
    ulSetError ( UL_FATAL,
      "TXFloader: TXF Map is not a power-of-two in size!" ) ;
*/
    return 0;
  }

  glPixelStorei ( GL_UNPACK_ALIGNMENT, 1 ) ;

  map_level = 0 ;

  for (i = 0 ; texels [ i ] != NULL ; i++)
  {
    int w = xsize>>i ;
    int h = ysize>>i ;

    if ( w <= 0 ) w = 1 ;
    if ( h <= 0 ) h = 1 ;

    glTexImage2D  ( GL_TEXTURE_2D,
                     map_level, zsize, w, h, 0 /* Border */,
                            (zsize==1)?GL_LUMINANCE:
                            (zsize==2)?GL_LUMINANCE_ALPHA:
                            (zsize==3)?GL_RGB:
                                       GL_RGBA,
                            GL_UNSIGNED_BYTE, (GLvoid *) texels[i] ) ;
    map_level++ ;
    free( texels [ i ] );
  }
  return 1;
}

static int load_txf(const char *fname, GLenum mag, GLenum min)
{
/*
  if (! glIsValidContext ())
  {
    ulSetError (UL_FATAL,
      "FNT font loader called without a valid OpenGL context.");
  }
*/
  FILE *fd;
  unsigned char magic[4];
  int endianness;
  int format;
  int tex_width;
  int tex_height;
  int max_height;
  int num_glyphs;
  int w;
  int h;
  float xstep;
  float ystep;
  int i, j;
  TXF_Glyph glyph;
  int ntexels;
  unsigned char* teximage;
  unsigned char* texbitmap;

  if((fd = fopen(fname, "rb")) == NULL)
  {
/*
    ulSetError (UL_WARNING,
      "fntLoadTXF: Failed to open '%s' for reading.", fname);
    return FNT_FALSE;
*/
    return 0;
  }
  _fntCurrImageFd = fd;

  if((int) fread(&magic, sizeof (unsigned int), 1, fd) != 1)
  {
/*
    ulSetError (UL_WARNING,
      "fntLoadTXF: '%s' an empty file!", fname);
    return FNT_FALSE;
*/
    return 0;
  }

  if(magic[0] != 0xFF || magic [1] != 't' ||
     magic[2] != 'x'  || magic [3] != 'f')
  {
/*
    ulSetError (UL_WARNING,
      "fntLoadTXF: '%s' is not a 'txf' font file.", fname);
    return FNT_FALSE;
*/
    return 0;
  }

  _fntIsSwapped  = 0;
  endianness  = _fnt_readInt();
  _fntIsSwapped  = (endianness != 0x12345678);

  format      = _fnt_readInt ();
  tex_width   = _fnt_readInt ();
  tex_height  = _fnt_readInt ();
  max_height  = _fnt_readInt ();
                _fnt_readInt ();
  num_glyphs  = _fnt_readInt ();

  w = tex_width;
  h = tex_height;

  xstep = 0.5f / (float) w;
  ystep = 0.5f / (float) h;

  /*
    Load the TXF_Glyph array
  */

  for(i = 0; i < num_glyphs; i++)
  {
    glyph.ch      = _fnt_readShort ();

    glyph.w       = _fnt_readByte  ();
    glyph.h       = _fnt_readByte  ();
    glyph.x_off   = _fnt_readByte  ();
    glyph.y_off   = _fnt_readByte  ();
    glyph.step    = _fnt_readByte  ();
    glyph.unknown = _fnt_readByte  ();
    glyph.x       = _fnt_readShort ();
    glyph.y       = _fnt_readShort ();

    set_glyph(_tex_font,
      (char) glyph.ch,
      (float) glyph.step              / (float) max_height,
      (float) glyph.x                 / (float) w + xstep,
      (float)(glyph.x + glyph.w)     / (float) w + xstep,
      (float) glyph.y                 / (float) h + ystep,
      (float)(glyph.y + glyph.h)     / (float) h + ystep,
      (float) glyph.x_off             / (float) max_height,
      (float)(glyph.x_off + glyph.w) / (float) max_height,
      (float) glyph.y_off             / (float) max_height,
      (float)(glyph.y_off + glyph.h) / (float) max_height);
  }

  _tex_font->exists[' '] = 0;

  /*
    Load the image part of the file
  */

  ntexels = w * h;

  switch(format)
  {
    case FNT_BYTE_FORMAT:
      {
        unsigned char* orig = malloc(sizeof(unsigned char) * ntexels);
        if((int) fread(orig, 1, ntexels, fd) != ntexels)
        {
/*
          ulSetError (UL_WARNING,
            "fntLoadTXF: Premature EOF in '%s'.", fname);
          return FNT_FALSE;
*/
          free(orig);
          return 0;
        }
        teximage = malloc(sizeof(unsigned char) * 2 * ntexels);

        for(i = 0; i < ntexels; i++)
        {
          teximage[i*2    ] = orig [i];
          teximage[i*2 + 1] = orig [i];
        }
        free(orig);
      }
      break;
   
    case FNT_BITMAP_FORMAT:
      {
        int stride = (w + 7) >> 3;

        texbitmap = malloc(sizeof(unsigned char) * stride * h);
        if((int) fread(texbitmap, 1, stride * h, fd) != stride * h)
        {
          free(texbitmap);
/*
          ulSetError (UL_WARNING,
            "fntLoadTXF: Premature EOF in '%s'.", fname);
          return FNT_FALSE;
*/
          return 0;
      	}
        teximage = malloc(sizeof(unsigned char) * 2 * ntexels);

        for(i = 0; i < 2 * ntexels; i++)
	        teximage[i] = 0;

        for (i = 0; i < h; i++)
          for (j = 0; j < w; j++)
            if (texbitmap[i * stride + (j >> 3)] & (1 << (j & 7)))
            {
              teximage[(i * w + j) * 2    ] = 255;
              teximage[(i * w + j) * 2 + 1] = 255;
            }

        free(texbitmap);
      }
      break;
    default:
      break;
/*
      ulSetError (UL_WARNING,
        "fntLoadTXF: Unrecognised format type in '%s'.", fname);
      return FNT_FALSE;
*/
  }
  fclose (fd);
  _fntCurrImageFd = NULL;

  glGenTextures(1, &_texture_id);
  glBindTexture(GL_TEXTURE_2D, _texture_id);

  // set some attributes of _texture_id?
  if(!tex_make_mip_maps(teximage, w, h, 2))
    return 0;

  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, mag);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, min);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);

  // restore default state?
  glBindTexture (GL_TEXTURE_2D, 0);

  return 1;
}

static int init_font()
{
  GLenum mag = GL_NEAREST;
  GLenum min = GL_LINEAR_MIPMAP_LINEAR;

  _tex_font = (TexFont*) malloc(sizeof(TexFont));

  _tex_font->bound       = 0;
  _tex_font->fixed_pitch = 0;
//  _tex_font->texture    // _texture_id
  _tex_font->width       =  1.0f ;
  _tex_font->gap         =  0.1f ;

  memset(_tex_font->exists, 0, FNTMAX_CHAR * sizeof(int));

  // load font
  if(!load_txf(_font_fname, mag, min)) {
    fprintf(stderr, "load_txf() failed\n");
    return 0;
  }
  return 1;  
}

int font_char_width() {
  unsigned int cc1 = (unsigned char) 'L' ;
  int ww = (int) (( _tex_font->gap + ( _tex_font->fixed_pitch ? _tex_font->width : _tex_font->widths[cc1] ) ) * _pointsize);
  return ww;
}

static float low_putch(sgVec3 curpos, float pointsize, float italic, char c)
{
  unsigned int cc = (unsigned char) c ;

  /* Auto case-convert if character is absent from font. */

  if ( ! _tex_font->exists [ cc ] )
  {
    if ( cc >= 'A' && cc <= 'Z' )
      cc = cc - 'A' + 'a' ;
    else
    if ( cc >= 'a' && cc <= 'z' )
      cc = cc - 'a' + 'A' ;

    if ( cc == ' ' )
    {
      // wknight 2009-11-10: make space width the same as others for monospaced font
      unsigned int cc1 = (unsigned char) 'L' ;
      unsigned int cc2 = (unsigned char) 'l' ;
      if(_tex_font->exists[cc1] && _tex_font->exists[cc2] && _tex_font->widths[cc1]==_tex_font->widths[cc2])
      {
        float ww = ( _tex_font->gap + ( _tex_font->fixed_pitch ? _tex_font->width : _tex_font->widths[cc1] ) ) * pointsize ;
        curpos [ 0 ] += ww;
        return ww;
      }
      curpos [ 0 ] += pointsize / 2.0f ;
      return pointsize / 2.0f ;
    }
  }

  /*
    We might want to consider making some absent characters from
    others (if they exist): lowercase 'l' could be made into digit '1'
    or letter 'O' into digit '0'...or vice versa. We could also
    make 'b', 'd', 'p' and 'q' by mirror-imaging - this would
    save a little more texture memory in some fonts.
  */

  if ( ! _tex_font->exists [ cc ] )
    return 0.0f ;
  
  glBegin ( GL_TRIANGLE_STRIP ) ;
    glTexCoord2f ( _tex_font->t_left [cc], _tex_font->t_bot[cc] ) ;
    glVertex3f   ( curpos[0] +          _tex_font->v_left [cc] * pointsize,
                   curpos[1] +          _tex_font->v_bot  [cc] * pointsize,
                   curpos[2] ) ;

    glTexCoord2f ( _tex_font->t_left [cc], _tex_font->t_top[cc] ) ;
    glVertex3f   ( curpos[0] + (_italic + _tex_font->v_left [cc]) * pointsize,
                   curpos[1] +           _tex_font->v_top  [cc]  * pointsize,
                   curpos[2] ) ;

    glTexCoord2f ( _tex_font->t_right[cc], _tex_font->t_bot[cc] ) ;
    glVertex3f   ( curpos[0] +          _tex_font->v_right[cc] * pointsize,
                   curpos[1] +          _tex_font->v_bot  [cc] * pointsize,
                   curpos[2] ) ;

    glTexCoord2f ( _tex_font->t_right[cc], _tex_font->t_top[cc] ) ;
    glVertex3f   ( curpos[0] + (italic + _tex_font->v_right[cc]) * pointsize,
                   curpos[1] +           _tex_font->v_top  [cc]  * pointsize,
                   curpos[2] ) ;
  glEnd () ;

  float ww = ( _tex_font->gap + ( _tex_font->fixed_pitch ? _tex_font->width : _tex_font->widths[cc] ) ) * pointsize ;
  curpos[0] += ww ;
  return ww ;
}


static void font_puts(const char* s)
{
  float origx;

  // bind texture
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, _texture_id);
//  if ( ! bound )
//    bind_texture () ;

  origx = _curpos[0] ;
    
  while ( *s != '\0' )
  {
    if (*s == '\n')
    {
      _curpos[0]  = origx ;
      _curpos[1] -= _pointsize ;
    }
    else
      low_putch ( _curpos, _pointsize, _italic, *s ) ;

    s++ ;
  }
  // TODO: unbind texture

}

void font_set_color(float r, float g, float b, float a) {
  _font_color[0] = r;
  _font_color[1] = g;
  _font_color[2] = b;
  _font_color[3] = a;
}

void font_draw(int x, int y, const char* s)
{
  GLint vp[4];
  int w, h;

//printf("font_draw: x: %d, y: %d, s: %s\n", x, y, s);

  // do one-time init
  if(_tex_font == NULL && !init_font()) {
    // TODO: replace with better err handling
    fprintf(stderr, "init_font failed!\n");
    return;
  }
//printf("init_font succeeded!\n");
//return;

  // save gl state
  glPushAttrib(GL_ALL_ATTRIB_BITS);
  glEnable(GL_ALPHA_TEST);
  glEnable(GL_BLEND);
  glAlphaFunc(GL_GREATER, 0.1f);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  // set projection to ortho
  glGetIntegerv(GL_VIEWPORT, vp);
  w = vp[2];
  h = vp[3];
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glLoadIdentity();
  glOrtho(0, w, 0, h, -1, 1);

  // draw text
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glColor3f(_font_color[0], _font_color[1], _font_color[2]);
  _curpos[0] = x;
  _curpos[1] = y;
  _curpos[2] = 0;
  font_puts(s);
  glPopMatrix();

  // restore projection
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();
  glPopAttrib();
  glMatrixMode(GL_MODELVIEW);
}// font_draw

int font_line_height() {
  return _pointsize;
}

int font_num_rows() {
  int client_height = win_height() - win_title_height();
  int num_rows = client_height / font_line_height();
  return num_rows;
}

