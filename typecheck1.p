program typecheck(output);

const
    isomax       = 255;     { ISO 4873 (646 is a subset) max value }
    maxstr       = 512;     { maximum characters for chstring type }
    ioerror      = -1;      { file descriptor not available indicator }
    iomaxfd      = 19;      { maximum available stream number }
    nul          = 0;       { ISO 4873 null character }
    zmaxrow      = 59;      { allows a maximum of 60 rows }
    zmaxcol      = 131;     { allows a maximum of 132 columns }
    zfieldlimit  = 239;     { allows a maximum of 240 fields }

{ ******************************************************************* }
{ *                                                                 * }
{ *     Software Tools :: Type definitions exported to primitives   * }
{ *                                                                 * }
{ ******************************************************************* }

type
    byte        = 0..255;
    coltype     = 0..zmaxcol;
    fdpointer   = integer;
    fieldindex  = 0..zfieldlimit;
    filedesc    = ioerror..iomaxfd;
    isochar     = nul..isomax;
    modeindex   = 0..63;
    rowtype     = 0..zmaxrow;
    smallint    = 0..255;

    chstring    = packed array [1..maxstr] of isochar;
    chtable     = packed array [byte] of char;
    imtype      = array[rowtype,coltype] of isochar;
    itable      = packed array [byte] of byte;
    modearray   = packed array [modeindex] of smallint;
    textlit     = packed array [1..24] of char;

var retval : integer;

    varchstring   : chstring;
    varchtable    : chtable;
    varimtype     : imtype;
    varitable     : itable;
    varmodearray  : modearray;
    vartextlit    : textlit;

#include "tc.h"

begin

    retval := 0;

    SIZBYTE       ( retval, 17, 19);
    SIZCOLTYPE    ( retval, 17, 19);
    SIZFDPOINTER  ( retval, 17, 19);
    SIZFIELDINDEX ( retval, 17, 19);
    SIZFILEDESC   ( retval, 17, 19);
    SIZISOCHAR    ( retval, 17, 19);
    SIZMODEINDEX  ( retval, 17, 19);
    SIZROWTYPE    ( retval, 17, 19);
    SIZSMALLINT   ( retval, 17, 19);

    varchstring[1]  := 17;  varchstring[2]  := 19;
    SIZCHSTRING   ( retval, varchstring);

    varchtable[0]   := chr(17);  varchtable[1]   := chr(19);
    SIZCHTABLE    ( retval, varchtable);

    varimtype[0][0] := 17;  varimtype[0][1] := 19;
    SIZIMTYPE     ( retval, varimtype);

    varitable[0]    := 17;  varitable[1]    := 19;
    SIZITABLE     ( retval, varitable);

    varmodearray[0] := 17;  varmodearray[1] := 19;
    SIZMODEARRAY  ( retval, varmodearray);

    vartextlit[1]   := chr(17);  vartextlit[2]   := chr(19);
    SIZTEXTLIT    ( retval, vartextlit);

    CRASHOUT(retval);
end.
