program typedefs(output);

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

    typelist    = (  tchecker, tbyte, tcoltype, tfdpointer,
                     tfieldindex, tfiledesc, tisochar, tmodeindex,
                     trowtype, tsmallint, tchstring, tchtable,
                     timtype, titable, tmodearray, ttextlit );

    over        = record
        case typelist of
            tchecker    : (checker     : packed array[1..12] of char;);
            tbyte       : (vbyte       : byte;          );
            tcoltype    : (vcoltype    : coltype;       );
            tfdpointer  : (vfdpointer  : fdpointer;     );
            tfieldindex : (vfieldindex : fieldindex;    );
            tfiledesc   : (vfiledesc   : filedesc;      );
            tisochar    : (visochar    : isochar;       );
            tmodeindex  : (vmodeindex  : modeindex;     );
            trowtype    : (vrowtype    : rowtype;       );
            tsmallint   : (vsmallint   : smallint;      );
            tchstring   : (vchstring   : chstring;      );
            tchtable    : (vchtable    : chtable;       );
            timtype     : (vimtype     : imtype;        );
            titable     : (vitable     : itable;        );
            tmodearray  : (vmodearray  : modearray;     );
            ttextlit    : (vtextlit    : textlit;       );
    end;

var
    overrec : over;

procedure dotypedef ( s : integer );
begin
    case s of
    1 : write('char    ');
    2 : write('short   ');
    4 : write('long    ');
    end;
end;

procedure setup;
var i : integer;
begin
    for i := 1 to 12 do
        overrec.checker[i] := 'a';
end;

function sizof : integer;
var i : integer;
    count : integer;
begin
    count := 0;
    for i := 1 to 12 do
    begin
        if overrec.checker[i] <> 'a'
        then
            count := count + 1;
    end;
    sizof := count;
end;

procedure typedefs;
var retval : integer;

begin
    setup;
    overrec.vbyte := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('byte;');

    setup;
    overrec.vchstring[1] := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('* chstring;');

    setup;
    overrec.vchtable[0] := '0';
    retval := sizof;
    write('    typedef          ');
    dotypedef(retval);
    writeln('* chtable;');

    setup;
    overrec.vcoltype    := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('coltype;');

    setup;
    overrec.vfdpointer  := 0;
    retval := sizof;
    write('    typedef          ');
    dotypedef(retval);
    writeln('fdpointer;');

    setup;
    overrec.vfieldindex := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('fieldindex;');

    setup;
    overrec.vfiledesc   := 0;
    retval := sizof;
    write('    typedef          ');
    dotypedef(retval);
    writeln('filedesc;');

    setup;
    overrec.vimtype[0,0] := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('* imtype;');

    setup;
    overrec.vitable[0]  := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('* itable;');

    setup;
    overrec.visochar    := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('isochar;');

    setup;
    overrec.vmodearray[0] := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('* modearray;');

    setup;
    overrec.vmodeindex  := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('modeindex;');

    setup;
    overrec.vrowtype    := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('rowtype;');

    setup;
    overrec.vsmallint   := 0;
    retval := sizof;
    write('    typedef unsigned ');
    dotypedef(retval);
    writeln('smallint;');

    setup;
    overrec.vtextlit[1] := '0';
    retval := sizof;
    write('    typedef          ');
    dotypedef(retval);
    writeln('* textlit;');

end;

begin
    writeln('#define ZMAXROW ', zmaxrow);
    writeln('#define ZMAXCOL ', zmaxcol);
    writeln('#define MAXSTR  ', maxstr);
    writeln;
    writeln('#ifndef HELPDIR');
    writeln('#define HELPDIR "/usr/local/lib"');
    writeln('#endif');
    writeln;
    writeln('#ifndef _NFILE');
    writeln('#define _NFILE 32');
    writeln('#endif');
    writeln;
    typedefs;

end.
