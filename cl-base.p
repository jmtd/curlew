program curlew;
 
{ %% Source generation dated :  Wed, 04 May 88  12:19:09 BST  %%%%%%% }
 
 
{ ****************************************************** curlew ***** }
{ *                                                                 * }
{ *                           C U R L E W                           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ %%%%%% update %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cl-bsd %%%%% }
{ %                                                                 % }
{ %     Updated for the UNIX time-sharing system, release 4.3bsd    % }
{ %     UNIX is a trademark of A.T.&T. Bell Laboratories, U.S.A.    % }
{ %                                                                 % }
{ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% }
 
 
{ ****************************************************** curlew ***** }
{ *                                                                 * }
{ *   A portable full-screen editor intended for use over a data    * }
{ *   communications network.  The full-screen user interface is    * }
{ *   derived from that of the old NUMAC Screen Editor, "sc".       * }
{ *   The network virtual terminal support is that of the "The      * }
{ *   Simple Screen Management Protocol" (United Kingdom Joint      * }
{ *   Network Team, July 1985).                                     * }
{ *                                                                 * }
{ *   The context editor and file buffer management facilities      * }
{ *   provided were inspired by and are modelled on "edit", by      * }
{ *   B.W.Kernighan and P.J.Plauger.  See the book "Software Tools  * }
{ *   in Pascal" (Addison-Wesley, 1981).                            * }
{ *                                                                 * }
{ *   Screen editor code, SSMP network virtual terminal support,    * }
{ *   and other extensions by Alan Hunter, Computing Laboratory,    * }
{ *   University of Newcastle upon Tyne.                            * }
{ *                                                                 * }
{ *   This is PUBLIC DOMAIN SOFTWARE, by which is meant that it     * }
{ *   may be copied and used by individuals or institutions but     * }
{ *   any rights of commercial exploitation are retained by the     * }
{ *   University of Newcastle upon Tyne.                            * }
{ *                                                                 * }
{ *   CURLEW screen editor and SSMP virtual terminal coding is      * }
{ *     copyright (1987) by the University of Newcastle upon Tyne.  * }
{ *   The original source of the Software Tools Pascal routines is  * }
{ *     copyright (1981) by Bell Telephone Laboratories,            * }
{ *       Incorporated, and Whitesmiths, Ltd.                       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
const
 
 
{ ****************************************************** iso646 ***** }
{ *                                                                 * }
{ *            International Standard 646 character set             * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    blank = 32;
 
    { numerics }
    dig0 = 48;   dig1 = 49;   dig2 = 50;   dig3 = 51;   dig4 = 52;
    dig5 = 53;   dig6 = 54;   dig7 = 55;   dig8 = 56;   dig9 = 57;
 
    { lower case alphabetics }
    leta = 97;   letb = 98;   letc = 99;   letd = 100;  lete = 101;
    letf = 102;  letg = 103;  leth = 104;  leti = 105;  letj = 106;
    letk = 107;  letl = 108;  letm = 109;  letn = 110;  leto = 111;
    letp = 112;  letq = 113;  letr = 114;  lets = 115;  lett = 116;
    letu = 117;  letv = 118;  letw = 119;  letx = 120;  lety = 121;
    letz = 122;
 
    { upper case alphabetics }
    capa = 65;   capb = 66;   capc = 67;   capd = 68;   cape = 69;
    capf = 70;   capg = 71;   caph = 72;   capi = 73;   capj = 74;
    capk = 75;   capl = 76;   capm = 77;   capn = 78;   capo = 79;
    capp = 80;   capq = 81;   capr = 82;   caps = 83;   capt = 84;
    capu = 85;   capv = 86;   capw = 87;   capx = 88;   capy = 89;
    capz = 90;
 
    { other graphic symbols }
    exclam = 33;     dquote = 34;     sharp = 35;      dollar = 36;
    percent = 37;    amper = 38;      squote = 39;     lparen = 40;
    rparen = 41;     star = 42;       plus = 43;       comma = 44;
    minus = 45;      period = 46;     slash = 47;      colon = 58;
    semicol = 59;    less = 60;       equals = 61;     greater = 62;
    question = 63;   atsign = 64;     lbrack = 91;     backslash = 92;
    rbrack = 93;     cflex = 94;      uscore = 95;     grave = 96;
    lbrace = 123;    bar = 124;       rbrace = 125;    tilde = 126;
 
    { control characters }
    nul = 0;
    ctla = 1;    ctlb = 2;    ctlc = 3;    ctld = 4;    ctle = 5;
    ctlf = 6;    ctlg = 7;    ctlh = 8;    ctli = 9;    ctlj = 10;
    ctlk = 11;   ctll = 12;   ctlm = 13;   ctln = 14;   ctlo = 15;
    ctlp = 16;   ctlq = 17;   ctlr = 18;   ctls = 19;   ctlt = 20;
    ctlu = 21;   ctlv = 22;   ctlw = 23;   ctlx = 24;   ctly = 25;
    ctlz = 26;
    esc = 27;    fs = 28;     gs = 29;     rs = 30;     us = 31;
    del = 127;
 
 
{ ****************************************************** gblcons **** }
{ *                                                                 * }
{ *              Software Tools :: Global constants                 * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    isomax  = 255;          { ISO 4873 (646 is a subset) max value }
 
    maxstr  = 512;          { maximum characters for chstring type }
    endstr  = nul;          { end of string marked with nul }
    newline = ctlj;         { end of line marked with line feed }
    tab     = ctli;         { tab marked with horizontal tab }
    backspace = ctlh;       { back space output device character }
    endfile = ctly;         { end of file marked with em }
 
    maxpat  = maxstr;       { maximum characters in a pattern }
    closize = 1;            { size of a closure entry }
 
    nccl    = exclam;       { negated class is "!" (can't be negate) }
    litchar = plus;         { literal character flagged by "+" }
    mkditto = ctlz;         { ditto marker in string is sub }
 
    ioerror = -1;           { file descriptor not available indicator }
    iomaxfd = 19;           { maximum available stream number }
 
    ioread = 1;             { open mode for reading }
    iowrite = 2;            { open mode for writing }
    ioappend = 3;           { open mode for writing, append to end }
 
    iomddeflt = 0;          { normal file descriptor state }
    iomdasis = 1;           { "as is" : packets ready to write }
    iomdmsg = 2;            { "message" : no native mode networking }
 
    maxarg = 10;            { maximum number of command arguments }
 
    idef = 0;               { o/s default interrupt processing }
    imask = 1;              { mask interrupts -> just continue }
    ikill = 2;              { interrupt -> kill application }
 
    { following are for use with "getinf" }
    sfnpfx    =  1;         { scratch filename  prefix }
    cmdpars   =  2;         { command parameter string }
    timedate  =  3;         { time and date, #822 format }
    username  =  4;         { username }
    maxframe  =  5;         { frames per packet in SSMP, nul -> 2 }
    sortdate  =  6;         { time and date, sortable format }
    gspare2   =  7;         { (not in use) }
    litfchar  =  8;         { literal file initial character }
    ffcrtn    =  9;         { "y" means "ffcopy" routine available }
    ixcrtn    = 10;         { "y" means "ixcopy" routine available }
 
 
{ ****************************************************** ssmpcons *** }
{ *                                                                 * }
{ *              SSMP shared data structure constants               * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    zmaxrow = 59;        { allows a maximum of 60 rows }
    zmaxcol = 131;       { allows a maximum of 132 columns }
    isospace  = blank;   { to fit with The Book }
    zfieldlimit = 239;   { allows a maximum of 240 fields }
 
    { mode array }
    tlevel    = 0;     tmaxrow   = 1;     tmaxcol   = 2;
    dsinvalid = 3;     notify    = 4;     selectgr  = 5;
    reqshift  = 6;     cursor    = 7;     icharmode = 8;
    ilinerow  = 9;     intsignal = 10;    kinthost  = 11;
    ksuspend  = 12;    krestart  = 13;    kenter    = 14;
    kcsrup    = 15;    kcsrdown  = 16;    kcsrleft  = 17;
    kcsrright = 18;    knexttab  = 19;    kprevtab  = 20;
    kleftupd  = 21;    kfirstns  = 22;    kalastns  = 23;
    kinsmode  = 24;    keraright = 25;    kinsspac  = 26;
    kdelchar  = 27;    keraprev  = 28;    kinsline  = 29;
    kdelline  = 30;    keraline  = 31;    kappline  = 32;
    ksplline  = 33;    knextfld  = 34;    kprevfld  = 35;
    khomefld  = 36;    knewline  = 37;
 
 
{ ****************************************************** ssmpcons *** }
{ *                                                                 * }
{ *        SSMP network encoding and transmission constants         * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    defrend    = 0;   { selectgr : default rendition }
    bold       = 1;   { selectgr : bold, or increased intensity }
    faint      = 2;   { selectgr : faint, or reduced intensity }
    italicised = 3;   { selectgr : italicised, or slanted }
    underlined = 4;   { selectgr : underlined }
    slowblink  = 5;   { selectgr : slowly blinking (less than 150/min) }
    rapidblink = 6;   { selectgr : rapidly blinking (150/min or more) }
    negative   = 7;   { selectgr : negative image (reverse video) }
    concealed  = 8;   { selectgr : concealed (displayed as SPACEs) }
    crossedout = 9;   { selectgr : crossed out (marked for deletion) }
 
    maxmode = knewline;  { maximum allocated mode index }
    framesize = 60;      { characters per SSMP frame output }
 
 
type
 
 
{ ****************************************************** gbltype **** }
{ *                                                                 * }
{ *          Software Tools :: Global type declarations             * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    isochar  = nul..isomax;
    chstring = packed array [1..maxstr] of isochar;
    tablist  = array [1..maxstr] of boolean;
    byte     = 0..255;
    itable   = packed array [byte] of byte;
    chtable  = packed array [byte] of char;
    textlit  = packed array [1..24] of char;
    filedesc = ioerror..iomaxfd;
    fdpointer = integer;
 
 
{ ****************************************************** ssmptype *** }
{ *                                                                 * }
{ *                SSMP shared data structure types                 * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    toktype = (withhost, withterm);
    rowtype = 0..zmaxrow;               { in use, 0..maxrow }
    coltype = 0..zmaxcol;               { in use, 0..maxcol }
 
    savedfield =                        { each stored field definition }
        record
            fldtop, fldbottom : rowtype;    { stored update limit rows }
            fldleft, fldright : coltype     { stored update limit cols }
        end;
 
    fieldindex = 0..zfieldlimit;        { in use, 0..((maxrow+1)*4-1) }
    modeindex  = 0..63;                 { 37 is highest defined index }
    smallint   = 0..255;                { parameter range }
    modearray  = packed array [modeindex]
                        of smallint;    { terminal emulation status }
    tabstop    = (notab, tabset);       { tabulation stop }
 
 
{ ****************************************************** ssmptype *** }
{ *                                                                 * }
{ *          SSMP network encoding and transmission types           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    charstr = packed array [1..16] of isochar;
    charlen = 0..16;
    primpar = array [1..4] of smallint;
    rowtext = array [coltype] of isochar;
    ncftype = (nocf, csrpend, fldpend);
    treqtype = (notkreq, needtok, expecttok);
 
 
var
 
 
{ ****************************************************** gblvar ***** }
{ *                                                                 * }
{ *         Software Tools :: Global variable declarations          * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    envlocn : integer;              { environment location }
 
    littoiso : itable;              { native to iso code conversions }
    isotolit : chtable;             { iso to native code conversions }
 
    stdin  : filedesc;              { standard input file descriptor }
    stdout : filedesc;              { standard output file descriptor }
    stderr : filedesc;              { standard error file descriptor }
 
    initin, initout : filedesc;     { initial standard input & output }
 
    cmdline : chstring;             { command argument text }
    nbrcmdargs : integer;           { number of command arguments }
    cmdargidx : array [0..maxarg] of integer;    { argument offsets }
 
    scan    : isochar;              { forward scan character }
    backscan : isochar;             { backward scan character }
 
    escape  : isochar;              { escape special meanings }
    closure : isochar;              { closure }
    bol     : isochar;              { begining of line }
    eol     : isochar;              { end of line }
    any     : isochar;              { wildcard }
    ccl     : isochar;              { character class start }
    cclend  : isochar;              { ... and end }
    negate  : isochar;              { class negation }
    anycase : isochar;              { case sensitivity toggle }
    ditto   : isochar;              { ditto character }
 
    cssinit : boolean;              { pattern start anycase state }
 
 
{ ****************************************************** ssmpvar **** }
{ *                                                                 * }
{ *               SSMP shared data structure variables              * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    token : toktype;                    { access control token }
    row   : rowtype;                    { cursor row }
    col   : coltype;                    { cursor column }
 
    image : packed array [rowtype,coltype]
                        of isochar;     { screen image }
 
    curfield, maxfield : fieldindex;
    field : array [fieldindex]
                        of savedfield;  { stored field definitions }
 
    boxtop, boxbottom : rowtype;        { update limits - rows }
    boxleft, boxright : coltype;        { update limits - columns }
    mode  : modearray;                  { terminal emulation status }
    tabs  : array [coltype] of tabstop; { tabulation stops array }
 
 
{ ****************************************************** ssmpvar **** }
{ *                                                                 * }
{ *         SSMP network encoding and transmission variables        * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    ssmplocn : integer;           { network environment pointer }
    masterlevel : smallint;       { session level after negotiation }
    repainted : boolean;          { true if screen refreshed }
    treqstate : treqtype;         { state of H-REQTOKEN processing }
    ssmpstate : isochar;          { parser state }
    tparidx, tsum : integer;      { used in parameter decoding }
    gotdigit : boolean;           { used in parameter decoding }
    tprid : isochar;              { returned prim id (star=character) }
    tpars : primpar;              { returned primitive parameters }
    cfstate : ncftype;            { setcursor/setfield optimisation }
 
    filter : itable;              { filter input and strip parity }
    encode, decode : itable;      { iso to/from ssmp conversions }
 
    inbuff, outbuff : chstring;   { input and output frame buffers }
    inlen : integer;              { characters in input buffer }
    inptr, outptr : integer;      { buffer pointers }
    framenbr : integer;           { index of output frame in packet }
    mxframenbr : integer;         { ... and this the maximum }
    outremdr : integer;           { characters available in frame }
 
 
#include "st.h"
 
 
{ ****************************************************** stprim ***** }
{ *                                                                 * }
{ *           Software Tools :: Initialisation routines             * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ setctk  -- initialise pattern matching chicken track characters }
procedure setctk (alternate : boolean);
begin
    { set up Software Tools values }
    scan    := slash;           { forward scan is "/" }
    backscan := backslash;      { backward scan is "\" }
    escape  := atsign;          { escape special meanings with "@" }
    closure := star;            { closure signalled by "*" }
    bol     := percent;         { begining of line by "%" }
    eol     := dollar;          { end of line by "$" }
    any     := question;        { wildcard by "?" }
    ccl     := lbrack;          { character class starts with "[" }
    cclend  := rbrack;          { ... and ends with "]" }
    negate  := cflex;           { class negation signalled by "^" }
    anycase := tilde;           { case sensitivity toggle is "~" }
    ditto   := amper;           { ditto character is "&" }
    cssinit := true;            { case sensitive scan default }
 
    { check for UNIX (tm) values preferred }
    if alternate then
    begin
        backscan := question;   { backward scan is "?" }
        escape  := backslash;   { escape special meanings with "\" }
        bol     := cflex;       { begining of line by "^" }
        any     := period;      { wildcard by "." }
        anycase := tilde;       { case sensitivity toggle is "~" }
        ditto   := amper;       { ditto character is "&" }
    end
end;  {setctk}
 
 
{ setint  -- select interrupt (BREAK key) processing }
procedure setint (intcode : integer);
begin
    SINTRPT(envlocn, intcode);  { 0 = default, 1 = mask, 2 = kill exec }
end;  {setint}
 
 
{ initsoft -- initialise software tools environment }
procedure initsoft (intcode : integer);
begin
    { initialise software tools environment, get translate tables }
    SGETSTE(envlocn, littoiso, isotolit);
    if intcode > 0 then
        setint(intcode);        { 1 = mask, 2 = kill exec }
 
    stdin := 0;                 { standard input }
    stdout := 1;                { standard output }
    stderr := 2;                { standard error }
 
    initin := stdin;  initout := stdout;    { save values }
 
    nbrcmdargs := 0;            { no command arguments yet }
    cmdargidx[1] := 1;          { ... keeps some compilers happy }
    setctk(false)               { set up chicken tracks }
end;  {initsoft}
 
 
{ closesoft -- release resources for software tools environment }
procedure closesoft;
begin
    SRELSTE(envlocn, 0)     { return after clean up }
end;  {closesoft}
 
 
{ errorexit -- emergency, stop program now }
procedure errorexit;
begin
    SRELSTE(envlocn, 1)     { don't return here ... }
end;  {errorexit}
 
 
{ ****************************************************** stprim ***** }
{ *                                                                 * }
{ *                 Software Tools :: Primitives                    * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ %% next routine name changed from "open" to avoid symbol clash }
 
{ openf -- open a file for reading or writing }
function openf (var name : chstring;
                openmode : integer)
        : filedesc;
var
    fd : filedesc;
begin
    SOPEN(envlocn, name, openmode, fd);
    openf := fd
end;  {openf}
 
 
{ create -- open a file for reading or writing, create if necessary }
function create (var name : chstring;
                 openmode : integer)
        : filedesc;
var
    fd : filedesc;
begin
    SCREATE(envlocn, name, openmode, fd);
    create := fd
end;  {create}
 
 
{ iocontrol -- set state of opened file descriptor }
procedure iocontrol (newstate : integer;
                     fd : filedesc);
begin
    SIOCTRL(envlocn, newstate, fd)
end;  {iocontrol}
 
 
{ secure -- secure disk copy of opened file without closing it }
procedure secure (fd : filedesc);
begin
    SSECURE(envlocn, fd)
end;  {secure}
 
 
{ %% next routine name changed from "rewind" to avoid symbol clash }
 
{ rewindf -- rewind (read) or reset (write, append) file desc }
function rewindf (fd : filedesc)
        : boolean;
var
    rc : integer;
begin
    SREWIND(envlocn, fd, rc);
    rewindf := (rc = 0)
end;  {rewindf}
 
 
{ %% next routine name changed from "close" to avoid symbol clash }
 
{ closef -- close a stream after input or output }
procedure closef (fd : filedesc);
begin
    SCLOSE(envlocn, fd)
end;  {closef}
 
 
{ remove -- remove (destroy) file }
function remove (var name : chstring)
        : boolean;
var
    rc : integer;
begin
    SREMOVE(envlocn, name, rc);
    remove := (rc = 0)
end;  {remove}
 
 
{ %% next routine name changed from "rename" to avoid symbol clash }
 
{ renamf -- change name of file oldname to newname }
function renamf (var oldname : chstring;
                 var newname : chstring)
        : boolean;
var
    rc : integer;
begin
    SRENAME(envlocn, oldname, newname, rc);
    renamf := (rc = 0)
end;  {renamf}
 
 
{ getline -- read one complete input record from stream fd }
function getline (var dest : chstring;
                  fd : filedesc;
                  maxlen : integer)
        : boolean;
var
    rc : integer;
begin
    SGETLIN(envlocn, dest, fd, maxlen, rc);
    getline := (rc = 0)
end;  {getline}
 
 
{ getcf -- read one character from stream fd }
function getcf (var c : isochar;
                fd : filedesc)
        : isochar;
begin
    SGETCF(envlocn, c, fd);
    getcf := c
end;  {getcf}
 
 
{ putstr -- write string src to file descriptor fd }
procedure putstr (var src : chstring;
                  fd : filedesc);
begin
    SPUTSTR(envlocn, src, fd)
end;  {putstr}
 
 
{ putcf -- put character c to file descriptor fd }
procedure putcf (c : isochar;
                 fd : filedesc);
begin
    SPUTCF(envlocn, c, fd)
end;  {putcf}
 
 
{ ffcopy -- copy from one file descriptor to another }
function ffcopy (fdin : filedesc;
                 fdout : filedesc;
                 var nrecds : integer)
        : boolean;
var
    rc : integer;
begin
    SFFCOPY(envlocn, fdin, fdout, nrecds, rc);
    if rc < 0 then nrecds := -nrecds;           { truncation flag }
    ffcopy := (rc <= 0)
end;  {ffcopy}
 
 
{ ixcopy -- copy specified record from one f/d to another }
function ixcopy (fdx : fdpointer;
                 fdin : filedesc;
                 fdout : filedesc)
        : boolean;
var
    rc : integer;
begin
    SIXCOPY(envlocn, fdx, fdin, fdout, rc);
    ixcopy := (rc = 0)
end;  {ixcopy}
 
 
{ getindex -- returns next get/put index for future seek }
function getindex (var fdidx : fdpointer;
                   fd : filedesc)
        : boolean;
var
    rc : integer;
begin
    SGETIDX(envlocn, fdidx, fd, rc);
    getindex := (rc = 0)
end;  {getindex}
 
 
{ seek -- set next read pointer for fd }
procedure seek (fdidx : fdpointer;
                fd : filedesc);
begin
    SSEEK(envlocn, fdidx, fd)
end;  {seek}
 
 
{ itoxpc -- internal to external file pointer conversion }
procedure itoxpc (var str : chstring;
                  sidx : integer;
                  fdx : fdpointer);
begin
    SITOXPC(envlocn, str, sidx, fdx)
end;  {itoxpc}
 
 
{ xtoipc -- external to internal file pointer conversion }
procedure xtoipc (var str : chstring;
                  sidx : integer;
                  var fdx : fdpointer);
begin
    SXTOIPC(envlocn, str, sidx, fdx)
end;  {xtoipc}
 
 
{ getfds -- get file descriptor status }
procedure getfds (var fdstat : integer;
                  fd : filedesc);
begin
    SGETFDS(envlocn, fdstat, fd)
end;  {getfds}
 
 
{ prompt -- set standard input prompt string }
procedure prompt (var pstr : chstring);
begin
    SPROMPT(envlocn, pstr)
end;  {prompt}
 
 
{ getinf -- return information according to index }
procedure getinf (index : integer;
                  var info : chstring;
                  maxlen : integer);
begin
    SGETINF(envlocn, index, info, maxlen)
end;  {getinf}
 
 
{ syscmd -- execute command line }
procedure syscmd (var newcmd : chstring;
                  var rc : integer);
begin
    SSYSCMD(envlocn, newcmd, rc)
end;  {syscmd}
 
 
{ mailer -- interface to e-mail spooler }
function mailer (index : integer;
                 var info : chstring)
        : boolean;
var
    rc : integer;
begin
    SMAILER(envlocn, index, info, rc);
    mailer := (rc = 0)
end;  {mailer}
 
 
{ timewait -- wait for a given elapsed time interval }
procedure timewait (waittime : integer);
begin
    STWAIT(envlocn, waittime)
end;  {timewait}
 
 
{ loguse -- log use of software tools application }
procedure loguse (var name : chstring);
begin
    SLOGUSE(envlocn, name);
end;  {loguse}
 
 
{ ****************************************************** ssmprtn **** }
{ *                                                                 * }
{ *        SSMP :: Host virtual terminal service routines           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ ****************************************************** ssmprtn **** }
{ *                                                                 * }
{ *   All SSMP service procedures are defined here.  If this        * }
{ *   section is split into a separate module, the procedures and   * }
{ *   functions listed in the following explanatory text will       * }
{ *   need to be exported.   Variables defined as "Shared data      * }
{ *   structure" or "Network encoding and transmission" are         * }
{ *   required by these SSMP routines only.                         * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ ****************************************************** ssmprtn **** }
{ *                                                                 * }
{ *         General description of the SSMP host routines           * }
{ *         ---------------------------------------------           * }
{ *                                                                 * }
{ *   The following procedures service requests to generate the     * }
{ *   equivalent host primitives.  With the exception of            * }
{ *   "reqtoken", they should only be called whilst the token is    * }
{ *   with the host application.                                    * }
{ *                                                                 * }
{ *   Note that optimisation of H-SETCURSOR and H-SETFIELD is       * }
{ *   performed automatically.  Only essential instances will be    * }
{ *   generated.                                                    * }
{ *                                                                 * }
{ *      textchar     : H-CHARACTER to send text                    * }
{ *      sendtoken    : H-TOKEN to transfer token                   * }
{ *      setcursor    : H-SETCURSOR to set the cursor position      * }
{ *      setmode      : H-SETMODE to set a mode array element value * }
{ *      erasetoright : H-ERASETORIGHT to erase to end of row       * }
{ *      insertspace  : H-INSERTSPACE to insert SPACE characters    * }
{ *      deletechar   : H-DELETECHAR to delete characters           * }
{ *      soundalarm   : H-SOUNDALARM to sound the audible alarm     * }
{ *      scrollup     : H-SCROLLUP to scroll rows up                * }
{ *      scrolldown   : H-SCROLLDOWN to scroll rows down            * }
{ *      erasedisplay : H-ERASEDISPLAY to erase screen image        * }
{ *      erasefields  : H-ERASEFIELDS to erase all field defns      * }
{ *      setfield     : H-SETFIELD to select new field definition   * }
{ *      setupdate    : H-SETUPDATE to set update limits for field  * }
{ *      erasetabs    : H-ERASETABS to erase all tabulation stops   * }
{ *      settab       : H-SETTAB to set one tabulation stop         * }
{ *      session      : H-SESSION to enter or exit session          * }
{ *      reqtoken     : H-REQTOKEN if no token by end of frame      * }
{ *                                                                 * }
{ *   The following procedures allow interrogation of the shared    * }
{ *   data structure variables.  Use of functions and procedures    * }
{ *   for this purpose hides the data from the application so that  * }
{ *   all assignments are under the control of procedures in the    * }
{ *   SSMP module and can be vetted.  The data returned for each    * }
{ *   procedure is:                                                 * }
{ *                                                                 * }
{ *      maxrow       : session maximum row value                   * }
{ *      maxcol       : session maximum column value                * }
{ *      fieldlimit   : session maximum field index                 * }
{ *      getloc       : current cursor position row and column      * }
{ *      getfield     : current field index                         * }
{ *      getmode      : a copy of the mode array                    * }
{ *      getrow       : the text of the requested row               * }
{ *                                                                 * }
{ *   The next two procedures are to allow convenient replacement   * }
{ *   of shared data structure values.                              * }
{ *                                                                 * }
{ *      putmode      : makes mode array conform to that supplied   * }
{ *      putrow       : replaces the text for the specified row     * }
{ *                                                                 * }
{ *   Note that "putmode" will issue only those H-SETMODEs required * }
{ *   to correct the mode array.  A convenient way of quickly       * }
{ *   switching terminal operating modes is to keep a suitable copy * }
{ *   of the mode array for each set required and use "putmode" to  * }
{ *   establish that state from any other.                          * }
{ *                                                                 * }
{ *   The second procedure, "putrow", will optimise generation of   * }
{ *   the required host primitives.  It will use H-SETCURSOR to     * }
{ *   skip ten or more consecutive blanks where this is possible    * }
{ *   (that is, either default rendition set or mode[reqshift]=1).  * }
{ *                                                                 * }
{ *   If the application requires to refresh the terminal copy of   * }
{ *   the shared data structure, the following procedure will do    * }
{ *   this.  Note that since the graphic rendition of each          * }
{ *   character is not held in the data structure, any highlighting * }
{ *   will be lost and must be separately re-established if         * }
{ *   required.                                                     * }
{ *                                                                 * }
{ *      refresh      : refreshes the whole shared data structure   * }
{ *                                                                 * }
{ *   The following procedures wrap up the session entry            * }
{ *   negotiation and the recommended generation of primitives at   * }
{ *   session close.                                                * }
{ *                                                                 * }
{ *      startssmp    : negotiate session start with terminal       * }
{ *      stopssmp     : tidy up and close down session              * }
{ *                                                                 * }
{ *   The key to use of the whole SSMP module is the last           * }
{ *   primitive:                                                    * }
{ *                                                                 * }
{ *      getprimitive : process input until primitive decoded       * }
{ *                                                                 * }
{ *   This function should be repeatedly called to fetch each       * }
{ *   primitive from the terminal.  Input frames will be fetched    * }
{ *   automatically as required.  Each call returns exactly one     * }
{ *   terminal-generated primitive decoded into the primitive       * }
{ *   identifier and parameters.  The primitive may be processed as * }
{ *   appropriate.  Only T-TOKEN must be processed, and only in     * }
{ *   response to this primitive may host primitives other than     * }
{ *   H-REQTOKEN be generated.                                      * }
{ *                                                                 * }
{ *   When each primitive is presented by "getprimitive" the host   * }
{ *   copy of the shared data structure will already have been      * }
{ *   updated.  The parser calls the relevant T-primitive semantic  * }
{ *   routine to perform this action before returning control.      * }
{ *   Calls to "getloc", "getfield", "getmode" and "getrow" at this * }
{ *   point will therefore return correct values.                   * }
{ *                                                                 * }
{ *   The semantic routine called on recognition of T-TOKEN checks  * }
{ *   mode[TLEVEL] and mode[DSINVALID] for values consistent with   * }
{ *   the current SSMP session.  If they are not consistent, the    * }
{ *   values are corrected and "refresh" is called to correct the   * }
{ *   terminal.  On being presented with T-TOKEN, the application   * }
{ *   is freed from the necessity of checking session integrity and * }
{ *   may act on the request code as appropriate.                   * }
{ *                                                                 * }
{ *   The master session level will be taken from the first         * }
{ *   T-SETMODE setting it.  Note that it is the responsibility of  * }
{ *   the host application calling "getprimitive" to check the      * }
{ *   screen dimensions offered.  This should be done at the first  * }
{ *   T-TOKEN; if the values are unsuitable a suitable text message * }
{ *   should be output and "stopssmp" called.                       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ initcoding -- initialise tables for SSMP primitive encoding }
procedure initcoding;
var
    j : smallint;
    s : chstring;
begin
    { i/o system and session initialisation }
    masterlevel := 0;
    outremdr := 0;  outptr := 0;
    framenbr := 1;
    getinf(maxframe, s, maxstr);            { ssmp frames/packet }
    if s[1] = endstr then
        mxframenbr := 2                        { the safe value }
    else
    begin
        mxframenbr := s[1] - dig0;
        if (mxframenbr < 1) or (mxframenbr > 7) then
            mxframenbr := 2
    end;
 
    cfstate := nocf;
    ssmpstate := nul;
    treqstate := notkreq;
    repainted := false;
 
    { input filter table to pass valid characters and strip parity }
    for j := 0 to 127 do
        filter[j] := nul;
    filter[blank] := blank;
    for j := lparen to semicol do
        filter[j] := j;
    filter[equals] := equals;
    for j := capa to capz do
    begin
        filter[j] := j;  filter[j+32] := j+32
    end;
    for j := 0 to 127 do
        filter[j+128] := filter[j];
 
    { decoding table for incoming T-CHARACTER primitives }
    for j := 0 to 127 do
    begin
       decode[j] := 32;
       encode[j] := 32
    end;
 
    decode[48] := 0;
    for j := 0 to 25 do
        decode[65+j]  := j + 1;
    for j := 0 to 4  do
        decode[49+j]  := j + 27;
    for j := 0 to 6  do
        decode[97+j]  := j + 33;
    for j := 0 to 5  do
        decode[104+j] := j + 58;
    decode[110] := 64;
    for j := 0 to 4  do
        decode[111+j] := j + 91;
    decode[116] := 96;
    for j := 0 to 4  do
        decode[117+j] := j + 123;
 
    { encoding table for generating H-CHARACTER primitives }
    for j := 0 to 127 do
        encode[decode[j]] := j;
    encode[32] := 32
end;  {initcoding}
 
 
{ initshared -- initialise our copy of the shared data structure }
procedure initshared;
var
    fidx : fieldindex;
    trow : rowtype;
    tcol : coltype;
    midx : modeindex;
begin
    token := withhost;
    row := 0;  col := 0;
 
    { stored field definitions }
    for fidx := 0 to zfieldlimit do
    with field[fidx] do
    begin
        fldtop := 0;   fldbottom := 0;
        fldleft := 0;  fldright := 0;
    end;
    curfield := 0;  maxfield := 0;
 
    { update limits }
    boxtop := 0;   boxbottom := 0;
    boxleft := 0;  boxright := 0;
 
    { mode array }
    for midx := 0 to 63 do
        mode[midx] := 0;
 
    { tabulation stops array}
    for tcol := 0 to zmaxcol do
        tabs[tcol] := notab;
 
    { not true ssmp, but assign all elements of the screen array
      to avoid upsetting Pascal run time checking routines }
    for trow := 0 to zmaxrow do
        for tcol := 0 to zmaxcol do
            image[trow,tcol] := grave
end;  {initshared}
 
 
{ netread -- get next frame from network }
procedure netread;
var
    j : integer;
begin
    if not getline(inbuff, stdin, maxstr) then
        inbuff[1] := endstr;
    j := 1;  inptr := 0;
    while inbuff[j] <> endstr do
        j := j + 1;
    inlen := j - 1;
    if inlen < 4 then
        for j := inlen+1 to 4 do
            inbuff[j] := isospace
end;  {netread}
 
 
{ netwrite -- output assembled frames to the network }
procedure netwrite;
begin
    outbuff[outptr+1] := endstr;
    putstr(outbuff, stdout)
end;  {netwrite}
 
 
{ endframe -- end current output frame }
procedure endframe;
begin
    if outptr > 0 then
    begin
        if outbuff[outptr] = isospace then
        begin                           { foil trailing space trim }
            outbuff[outptr+1] := dollar;
            outptr := outptr + 1
        end;
        outbuff[outptr+1] := ctlm;
        outbuff[outptr+2] := ctlj;
        outptr := outptr + 2;
        if framenbr < mxframenbr then
            framenbr := framenbr + 1
        else
        begin
            netwrite;
            framenbr := 1;
            outptr := 0
        end
    end;
    outremdr := 0
end;  {endframe}
 
 
{ pushframe -- push frame(s) to network }
procedure pushframe;
begin
    endframe;
    if outptr > 0 then
    begin
        netwrite;
        framenbr := 1;
        outptr := 0
    end
end;  {pushframe}
 
 
{ assemble -- encode host SSMP primitive and add to output frame }
procedure assemble (primid : isochar;
                    npars : smallint;
                    pars : primpar);
var
    pstr, istr : charstr;
    plen, ilen, chindex : charlen;
    pindex, jindex, itemp : smallint;
begin
    if primid = star then
    begin                               { H-CHARACTER }
        itemp := encode[pars[1]];
        plen := 1;
        if itemp = blank then
            pstr[1] := pars[1]
        else
        begin  { escaped set }
            pstr[1] := colon;
            pstr[2] := itemp;
            plen := 2
        end
    end
    else
    begin                               { not H-CHARACTER }
        pstr[1] := equals;
        pstr[2] := primid;
        plen := 2;
        if npars = 0 then
            plen := 3
        else
        for pindex := 1 to npars do
        begin
            itemp := pars[pindex];  ilen := 0;
            while itemp>0 do
            begin
                ilen := ilen + 1;
                istr[16-ilen] := (itemp mod 10) + dig0;
                itemp := itemp div 10
            end;
            if ilen=0 then
            begin
                ilen := 1;  istr[15] := dig0;
            end;
            for jindex := ilen downto 1 do
            begin
                plen := plen + 1;  pstr[plen] := istr[16-jindex]
            end;
            plen := plen + 1;
            pstr[plen] := comma
        end;
        pstr[plen] := semicol
    end;
 
    { add encoded primitive to output frame }
    for chindex := 1 to plen do
    begin
        if outremdr = 0 then
        begin
            endframe;
            outptr := outptr + 1;
            outbuff[outptr] := ctlk;
            outremdr := framesize
        end;
        outptr := outptr + 1;
        outbuff[outptr] := pstr[chindex];
        outremdr := outremdr - 1
    end
end;  {assemble}
 
 
{ cftest -- issues pending H-SETCURSOR or H-SETFIELD as necessary }
procedure cftest (newcfstate : ncftype);
var
    ppar : primpar;
begin
    if newcfstate <> cfstate then
    begin
        case cfstate of
 
        nocf:
            ;
 
        csrpend:
            begin
                ppar[1] := row;  ppar[2] := col;
                assemble(capb, 2, ppar);
            end;
 
        fldpend:
            begin
                ppar[1] := curfield;  assemble(capl, 1, ppar);
            end;
 
        end;  {case}
        cfstate := newcfstate
    end
end;  {cftest}
 
 
{ maxrow -- returns current session maximum row value }
function maxrow : rowtype;
begin
    maxrow := mode[tmaxrow]
end;  {maxrow}
 
 
{ maxcol -- returns current session maximum column value }
function maxcol : coltype;
begin
    maxcol := mode[tmaxcol]
end;  {maxcol}
 
 
{ fieldlimit -- returns current session maximum field index }
function fieldlimit : fieldindex;
begin
    fieldlimit := ((maxrow + 1) * 4) - 1
end;  {fieldlimit}
 
 
{ eraserow -- erase part of one row to SPACE characters }
procedure eraserow (rowa : rowtype;
                    cola : coltype;
                    colb : coltype);
var
    ctemp : coltype;
begin
    for ctemp := cola to colb do
        image[rowa,ctemp] := isospace
end;  {eraserow}
 
 
{ erasebox -- erase a rectangle of positions to SPACE characters }
procedure erasebox (rowa : rowtype;
                    rowb : rowtype;
                    cola : coltype;
                    colb : coltype);
var
    rtemp : rowtype;
begin
    for rtemp := rowa to rowb do
        eraserow(rtemp, cola, colb)
end;  {erasebox}
 
 
{ rowcopy -- copy part of row to same column range of another row }
procedure rowcopy (rowa : rowtype;
                   rowb : rowtype;
                   cola : coltype;
                   colb : coltype);
var
    ctemp : coltype;
begin
    for ctemp := cola to colb do
        image[rowb,ctemp] := image[rowa,ctemp]
end;  {rowcopy}
 
 
{ rightshift -- shift row characters to right within column range }
procedure rightshift (rowa : rowtype;
                      cola : coltype;
                      colb : coltype;
                      ncols : smallint);
var
    ctemp : coltype;
begin
    if (colb - cola) < ncols then
        eraserow(rowa, cola, colb)
    else
    begin
        for ctemp := colb - ncols downto cola do
            image[rowa,ctemp+ncols] := image[rowa,ctemp];
        eraserow(rowa, cola, cola+ncols-1)
    end
end;  {rightshift}
 
 
{ leftshift -- shift row characters to left within column range }
procedure leftshift (rowa : rowtype;
                     cola : coltype;
                     colb : coltype;
                     ncols : smallint);
var
    ctemp : coltype;
begin
    if (colb - cola) < ncols then
        eraserow(rowa, cola, colb)
    else
    begin
        for ctemp := cola + ncols to colb do
            image[rowa,ctemp-ncols] := image[rowa,ctemp];
        eraserow(rowa, colb-ncols+1, colb)
    end
end;  {leftshift}
 
 
{ textchar -- generate H-CHARACTER to send text }
procedure textchar (ch : isochar);
var
    ppar : primpar;
    dspch : isochar;
begin
    cftest(nocf);               { flush any H-SETFIELD or H-SETCURSOR }
    if ch > del
        then dspch := grave     { not in ISO 646 -> display grave }
        else dspch := ch;
    ppar[1] := dspch;
    assemble(star, 1, ppar);
    image[row,col] := ch;
    if col < maxcol then
        col := col + 1
end;  {textchar}
 
 
{ sendtoken -- generate H-TOKEN to transfer token }
procedure sendtoken (reqcode : smallint);
var
    ppar : primpar;
begin
    cftest(nocf);               { flush any H-SETFIELD or H-SETCURSOR }
    ppar[1] := reqcode;         { token code, 0 or 1 }
    assemble(capa, 1, ppar);
    pushframe;                  { H-TOKEN ends frame }
    if mode[cursor] = 0 then
    begin                       { bound cursor }
        if (row < boxtop) or (row > boxbottom)
            or (col < boxleft) or (col > boxright) then
        begin
            row := boxtop;
            col := boxleft
        end
    end;
    mode[tlevel] := 0;          { check this on token return }
    token := withterm           { control with terminal emulation }
end;  {sendtoken}
 
 
{ setcursor -- generate H-SETCURSOR to set the cursor position }
procedure setcursor (newrow : rowtype;
                     newcol : coltype);
begin
    cftest(csrpend);        { flush any H-SETFIELD, defer H-SETCURSOR }
    row := newrow;
    col := newcol
end;  {setcursor}
 
 
{ setmode -- generate H-SETMODE to set a mode array element value }
procedure setmode (index : modeindex;
                   ivalue : smallint);
var
    ppar : primpar;
begin
    ppar[1] := index;           { element index number }
    ppar[2] := ivalue;          { new value }
    assemble(capc, 2, ppar);
    mode[index] := ivalue
end;  {setmode}
 
 
{ erasetoright -- generate H-ERASETORIGHT to erase to end of row }
procedure erasetoright;
var
    ppar : primpar;
begin
    cftest(nocf);               { flush any H-SETFIELD or H-SETCURSOR }
    ppar[1] := nul;
    assemble(capd, 0, ppar);
    eraserow(row, col, maxcol)
end;  {erasetoright}
 
 
{ insertspace -- generate H-INSERTSPACE to insert SPACE characters }
procedure insertspace (nsp : smallint);
var
    ppar : primpar;
begin
    cftest(nocf);               { flush any H-SETFIELD or H-SETCURSOR }
    ppar[1] := nsp;             { number of space characters }
    assemble(cape, 1, ppar);
    if mode[reqshift] = 1 then
        rightshift(row, col, maxcol, nsp)
end;  {insertspace}
 
 
{ deletechar -- generate H-DELETECHAR to delete characters }
procedure deletechar (nch : smallint);
var
    ppar : primpar;
begin
    cftest(nocf);               { flush any H-SETFIELD or H-SETCURSOR }
    ppar[1] := nch;             { number of characters }
    assemble(capf, 1, ppar);
    if mode[reqshift] = 1 then
        leftshift(row, col, maxcol, nch)
end;  {deletechar}
 
 
{ soundalarm -- generate H-SOUNDALARM to sound the audible alarm }
procedure soundalarm;
var
    ppar : primpar;
begin
    ppar[1] := nul;
    assemble(capg, 0, ppar)
end;  {soundalarm}
 
 
{ scrollup -- generate H-SCROLLUP to scroll rows up }
procedure scrollup (rowa : rowtype;
                    rowb : rowtype;
                    nrows : smallint);
var
    rtemp : rowtype;
    ppar : primpar;
begin
    ppar[1] := rowa;            { upper row }
    ppar[2] := rowb;            { lower row }
    ppar[3] := nrows;           { number of rows to scroll }
    assemble(caph, 3, ppar);
    if (rowb-rowa) < nrows then
        erasebox(rowa, rowb, 0, maxcol)
    else
    begin
        for rtemp := rowa+nrows to rowb do
            rowcopy(rtemp, rtemp-nrows, 0, maxcol);
        erasebox(rowb-nrows+1, rowb, 0, maxcol)
    end
end;  {scrollup}
 
 
{ scrolldown -- generate H-SCROLLDOWN to scroll rows down }
procedure scrolldown (rowa : rowtype;
                      rowb : rowtype;
                      nrows : smallint);
var
    rtemp : rowtype;
    ppar : primpar;
begin
    ppar[1] := rowa;            { upper row }
    ppar[2] := rowb;            { lower row }
    ppar[3] := nrows;           { number of rows to scroll }
    assemble(capi, 3, ppar);
    if (rowb-rowa) < nrows then
        erasebox(rowa, rowb, 0, maxcol)
    else
    begin
        for rtemp := rowb-nrows downto rowa do
            rowcopy(rtemp, rtemp+nrows, 0, maxcol);
        erasebox(rowa, rowa+nrows-1, 0, maxcol)
    end
end;  {scrolldown}
 
 
{ erasedisplay -- generate H-ERASEDISPLAY to erase screen image }
procedure erasedisplay;
var
    ppar : primpar;
begin
    if cfstate = csrpend then
        cfstate := nocf         { implied cursor movement to [0,0] }
    else
        cftest(nocf);           { flush any H-SETFIELD }
    ppar[1] := nul;
    assemble(capj, 0, ppar);
    erasebox(0, maxrow, 0, maxcol);
    row := 0;
    col := 0
end;  {erasedisplay}
 
 
{ erasefields -- generate H-ERASEFIELDS to erase all field defns }
procedure erasefields;
var
    ftemp : fieldindex;
    ppar : primpar;
begin
    if cfstate = fldpend then
        cfstate := nocf         { implicit selection of field zero }
    else
        cftest(nocf);           { flush any H-SETCURSOR }
    ppar[1] := nul;
    assemble(capk, 0, ppar);
    curfield := 0;
    maxfield := 0;
    for ftemp := 0 to fieldlimit do
    with field[ftemp] do
    begin
        fldtop := 0;  fldbottom := 0;
        fldleft := 0;  fldright := 0
    end;
    boxtop := 0;  boxbottom := 0;
    boxleft := 0;  boxright := 0
end;  {erasefields}
 
 
{ setfield -- generate H-SETFIELD to select new field definition }
procedure setfield (fidx : fieldindex);
begin
    cfstate := fldpend;         { suppress any H-SETCURSOR }
    if fidx > maxfield then
        maxfield := fidx;
    curfield := fidx;
    with field[curfield] do
    begin
        boxtop := fldtop;  boxbottom := fldbottom;
        boxleft := fldleft;  boxright := fldright
    end;
    row := boxtop;  col := boxleft
end;  {setfield}
 
 
{ setupdate -- generate H-SETUPDATE to set update limits for field }
procedure setupdate (rowa : rowtype;
                     rowb : rowtype;
                     cola : coltype;
                     colb : coltype);
var
    ppar : primpar;
begin
    cftest(nocf);               { flush any H-SETFIELD or H-SETCURSOR }
    ppar[1] := rowa;            { field upper row }
    ppar[2] := rowb;            { field lower row }
    ppar[3] := cola;            { field leftmost column }
    ppar[4] := colb;            { field rightmost column }
    assemble(capm, 4, ppar);
    with field[curfield] do
    begin
        boxtop := rowa;     fldtop := boxtop;
        boxbottom := rowb;  fldbottom := boxbottom;
        boxleft  := cola;   fldleft := boxleft;
        boxright := colb;   fldright := boxright
    end
end;  {setupdate}
 
 
{ erasetabs -- generate H-ERASETABS to erase all tabulation stops }
procedure erasetabs;
var
    ctemp : coltype;
    ppar : primpar;
begin
    ppar[1] := nul;
    assemble(capn, 0, ppar);
    for ctemp := 0 to maxcol do
        tabs[ctemp] := notab
end;  {erasetabs}
 
 
{ settab -- generate H-SETTAB to set one tabulation stop }
procedure settab (tcol : coltype);
var
    ppar : primpar;
begin
    ppar[1] := tcol;            { tabulation stop column }
    assemble(capo, 1, ppar);
    tabs[tcol] := tabset
end;  {settab}
 
 
{ session -- generate H-SESSION to enter or exit session }
procedure session (reqcode : smallint);
var
    ppar : primpar;
begin
    cftest(nocf);           { flush any [H-SETFIELD or] H-SETCURSOR }
    ppar[1] := reqcode;     { request code, 0 or 1 }
    assemble(capp, 1, ppar);
    if reqcode = 0 then
        initshared          { new session, init shared data structure }
    else
        pushframe           { current session ends, flush to network }
end;  {session}
 
 
{ fetchtoken -- generate H-REQTOKEN to request early return of token }
procedure fetchtoken;
var
    ppar : primpar;
begin
    cftest(nocf);           { flush any H-SETFIELD or H-SETCURSOR }
    ppar[1] := nul;
    pushframe;              { this primitive travels alone... }
    assemble(capq, 0, ppar);
    pushframe;              { ...so end the frame }
    treqstate := expecttok  { having asked, there's bound to be one }
end;  {fetchtoken}
 
 
{ reqtoken -- if we haven't got the token soon, generate H-REQTOKEN }
procedure reqtoken;
begin
    treqstate := needtok    { ask if no token by end of frame }
end;  {reqtoken}
 
 
{ getloc -- returns current cursor position row and column }
procedure getloc (var currow : rowtype;
                  var curcol : coltype);
begin
    currow := row;
    curcol := col
end;  {getloc}
 
 
{ getfield -- returns current field index }
procedure getfield (var curfdx : fieldindex);
begin
    curfdx := curfield
end;  {getfield}
 
 
{ getmode -- returns a copy of the mode array }
procedure getmode (var mcopy : modearray);
begin
    mcopy := mode
end;  {getmode}
 
 
{ putmode -- makes the real mode array conform to that supplied }
procedure putmode (var mcopy : modearray);
var
    midx : modeindex;
begin
    for midx := notify to knewline do
        if mcopy[midx] <> mode[midx] then
            setmode(midx, mcopy[midx])
end;  {putmode}
 
 
{ getrow -- returns the text of the requested row }
procedure getrow (r : rowtype;
                  var line : rowtext);
var
    tcol, mcol : coltype;
begin
    mcol := maxcol;
    for tcol := 0 to mcol do
        line[tcol] := image[r,tcol];
    if mcol < zmaxcol then
        for tcol := mcol+1 to zmaxcol do
            line[tcol] := blank
end;  {getrow}
 
 
{ putrow -- replaces the text for the specified row }
procedure putrow (r : rowtype;
                  var line : rowtext);
var
    tcol, mcol : coltype;
    done : boolean;
    ch : isochar;
    bcount, bidx : smallint;
begin
    done := false;
    mcol := maxcol;
    setcursor(r, 0);
 
    if mode[selectgr] <> defrend then
    begin
        if mode[reqshift] = 1 then
            insertspace(mcol+1)     { clear to selected rendition }
        else
        begin                       { must output each character }
            for tcol := 0 to mcol do
                textchar(line[tcol]);
            done := true
        end
    end
    else
        erasetoright;           { clear to default rendition spaces }
 
    { if the text has not yet been output, use the following
      algorithm which will skip large areas of white space }
    tcol := 0;
    bcount := 0;
    while not done do
    begin
        ch := line[tcol];
        if ch = blank then
            bcount := bcount + 1
        else
        begin
            if bcount > 0 then
            begin
                if bcount >= 10 then
                    setcursor(r, tcol)
                else
                    for bidx := 1 to bcount do
                        textchar(blank);
                bcount := 0
            end;
            textchar(ch)
        end;
        if tcol = mcol then
            done := true
        else
            tcol := tcol + 1
    end
end;  {putrow}
 
 
{ refresh -- refreshes the whole shared data structure }
procedure refresh;
var
    svrow, trow : rowtype;
    svcol, tcol : coltype;
    fidx, fcur, fmax : fieldindex;
    fdefs : array [fieldindex] of savedfield;
    midx : modeindex;
    mval : smallint;
    tdefs : array [coltype] of tabstop;
    text : rowtext;
begin
    svrow := row;  svcol := col;    { note cursor position }
 
    { stored field definitions }
    fcur := curfield;
    fmax := maxfield;
    for fidx := 0 to fmax do
        fdefs[fidx] := field[fidx];
    erasefields;
    for fidx := 0 to fmax do
    with fdefs[fidx] do
    begin
        setfield(fidx);
        setupdate(fldtop, fldbottom, fldleft, fldright)
    end;
    if fcur <> curfield then
        setfield(fcur);
 
    { mode array }
    if masterlevel = 0 then
        masterlevel := 1;       { safety check }
    mode[tlevel] := masterlevel;
    mode[dsinvalid] := 0;
    mode[selectgr] := defrend;
    for midx := 0 to maxmode do
    begin
        mval := mode[midx];
        setmode(midx, mval)
    end;
 
    { tabulation stops array }
    for tcol := 0 to maxcol do
        tdefs[tcol] := tabs[tcol];
    erasetabs;
    for tcol := 0 to maxcol do
        if tdefs[tcol] = tabset then
            settab(tcol);
 
    { screen image and cursor position }
    for trow := 0 to maxrow do
    begin
        getrow(trow, text);
        putrow(trow, text)
    end;
    setcursor(svrow, svcol)
end;  {refresh}
 
 
{ tcharacter -- interpret T-CHARACTER character replaced report }
procedure tcharacter (ch : isochar);
begin
    image[row,col] := ch;
    if col < boxright then
        col := col + 1
end;  {tcharacter}
 
 
{ ttoken -- interpret T-TOKEN return of token }
procedure ttoken (reqcode : smallint);
begin
    token := withhost;
    if reqcode = 128 then               { reply to H-REQTOKEN }
        mode[tlevel] := masterlevel
    else if treqstate = expecttok then
        netread;                        { swallow duplicate token }
    treqstate := notkreq;
 
    if (mode[dsinvalid] <> 0) or        { data structure corrupt }
        (mode[tlevel] <> masterlevel)   { return from nested session }
    then
    begin
        refresh;
        repainted := true
    end
    { application will interpret the request code parameter }
end;  {ttoken}
 
 
{ tsetcursor -- interpret T-SETCURSOR cursor positioned report }
procedure tsetcursor (newrow : rowtype;
                      newcol : coltype);
begin
    row := newrow;
    col := newcol
end;  {tsetcursor}
 
 
{ tsetmode -- interpret T-SETMODE mode array correction report }
procedure tsetmode (index : modeindex;
                    ivalue : smallint);
var
    newval : smallint;
begin
    newval := ivalue;
    if index <= dsinvalid then
    begin
        case index of
 
        tlevel:
            if newval = 0 then
                mode[dsinvalid] := 1
            else if masterlevel = 0 then
                masterlevel := newval;
 
        tmaxrow:
            if newval > zmaxrow then
                newval := zmaxrow;
 
        tmaxcol:
            if newval > zmaxcol then
                newval := zmaxcol;
 
        dsinvalid:
            newval := 1;
 
        end  {case}
    end
    else
    if (index = icharmode) and (newval > 1) then
        newval := 0
    else
        ivalue := 0;
    mode[index] := newval;
end;  {tsetmode}
 
 
{ terasetoright -- interpret T-ERASETORIGHT right erasure report }
procedure terasetoright;
begin
    if (mode[keraright] > 0) or (mode[keraline] > 0) then
        eraserow(row, col, boxright)
end;  {terasetoright}
 
 
{ tinsertspace -- interpret T-INSERTSPACE SPACEs inserted report }
procedure tinsertspace (nsp : smallint);
begin
    if (mode[kinsspac] > 0)
        or (mode[icharmode] = 1) then
            rightshift(row, col, boxright, nsp)
end;  {tinsertspace}
 
 
{ tdeletechar -- interpret T-DELETECHAR characters deleted report }
procedure tdeletechar (nch : smallint);
begin
    if mode[kdelchar] > 0 then
        leftshift(row, col, boxright, nch)
end;  {tdeletechar}
 
 
{ teraseprev -- interpret T-ERASEPREV previous char erasure report }
procedure teraseprev (nch : smallint);
var
    temp : smallint;
begin
    if mode[keraprev] > 0 then
    begin
        { Note:  nch <= col - boxleft }
        for temp := 1 to nch do
        begin
            col := col - 1;
            image[row,col] := isospace
        end
    end
end;  {teraseprev}
 
 
{ tinsertline -- interpret T-INSERTLINE line(s) inserted report }
procedure tinsertline (nln : smallint);
var
    rtemp : rowtype;
begin
    if mode[kinsline] > 0 then
    begin
        if (boxbottom-row) < nln then
            erasebox(row, boxbottom, boxleft, boxright)
        else
        begin
            for rtemp := boxbottom-nln downto row do
                rowcopy(rtemp, rtemp+nln, boxleft, boxright);
            erasebox(row, row+nln-1, boxleft, boxright)
        end
    end
end;  {tinsertline}
 
 
{ tdeleteline -- interpret T-DELETELINE line(s) deleted report }
procedure tdeleteline (nln : smallint);
var
    rtemp : rowtype;
begin
    if mode[kdelline] > 0 then
    begin
        if (boxbottom-row) < nln then
            erasebox(row, boxbottom, boxleft, boxright)
        else
        begin
            for rtemp := row+nln to boxbottom do
                rowcopy(rtemp, rtemp-nln, boxleft, boxright);
            erasebox(boxbottom-nln+1, boxbottom, boxleft, boxright)
        end
    end
end;  {tdeleteline}
 
 
{ tappendline -- interpret T-APPENDLINE line appended report }
procedure tappendline;
var
    rtemp : rowtype;
begin
    if mode[kappline] > 0 then
    begin
        col := boxleft;
        if (row >= mode[ilinerow]) or (row = boxbottom) then
        begin
            if boxtop < boxbottom then
                for rtemp := boxtop+1 to row do
                    rowcopy(rtemp, rtemp-1, boxleft, boxright)
        end
        else
        begin
            row := row + 1;
            for rtemp := boxbottom-1 downto row do
                rowcopy(rtemp, rtemp+1, boxleft, boxright)
        end;
        eraserow(row, boxleft, boxright)
    end
end;  {tappendline}
 
 
{ tsplitline -- interpret T-SPLITLINE line split report }
procedure tsplitline;
var
    rtemp : rowtype;
    cinit : coltype;
begin
    if mode[ksplline] > 0 then
    begin
        cinit := col;
        col := boxleft;
        if (row >= mode[ilinerow]) or (row = boxbottom) then
        begin
            if boxtop < boxbottom then
                for rtemp := boxtop+1 to row do
                    rowcopy(rtemp, rtemp-1, boxleft, boxright)
        end
        else
        begin
            for rtemp := boxbottom-1 downto row do
                rowcopy(rtemp, rtemp+1, boxleft, boxright);
            row := row + 1
        end;
        if row > boxtop then
            eraserow(row-1, cinit, boxright);
        leftshift(row, boxleft, boxright, cinit-boxleft)
    end
end;  {tsplitline}
 
 
{ tsetfield -- interpret T-SETFIELD field selection report }
procedure tsetfield (fidx : fieldindex);
begin
    { Note: fidx <= maxfield }
    curfield := fidx;
    with field[curfield] do
    begin
        boxtop := fldtop;  boxbottom := fldbottom;
        boxleft := fldleft;  boxright := fldright
    end;
    row := boxtop;  col := boxleft
end;  {tsetfield}
 
 
{ parsenum -- parse a stream of characters into n numbers }
function parsenum (expected : integer;
                   c : isochar;
                   var fin : boolean)
        : isochar;
var
    nst : isochar;
begin
    fin := false;
    nst := ssmpstate;           { state change on completion or error }
 
    if (c >= dig0) and (c <= dig9) then
    begin
        tsum := (10 * tsum) + (c - dig0);  gotdigit := true;
        if tsum > 255 then nst := question  { parameter too large }
    end
    else
    if ((c = comma) or (c = semicol))       { parameter terminator }
        and gotdigit then                   { at least one digit }
    begin
        tparidx := tparidx + 1;
        tpars[tparidx] := tsum;
        tsum := 0;
        gotdigit := false;
        if tparidx = expected then
        begin                   { got enough pars, check termination }
            if c = semicol then
            begin
                fin := true;  nst := nul    { finished }
            end
            else
                nst := question             { too many parameters }
        end
        else
        if c <> comma then
             nst := nul                     { early termination }
    end
    else
        nst := question;                    { unexpected character }
    parsenum := nst
end;  {parsenum}
 
 
{ parsesemi -- check termination for primitives with no parameters }
function parsesemi (c : isochar;
                    var ok : boolean)
            : isochar;
var
    flag : boolean;
begin
    flag := (c = semicol);
    if flag then
        parsesemi := nul            { finished }
    else
        parsesemi := question;      { unexpected character }
    ok := flag
end;  {parsesemi}
 
 
{ parsechar -- finite state machine emulation for ssmp }
function parsechar (ch : isochar) : boolean;
var
    nextst, tch : isochar;
    complete : boolean;
begin
    nextst := question;
    complete := true;
    case ssmpstate of
 
    nul:        { ground state, process after case to catch errors }
        ;
 
    colon:      { an encoded character follows }
        begin
            tch := decode[ch];
            if tch <> blank then
            begin
                tprid := star;
                tpars[1] := tch;
                tcharacter(tch);
                nextst := nul
            end
        end;
 
    equals:     { start of a primitive other than T-CHARACTER }
        if (ch >= capa) and (ch <= capl) then
        begin
            nextst := ch;
            tprid := ch;
            complete := false;
            tparidx := 0;               { initialise number parser }
            tsum := 0;
            gotdigit := false
        end;
 
    capa:       { parsing T-TOKEN(reqcode) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
            begin
                ttoken(tpars[1]);
                if repainted then
                begin
                    tpars[1] := 129;    { tell the application }
                    repainted := false
                end;
                inlen := 0              { discard remainder of frame }
            end
        end;
 
    capb:       { parsing T-SETCURSOR(newrow, newcol) }
        begin
            nextst := parsenum(2, ch, complete);
            if complete then
            begin
                complete :=
                    (tpars[1] <= maxrow) and (tpars[2] <= maxcol);
                if complete then
                    tsetcursor(tpars[1], tpars[2])
            end
        end;
 
    capc:       { parsing T-SETMODE(index, ivalue) }
        begin
            nextst := parsenum(2, ch, complete);
            if complete then
            begin
                complete := tpars[1] <= 63;
                if complete then
                    tsetmode(tpars[1], tpars[2])
            end
        end;
 
    capd:       { parsing T-ERASETORIGHT }
        begin
            nextst := parsesemi(ch, complete);
            if complete then
                terasetoright
        end;
 
    cape:       { parsing T-INSERTSPACE(nch) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
                tinsertspace(tpars[1])
        end;
 
    capf:       { parsing T-DELETECHAR(nch) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
                tdeletechar(tpars[1])
        end;
 
    capg:       { parsing T-ERASEPREV(nch) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
                teraseprev(tpars[1])
        end;
 
    caph:       { parsing T-INSERTLINE(nln) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
                tinsertline(tpars[1])
        end;
 
    capi:       { parsing T-DELETELINE(nln) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
                tdeleteline(tpars[1])
        end;
 
    capj:       { parsing T-APPENDLINE }
        begin
            nextst := parsesemi(ch, complete);
            if complete then
                tappendline
        end;
 
    capk:       { parsing T-SPLITLINE }
        begin
            nextst := parsesemi(ch, complete);
            if complete then
                tsplitline
        end;
 
    capl:       { parsing T-SETFIELD(fidx) }
        begin
            nextst := parsenum(1, ch, complete);
            if complete then
            begin
                complete := tpars[1] <= maxfield;
                if complete then
                    tsetfield(tpars[1])
            end
        end
 
    end;  {case}
 
    if nextst = question then
    begin       { process in ground state }
        nextst := nul;
        complete := false;
        if (ch = equals) or (ch = colon) then
            nextst := ch
        else
        if ch <> semicol then
        begin  { T-CHARACTER }
            tprid := star;
            tpars[1] := ch;
            tcharacter(ch);
            complete := true
        end
    end;
 
    ssmpstate := nextst;
    parsechar := complete
end;  {parsechar}
 
 
{ getprimitive -- process input until a primitive has been decoded }
procedure getprimitive (var pcode : isochar;
                        var ppars : primpar);
var
    nextch : isochar;
begin
    repeat
        repeat
            while inptr >= inlen do
            begin
                if treqstate = needtok then
                    fetchtoken;
                netread
            end;
            inptr := inptr + 1;
            nextch := filter[inbuff[inptr]]
        until nextch <> nul;
    until parsechar(nextch);
    pcode := tprid;
    ppars := tpars
end;  {getprimitive}
 
 
{ resetlink -- reset network link at end of session }
procedure resetlink;
begin
    iocontrol(iomddeflt, stdout);   { normal output }
    iocontrol(iomddeflt, stdin);    { whatever is normal input }
end;  {resetlink}
 
 
{ startssmp -- negotiate screen management session with terminal }
procedure startssmp (var success : boolean;
                     usertext : chstring);
var
    j : integer;
begin
    initcoding;
    iocontrol(iomdasis, stdout);    { ready built packets }
    iocontrol(iomdmsg, stdin);      { no native mode, please }
 
    session(0);                 { initialises shared data structure }
    textchar(blank);  textchar(blank);
    j := 1;
    while usertext[j] <> endstr do
    begin
        textchar(usertext[j]);
        j := j + 1
    end;
    textchar(blank);  textchar(blank);
    sendtoken(1);
 
    netread;            { read first frame, crude check for T-SETMODE }
    success := (inbuff[1] = equals) and (inbuff[2] = capc)
        and (inbuff[3] = dig0);
 
    if not success then
    begin
        timewait(3);            { 3 second wait stabilises terminal }
        session(1);             { cures double RETURN by user }
        resetlink               { and back to normal i/o }
    end;
    { any error message is the responsibility of the application }
end;  {startssmp }
 
 
{ stopssmp -- tidy up and close down screen management session }
procedure stopssmp;
begin
    scrollup(0, maxrow, 1);
    setcursor(maxrow, 0);
    session(1);
    resetlink
end;  {stopssmp}
 
 
{ ### End of SSMP module ### }
 
 
{ ****************************************************** stdenv ***** }
{ *                                                                 * }
{ *        Software Tools :: Standard environment routines          * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ skipbl -- skip blanks and tabs at s[i]... }
procedure skipbl (var s : chstring;
                  var i : integer);
begin
    while (s[i] = blank) or (s[i] = tab) do
        i := i + 1
end;  {skipbl}
 
 
{ addstr -- put c in outset[j], if it fits, increment j }
function addstr (c : isochar;
                 var outset : chstring;
                 var j : integer;
                 maxset : integer)
        : boolean;
begin
    if j > maxset then
        addstr := false
    else
    begin
        outset[j] := c;  j := j + 1;  addstr := true
    end
end;  {addstr}
 
 
{ equal -- test two strings for equality }
function equal (var str1 : chstring;
                var str2 : chstring)
        : boolean;
var
    i : integer;
begin
    i := 1;
    while (str1[i] = str2[i]) and (str1[i] <> endstr) do
        i := i + 1;
    equal := (str1[i] = str2[i])
end;  {equal}
 
 
{ mapesc -- map s[i] into escaped character, increment i }
function mapesc (var s : chstring;
                 var i : integer)
        : isochar;
begin
    if s[i] <> escape then
        mapesc := s[i]
    else if s[i+1] = endstr then
        mapesc := escape
    else
    begin
        i := i + 1;
        if s[i] = letn then
            mapesc := newline
        else if s[i] = lett then
            mapesc := tab
        else
            mapesc := s[i]
    end
end;  {mapesc}
 
 
{ chindex -- find position of character c in string s }
function chindex (var s : chstring;
                  c : isochar)
        : integer;
var
    i : integer;
begin
    i := 1;
    while (s[i] <> c) and (s[i] <> endstr) do
        i := i + 1;
    if s[i] = endstr then
        chindex := 0
    else
        chindex := i
end;  {chindex}
 
 
{ isdigit -- true if c is a digit }
function isdigit (c : isochar)
        : boolean;
begin
    isdigit := (c >= dig0) and (c <= dig9)
end;  {isdigit}
 
 
{ islower -- true if c is a lower case letter }
function islower (c : isochar)
        : boolean;
begin
    islower := (c >= leta) and (c <= letz)
end;  {islower}
 
 
{ isupper -- true if c is an upper case letter }
function isupper (c : isochar)
        : boolean;
begin
    isupper := (c >= capa) and (c <= capz)
end;  {isupper}
 
 
{ isletter -- true if c is a letter }
function isletter (c : isochar)
        : boolean;
begin
    isletter := (islower(c) or isupper(c))
end;  {isletter}
 
 
{ isalphanum -- true if c is a letter or a digit }
function isalphanum (c : isochar)
        : boolean;
begin
    isalphanum := (islower(c) or isupper(c) or isdigit(c))
end;  {isalphanum}
 
 
{ lowercase -- take character, return as lower case if upper case }
function lowercase (c : isochar)
        : isochar;
begin
    if isupper(c) then
        lowercase := c - capa + leta
    else
        lowercase := c
end;  {lowercase}
 
 
{ itoc -- converts integer n to string in s[i], returns end of s }
function itoc (n : integer;
               var s : chstring;
               i : integer)
        : integer;
begin
    if n < 0 then
    begin
       s[i] := minus;
       itoc := itoc(-n, s, i+1)
    end
    else
    begin
        if n >= 10 then
            i := itoc(n div 10, s, i);
        s[i] := (n mod 10) + dig0;
        s[i+1] := endstr;
        itoc := i + 1
    end
end;  {itoc}
 
 
{ max -- computes maximum of two integers }
function max (x : integer;
              y : integer)
        : integer;
begin
    if x > y then
        max := x
    else
        max := y
end;  {max}
 
 
{ min -- computes minimum of two integers }
function min (x : integer;
              y : integer)
        : integer;
begin
    if x < y then
        min := x
    else
        min := y
end;  {min}
 
 
{ scopy -- copies string starting at src[i] to dest starting at j }
procedure scopy (var src : chstring;
                 i : integer;
                 var dest : chstring;
                 j : integer);
begin
    while (src[i] <> endstr) and (j < maxstr) do
    begin
        dest[j] := src[i];
        i := i + 1;
        j := j + 1
    end;
    dest[j] := endstr
end;  {scopy}
 
 
{ getword -- get word from s[i] into out }
function getword (var s : chstring;
                  i : integer;
                  var out : chstring)
        : integer;
var
    j : integer;
    c : isochar;
begin
    c := s[i];
    while (c = blank) or (c = tab) or (c=newline) do
    begin
        i := i + 1;
        c := s[i]
    end;
    j := 1;
    while (c <> endstr) and (c <> blank) and (c <> tab)
        and (c <> newline) do
    begin
        out[j] := s[i];
        i := i + 1;
        c := s[i];
        j := j + 1
    end;
    out[j] := endstr;
    if s[i] = endstr then
        getword := 0
    else
        getword := i
end;  {getword}
 
 
{ ctoi -- convert string at s[i] to integer, increment i }
function ctoi (var s : chstring;
               var i : integer)
        : integer;
var
    n, sign : integer;
begin
    while (s[i] = blank) or (s[i] = tab) do i := i + 1;
    if s[i] = minus then
        sign := -1
    else
        sign := 1;
    if (s[i] = minus) or (s[i] = plus) then
        i := i + 1;
    n := 0;
    while isdigit(s[i]) do
    begin
        n := 10 * n + ord(s[i]) - ord(dig0);
        i := i + 1
    end;
    ctoi := sign * n
end;  {ctoi}
 
 
{ length -- computes length of string s }
function length (var s : chstring)
        : integer;
var
    n : integer;
begin
    n := 1;
    while s[n] <> endstr do
        n := n + 1;
    length := n - 1
end;  {length}
 
 
{ append -- append contents of str1 to contents of str2 }
procedure append (var str1 : chstring;
                    var str2 : chstring);
begin
    scopy(str1, 1, str2, length(str2)+1)
end;  {append}
 
 
{ setstring -- make string from literal }
procedure setstring (var target : chstring;
                     txt : textlit);
const
    endlit = '&';
    litlit = '@';
var
    copying : boolean;
    sidx, tidx : integer;
    isoch : isochar;
    lch : char;
begin
    tidx := 1;  sidx := 1;  copying := txt[1] <> endlit;
 
    while copying do
    begin
        lch := txt[sidx];
        isoch := nul;
        if lch = litlit then
        begin
            if sidx < 24 then
            begin
                sidx := sidx + 1;
                lch := txt[sidx];
                if lch = 'n' then           { @n = newline }
                    isoch := newline
                else if lch = 't' then      { @t = tab }
                    isoch := tab
            end;
        end;
        if isoch = nul then
            target[tidx] := littoiso[ord(lch)]
        else
            target[tidx] := isoch;
        tidx := tidx + 1;
        sidx := sidx + 1;
        if sidx > 24 then
            copying := false
        else
            copying := txt[sidx] <> endlit
    end;
    target[tidx] := endstr
end;  {setstring}
 
 
{ appstring -- append literal to existing string }
procedure appstring (var target : chstring;
                     txt : textlit);
var
    temp : chstring;
begin
    setstring(temp, txt);
    append(temp, target)
end;  {appstring}
 
 
{ getarg -- gets up to maxsize characters of the n'th argument }
function getarg (n : integer;
                 var str : chstring;
                 maxsize : integer)
        : boolean;
begin
    if (n < 0) or (n > nbrcmdargs) then
        getarg := false
    else
    begin
        scopy(cmdline, cmdargidx[n], str, 1);
        getarg := true
    end
end;  {getarg}
 
 
{ mustopen -- open file or die }
function mustopen (var name : chstring;
                   iomode : integer)
        : filedesc;
var
    fd : filedesc;
    s : chstring;
begin
    fd := openf(name, iomode);
    if fd = ioerror then
    begin
        scopy(name, 1, s, 1);
        appstring(s, ':  cannot open file@n&  ');
        putstr(s, stderr);
        errorexit
    end;
    mustopen := fd
end;  {mustopen}
 
 
{ mustcreate -- create file or die }
function mustcreate (var name : chstring;
                     iomode : integer)
        : filedesc;
var
    fd : filedesc;
    s : chstring;
begin
    fd := create(name, iomode);
    if fd = ioerror then
    begin
        scopy(name, 1, s, 1);
        appstring(s, ':  cannot create file@n&');
        putstr(s, stderr);
        errorexit
    end;
    mustcreate := fd
end;  {mustcreate}
 
 
{ fcopy -- copy file fin to file fout }
procedure fcopy (fin : filedesc;
                 fout : filedesc);
var
    lin : chstring;
begin
    while getline(lin, fin, maxstr) do
        putstr(lin, fout)
end;  {fcopy}
 
 
{ ****************************************************** ssmpex ***** }
{ *                                                                 * }
{ *                         SSMP Extras                             * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ literal -- convert literal string into 1 to 24 character calls }
procedure literal (txt : textlit);
var
    s : chstring;
    i : integer;
begin
    setstring(s, txt);
    i := 1;
    while s[i] <> endstr do
    begin
        textchar(s[i]);
        i := i + 1
    end
end;  {literal}
 
 
{ outdec -- send integer to screen image }
procedure outdec (n : integer);
var
    nd, k : integer;
    s : chstring;
begin
    nd := itoc(n, s, 1);
    for k := 1 to nd-1 do
        textchar(s[k]);
end;  {outdec}
 
 
{ slcopy -- copy string s[i].. to rowtext ln[j].., max n characters }
procedure slcopy (var s : chstring;
                  i : integer;
                  var ln : rowtext;
                  j : coltype;
                  n : integer);
var
    jmax : integer;
begin
    jmax := j + (n - 1);
    while (s[i] <> endstr) and (s[i] <> newline) and (j <= jmax) do
    begin
        ln[j] := s[i];
        i := i + 1;
        j := j + 1
    end
end;  {slcopy}
 
 
{ ****************************************************** pattern **** }
{ *                                                                 * }
{ *          Software Tools :: Pattern matching routines            * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ dodash -- expand set at src[i] into dest[j], stop at delim }
procedure dodash (delim : isochar;
                  var src : chstring;
                  var i : integer;
                  var dest : chstring;
                  var j : integer;
                  maxset : integer);
var
    k, ks, ke : isochar;
    junk : boolean;
begin
    while (src[i] <> delim) and (src[i] <> endstr) do
    begin
        if src[i] = escape then
            junk := addstr(mapesc(src, i), dest, j, maxset)
        else
        if src[i] <> minus then
            junk := addstr(src[i], dest, j, maxset)
        else
        if (j <= 1) or (src[i+1] = endstr) then
            junk := addstr(minus, dest, j, maxset)  { literal "-" }
        else
        if isalphanum(src[i-1])
            and isalphanum(src[i+1])
                and (src[i-1] <= src[i+1]) then
        begin
            { limits calculated first because some compilers get upset }
            ks := src[i-1] + 1;  ke := src[i+1];
            for k := ks to ke do
                junk := addstr(k, dest, j, maxset);
            i := i + 1
        end
        else
            junk := addstr(minus, dest, j, maxset);
        i := i + 1
    end;
end;  {dodash}
 
 
{ makepat -- make pattern from arg[i], terminate at delim }
function makepat (var arg : chstring;
                  start : integer;
                  delim : isochar;
                  var pat : chstring)
        : integer;
var
    i, j, lastj, lj : integer;
    done, css, junk : boolean;
    tc, plj : isochar;
 
 
{ getccl -- expand character class at arg[i] into pat[j] }
function getccl (var arg : chstring;
                 var i : integer;
                 var pat : chstring;
                 var j : integer)
        : boolean;
var
    jstart : integer;
    junk : boolean;
begin
    i := i + 1;  { skip over '[' }
    if arg[i] = negate then
    begin
        junk := addstr(nccl, pat, j, maxpat);
        i := i + 1
    end
    else
        junk := addstr(ccl, pat, j, maxpat);
    jstart := j;
    junk := addstr(nul, pat, j, maxpat);  { room for count }
    dodash(cclend, arg, i, pat, j, maxpat);
    pat[jstart] := j - jstart - 1;
    getccl := arg[i] = cclend
end;  {getccl}
 
 
{ stclose -- insert closure entry at pat[j] }
procedure stclose (var pat : chstring;
                   var j : integer;
                   lastj : integer);
var
    jp, jt : integer;
    junk : boolean;
begin
    for jp := j - 1 downto lastj do
    begin
        jt := jp + closize;
        junk := addstr(pat[jp], pat, jt, maxpat)
    end;
    j := j + closize;
    pat[lastj] := closure       { where original pattern began }
end;  {stclose}
 
 
begin  { makepat main routine }
    j := 1;                     { pat index }
    i := start;                 { arg index }
    css := cssinit;             { case sensitive scan default }
    lastj := 1;
    done := false;
    while (not done) and (arg[i] <> delim)
        and (arg[i] <> endstr) do
    begin
        lj := j;
        if arg[i] = any then
            junk := addstr(any, pat, j, maxpat)
        else
        if (arg[i] = bol) and (i = start) then
            junk := addstr(bol, pat, j, maxpat)
        else
        if (arg[i] = eol) and (arg[i+1] = delim) then
            junk := addstr(eol, pat, j, maxpat)
        else
        if arg[i] = ccl then
            done := getccl(arg, i, pat, j) = false
        else
        if (arg[i] = closure) and (i > start) then
        begin
            lj := lastj;
            plj := pat[lj];
            if (plj = bol) or (plj = eol) or (plj = closure) then
                done := true  { force loop termination }
            else
                stclose(pat, j, lastj)
        end
        else
        if arg[i] = anycase then
            css := not css        { invert case sensitivity switch }
        else
        begin  { literal character }
            if (not css) and isletter(arg[i]) then
            begin  { anycase match for letter }
                junk := addstr(ccl, pat, j, maxpat);
                junk := addstr(2, pat, j, maxpat);
                tc := arg[i];
                junk := addstr(tc, pat, j, maxpat);
                if tc < leta then tc := tc - capa + leta
                             else tc := tc - leta + capa;
                junk := addstr(tc, pat, j, maxpat);
            end
            else
            begin  { true literal }
                junk := addstr(litchar, pat, j, maxpat);
                junk := addstr(mapesc(arg, i), pat, j, maxpat)
            end
        end;
        lastj := lj;
        if not done then i := i + 1
    end;
    if done or (arg[i] <> delim) then
        makepat := 0  { finished early }
    else
    if not addstr(endstr, pat, j, maxpat) then
        makepat := 0  { no room }
    else
        makepat := i  { all is well }
end;  {makepat}
 
 
{ getpat -- convert whole of argument into pattern }
function getpat (var arg : chstring;
                 var pat : chstring)
        : boolean;
begin
    getpat := makepat(arg, 1, endstr, pat) > 0
end;  {getpat}
 
 
{ amatch -- look for match of pat[j]... at lin[offset]... }
function amatch (var lin : chstring;
                 offset : integer;
                 var pat : chstring;
                 j : integer)
        : integer;
var
    i, k : integer;
    done : boolean;
 
 
{ locate -- look for c in character class at pat[offset] }
function locate (c : isochar;
                 var pat : chstring;
                 offset : integer)
        : boolean;
var
    i : integer;
begin
    { size of class is at pat[offset], characters follow }
    locate := false;
    i := offset + pat[offset];  { last position }
    while i > offset do
        if c = pat[i] then
    begin
        locate := true;
        i := offset  { force loop termination }
    end
    else
        i := i - 1
end;  {locate}
 
 
{ omatch -- match one pattern element at pat[j] }
function omatch (var lin : chstring;
                 var i : integer;
                 var pat : chstring;
                 j : integer)
 
        : boolean;
var
    advance : -1..1;
begin
    advance := -1;
    if lin[i] = endstr then
        omatch := false
    else if pat[j] = litchar then
    begin
        if lin[i] = pat[j+1] then
            advance := 1;
    end
    else if pat[j] = bol then
    begin
        if i = 1 then
            advance := 0;
    end
    else if pat[j] = any then
    begin
        if lin[i] <> newline then
            advance := 1;
    end
    else if pat[j] = eol then
    begin
        if lin[i] = newline then
            advance := 0;
    end
    else if pat[j] = ccl then
    begin
        if locate(lin[i], pat, j+1) then
            advance := 1;
    end
    else if pat[j] = nccl then
    begin
        if (lin[i] <> newline)
            and (not locate(lin[i], pat, j+1)) then
                advance := 1
    end
    else
        errorexit;
 
    if advance >= 0 then
    begin
        i := i + advance;
        omatch := true
    end
    else
        omatch := false
end;  {omatch}
 
 
{ patsize -- returns size of pattern entry at pat[n] }
function patsize (var pat : chstring;
                      n : integer)
        : integer;
var
    ptn : isochar;
begin
    ptn := pat[n];
    if ptn = litchar then
        patsize := 2
    else if (ptn = bol) or (ptn = eol) or (ptn = any) then
        patsize := 1
    else if (ptn = ccl) or (ptn = nccl) then
        patsize := pat[n+1] + 2
    else if ptn = closure then
        patsize := closize
    else
        errorexit
end;  {patsize}
 
 
begin  { amatch main routine }
    done := false;
    while (not done) and (pat[j] <> endstr) do
        if pat[j] = closure then
    begin
        j := j + patsize(pat, j);  { step over closure }
        i := offset;
 
        { match as many as possible }
        while (not done) and (lin[i] <> endstr) do
            if not omatch(lin, i, pat, j) then done := true;
 
        { i points to input character that made us fail }
        { match rest of pattern against rest of input }
        { shrink closure by 1 after each failure }
        done := false;
        while (not done) and (i >= offset) do
        begin
            k := amatch(lin, i, pat, j+patsize(pat,j));
            if k > 0 then  { matched rest of pattern }
                done := true
            else
                i := i - 1
        end;
        offset := k;  { if k=0 failure else success }
        done := true
    end
    else
    if not omatch(lin, offset, pat, j) then
    begin
        offset := 0;  { non-closure }
        done := true
    end
    else  { omatch succeeded on this pattern element }
        j := j + patsize(pat, j);
    amatch := offset
end;  {amatch}
 
 
{ match -- find a match anywhere on a line }
function match(var lin : chstring;
               var pat : chstring)
        : boolean;
var
    i, pos : integer;
begin
    pos := 0;  i := 1;
    while (lin[i] <> endstr) and (pos = 0) do
    begin
        pos := amatch(lin, i, pat, 1);
        i := i + 1
    end;
    match := pos > 0
end;  {match}
 
 
{ makesub -- make substitution string from arg in sub }
function makesub (var arg : chstring;
                  fromm : integer;
                  delim : isochar;
                  var sub : chstring)
        : integer;
var
    i, j : integer;
    junk : boolean;
begin
    j := 1;  i := fromm;
    while (arg[i] <> delim) and (arg[i] <> endstr) do
    begin
        if arg[i] = ditto then
            junk := addstr(mkditto, sub, j, maxpat)
        else
            junk := addstr(mapesc(arg, i), sub, j, maxpat);
        i := i + 1
    end;
    if arg[i] <> delim then  { missing delimiter }
        makesub := 0
    else
    if not addstr(endstr, sub, j, maxpat) then
        makesub := 0
    else
        makesub := i
end;  {makesub}
 
 
{ ****************************************************** curlew ***** }
{ *                                                                 * }
{ *                 T h e   E d i t o r   C o d e                   * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ editor -- the editor code }
procedure editor;
 
 
const
 
 
{ ****************************************************** clcons ***** }
{ *                                                                 * }
{ *                   CURLEW :: Editor Constants                    * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    maxlines = 16384;       { maximum number of lines in file buffer }
    curline = period;       { dot signals current line }
    lastline = dollar;      { dollar signals last line }
    topline = sharp;        { sharp signals top line of f/s display }
 
    cmdprompt = greater;    { command prompt character }
    txtprompt = period;     { a/c/i prompt character }
    cbmax = 59;             { number of rows in conversation buffer }
 
    minkey = 1;             { minimum function key number }
    maxkey = 37;            { maximum function key number }
    vkdlim = 2048;          { characters available for definitions }
    keyleadin = atsign;     { function key lead-in on command line }
 
    { following are for use with "getinf" and CURLEW-specific }
    clbuffer  = 11;         { CURLEW :: edit buffer filename }
    clclone   = 12;         { CURLEW :: clone buffer filename }
    clprofile = 13;         { CURLEW :: profile filename }
    clsaveone = 14;         { CURLEW :: first safety filename }
    clsavetwo = 15;         { CURLEW :: second safety filename }
    cljournal = 16;         { CURLEW :: journal filename }
    clhelpcmd = 17;         { CURLEW :: system help command }
    clhelpfn  = 18;         { CURLEW :: simple help file }
    clsitedef = 19;         { CURLEW :: site default overrides }
    clrensave = 20;         { CURLEW :: rename save file switch }
    clwidchk  = 21;         { CURLEW :: check line width overflow }
 
 
type
 
 
{ ****************************************************** cltype ***** }
{ *                                                                 * }
{ *                     CURLEW :: Editor Types                      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    astype = (
        entry,              { negotiation reply }
        coned,              { context editor }
        fsereq,             { full-screen editor request }
        fsecmd );           { context command from full-screen editor }
    stcode = (
        enddata,            { no more text to scan }
        err,                { failure }
        ok );               { success (so far!) }
    errtype = (
        basic,              { no special note }
        search,             { pattern search failed }
        lrange );           { line parameter out of range }
    cstype = (
        concmd,             { context editor command }
        conapp,             { new line for a/c/i command }
        conecmd,            { y/n reply to e command }
        conqcmd,            { y/n reply to q command }
        paused  );          { replying to page-full prompt (querymore) }
    cmdtype = (
        badcmd,
        gcmd, xcmd,
        acmd, ccmd, cocmd, cucmd, clcmd, dcmd, ecmd, excmd, fcmd,
        focmd, hcmd, icmd, kcmd, lcmd, mcmd, pcmd, prcmd, qcmd,
        rcmd, scmd, secmd, shcmd, stcmd, ucmd, vcmd, wcmd,
        yesrep, norep, okrep, canrep );
    fstype = (
        normal,             { normal full-screen operation }
        blkmode );          { a block has been marked }
    traptype = (
        safe,               { no mousetrap set }
        armed,              { block ^Q or ^W }
        sprung);            { still no action, must reset block mode }
    masktype =
        array [nul..del] of isochar;    { for control character mask }
 
 
var
 
 
{ ****************************************************** clvar ****** }
{ *                                                                 * }
{ *                   CURLEW :: Editor Variables                    * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
    screenmode : boolean;   { true if frames may be fetched }
    tokencode : smallint;   { set to 1 for restricted transfer }
    appstate : astype;      { application processing state }
    cstate : cstype;        { context editor processing state }
    fstate : fstype;        { full-screen editor processing state }
    filenbr : integer;      { number of files edited this session }
 
    { mode arrays }
    ctxtmode : modearray;   { mode array for editor commands }
    nfsomode : modearray;   { mode array for normal f/screen operation }
    blokmode : modearray;   { mode array for block operation }
    bblkmode : modearray;   { modified version for basic block }
 
    { screen positions }
    toprow : rowtype;       { top row of conversation or file display }
    botrow : rowtype;       { bottom row of file display }
    pinrow : rowtype;       { preferred insertion row }
    cmdrow : rowtype;       { row from which commands are read }
    cmdcol : coltype;       { ... and the command start column }
 
    { file buffer }
    buftext : array [0..maxlines] of fdpointer; { line locations }
    bufmark : array [0..maxlines] of isochar;   { line markers }
 
    { checkpoint buffer }
    cptext  : array [0..maxlines] of fdpointer; { checkpoint text }
    cplstln : integer;      { checkpoint last line }
    cpcurln : integer;      { checkpoint current line }
    cptopln : integer;      { checkpoint top of screen line }
    cpfsrow : rowtype;      { checkpoint f/s row }
    cpfscol : coltype;      { checpoint f/s column }
    cpchanged : boolean;    { checkpoint changed flag }
    cpneeded : boolean;     { checkpoint and buffer differ flag }
 
    { buffer scratch file }
    scrout : filedesc;      { scratch output fd }
    scrin : filedesc;       { scratch input fd }
    recout : fdpointer;     { next record to write to scrout }
    bufferok : boolean;     { true if buffer passes integrity checks }
    widcheck : boolean;     { true record truncation is to be checked }
    crecdlen : boolean;     { true if record truncation problem }
    cfilelen : boolean;     { true is file length truncation problem }
 
    { editor buffer line parameters }
    line1 : integer;        { first line number }
    line2 : integer;        { second line number }
    nlines : integer;       { number of line numbers specified }
    curln : integer;        { current line; value of dot }
    lastln : integer;       { last line; value of dollar }
    topln : integer;        { full-screen; top of display value }
    itopln : integer;       { intermediate top line used for '#' }
    topused : boolean;      { true if topline used in computation }
 
    pat : chstring;         { current search pattern }
    lin : chstring;         { input line }
    prevlin : chstring;     { previous input line }
    savefile : chstring;    { remembered file name }
    newfile : chstring;     { new file name from edit }
 
    cursave, i : integer;
    status : stcode;        { overall command completion status }
    msgdone : boolean;      { true if error message printed already }
    errcode : errtype;      { fine control for error messages }
    changed : boolean;      { true if buffer and file differ }
 
    { conversation buffer }
    blankrow : rowtext;     { a completely blank row }
    cbuf : array [0..cbmax] of rowtext;        { conversation buffer }
    cbrows : integer;       { number of rows in conversation buffer }
    cfirst : integer;       { first row in conversation buffer }
    cnext : integer;        { conversation buffer row for next char }
    cbidx : integer;        { array index derived from cnext }
    cindent : integer;      { indent for subsequent lines }
    ccol : coltype;         { column in row for next character }
    cblfull : boolean;      { true if current row is full to maxcol }
    pausing : boolean;      { true if pausing when screen full }
    cpause : integer;       { pause after this many rows }
 
    { full-screen current position and line cache }
    fsrow : rowtype;        { full-screen cursor row tracking }
    fscol : coltype;        { full-screen cursor column tracking }
    fsline : integer;       { full-screen active line, if not zero }
    fstext : chstring;      { text associated with fsline }
    fschanged : boolean;    { true if fstext differs from buffer }
    vtitle : chstring;      { full-screen title if set }
    tokreq : boolean;       { true if the token has been requested }
    fscmask : boolean;      { true if c/chars masked in f/s operation }
    mask : masktype;        { control character mask }
 
    { block mode }
    blktopln : integer;     { top line as block mode entered }
    blkrow : rowtype;       { block mark cursor row }
    blkcol : coltype;       { block mark cursor column }
    blkoset : integer;      { left margin column at block mode entry }
    mousetrap : traptype;   { block ^Q or ^W mousetrap }
    vbmark : boolean;       { visual block mark indication }
 
    { clone details }
    cloneexists : boolean;  { true if scratch file has been created }
    fileclone : boolean;    { true if current clone in scratch file }
    charclone : boolean;    { true if clone is a character rectangle }
    sclone : chstring;      { used for internal clone storage }
 
    { journal file details }
    rebuild : boolean;      { true if session rebuild in progress }
    jfout : filedesc;       { journal file writes (logging) }
    jfin : filedesc;        { journal file reads (recovery) }
    jfprevc : isochar;      { previous command character }
    jfprevln : integer;     { previous command line number }
 
    { profile parameters }
    tabcols : array [coltype] of tabstop;      { tab stop columns }
    tabrpt : integer;       { if non-zero, tab repeat interval }
    detab : boolean;        { true if "gettxt" is to expand tabs }
    entab : boolean;        { true if "write" is to compress with tabs }
    htkeys : boolean;       { true if horizontal tab keys available }
    gblfmt : boolean;       { true for "fo b", false for "fo l" }
    gblwidth : integer;     { default width for "fo" command }
    gblpara : integer;      { default paragraph indent for "fo" }
    gbloset : integer;      { default offset for "fo" command }
    gbleos : integer;       { default extra sentence spaces for "fo" }
    blkpara : boolean;      { true if ^B..^P is to paragraph }
    rrend : integer;        { secondary SELECTGR code }
    mlevel : integer;       { control character entry mask }
    rappend : boolean;      { true for RETURN appends (else splits) }
    ciview : boolean;       { true for char insertion after "view" }
    loopsearch : boolean;   { true for search loop over whole buffer }
    alttracks : boolean;    { true for UNIX(tm) chicken tracks }
    acsearch : boolean;     { true for anycase search }
    autoimage : boolean;    { true for host-initiated image correction }
    autoview : boolean;     { automatic "v" command switch }
    inswrap : boolean;      { insert word wrap switch }
    cscroll : integer;      { vertical cursor movement action }
    xoset : integer;        { horizontal scroll offset }
 
    kptrs : array [minkey..maxkey] of integer;  { f/key pointers }
    kdefs : array [1..vkdlim] of isochar;       { f/key text }
    kdmax : integer;        { characters used in vkdefs }
    kpick : array [minkey..maxkey] of boolean;  { cmd pickup flags }
 
 
{ ****************************************************** cljournl *** }
{ *                                                                 * }
{ *     CURLEW :: Routines to access the editor journal file        * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ jfcontrol -- control open status of journal file }
procedure jfcontrol (iomode : integer);
var
    jfilename : chstring;
    junk : boolean;
begin
    getinf(cljournal, jfilename, maxstr);
    if jfilename[1] = endstr then
    begin                               { no journal file available }
        jfin := ioerror;
        jfout := ioerror
    end
    else if iomode = ioread then
    begin                               { recovery check open }
        jfin := create(jfilename, iomode);
        jfout := ioerror
    end
    else if iomode = iowrite then
    begin                               { nil recovery open }
        if jfin <> ioerror then
        begin
            closef(jfin);  jfin := ioerror
        end;
        if jfout <> ioerror then
            closef(jfout);
        jfout := create(jfilename, iowrite)
    end
    else if iomode = ioappend then
    begin                               { post-recovery open, "k" save }
        if jfin <> ioerror then
        begin
            closef(jfin);  jfin := ioerror
        end;
        if jfout <> ioerror then
            closef(jfout);
        jfout := openf(jfilename, ioappend)
    end
    else
    begin                               { end of session clean up }
        closef(jfout);
        jfout := openf(jfilename, iowrite);  { empty, remove may fail }
        closef(jfout);
        junk := remove(jfilename)           { if you can }
    end;
    jfprevc := nul                      { no cached command }
end;  {jfcontrol}
 
 
{ jwrite -- write command to journal file }
procedure jwrite (ln1 : integer;
                  ln2 : integer;
                  cmd : isochar;
                  var s : chstring);
var
    js, pdel : chstring;
    oneshot : boolean;
    delim : isochar;
    nd, j, k, l : integer;
begin
    case cmd of
 
    leta, letc:                         { append, change }
        begin
            j := itoc(ln1, js, 1);
            js[j] := cmd;
            oneshot := length(s) < (maxstr-48);
 
            if oneshot then             { room, find a delimiter }
            begin
                setstring(pdel, '/:#$&                   ');
                k := 1;
                while s[k] <> endstr do
                begin
                    l := 1;
                    repeat
                        if pdel[l] = s[k] then
                            pdel[l] := blank;
                        l := l + 1
                    until pdel[l] = endstr;
                    k := k + 1
                end;
                l := 1;
                while (pdel[l] <> endstr) and (pdel[l] = blank) do
                    l := l + 1;
                delim := pdel[l];
                oneshot := delim <> endstr
            end;
 
            if oneshot then             { found a delimiter }
            begin
                js[j+1] := delim;
                scopy(s, 1, js, j+2)
            end
            else                        { preferred delimiters in s }
            begin
                js[j+1] := newline;
                js[j+2] := endstr;
                putstr(js, jfout);
                putstr(s, jfout);
                js[1] := period;
                js[2] := newline;
                js[3] := endstr
            end;
        end;
 
    letd:                               { delete }
        begin
            nd := itoc(ln1, js, 1);
            j := nd;
            if ln2 > ln1 then
            begin
                js[nd] := comma;
                j := itoc(ln2, js, nd+1)
            end;
            js[j] := letd;
            js[j+1] := newline;
            js[j+2] := endstr
        end;
 
    lete, letf:                         { edit, file }
        begin
            js[1] := cmd;
            js[2] := blank;
            scopy(s, 1, js, 3);
            j := length(js);
            js[j+1] := newline;
            js[j+2] := endstr
        end;
 
    letk, letu:                         { keep, undo }
        begin
            js[1] := cmd;
            js[2] := newline;
            js[3] := endstr
        end;
 
    end;  {case}
    putstr(js, jfout)
end;  {jwrite}
 
 
{ journal -- accept journal log request and optimise }
procedure journal (ln1 : integer;
                   ln2 : integer;
                   cmd : isochar;
                   var s : chstring);
var
    tc : isochar;
    nl : chstring;
begin
    if jfout <> ioerror then
    begin
        tc := cmd;
        nl[1] := newline;  nl[2] := endstr;
        if jfprevc = letd then
        begin
            if (tc = leta) and (jfprevln = ln1+1) then
            begin
                jwrite(jfprevln, 0, letc, s);
                tc := nul
            end
            else
                jwrite(jfprevln, jfprevln, jfprevc, nl);
            jfprevc := nul
        end;
 
        if tc <> nul then
        begin
            if tc = letd then
            begin
                if ln1 = ln2 then
                begin
                    jfprevc := tc;
                    jfprevln := ln1
                end
            end;
            if jfprevc = nul then
                jwrite(ln1, ln2, tc, s)
        end
    end
end;  {journal}
 
 
{ ****************************************************** clwhite **** }
{ *                                                                 * }
{ *             CURLEW :: White space (tab) conversion              * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ expand -- expansion of tabulation stops in buffer text }
procedure expand (var s : chstring);
var
    c : isochar;
    i, j, k : integer;
    tc : coltype;
    t : chstring;
    fini : boolean;
begin
    fini := false;
    i := 1;
    j := 1;
    repeat
        c := s[i];
        i := i + 1;
        if c <> tab then
        begin
            t[j] := c;
            j := j + 1
        end
        else
        begin
            k := 1;
            if tabrpt > 0 then
                k := tabrpt - ((j - 1) mod tabrpt)
            else
            begin
                tc := j;
                while (tc < maxcol) and (tabcols[tc] <> tabset) do
                    tc := tc + 1;
                if tabcols[tc] = tabset then
                    k := tc + 1 - j
            end;
            while (k > 0) and (j < maxstr) do
            begin
                t[j] := blank;
                j := j + 1;
                k := k - 1
            end
        end;
        fini := (c = endstr) or (j >= maxstr)
    until fini;
    if t[j-1] <> endstr then
    begin
        t[j-2] := newline;
        t[j-1] := endstr
    end;
    scopy(t, 1, s, 1)
end;  {expand}
 
 
{ compress -- compression of white space into tab characters }
procedure compress (var s : chstring);
var
    c : isochar;
    i, j, k, nch : integer;
    tc : coltype;
    t : chstring;
begin
    i := 1;
    j := 1;
    k := 0;
    repeat
        k := i;
        while s[i] = blank do
            i := i + 1;
        if i > k then
        begin
            nch := 0;
            if i < (k+3) then
                nch := i - k
            else if tabrpt > 0 then
            begin
                while i > k do
                begin
                    nch := nch + 1;
                    if (k mod tabrpt) = 0 then
                    begin
                        t[j] := tab;
                        j := j + 1;
                        nch := 0
                    end;
                    k := k + 1
                end
            end
            else
            begin
                while i > k do
                begin
                    nch := nch + 1;
                    if k <= maxcol then
                    begin
                        tc := k;
                        if tabcols[tc] = tabset then
                        begin
                            t[j] := tab;
                            j := j + 1;
                            nch := 0
                        end
                    end;
                    k := k + 1
                end
            end;
            while nch > 0 do
            begin
                t[j] := blank;
                j := j + 1;
                nch := nch - 1
            end
        end;
        while (s[i] <> blank) and (s[i] <> endstr) do
        begin
            t[j] := s[i];
            i := i + 1;
            j := j + 1
        end
    until s[i] = endstr;
    t[j] := endstr;
    scopy(t, 1, s, 1)
end;  {compress}
 
 
{ ****************************************************** cledbuf **** }
{ *                                                                 * }
{ *             CURLEW :: Edit Buffer Management Routines           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ checkpoint -- checkpoint buffer for subsequent undo command }
procedure checkpoint;
var
    j : integer;
    ns : chstring;
begin
    if jfout <> ioerror then
        secure(jfout);
    if cpneeded then                    { only copy array if changed }
    begin
        for j := 0 to lastln do
            cptext[j] := buftext[j];
        cpneeded := false;
        journal(0, 0, letk, ns)
    end;
    cplstln := lastln;
    cpcurln := curln;
    if appstate = coned then
    begin
        cptopln := curln;
        cpfsrow := toprow;
        cpfscol := 0
    end
    else
    begin
        cptopln := topln;
        cpfsrow := fsrow;
        cpfscol := fscol
    end;
    cpchanged := changed;
    ns[1] := endstr
end;  {checkpoint}
 
 
{ setbuf -- create scratch file and set up line zero }
procedure setbuf;
var
    edittemp : chstring;
    junk : boolean;
begin
    getinf(clbuffer, edittemp, maxstr);
    scrout := create(edittemp, iowrite);
    scrin := openf(edittemp, ioread);
    if (scrout = ioerror) or (scrin = ioerror) then
    begin
        erasedisplay;  soundalarm;
        setcursor(maxrow-4, 2);
        literal('*** Edit buffer initiali');
        literal('sation failed :: abandon');
        literal('ing session !!&         ');
        stopssmp;  errorexit
    end;
 
    bufferok := true;
    junk := getindex(recout, scrout);
    curln := 0;
    lastln := 0;
    changed := false;  cpneeded := true;
 
    crecdlen := false;  cfilelen := false;
    getinf(clwidchk, edittemp, maxstr);
    widcheck := edittemp[1] = lety;
 
    buftext[0] := 0;
    checkpoint
end;  {setbuf}
 
 
{ getmark -- get mark from nth line }
function getmark (n : integer)
        : boolean;
begin
    getmark := (bufmark[n] = plus)
end;  {getmark}
 
 
{ putmark -- put mark m on nth line }
procedure putmark (n : integer;
                   m : boolean);
begin
    if m then bufmark[n] := plus
         else bufmark[n] := minus
end;  {putmark}
 
 
{ reverse -- reverse buffer lines n1..n2 }
procedure reverse (n1 : integer;
                   n2 : integer);
var
    temptext : fdpointer;
    tempmark : isochar;
begin
    while n1 < n2 do
    begin
        temptext := buftext[n1];     tempmark := bufmark[n1];
        buftext[n1] := buftext[n2];  bufmark[n1] := bufmark[n2];
        buftext[n2] := temptext;     bufmark[n2] := tempmark;
        n1 := n1 + 1;
        n2 := n2 - 1
    end
end;  {reverse}
 
 
{ blkmove -- move block of lines n1..n2 to after n3 }
procedure blkmove (n1 : integer;
                   n2 : integer;
                   n3 : integer);
begin
    if n3 < n1-1 then
    begin
        reverse(n3+1, n1-1);
        reverse(n1, n2);
        reverse(n3+1, n2)
    end
    else if n3 > n2 then
    begin
        reverse(n1, n2);
        reverse(n2+1, n3);
        reverse(n1, n3)
    end;
    changed := true;            { all changes call this routine }
    cpneeded := true            { ... and checkpoint is out of date }
end;  {blkmove}
 
 
{ puttxt -- put text from lin after curln }
function puttxt (var lin : chstring)
        : stcode;
var
    junk : boolean;
begin
    puttxt := err;
    if lastln >= maxlines then
        cfilelen := true
    else
    begin
        if widcheck then
            if length(lin) > maxstr-2 then
        begin
            crecdlen := true;
            lin[maxstr-2] := newline;  lin[maxstr-1] := endstr
        end;
        lastln := lastln + 1;
        putstr(lin, scrout);
        putmark(lastln, false);
        buftext[lastln] := recout;
        junk := getindex(recout, scrout);
        blkmove(lastln, lastln, curln);
        journal(curln, 0, leta, lin);
        curln := curln + 1;
        puttxt := ok
    end
end;  {puttxt}
 
 
{ putfiletxt -- put file from fd after curln }
function putfiletxt (fd : filedesc;
                     var count : integer)
        : stcode;
var
    done, junk : boolean;
    start, j : integer;
begin
    putfiletxt := err;
    count := maxlines - lastln;
    if count > 0 then
    begin
        done := ffcopy(fd, scrout, count);
        if done then
        begin
            if count < 0 then           { check for truncated records }
            begin
                count := -count;
                if widcheck then
                    crecdlen := true
            end;
            start := lastln + 1;
            for j := 1 to count do
            begin
                lastln := lastln + 1;
                junk := getindex(recout, scrout);
                buftext[lastln] := recout;
                putmark(lastln, false)
            end;
            blkmove(start, lastln, curln);
            curln := curln + count;
            if lastln >= maxlines then
                cfilelen := true;
            junk := getindex(recout, scrout);   { for next "puttxt" }
            putfiletxt := ok
        end
        else
        begin
            bufferok := false;  soundalarm
        end
    end
end;  {putfiletxt}
 
 
{ gettxt -- get text from line n into s }
procedure gettxt (n : integer;
                  var s : chstring);
var
    junk : boolean;
begin
    if (n < 1) or (n > lastln) then
        s[1] := endstr
    else
    begin
        seek(buftext[n], scrin);
        junk := getline(s, scrin, maxstr);
        if detab then
            expand(s)                   { tabs -> space conversion }
    end
end;  {gettxt}
 
 
{ copytxt -- copy text line from buffer to file descriptor }
function copytxt (n : integer;
                  fd : filedesc)
        : stcode;
begin
    copytxt := err;
    if (n >= 1) and (n <= lastln) then
    begin
        if ixcopy(buftext[n], scrin, fd) then
            copytxt := ok
    end
end;  {copytxt}
 
 
{ reptxt -- replace text from lin at lnum }
function reptxt (var lin : chstring;
                 lnum : integer)
        : stcode;
var
    csave : integer;
    jsave : filedesc;
    status : stcode;
begin
    curln := lastln;
    jsave := jfout;  jfout := ioerror;  { inhibit journal write }
    status := puttxt(lin);
    jfout := jsave;                     { re-enable journal }
    curln := min(lnum, lastln);
    if status = ok then
    begin
        buftext[curln] := buftext[lastln];
        putmark(curln, false);
        lastln := lastln - 1;
        journal(curln, 0, letc, lin)
    end;
    reptxt := status
end;  {reptxt}
 
 
{ restore -- restore file from checkpoint }
procedure restore;
var
    j, k, ti : integer;
    tp : fdpointer;
    tr : rowtype;
    tc : coltype;
begin
    k := min(lastln, cplstln);
    for j := 0 to k do
    begin
        tp := cptext[j];
        cptext[j] := buftext[j];
        buftext[j] := tp
    end;
 
    if k < lastln then
    begin
        for j := k+1 to lastln do
            cptext[j] := buftext[j]
    end
    else if k < cplstln then
    begin
        for j := k+1 to cplstln do
            buftext[j] := cptext[j]
    end;
 
    ti := cplstln;  cplstln := lastln;  lastln := ti;
    ti := cpcurln;  cpcurln := curln;   curln := ti;
    if appstate = coned then
    begin
        topln := curln;
        fsrow := toprow;
        fscol := 0
    end;
    ti := cptopln;  cptopln := topln;   topln := ti;
    tr := cpfsrow;  cpfsrow := fsrow;   fsrow := tr;
    tc := cpfscol;  cpfscol := fscol;   fscol := tc;
 
    if cpchanged then
        changed := true;    { may not have, but make the user think }
    cpneeded := true        { safety }
end;  {restore}
 
 
{ edbufok -- returns an integrity verdict on the edit buffer }
function edbufok
        : boolean;
var
    rc : integer;
begin
    if bufferok then
    begin
        getfds(rc, scrout);
        bufferok := (rc = 0);
        if bufferok then
        begin
            getfds(rc, scrin);
            bufferok := (rc = 0)
        end
    end;
    if not bufferok then
        soundalarm;             { make them look }
    edbufok := bufferok
end;  {edbufok}
 
 
{ clrbuf -- dispose of scratch file }
procedure clrbuf;
var
    edittemp : chstring;
    junk : boolean;
begin
    closef(scrin);
    closef(scrout);
    getinf(clbuffer, edittemp, maxstr);
    junk := remove(edittemp)
end;  {clrbuf}
 
 
{ ****************************************************** cllpar ***** }
{ *                                                                 * }
{ *            CURLEW :: Line number parameter routines             * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ nextln -- get line after n }
function nextln (n : integer)
        : integer;
begin
    if n >= lastln
        then nextln := 0
        else nextln := n + 1
end;  {nextln}
 
 
{ prevln -- get line before n }
function prevln (n : integer)
        : integer;
begin
    if n <= 0
        then prevln := lastln
        else prevln := n - 1
end;  {prevln}
 
 
{ optpat -- get optional pattern from lin[i] and increment i }
function optpat (var lin : chstring;
                 var i : integer)
        : stcode;
begin
    if lin[i] = endstr then
        i := 0
    else if lin[i+1] = endstr then
        i := 0
    else if lin[i+1] = lin[i] then   { repeated delimiter }
        i := i + 1                   { leave existing pattern alone }
    else
        i := makepat(lin, i+1, lin[i], pat);
    if pat[1] = endstr then
        i := 0;
    if i = 0 then
    begin
        pat[1] := endstr;
        optpat := err
    end
    else
        optpat := ok
end;  {optpat}
 
 
{ patscan -- find next occurence of pattern after line n }
function patscan (way : isochar;
                  var n : integer)
        : stcode;
var
    done : boolean;
    pn : integer;
    line : chstring;
begin
    n := curln;
    patscan := err;
    done := false;
    repeat
        pn := n;
        if way = scan then
        begin                           { forwards }
            n := nextln(n);
            done := (not loopsearch) and (pn > n)
        end
        else
        begin                           { backwards }
            n := prevln(n);
            done := (not loopsearch) and (pn < n)
        end;
 
        if done then
            n := curln                  { search loop failed }
        else
        begin                           { check new line's text }
            gettxt(n, line);
            if match(line, pat) then
            begin
                patscan := ok;
                done := true
            end
        end
    until (n = curln) or done
end;  {patscan}
 
 
{ getnum -- get a single line number component }
function getnum (var lin : chstring;
                 var i : integer;
                 var num : integer;
                 var status : stcode)
        : stcode;
begin
    status := ok;
    skipbl(lin, i);
    if isdigit(lin[i]) then
    begin
        num := ctoi(lin, i);
        i := i - 1          { move back, to be advanced at end }
    end
    else if lin[i] = curline then
        num := curln
    else if lin[i] = lastline then
        num := lastln
    else if lin[i] = topline then
    begin
        topused := true;
        num := itopln;  topln := itopln
    end
    else if (lin[i] = scan) or (lin[i] = backscan) then
    begin
        if optpat(lin, i) = err then
            status := err
        else
        begin
            status := patscan(lin[i], num);
            if status = err then
                errcode := search
        end
    end
    else
        status := enddata;
    if status = ok then
        i := i + 1;         { next character to be examined }
    getnum := status
end;  {getnum}
 
 
{ getone -- get one line number expression }
function getone (var lin : chstring;
                 var i : integer;
                 var num : integer;
                 var status : stcode)
        : stcode;
var
    istart, mul, pnum : integer;
    junk : stcode;
begin
    istart := i;
    num := 0;
    topused := false;
    skipbl(lin, i);
    if (lin[i] = plus) or (lin[i] = minus) then
    begin
        num := curln;  status := ok
    end
    else
        junk := getnum(lin, i, num, status);    { 1st term }
    while status = ok do
    begin
        skipbl(lin, i);
        if (lin[i] <> plus) and (lin[i] <> minus) then
            status := enddata
        else
        begin
            if lin[i] = plus
                then mul := +1
                else mul := -1;
            i := i + 1;
            if getnum(lin, i, pnum, status) = enddata then
            begin
                pnum := 1;  status := ok
            end;
            if status = ok then
                num := num + mul * pnum;
        end;
    end;
    if topused then
    begin                           { constrain line number }
        num := max(num, 1);
        num := min(num, lastln)
    end;
    if (num < 0 ) or (num > lastln) then
    begin
        status := err;
        errcode := lrange
    end;
    if status <> err then
    begin
        if i <= istart
            then status := enddata
            else status := ok
    end;
    getone := status
end;  {getone}
 
 
{ getlist -- get list of line nums at lin[i] and increment i }
function getlist (var lin : chstring;
                  var i : integer;
                  var status : stcode)
        : stcode;
var
    num : integer;
    done : boolean;
begin
    line2 := 0;
    nlines := 0;
    if appstate = coned then
        itopln := curln
    else
        itopln := topln;
    done := (getone(lin, i, num, status) <> ok);
    while not done do
    begin
        line1 := line2;
        line2 := num;
        nlines := nlines + 1;
        if lin[i] = semicol then
        begin
            curln := num;  itopln := curln;  fsrow := toprow
        end;
        if (lin[i] = comma) or (lin[i] = semicol) then
        begin
            i := i + 1;
            done := (getone(lin, i, num, status) <> ok)
        end
        else
            done := true
    end;
    nlines := min(nlines, 2);
    if nlines = 0 then line2 := curln;
    if nlines <= 1 then line1 := line2;
    if status <> err then status := ok;
    getlist := status
end;  {getlist}
 
 
{ default -- set defaulted line numbers }
function default (def1 : integer;
                  def2 : integer;
                  var status : stcode)
        : stcode;
begin
    if nlines = 0 then
    begin
        line1 := def1;  line2 := def2
    end;
    if (line1 > line2) or (line1 <= 0) then
        status := err
    else
        status := ok;
    default := status
end;  {default}
 
 
{ ****************************************************** cldelete *** }
{ *                                                                 * }
{ *    CURLEW :: line deletion, called also for line replacement    * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ lndelete -- delete lines n1 through n2 }
function lndelete (n1 : integer;
                   n2 : integer;
                   var status : stcode)
        : stcode;
var
    ns : chstring;
begin
    if n1 <= 0 then
        status := err
    else
    begin
        blkmove(n1, n2, lastln);
        lastln := lastln - (n2 - n1 + 1);
        curln := prevln(n1);
        ns[1] := endstr;
        journal(n1, n2, letd, ns);
        status := ok
    end;
    lndelete := status
end;  {lndelete}
 
 
{ ****************************************************** clceirtn *** }
{ *                                                                 * }
{ *         CURLEW :: Context editor screen image routines          * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ edname -- put up the editor name }
procedure edname;
begin
    setcursor(0, 0);
    if rrend <> defrend then
        setmode(selectgr, rrend);
    literal(' Curlew &               ');
    if rrend <> defrend then
        setmode(selectgr, defrend);
    textchar(colon)
end;  {edname}
 
 
{ edprompt -- put up the editor command prompt }
procedure edprompt;
var
    ckcol : coltype;
begin
    setcursor(cmdrow, 0);
    case cstate of
 
    concmd, conapp:
        begin
            ckcol := 2;
            if cstate = concmd then
            begin
                if appstate = fsecmd then
                begin
                    literal('Enter command &         ');
                    ckcol := 16
                end;
                textchar(cmdprompt)
            end
            else
                textchar(txtprompt);
            textchar(blank)
        end;
 
    conecmd, conqcmd:
        begin
            literal('Discard changes?  (y/n):');
            textchar(blank);
            ckcol := 25
        end;
 
    paused:
        begin
            setmode(selectgr, rrend);
            literal(' More output?  (y/n): & ');
            setmode(selectgr, defrend);
            textchar(blank);
            ckcol := 23
        end;
 
    end;  {case}
 
    erasetoright;
    if cmdcol <> ckcol then
    begin
        cmdcol := ckcol;
        setupdate(cmdrow, cmdrow, cmdcol, maxcol)
    end;
    if appstate <> fsereq then
        putmode(ctxtmode)               { may set/reset char insertion }
end;  {edprompt}
 
 
{ ctxtimage -- set up screen image for context operation }
procedure ctxtimage;
var
    c : coltype;
begin
    appstate := coned;
    putmode(ctxtmode);
    setcursor(0, 0);
    erasetoright;
    edname;
    literal(' Full-screen text editor');
    setcursor(1, 0);
    for c := 0 to maxcol do
        textchar(minus);
    edprompt
end;  {ctxtimage}
 
 
{ ****************************************************** clfsirtn *** }
{ *                                                                 * }
{ *       CURLEW :: Full-screen image and line cache routines       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ header -- put header line on screen }
procedure header;
var
    s : chstring;
    ln : rowtext;
begin
    if vtitle[1] <> newline then
        scopy(vtitle, 1, s, 1)
    else if savefile[1] = endstr then
        setstring(s, '-- no filename --&      ')
    else
        scopy(savefile, 1, s, 1);
    ln := blankrow;
    slcopy(s, 1, ln, 0, maxcol-25);
    putrow(0, ln)
end;  {header}
 
 
{ vbmreset -- reset visual block mark if on-screen }
procedure vbmreset;
var
    ln : rowtext;
    bline : integer;
    rr : rowtype;
begin
    if vbmark then
    begin
        bline := blktopln + blkrow - topln;
        if (bline >= toprow) and (bline <= botrow) then
        begin
            rr := bline;  getrow(rr, ln);  putrow(rr, ln);
            setcursor(fsrow, fscol)
        end;
        vbmark := false
    end
end;  {vbmreset}
 
 
{ markblock -- show position of block mark }
procedure markblock;
const
    mkenable = false;
var
    tb : boolean;
    by, bx, bxx : integer;
    ln : rowtext;
    rr : rowtype;
    cc : coltype;
    cmode : modearray;
begin
    tb := mkenable;
    if rrend = negative then            { not worth it otherwise }
        if tb then                      { locked-out by mkenable }
    begin
        by := blktopln + blkrow - topln;
        bx := blkoset - xoset + blkcol;
        if (by >= toprow) and (by <= botrow) then
        begin
            getrow(by, ln);  getloc(rr, cc);  getmode(cmode);
            if cmode[selectgr] <> negative then
                setmode(selectgr, rrend);
            if bx > 0 then
            begin                           { leading mark }
                bxx := min(bx-1, maxcol);
                setcursor(by, bxx);  textchar(ln[bxx])
            end;
            if bx < maxcol then
            begin                           { trailing mark }
                bxx := max(bx+1, 0);
                setcursor(by, bxx);  textchar(ln[bxx])
            end;
            if cmode[selectgr] <> negative then
                setmode(selectgr, defrend);
            setcursor(rr, cc);  vbmark := true
        end
    end
end;  {markblock}
 
 
{ viewstate -- set f/s operating state and reflect in header }
procedure viewstate (nstate : fstype);
begin
    fstate := nstate;
    setcursor(0, maxcol-20);
    erasetoright;
    if fstate = normal then
        putmode(nfsomode)
    else
    begin
        setmode(selectgr, rrend);
        markblock;
        literal(' block: &               ');
        setmode(selectgr, defrend);
        textchar(blank);
        outdec(blktopln+blkrow-toprow);
        literal(' at &                   ');
        outdec(blkcol+1+blkoset);
        putmode(blokmode)
    end
end;  {viewstate}
 
 
{ ruler -- put ruler line on screen }
procedure ruler (rr : rowtype);
var
    s : chstring;
    ln : rowtext;
    cc : coltype;
    j, k, lclxoset, roset, nd : integer;
begin
    setstring(s, '====.====|====.====|&   ');
    lclxoset := xoset;
    if rr > (maxrow div 2) then
        lclxoset := 0;
    roset := (lclxoset mod 10) + 1;
    s[roset+10] := endstr;
    j := 0;
    k := maxcol + 1;
    ln := blankrow;
    while k > 0 do
    begin                               { build ruler pattern }
        slcopy(s, roset, ln, j, k);
        j := j + 10;  k := k - 10
    end;
    if lclxoset > 0 then
    begin                               { calibrate first ruler bar }
        cc := 0;
        while ln[cc] <> bar do
            cc := cc + 1;
        j := lclxoset + cc + 1;
        s[1] := blank;
        nd := itoc(j, s, 2);
        s[nd] := blank;  s[nd+1] := endstr;
        slcopy(s, 1, ln, cc+1, 10)
    end;
    setmode(selectgr, rrend);
    putrow(rr, ln);
    setmode(selectgr, defrend)
end;  {ruler}
 
 
{ filetext -- put file text on screen for row rr }
procedure filetext (rr : rowtype);
var
    s : chstring;
    ln, oldln : rowtext;
    j, k, mc, c : integer;
    sdiffers, remblank : boolean;
begin
    ln := blankrow;
    j := topln + rr - 2;
    if j <= lastln then
    begin
        gettxt(j, s);
        i := 1;
        while (s[i] <> newline) and (i <= xoset) do
            i := i + 1;
        slcopy(s, i, ln, 0, maxcol+1)
    end;
    getrow(rr, oldln);
    sdiffers := false;
    j := 0;
    mc := maxcol;
    while (j <= mc) and (not sdiffers) do
    begin
        if ln[j] <> oldln[j] then
            sdiffers := true
        else
            j := j + 1
    end;
    if sdiffers then
    begin
        k := j;
        remblank := true;
        while (k <= mc) and remblank do
        begin
            if ln[k] <> blank then
                remblank := false;
            k := k + 1
        end;
        if remblank then
        begin
            setcursor(rr, j);
            erasetoright
        end
        else if j < (mc div 4) then
            putrow(rr, ln)
        else
        begin
            k := mc;
            while (k > j) and (ln[k] = blank) do
                k := k - 1;
            setcursor(rr, j);
            erasetoright;
            for c := j to k do
                textchar(ln[c])
        end
    end
end;  {filetext}
 
 
{ replace -- if changed, replace active line in file buffer }
procedure replace;
var
    stat : stcode;
begin
    if fschanged then
    begin
        stat := reptxt(fstext, fsline);
        fschanged := false
    end;
    fsline := 0                         { mark cache line invalid }
end;  {replace}
 
 
{ fileimage -- conditionally correct the file image }
procedure fileimage;
var
    r : rowtype;
begin
    replace;                            { safety }
    for r := toprow to botrow do
        filetext(r);
    if fstate = blkmode then
        markblock                       { in case it's been overwritten }
end;  {fileimage}
 
 
{ fetch -- get line and text for row at r }
procedure fetch (r : rowtype);
var
    line, j : integer;
    stat : stcode;
    bs : chstring;
begin
    line := topln + r - toprow;
    if line <> fsline then
    begin
        replace;                        { if changed, replace text }
        if line > lastln then
        begin
            bs[1] := newline;  bs[2] := endstr;
            curln := lastln;
            for j := lastln+1 to line do
                stat := puttxt(bs);
        end;
        gettxt(line, fstext);           { text of active line }
        fsline := line                  { ... and buffer line number }
    end
end;  {fetch}
 
 
{ ****************************************************** clinform *** }
{ *                                                                 * }
{ *             CURLEW :: I/O Status Information Routines           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ inform -- display literal, conditionally transfer token }
procedure inform (tag : textlit);
begin
    setcursor(maxrow, maxcol - 15);
    setmode(selectgr, rrend);
    textchar(blank);
    literal(tag);
    textchar(blank);
    setcursor(maxrow, 0);
    sendtoken(1)                        { restricted token transfer }
end;  {inform}
 
 
{ reclaim -- reclaim token after information message }
function reclaim
        : integer;
var
    pc : isochar;
    pars : primpar;
begin
    repeat
        getprimitive(pc, pars)          { fetch next primitive }
    until
        pc = capa;                      { got the token back }
    if pars[1] > 128 then
    begin                               { restart; fix-up required }
        if appstate = coned then
            edname
        else
        if rrend <> defrend then
        begin
            ruler(toprow-1);
            ruler(botrow+1)
        end
    end;
    setcursor(maxrow, maxcol - 15);
    setmode(selectgr, defrend);
    erasetoright;
    reclaim := pars[1]
end;  {reclaim}
 
 
{ ****************************************************** clconbuf *** }
{ *                                                                 * }
{ *             CURLEW :: Conversation buffer routines              * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ flushcb -- flush conversation buffer to screen }
procedure flushcb;
var
    cl, nd, md : integer;
    lcol : coltype;
    lrow : rowtype;
begin
    md := cmdrow - toprow;          { maximum rows available }
    nd := cnext - cfirst;           { potential number to display }
    if (not pausing) and (nd > (md div 2)) then
    begin
        cfirst := cnext - 2;
        cbidx := cfirst mod cbrows;
        for lcol := 0 to maxcol do
            cbuf[cbidx][lcol] := period;
        nd := 2
    end;
    if nd > md then                 { too many }
    begin
        nd := md;
        cfirst := cnext - md
    end;
    if nd < md then                 { less than display, keep overlap }
        scrollup(toprow, cmdrow-1, nd);
    lrow := cmdrow - nd;            { first new row }
    cl := cfirst;                   { first buffer text row index }
    while cl <> cnext do
    begin
        cbidx := cl mod cbrows;
        putrow(lrow, cbuf[cbidx]);
        cl := cl + 1;
        lrow := lrow + 1
    end;
end;  {flushcb}
 
 
{ lastcb -- flush last line of conversation buffer to screen }
procedure lastcb;
var
    ln : rowtext;
    j : integer;
begin
    cbidx := (cnext - 1) mod cbrows;
    ln := cbuf[cbidx];
    if (ln[0] = blank) and (ln[1] = blank) then
    begin
        ln[0] := lbrack;
        j := maxcol - 2;
        while ln[j] = blank do
            j := j - 1;
        ln[j+2] := rbrack
    end;
    putrow(maxrow, ln)
end;  {lastcb}
 
 
{ showposn -- returns column of next character to be written }
function showposn : coltype;
begin
    showposn := ccol
end;  {showposn}
 
 
{ showcmd -- log command line to conversation buffer }
procedure showcmd (ln : rowtext);
begin
    cbuf[0] := ln;
    cfirst := 0;
    cnext := 1;
    cbidx := cnext;
    ccol := 0;
    cindent := 0;
    cblfull := false;
    pausing := true;
    cpause := maxrow - 4
end;  {showcmd}
 
 
{ querymore -- ask user whether further verification is required }
procedure querymore;
var
    ln : rowtext;
    c : isochar;
    tcode : integer;
begin
    cstate := paused;
    repeat
        edprompt;
        sendtoken(0);
        tcode := reclaim;
        getrow(cmdrow, ln);
        c := lowercase(ln[cmdcol])
    until (tcode = ctlm) and ((c = blank) or (c = lety) or (c = letn));
    cstate := concmd;
 
    if c = letn then
        pausing := false;
    setcursor(cmdrow, 0);
    erasetoright
end;  {querymore}
 
 
{ shownl -- handle newline action in conversation buffer }
procedure shownl;
var
    cc : coltype;
    ln : rowtext;
begin
    if ccol < maxcol then
        for cc := ccol to maxcol do
            cbuf[cbidx][cc] := blank;
    if pausing and (cnext >= cpause) then
    begin
        ln := cbuf[cbidx];
        flushcb;
        querymore;
        cbuf[0] := ln;
        cnext := 0
    end;
    cnext := cnext + 1;
    cbidx := cnext mod cbrows;
    if cindent > 0 then
        for cc := 0 to cindent-1 do cbuf[cbidx][cc] := blank;
    ccol := cindent
end;  {shownl}
 
 
{ showc -- display character via conversation buffer }
procedure showc (c : isochar);
begin
    if c = newline then
    begin
        if cblfull then
            cblfull := false
        else
            cbuf[cbidx][ccol] := blank;
        cindent := 0;
        shownl
    end
    else
    begin
        if cblfull then
        begin
            shownl;
            cblfull := false
        end;
        cbuf[cbidx][ccol] := c;
        if ccol = maxcol then
            cblfull := true
        else
            ccol := ccol + 1
    end
end;  {showc}
 
 
{ showstr -- display string via conversation buffer }
procedure showstr (var s : chstring);
var
    j : integer;
begin
    j := 1;
    while s[j] <> endstr do
    begin
        showc(s[j]);
        j := j + 1
    end
end;  {showstr}
 
 
{ showlit -- display literal text via conversation buffer }
procedure showlit (l : textlit);
var
    s : chstring;
begin
    setstring(s, l);
    showstr(s)
end;  {showlit}
 
 
{ showdec -- show integer n r-j in field width w, ts trailing spaces }
procedure showdec (n : integer;
                   w : integer;
                   ts : integer);
var
    i, nd : integer;
    s : chstring;
begin
    nd := itoc(n, s, 1);
    for i := nd to w do showc(blank);
    for i := 1 to nd-1 do showc(s[i]);
    if ts < 0 then
        showc(newline)
    else
        for i := 1 to ts do showc(blank)
end;  {showdec}
 
 
{ ****************************************************** clgfnrtn *** }
{ *                                                                 * }
{ *       CURLEW :: Get filename and file status verification       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ getfn -- get filename from lin[i] }
function getfn (var lin : chstring;
                var i : integer;
                var fil : chstring)
        : stcode;
var
    k : integer;
    stat : stcode;
begin
    stat := err;
    fil[1] := endstr;
    if lin[i+1] = blank then
    begin
        k := getword(lin, i+2, fil);    { get new filename }
        if k > 0 then
            if lin[k] = newline then
                stat := ok
    end
    else if (lin[i+1] = newline) and (savefile[1] <> endstr) then
    begin
        scopy(savefile, 1, fil, 1);
        stat := ok
    end;
    if (stat = ok) and (savefile[1] = endstr) then
    begin
        scopy(fil, 1, savefile, 1);     { save if no old one }
        if appstate = fsereq then
        begin
            header;
            viewstate(fstate)
        end
    end;
    getfn := stat
end;  {getfn}
 
 
{ linestat -- show buffer current and last line numbers }
procedure linestat;
begin
    showlit('  Line &                ');
    showdec(topln+fsrow-toprow, 1, 0);
    showlit(' at &                   ');
    showdec(fscol+xoset+1, 1, 0);
    if xoset > 0 then
    begin
        showc(blank);
        showc(lparen);  showdec(fscol+1, 1, 0);  showc(rparen)
    end;
    if lastln < 1 then
        showlit(', buffer empty&         ')
    else
    begin
        showlit(', last line is &        ');
        showdec(lastln, 1, 0);
        if not edbufok then
            showlit(', edit buffer damaged!& ')
        else if cfilelen or crecdlen then
            showlit(', "write" disabled...&  ')
        else if changed then
            showlit('  (buffer changed)&     ')
    end;
    showc(newline)
end;  {linestat}
 
 
{ filestat -- verification of file and buffer status }
procedure filestat;
begin
    if appstate = fsereq then
    begin
        header;
        viewstate(fstate);
        linestat
    end
    else
    begin
        if savefile[1] = endstr then
            showlit('  No saved filename&    ')
        else
            showlit('  Saved filename     :  ');
        showstr(savefile);
        showc(newline);
        showlit('  Lines in buffer    :  ');
        showdec(lastln, 1, 4);
        if changed then
            showlit('(buffer changed)  &     ');
        showc(newline);
        if cfilelen or crecdlen then
        begin
            showlit('  *** "write" disabled t');
            showlit('o avoid loss of data fro');
            showlit('m oversize file@n&      ')
        end;
        if not edbufok then
        begin
            showlit('  *** "write" disabled b');
            showlit('ecause edit buffer integ');
            showlit('rity checks failed@n&   ')
        end
    end;
end;  {filestat}
 
 
{ ****************************************************** clacicmd *** }
{ *                                                                 * }
{ *      CURLEW :: "a" (append), "c" (change) and "i" (insert)      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ appcpar -- append command parameter text after line }
function appcpar (line : integer;
                 cmd : chstring;
                 i : integer;
                 glob : boolean)
        : stcode;
var
    delim : isochar;
    stat : stcode;
    inline : chstring;
    j, lct : integer;
    tc : isochar;
    irow : rowtype;
begin
    stat := err;
    lct := 0;
    curln := line;
    j := i + 1;
    skipbl(cmd, i);
    delim := cmd[i];
    if isalphanum(delim) then
    begin                               { no delimiter, add remainder }
        scopy(cmd, j, inline, 1);
        stat := puttxt(inline);
        if stat <> err then
            lct := 1
    end
    else
    begin                               { delimiter, process lines(s) }
        repeat
            i := i + 1;
            j := 1;
            tc := cmd[i];
            while (tc <> delim)
                and (tc <> newline) and (tc <> endstr) do
            begin
                inline[j] := tc;
                j := j + 1;
                i := i + 1;
                tc := cmd[i]
            end;
            inline[j] := newline;
            inline[j+1] := endstr;
            stat := puttxt(inline);
            if stat <> err then
                lct := lct + 1
        until (stat = err)
            or (cmd[i+1] = newline) or (cmd[i+1] = endstr)
    end;
 
    if not glob then
    begin
        showlit('  Text lines added :  & ');
        showdec(lct, 1, 0);
        showc(newline)
    end;
 
    if appstate = fsereq then
        if (line >= topln) and (line < (topln+botrow-toprow)) then
    begin
        irow := toprow + 1 + (line - topln);
        if lct < (botrow-irow) then
            scrolldown(irow, botrow, lct)
    end;
    appcpar := stat
end;  {appcpar}
 
 
{ doappend -- append lines after line }
function doappend (line : integer;
                   cmd : chstring;
                   i : integer;
                   glob : boolean)
        : stcode;
var
    tcol : coltype;
begin
    if (not glob) and (not rebuild) then
        checkpoint;
    if cmd[i] <> newline then           { one-shot command }
        doappend := appcpar(line, cmd, i, glob)
    else if glob then                   { too late for global }
        doappend := err
    else                                { prompt for text }
    begin
        curln := line;
        cstate := conapp;
        if not rebuild then
        begin                           { talking to the user }
            setcursor(0, maxcol-35);
            setmode(selectgr, rrend);
            literal(' Enter text; "." to end ');
            literal('insertion. &            ');
            setmode(selectgr, defrend);
            erasetabs;
            for tcol := 0 to maxcol-2 do
                if tabcols[tcol] = tabset then
                    settab(tcol+2);
        end;
        doappend := ok
    end;
end;  {doappend}
 
 
{ newtext -- insert line of input into buffer (from a/c/i) }
function newtext (inline : chstring)
        : stcode;
var
    stat : stcode;
    tc : coltype;
begin
    if (inline[1] = period) and (inline[2] = newline) then
        stat := enddata
    else
        stat := puttxt(inline);
    if stat <> ok then
    begin
        cstate := concmd;
        setcursor(0, maxcol-35);
        erasetoright;
 
        erasetabs;
        for tc := 0 to maxcol do
            if tabcols[tc] = tabset then
                settab(tc);
 
        if stat <> err then
            stat := ok
    end;
    newtext := stat
end;  {newtext}
 
 
{ ****************************************************** cldcmd ***** }
{ *                                                                 * }
{ *                     CURLEW :: "d" (delete)                      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ dodelete -- delete lines n1..n2 }
function dodelete (n1 : integer;
                   n2 : integer;
                   glob : boolean)
        : stcode;
var
    stat : stcode;
    oldlastln, lct : integer;
    drow : rowtype;
begin
    if (not glob) and (not rebuild) then
        checkpoint;
    oldlastln := lastln;
    if lndelete(n1, n2, stat) = ok then
        if nextln(curln) <> 0 then
            curln := nextln(curln);
    lct := oldlastln - lastln;
 
    if not glob then
    begin
        showlit('  Text lines deleted :  ');
        showdec(lct, 1, -1)
    end;
 
    if appstate = fsereq then
    begin
        if curln < topln then
        begin
            topln := max(curln, 1);
            fsrow := toprow
        end
        else
        if (n1 >= topln) and (n1 < (topln+botrow-toprow)) then
        begin
            drow := toprow + (n1 - topln);
            if lct < (botrow-drow) then
                scrollup(drow, botrow, lct)
        end
    end;
    dodelete := stat
end;  {dodelete}
 
 
{ ****************************************************** clplcmd **** }
{ *                                                                 * }
{ *              CURLEW :: "p" (print) and "l" (list)               * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ doprint -- print lines n1..n2 }
function doprint (n1 : integer;
                  n2 : integer;
                  lflag : boolean)
        : stcode;
var
    i : integer;
    line : chstring;
begin
    if n1 <= 0 then
        doprint := err
    else
    begin
        for i := n1 to n2 do
        begin
            if lflag then
            begin
                showdec(i, 6, 2);
                cindent := 8
            end;
            gettxt(i, line);
            showstr(line)
        end;
        curln := n2;
        doprint := ok
    end
end;  {doprint}
 
 
{ ****************************************************** clrcmd ***** }
{ *                                                                 * }
{ *                      CURLEW :: "r" (read)                       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ doread -- read "fil" after line n }
function doread (n : integer;
                 var fil : chstring;
                 glob : boolean;
                 rjfd : filedesc)
        : stcode;
var
    count : integer;
    t : boolean;
    stat : stcode;
    fd, jfd : filedesc;
    inline : chstring;
    rc, junk : integer;
    fastread : boolean;
begin
    if fil[1] = endstr then
    begin
        showlit('  *** No saved filename&');
        showc(newline);
        msgdone := true;
        stat := err
    end
    else
    begin
        fd := openf(fil, ioread);
        if fd = ioerror then
        begin
            showlit('  *** File does not exis');
            showlit('t or no read access :  &');
            showstr(fil);
            showc(newline);
            msgdone := true;
            stat := err
        end
        else
        begin
            inform('Reading file&           ');
            if not glob then
                checkpoint;
            curln := n;
            stat := ok;
            jfd := jfout;  jfout := rjfd;
            fastread := (jfout = ioerror);
            if fastread then
            begin                   { check that "ffcopy" available }
                getinf(ffcrtn, inline, maxstr);
                fastread := (inline[1] = lety)
            end;
            if fastread then        { fast file copy route }
                stat := putfiletxt(fd, count)
            else
            begin                   { record by record copy }
                count := 0;
                repeat
                    t := getline(inline, fd, maxstr);
                    if t then
                    begin
                        stat := puttxt(inline);
                        if stat <> err then
                            count := count + 1
                    end
                until (stat <> ok) or (not t);
            end;
            jfout := jfd;
            getfds(rc, fd);
            closef(fd);
            junk := reclaim;
            if (rc <= 0) and (stat = ok) then
                showlit('  Text lines read    :  ')
            else
            begin
                soundalarm;
                showlit('  *** Problems reading f');
                showlit('ile; stopped at record :');
                showc(blank);
                msgdone := true;
                autoview := false;      { if entry, no auto "v" }
                nbrcmdargs := 0;        { ...and no second parameter }
                stat := err
            end;
            showdec(count, 1, -1)
        end
    end;
    doread := stat
end;  {doread}
 
 
{ ****************************************************** clwexcmd *** }
{ *                                                                 * }
{ *              CURLEW :: "w" (write) and "ex" (exit)              * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ filebuild -- copy lines from buffer to target file }
function filebuild (n1 : integer;
                    n2 : integer;
                    fd : filedesc;
                    entab : boolean)
        : boolean;
var
    svdetab, direct : boolean;
    i, j, rc : integer;
    line : chstring;
    stat : stcode;
begin
    svdetab := detab;
    if entab then
        detab := true;          { must expand any tabs present }
    if detab then
        direct := false         { can't use ixcopy if tabs around }
    else
    begin
        getinf(ixcrtn, line, maxstr);
        direct := (line[1] = lety)
    end;
 
    if direct then
    begin
        j := n1;
        stat := ok;
        while (j <= n2) and (stat = ok) do
        begin
            stat := copytxt(j, fd);
            j := j + 1
        end;
        filebuild := (stat = ok)
    end
    else
    begin
        for i := n1 to n2 do
        begin
            gettxt(i, line);
            if entab then
                compress(line);     { spaces -> tab characters }
            putstr(line, fd)
        end;
        getfds(rc, fd);
        filebuild := (rc = 0)
    end;
    detab := svdetab;
    closef(fd)
end;  {filebuild}
 
 
{ safewrite -- save write information before emptying target file }
function safewrite (n1 : integer;
                    n2 : integer;
                    var sf : chstring)
        : boolean;
var
    sfile1, sfile2 : chstring;
    fd : filedesc;
    i : integer;
    safew, done : boolean;
begin
    safew := false;
    sf[1] := endstr;
    getinf(clsaveone, sfile1, maxstr);
    if sfile1[1] <> endstr then         { safety write needed? }
    begin
        fd := create(sfile1, iowrite);
        if fd <> ioerror then
        begin
            scopy(sfile1, 1, sf, 1);                { save the name }
            safew := filebuild(n1, n2, fd, false);  { write save file }
            if safew then
            begin
                { may need to rename this as a different filename }
                getinf(clsavetwo, sfile2, maxstr);
                if sfile2[1] <> endstr then
                begin
                    safew := renamf(sfile1, sfile2);    { rename it }
                    if safew then
                        scopy(sfile2, 1, sf, 1)     { correct the name }
                end
            end
        end
    end;
    safewrite := safew
end;  {safewrite}
 
 
{ dowrite -- write lines n1..n2 into file }
function dowrite (n1 : integer;
                  n2 : integer;
                  var fil : chstring)
        : stcode;
var
    i : integer;
    fd : filedesc;
    savefn, line : chstring;
    wholefile, filegone : boolean;
    swdone, tryrename, done : boolean;
    junk : integer;
begin
    if cfilelen or crecdlen then
    begin
        showlit('  *** "write" disabled t');
        showlit('o avoid loss of data fro');
        showlit('m oversize file@n&      ');
        msgdone := true;  dowrite := err
    end
    else if not edbufok then
    begin
        showlit('  *** "write" disabled b');
        showlit('ecause edit buffer integ');
        showlit('rity checks failed@n&   ');
        msgdone := true;  dowrite := err
    end
    else if fil[1] = endstr then
    begin
        showlit('  *** No saved filename&');
        showc(newline);
        msgdone := true;  dowrite := err
    end
    else
    begin
        wholefile := (n1 = 1) and (n2 = lastln);
        inform('Writing file&           ');
        swdone := safewrite(n1, n2, savefn);
        fd := create(fil, iowrite);
        if fd = ioerror then
        begin
            junk := reclaim;
            showlit('  *** Cannot create file');
            showlit(' or no write access :  &');
            showstr(fil);
            showc(newline);
            msgdone := true;
            dowrite := err
        end
        else
        begin
            tryrename := false;
            if swdone then
            begin
                getinf(clrensave, line, maxstr);
                tryrename := (line[1] = lety);
                if (not tryrename) and wholefile then
                begin                           { fix journal file }
                    jfcontrol(iowrite);
                    journal(0, 0, lete, savefn);
                    journal(0, 0, letf, savefile)
                end
            end;
 
            { may be able to just rename the save file as target .. }
            done := false;
            if tryrename then
            begin
                closef(fd);  fd := ioerror;      { can't rename if open }
                done := renamf(savefn, fil)
            end;
 
            { .. if that didn't work, have to try to build target }
            if done then
                savefn[1] := endstr             { no remove needed }
            else
            begin                               { do it the hard way }
                if fd = ioerror then
                    fd := create(fil, iowrite);
                done := filebuild(n1, n2, fd, entab)
            end;
 
            if done and wholefile then
            begin                               { final journal fix }
                jfcontrol(iowrite);
                journal(0, 0, lete, fil);
                journal(0, 0, letf, savefile)
            end;
            if savefn[1] <> endstr then
                filegone := remove(savefn);
            junk := reclaim;
            if done then
            begin
                showlit('  Text lines written :  ');
                showdec(n2-n1+1, 1, -1);
                if wholefile then
                    changed := false;
                dowrite := ok
            end
            else
            begin
                soundalarm;
                showlit('  *** Problems writing f');
                showlit('ile; check your disk spa');
                showlit('ce allocation@n&        ');
                msgdone := true;
                dowrite := err
            end;
            checkpoint
        end
    end
end;  {dowrite}
 
 
{ ****************************************************** clmcocmd *** }
{ *                                                                 * }
{ *              CURLEW :: "m" (move) and "co" (copy)               * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ move -- move line1..line2 after line3 }
function move (line3 : integer;
               glob : boolean)
        : stcode;
begin
    if (line1 <= 0) or ((line3 >= line1) and (line3 < line2)) then
        move := err
    else
    begin
        if not glob then
            checkpoint;
        blkmove(line1, line2, line3);
        if line3 > line1 then
            curln := line3
        else
            curln := line3 + (line2 - line1 + 1);
        if not glob then
        begin
            showlit('  Text lines moved :  & ');
            showdec(line2-line1+1, 1, -1)
        end;
        move := ok
    end
end;  {move}
 
 
{ copy -- copy line1..line2 after line3 }
function copy (line3 : integer;
               glob : boolean)
        : stcode;
var
    i, lsave : integer;
    line : chstring;
    stat : stcode;
begin
    if (line1 <= 0) or (lastln <= 0) then
        stat := err
    else
    begin
        if not glob then
            checkpoint;
        lsave := lastln;
        curln := lastln;
        for i := line1 to line2 do
        begin
            gettxt(i, line);
            stat := puttxt(line)
        end;
        if stat = ok then
        begin
            blkmove(lsave+1, lastln, line3);
            curln := line3 + (line2 - line1 + 1);
            if not glob then
            begin
                showlit('  Text lines copied :  &');
                showdec(line2-line1+1, 1, -1)
            end
        end;
    end;
    copy := stat
end;  {copy}
 
 
{ ****************************************************** clscmd ***** }
{ *                                                                 * }
{ *                    CURLEW :: "s" (substitute)                   * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ getrhs -- get right hand side of "s" command }
function getrhs (var lin : chstring;
                 var i : integer;
                 var sub : chstring;
                 var gflag : boolean)
        : stcode;
var
    ch : isochar;
begin
    getrhs := ok;
    if lin[i] = endstr then
        status := err
    else if lin[i+1] = endstr then
        status := err
    else
    begin
        i := makesub(lin, i+1, lin[i], sub);
        if i = 0 then
            getrhs := err
        else
        begin
            i := i + 1;  skipbl(lin, i);
            ch := lowercase(lin[i]);
            if ch = letg then
                gflag := true
            else
            begin
                i := i - 1;  gflag := false
            end
        end
    end
end;  {getrhs}
 
 
{ ckp -- check for "p", "l" or "n" after command }
function ckp (var lin : chstring;
              i : integer;
              var pflag : boolean;
              var lflag : boolean;
              var status : stcode)
        : stcode;
var
    ch : isochar;
begin
    skipbl(lin, i);
    ch := lowercase(lin[i]);
    pflag := (appstate <> fsereq);  { default off for full-screen }
    lflag := true;
    i := i + 1;
    if ch = letp then               { print text only }
    begin
        pflag := true;  lflag := false
    end
    else if ch = letn then          { don't print anything }
        pflag := false
    else if ch = letl then          { force printing, with lnum }
        pflag := true
    else
        i := i - 1;                 { none of these, backtrack }
 
    if lin[i] = newline then
        status := ok
    else
        status := err;
    ckp := status
end; {ckp}
 
 
{ catsub -- add replacement text to end of new }
procedure catsub (var lin : chstring;
                  var line : integer;
                  s1 : integer;
                  s2 : integer;
                  var sub : chstring;
                  var new : chstring;
                  var k : integer;
                  maxnew : integer);
var
    i, j : integer;
    junk : boolean;
begin
    i := 1;
    while sub[i] <> endstr do
    begin
        if sub[i] = mkditto then
            for j := s1 to s2 - 1 do
                junk := addstr(lin[j], new, k, maxnew)
        else
        begin
            junk := addstr(sub[i], new, k, maxnew);
            if sub[i] = newline then
            begin
                junk := addstr(endstr, new, k, maxnew);
                curln := line - 1;
                if puttxt(new) = ok then
                begin
                     k := 1;
                     line := line + 1;
                     line2 := line2 + 1
                end
                else
                     k := k - 1
            end
        end;
        i := i + 1
    end
end;  {catsub}
 
 
{ subst -- subsitute sub for occurences of pattern }
function subst (var sub : chstring;
                gflag : boolean;
                glob : boolean)
        : stcode;
var
    new, old : chstring;
    j, k, lastm, line, m, nsub : integer;
    stat : stcode;
    done, subbed, junk : boolean;
begin
    if glob then
        stat := ok
    else
    begin
        stat := err;
        checkpoint;
        nsub := 0;
    end;
    done := (line1 <= 0);
    line := line1;
    while (not done) and (line <= line2) do
    begin
        j := 1;
        subbed := false;
        gettxt(line, old);
        lastm := 0;
        k := 1;
        while old[k] <> endstr do
        begin
            if gflag or (not subbed) then
                m := amatch(old, k, pat, 1)
            else
                m := 0;
            if (m > 0) and (lastm <> m) then
            begin                       { replace matched text }
                subbed := true;
                catsub(old, line, k, m, sub, new, j, maxstr);
                lastm := m;
                if not glob then
                    nsub := nsub + 1
            end;
            if (m = 0) or (m = k) then
            begin                       { no match or null match }
                junk := addstr(old[k], new, j, maxstr);
                k := k + 1
            end
            else                        { skip matched text }
                k := m
        end;
        if subbed then
        begin
            if not addstr(endstr, new, j, maxstr) then
            begin
                stat := err;
                done := true
            end
            else
            begin
                stat := reptxt(new, line);
                line2 := line2 + curln - line;
                line := curln;
                if stat = err then
                    done := true
                else
                    stat := ok
            end;
        end;
        line := line + 1
    end;
    if not glob then
    begin
        if stat <> ok then
        begin
            showlit('  *** No substitution@n&');
            msgdone := true
        end
        else if appstate = fsereq then
        begin
            showlit('  Substitutions made :  ');
            showdec(nsub, 1, -1)
        end
    end;
    subst := stat
end;  {subst}
 
 
{ ****************************************************** clfocmd **** }
{ *                                                                 * }
{ *                    CURLEW :: "fo" (format)                      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ fmtdef -- set defaulted line numbers for format command }
function fmtdef (var status : stcode)
        : stcode;
var
    line, j : integer;
    lin : chstring;
begin
    if nlines = 0 then
    begin
        line := curln;
        gettxt(line, lin);
        j := 1;
        skipbl(lin, j);
        if (lin[j] <> newline) and (line > 1) then
        begin
            repeat
                line := line - 1;
                gettxt(line, lin);
                j := 1;
                skipbl(lin, j)
            until (lin[j] = newline) or (line <= 0);
            line := line + 1;
        end;
        line1 := line
    end;
    if nlines <= 1 then
    begin
        line := line1;
        repeat
            gettxt(line, lin);
            j := 1;
            skipbl(lin, j);
            if lin[j] <> newline then
                line := line + 1
        until (lin[j] = newline) or (line > lastln);
        line2 := line - 1
    end;
    if (line1 > line2) or (line1 <= 0) then
        status := err
    else
        status := ok;
    fmtdef := status
end;  {fmtdef}
 
 
{ dofmt -- simple word processing command }
function dofmt (line1 : integer;
                line2 : integer;
                var cmd : chstring;
                i : integer)
        : stcode;
type
    fmttype = (
        lj,                 { fill; left justify (ragged right margin) }
        jb,                 { fill; justify both margins }
        cen,                { centre text within margins }
        rj );               { quad right (ragged left margin) }
var
    { global parameters }
    reqfmt : fmttype;       { required formatting action; init=lj }
    osval : integer;        { offset of text output; >=0; init=0 }
    inval : integer;        { current indent; >= 0; init=0 }
    rmval : integer;        { right margin; init=70 }
    tival : integer;        { current temporary indent; init=0 }
    nptival : integer;      { tival for new paragraph; init=0 }
    hind : boolean;         { true -> hanging; init=false -> item }
 
    { output area }
    stat : stcode;          { status return }
    outp : integer;         { last char pos in outbuf; init=0 }
    outw : integer;         { width of text in outbuf; init=0 }
    outwds : integer;       { number of words in outbuf; init=0 }
    outbuf : chstring;      { lines to be filled collect here }
    dir : 0..1;             { direction for blank padding }
    eosbl : integer;        { loaded from eosextra at sentence end }
    eosextra : integer;     { extra blanks to add for sentence end }
    lct : integer;          { output line count }
    svcurln : integer;      { current line save }
    firstwd : boolean;      { true -> first word of item }
 
    { text input }
    line : integer;         { line being processed }
    inbuf : chstring;       { input line }
 
 
{ width -- compute width of character string }
function width (var buf : chstring)
        : integer;
var
    i, w : integer;
begin
    w := 0;
    i := 1;
    while buf[i] <> endstr do
    begin
        if buf[i] = backspace then
            w := w - 1
        else if buf[i] <> newline then
            w := w + 1;
        i := i + 1
    end;
    width := w
end;  {width}
 
 
{ put -- put out line with proper spacing and indenting }
procedure put (var buf : chstring);
var
    i, toffset : integer;
    ltext : chstring;
begin
    toffset := osval + inval + tival;
    tival := 0;
    for i := 1 to toffset do        { page offset + indenting }
        ltext[i] := blank;
    i := 1;
    while buf[i] <> newline do
    begin                           { convert hard blanks to blank }
        if buf[i] = del then
            buf[i] := blank;
        i := i + 1
    end;
    scopy(buf, 1, ltext, toffset+1);
    stat := puttxt(ltext);
    lct := lct + 1
end;  {put}
 
 
{ break -- end current filled line }
procedure break;
begin
    if outp > 0 then
    begin
        outbuf[outp] := newline;
        outbuf[outp+1] := endstr;
        put(outbuf)
    end;
    outp := 0;
    outw := 0;
    outwds := 0;
    eosbl := 0
end;  {break}
 
 
{ leadbl -- delete leading blanks }
procedure leadbl (var buf : chstring);
var
    i, j : integer;
begin
    i := 1;
    while buf[i] = blank do             { find first non-blank }
        i := i + 1;
    for j := i to length(buf) + 1 do
        buf[j-i+1] := buf[j];           { move line to left }
    if buf[1] = newline then
        break                           { blank line -> new paragraph }
end;  {leadbl}
 
 
{ spread -- spread words to justify right margin }
procedure spread (var buf : chstring;
                  outp : integer;
                  nextra : integer;
                  outwds : integer);
var
    i, j, nb, nholes : integer;
begin
    if (nextra > 0) and (outwds > 1) then
    begin
        dir := 1 - dir;                 { reverse previous direction }
        nholes := outwds - 1;
        i := outp - 1;
        j := min(maxstr-2, i+nextra);   { room for newline and endstr }
        while i < j do
        begin
            buf[j] := buf[i];
            if buf[i] = blank then
            begin
                if dir = 0
                    then nb := (nextra - 1) div nholes + 1
                    else nb := nextra div nholes;
                nextra := nextra - nb;
                nholes := nholes - 1;
                while nb > 0 do
                begin
                    j := j - 1;
                    buf[j] := blank;
                    nb := nb - 1
                end
            end;
            i := i - 1;
            j := j - 1
        end
    end
end;  {spread}
 
 
{ putword -- put word in outbuf; does margin justification }
procedure putword (var wordbuf : chstring);
var
    last, llval, nextra, w, j, k : integer;
    wlc : isochar;
begin
    w := width(wordbuf);
    last := length(wordbuf) + outp + 1 + eosbl; { new end of outbuf }
    llval := rmval - tival - inval;
    if (outp > 0)
        and ((outw+w+eosbl > llval) or (last >= maxstr)) then
    begin
        last := last - outp - eosbl;        { remember end of wordbuf }
        if reqfmt = jb then
        begin
            nextra := llval - outw + 1;
            if (nextra > 0) and (outwds > 1) then
            begin
                spread(outbuf, outp, nextra, outwds);
                outp := outp + nextra
            end
        end;
        break                               { flush previous line }
    end;
    for j := 1 to eosbl do
    begin
        outp := outp + 1;
        outbuf[outp] := del;                { it's a blank really }
        outw := outw + 1                    { 1 for each blank }
    end;
    eosbl := 0;
    scopy(wordbuf, 1, outbuf, outp+1);
    outp := last;
    outbuf[outp] := blank;                  { blank between words }
    outw := outw + w + 1;                   { 1 for blank }
    if firstwd then
    begin                                   { start of item }
        firstwd := false;
        k := -nptival;
        if w >= k then
            break                           { too long to fit in }
        else
        begin                               { indent for item text }
            outp := outp - 1;
            for j := w+1 to k do
            begin
                outp := outp + 1;
                outbuf[outp] := del
            end;
            outw := outw + k - w - 1
        end
    end
    else
    begin                                   { just an ordinary word }
        wlc := wordbuf[length(wordbuf)];
        if (wlc = period) or (wlc = question) or (wlc = exclam) then
            eosbl := eosextra;              { extra for sentence end }
        outwds := outwds + 1
    end
end;  {putword}
 
 
{ centre -- centre a line by setting tival }
procedure centre (var buf : chstring);
begin
    tival := max((rmval-inval-width(buf)) div 2, 0)
end;  {centre}
 
 
{ right -- right justify a line by setting tival }
procedure right (var buf : chstring);
begin
    tival := max(rmval-inval-width(buf), 0)
end;  {right}
 
 
{ initfmt -- set format parameter to default values }
procedure initfmt;
begin
    if gblfmt
        then reqfmt := jb
        else reqfmt := lj;
    dir := 0;
    eosbl := 0;
    eosextra := gbleos;
    osval := gbloset;
    inval := 0;
    rmval := gblwidth;
    tival := 0;
    nptival := gblpara;
    hind := false;
    firstwd := false;
    outp := 0;
    outw := 0;
    outwds := 0;
    lct := 0
end;  {initfmt}
 
 
{ fmtpars -- get override values from the command parameter string }
procedure fmtpars (var cmd : chstring;
                   i : integer);
var
    ch : isochar;
begin
    skipbl(cmd, i);
    while cmd[i] <> newline do
    begin
        ch := lowercase(cmd[i]);
        i := i + 1;
        if ch = letl then
            reqfmt := lj                { left justify (ragged right) }
        else if ch = letb then
            reqfmt := jb                { justify both margins }
        else if ch = letc then
            reqfmt := cen               { centre text }
        else if ch = letr then
            reqfmt := rj                { quad right (ragged left) }
        else if ch = letw then
        begin                           { width (right margin column }
            rmval := ctoi(cmd, i);
            rmval := max(rmval, 24);
            rmval := min(rmval, maxstr div 2)
        end
        else if ch = leti then
        begin                           { indent (left margin offset) }
            inval := ctoi(cmd, i);
            inval := max(inval, 0);
            inval := min(inval, 60)
        end
        else if ch = letp then
        begin                           { paragraph first line indent }
            nptival := ctoi(cmd, i);
            nptival := min(nptival, 24);
            nptival := max(nptival, -24)
        end
        else if ch = leth then
            hind := true                { hanging indentation }
        else if ch = lets then
        begin                           { sentence end spaces }
            eosextra := ctoi(cmd, i) - 1;
            eosextra := min(eosextra, 3);
            eosextra := max(eosextra, 0)
        end;
            { else ignore }
        skipbl(cmd, i)
    end;
    if (reqfmt = cen) or (reqfmt = rj) then
        nptival := 0;
    if nptival >= 0 then
    begin                               { normal paragraph }
        hind := false;
        if (rmval - inval - nptival) < 16 then
            rmval := inval + nptival + 16
    end
    else
    begin                               { item or hanging indent }
        inval := inval - nptival;
        if not hind then
            firstwd := true;
        if (rmval - inval) < 16
            then rmval := inval + 16
    end;
    tival := nptival
end;  {fmtpars}
 
 
{ text -- process text lines }
procedure text (var inbuf : chstring);
var
    wordbuf : chstring;
    i : integer;
begin
    if (inbuf[1] = blank) or (inbuf[1] = newline) then
        leadbl(inbuf);                  { move left }
    if inbuf[1] = newline then
    begin
        put(inbuf);                     { all blank line ... }
        tival := nptival;               { ... signals new paragraph }
        if (not hind) and (nptival < 0) then
            firstwd := true             { start of new item }
    end
    else
    begin
        case reqfmt of
 
        lj, jb:
            begin                       { filled text }
                i := 1;
                repeat
                    i := getword(inbuf, i, wordbuf);
                    if i > 0 then putword(wordbuf)
                until i = 0
            end;
 
        cen, rj:
            begin                       { centring or right justify }
                if reqfmt = cen then
                    centre(inbuf)
                else
                    right(inbuf);
                put(inbuf)
            end
        end  {case}
    end
end;  {text}
 
 
{ fiximage -- in full-screen mode, optimise image correction }
procedure fiximage;
var
    pinline : integer;      { display backstop }
    oldtopln : integer;     { old top of screen line number }
    oldbotln : integer;     { old bottom of screen line number }
    botln : integer;        { final bottom of screen line number }
    relbotln : integer;     { botln relative to previous buffer state }
    endln : integer;        { end of formatted text line number }
begin
    pinline := topln + pinrow - 2 - toprow;
    oldtopln := topln;
    oldbotln := topln + botrow - toprow;
    if curln < topln then
        topln := curln
    else if curln > pinline then
       topln := curln - pinrow + 2 + toprow;
 
    if (topln > oldtopln)
        and (line1 > oldtopln) and (line1 > topln) then
        scrollup(toprow, toprow+(line1-oldtopln-1), topln-oldtopln);
 
    botln := topln + botrow - toprow;
    relbotln := botln + line2 - line1 + 1 - lct;
    endln := line1 + lct - 1;
    if (oldbotln <> relbotln)
        and (line2 < oldbotln) and (endln < botln) then
    begin
        if oldbotln < relbotln then
            scrollup(endln+1-topln+toprow, botrow,
                                                relbotln-oldbotln)
        else
            scrolldown(line2+1-oldtopln+toprow, botrow,
                                                oldbotln-relbotln)
    end;
    fsrow := curln - topln + toprow
end;  {fiximage}
 
 
begin  { dofmt main routine }
    if fstate <> blkmode then           { not ^B..^P }
        checkpoint;
    initfmt;                            { set default values }
    fmtpars(cmd, i);                    { apply parameters }
 
    curln := line2;
    for line := line1 to line2 do
    begin                               { fetch and format source text }
        gettxt(line, inbuf);
        text(inbuf)
    end;
    break;                              { flush last output, if any }
    svcurln := curln;
    stat := lndelete(line1, line2, stat);
    curln := svcurln - line2 + line1 - 1;
 
    if appstate = fsereq then
        fiximage;
 
    if fstate <> blkmode then           { not ^B..^P }
    begin
        showlit('  Text lines formatted :');
        showc(blank);  showc(blank);
        showdec(line2-line1+1, 1, 0);
        showlit(' into &                 ');
        showdec(lct, 1, -1)
    end;
    dofmt := ok
end;  {dofmt}
 
 
{ ****************************************************** clsecmd **** }
{ *                                                                 * }
{ *                      CURLEW :: "se" (set)                       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ doset -- process set command to establish user profile requests }
function doset (var cmd : chstring;
                i : integer)
        : stcode;
var
    ch : isochar;
    isave, oldrend, oldxoset, newval : integer;
    pars : chstring;
 
 
{ gettabs -- get and set tab stop columns from parameter string }
procedure gettabs;
var
    ti, tj : integer;
    tc : coltype;
begin
    skipbl(cmd, i);
    if (cmd[i] = star) or isdigit(cmd[i]) then
    begin
        for tc := 0 to maxcol do
            tabcols[tc] := notab;
        tabrpt := 0;
 
        { get new stops from parameter string }
        if cmd[i] = star then
        begin                               { regular tab stops }
            if cmd[i] = star then
                i := i + 1;
            tabrpt := ctoi(cmd, i);
            if tabrpt <= 0 then
                tabrpt := 8;                { default is *8 }
            tabrpt := max(tabrpt, 2);
            tabrpt := min(tabrpt, (maxcol+1) div 4);
            for tc := 0 to maxcol do
                if (tc mod tabrpt) = 0 then
                    tabcols[tc] := tabset
        end
        else
        begin
            repeat
                ti := ctoi(cmd, i);
                if ti <> 0 then
                begin
                    tj := ti - 1;
                    tj := max(tj, 0);
                    tc := min(tj, maxcol);
                    tabcols[tc] := tabset
                end
            until ti = 0
        end;
 
        { establish new tabulation stops }
        erasetabs;
        for tc := 0 to maxcol do
            if tabcols[tc] = tabset then
                settab(tc)
    end
end;  {gettabs}
 
 
{ putkeydef -- replace definition for key n with string s }
procedure putkeydef (n : integer;
                     var s : chstring);
var
    i, j, k, koffset : integer;
begin
    j := n;
    k := kptrs[n];
 
    { skip existing definition by moving later definitions forward }
    i := k;
    while kdefs[i] <> newline do        { skip old definition }
        i := i + 1;
    koffset := i + 1 - k;
    for j := minkey to maxkey do
        if kptrs[j] > k then            { need to fix pointer }
            kptrs[j] := kptrs[j] - koffset;
    j := i + 1;
    while j <= kdmax do
    begin                               { move later defs forward }
        kdefs[k] := kdefs[j];
        j := j + 1;
        k := k + 1
    end;
 
    { add revised definition at the end }
    i := 1;
    kptrs[n] := k;
    while (k < vkdlim) and (s[i] <> endstr) do
    begin
        kdefs[k] := s[i];
        k := k + 1;
        i := i + 1
    end;
    kdefs[k] := newline;
    kdmax := k;
 
    { check for "prompt", needs preprocessing in "context" }
    kpick[n] := false;
    i := 1;  skipbl(s, i);
    if isletter(s[i]) then
    begin                               { dreadful kludge here ... }
        if (lowercase(s[i]) = letp)                          { "p" }
            and (lowercase(s[i+1]) = letr)                   { "r" }
                and (lowercase(s[i+2]) = leto) then          { "o" }
                    kpick[n] := true                   { "prompt"! }
    end
end;  {putkeydef}
 
 
{ getfkstr -- get and replace function key string }
procedure getfkstr;
var
   fks : chstring;
   delim, tc : isochar;
   knum, j : integer;
begin
   knum := ctoi(cmd, i);
   skipbl(cmd, i);
   delim := cmd[i];
   if isalphanum(delim)
       or (delim = newline) or (delim = endstr) then
           fks[1] := endstr
   else
   begin
       i := i + 1;
       j := 1;
       tc := cmd[i];
       while (tc <> delim)
           and (tc <> newline) and (tc <> endstr) do
       begin
           fks[j] := tc;
           j := j + 1;
           i := i + 1;
           tc := cmd[i]
       end;
       fks[j] := endstr
   end;
 
   if (knum >= 1) and (knum <= 37) then
       putkeydef(knum, fks)
end;  {getfkstr}
 
 
{ setmask -- set control character input mask }
procedure setmask (n : integer);
var
    c : isochar;
begin
    for c := nul to del do
        mask[c] := c;
    mask[newline] := nul;
    if n < 4 then
    begin                               { >=4 : all except lf, nul }
        for c := nul to us do
            mask[c] := nul;
        mask[del] := nul;               { 0 : mask all control chars }
        if n >= 1 then
        begin
            mask[ctli] := ctli;         { 1 : tab }
            if n >= 2 then
            begin                       { 2 : tab, del }
                mask[del] := del;
                if n >= 3 then
                begin                   { 3 : tab, del, esc, bs, ff }
                    mask[esc] := esc;
                    mask[ctlh] := ctlh;
                    mask[ctll] := ctll
                end
            end
        end
    end
end;  {setmask}
 
 
{ getswitch -- get value of on (+), off (-) parameter }
procedure getswitch (var sw : boolean);
begin
    skipbl(cmd, i);
    if (cmd[i] = plus) or (cmd[i] = minus) then
    begin
        sw := (cmd[i] = plus);
        i := i + 1
    end
end;  {getswitch}
 
 
{ getivalue -- get value of integer, check for + or - postfix }
function getivalue (var n : integer)
        : integer;
var
    tnum : integer;
begin
    skipbl(cmd, i);
    if isdigit(cmd[i]) or (cmd[i] = plus) or (cmd[i] = minus) then
    begin
        tnum := ctoi(cmd, i);
        if (cmd[i] = plus) or (cmd[i] = minus) then
        begin
            if cmd[i] = plus then       { increment existing value }
                tnum := n + tnum
            else                        { minus so decrement value }
                tnum := n - tnum;
            i := i + 1
        end
    end
    else tnum := n;                     { no number, no change }
    getivalue := tnum
end;  {getivalue}
 
 
begin  { doset main routine }
    skipbl(cmd, i);
    isave := i;
    while (cmd[i] <> bar) and                           { comment }
        (cmd[i] <> newline) and (cmd[i] <> endstr) do   { line end }
    begin
        ch := lowercase(cmd[i]);
        i := i + 1;
        if islower(ch) then
        case ch of
 
        leta:                           { a<sw> : RETURN append/split }
            begin
                getswitch(rappend);
                if rappend then
                    nfsomode[kappline] := ctlm  { RETURN appends }
                else
                    nfsomode[kappline] := nul;  { RETURN splits }
                if (appstate = fsereq) and (fstate = normal) then
                    putmode(nfsomode)
            end;
 
        letb:   getswitch(blkpara);     { b<sw> : ^B..^P paragraphing }
 
        letc:                           { c<sw> : insertion/overstrike }
            begin
                getswitch(ciview);
                if ciview then
                begin
                    nfsomode[icharmode] := 1;   { insertion default }
                    ctxtmode[icharmode] := 1    { ... and cmd input }
                end
                else
                begin
                    nfsomode[icharmode] := 0;   { overstrike default }
                    ctxtmode[icharmode] := 0    { ... and cmd input }
                end;
                if (appstate = fsereq) and (fstate = normal) then
                    putmode(nfsomode)
            end;
 
        letd:   getswitch(detab);       { d<sw> : detab in gettxt }
 
        lete:   getswitch(entab);       { e<sw> : entab on write }
 
        letf:   getfkstr;               { f<keydef> : function key def }
 
        letg:   ;
 
        leth:                           { h<sw> : horizontal tab keys }
            begin
                getswitch(htkeys);
                if htkeys then
                begin                   { local horizontal tab keys }
                    nfsomode[knexttab] := ctli;
                    nfsomode[kprevtab] := ctlf;
                    blokmode[knexttab] := ctli;
                    blokmode[kprevtab] := ctlf
                end
                else
                begin                   { host tab insert & prev word }
                    nfsomode[knexttab] := nul;
                    nfsomode[kprevtab] := nul;
                    blokmode[knexttab] := nul;
                    blokmode[kprevtab] := nul
                end;
                if appstate = fsereq then
                begin
                    if fstate = normal then
                        putmode(nfsomode)
                    else
                        putmode(blokmode)
                end
            end;
 
 
        leti:                           { i<sw> : auto image updating }
            begin
                getswitch(autoimage);
                if autoimage then
                    nfsomode[notify] := 164     { ch/ln del + ln split }
                else
                    nfsomode[notify] := 0;      { keep till frame end }
                if (appstate = fsereq) and (fstate = normal) then
                    putmode(nfsomode)
            end;
 
        letj:   getswitch(gblfmt);      { j<sw> : format b/l default }
 
        letk: ;
 
        letl:   getswitch(loopsearch);  { l<sw> : loop search action }
 
        letm:                           { m<num> : control char mask }
            begin
                mlevel := getivalue(mlevel);
                mlevel := max(mlevel, 0);
                mlevel := min(mlevel, 4);
                setmask(mlevel)
            end;
 
        letn:                           { n<sw> : anycase scan switch }
            begin
                getswitch(acsearch);
                cssinit := not acsearch
            end;
 
        leto:                           { o<num> : format text offset }
            begin
                gbloset := getivalue(gbloset);
                gbloset := max(gbloset, 0);
                gbloset := min(gbloset, 60)
            end;
 
        letp:                           { p<num> : format default "p" }
            begin
                gblpara := getivalue(gblpara);
                gblpara := max(gblpara, -24);
                gblpara := min(gblpara, 24)
            end;
 
        letq:   ;
 
        letr:                           { r<num> : alt rendition }
            begin
                oldrend := rrend;
                rrend := getivalue(rrend);
                if rrend > 9 then
                    rrend := 0;
                rrend := max(rrend, 0);
                if rrend = concealed then
                    rrend := defrend;           { you must see them! }
                if (rrend <> oldrend) and (oldrend <= crossedout) then
                begin
                    if appstate = coned then
                        edname                  { correct name }
                    else
                    if appstate = fsereq then
                    begin                       { correct f/s display }
                        if fstate = blkmode then
                            viewstate(fstate);
                        ruler(toprow-1);
                        ruler(botrow+1)
                    end
                end
            end;
 
        lets:                           { s<num> : format default }
            begin
                gbleos := gbleos + 1;
                gbleos := getivalue(gbleos) - 1;
                gbleos := min(gbleos, 3);
                gbleos := max(gbleos, 0)
            end;
 
        lett:   gettabs;                { t<tabdef> : set tab stops }
 
        letu:                           { u<sw> : K&P or UNIX c/tracks }
            begin
                getswitch(alttracks);
                setctk(alttracks);
                pat[1] := endstr
            end;
 
        letv:   getswitch(autoview);    { v<sw> : automatic view cmd }
 
        letw:                           { w<num> : format default "w" }
            begin
                gblwidth := getivalue(gblwidth);
                gblwidth := max(gblwidth, 24);
                gblwidth := min(gblwidth, maxstr div 2)
            end;
 
        letx:                           { x<num> : left margin offset }
            begin
                oldxoset := xoset;
                xoset := getivalue(xoset);
                xoset := max(xoset, 0);
                xoset := min(xoset, maxstr-maxcol-3);
                if (xoset <> oldxoset) and (appstate = fsereq) then
                begin
                    ruler(toprow-1);
                    newval := fscol + oldxoset - xoset;
                    newval := max(newval, 0);
                    newval := min(newval, maxcol);
                    fscol := newval
                end
            end;
 
        lety:                           { y<num> : vert csr movement }
            begin
                cscroll := getivalue(cscroll);
                cscroll := max(cscroll, 0);
                cscroll := min(cscroll, (botrow-toprow+1) div 2)
            end;
 
        letz:   getswitch(inswrap);     { z<sw> : wrap insertion }
 
        end;  {case}
        skipbl(cmd, i)
    end;
    if appstate = fsereq then
    begin
        showlit('  Set :  &              ');
        scopy(cmd, isave, pars, 1);
        showstr(pars)
    end;
    doset := ok
end;  {doset}
 
 
{ ****************************************************** clvcmd ***** }
{ *                                                                 * }
{ *                     CURLEW :: "v" (view)                        * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ doview -- full-screen mode entry }
function doview (line : integer;
                 achar : isochar)
        : stcode;
var
    action : isochar;
    ls : fstype;
    chsv : boolean;
    ln : rowtext;
    s : chstring;
    r : rowtype;
    c : coltype;
    nd, j : integer;
begin
    action := achar;
 
    { find out what to do }
    if action = plus then
    begin                               { full-screen wanted }
        if appstate = fsereq then       { refresh; full-screen }
            action := equals
    end
    else if action = minus then
    begin                               { context wanted }
        if appstate = coned then        { refresh; context }
            action := equals
    end
    else if action <> equals then
    begin                               { otherwise flip the state }
        if appstate = coned then
            action := plus
        else
            action := minus
    end;
 
    { manage any state change }
    if action = equals then
    begin                               { refresh from either state }
        if appstate = fsereq then
        begin
            refresh;                    { file comparison may correct }
            if nlines > 0 then
                topln := max(line, 1);
            ls := fstate;
            action := plus
        end
        else
        begin
            refresh;                    { remake image }
            edname;                     { only fix-up required }
            action := minus
        end
    end
    else if action = plus then
    begin                               { full-screen from context }
        appstate := fsereq;
        ls := normal;  vbmark := false;
        topln := max(line, 1);
        fsrow := toprow;
        fscol := 0;
        fschanged := false;
        fsline := 0;
        chsv := changed;
        fetch(fsrow);                   { make sure top line in buffer }
        changed := chsv;                { reset if just one blank line }
        curln := topln;
        checkpoint
    end
    else
    begin                               { context from full-screen }
        replace;
        appstate := coned;
        cstate := concmd;
        cmdcol := 0;
        ctxtimage;
        getloc(r, c);
        getrow(1, ln);                  { all minuses from ctxtimage }
        setstring(s, ' leaving full-screen ope');
        appstring(s, 'ration &                ');
        slcopy(s, 1, ln, 10, 40);
        nd := itoc(topln, s, 1);
        j := maxcol - 10;
        ln[j] := blank;
        slcopy(s, 1, ln, j+1, 10);
        ln[j+nd] := blank;
        putrow(maxrow-1, ln);
        setcursor(r, c);
        curln := min(topln, lastln);
        if ciview then                  { get ready for next view }
            nfsomode[icharmode] := 1
        else
            nfsomode[icharmode] := 0
    end;
 
    { if full-screen, the image needs to be set up }
    if action = plus then
    begin                               { full-screen image }
        header;
        viewstate(ls);                  { also sets mode array }
        ruler(toprow-1);
        fileimage;
        ruler(botrow+1);
        if not msgdone then
            linestat;
        setupdate(toprow, botrow, 0, maxcol);
        setcursor(fsrow, fscol)
    end;
 
    doview := ok
end;  {doview}
 
 
{ exitview -- exit from full-screen forced by other commands }
function exitview
        : stcode;
var
    junk : stcode;
begin
    if appstate = fsereq then
        junk := doview(min(topln, lastln), minus);
    exitview := ok
end;  {exitview}
 
 
{ ****************************************************** clecmd ***** }
{ *                                                                 * }
{ *                      CURLEW :: "e" (edit)                       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ startlog -- start log for new editor session }
procedure startlog;
var
    name : chstring;
    j, nd : integer;
begin
    setstring(name, 'curlew&                 ');
    filenbr := filenbr + 1;
    if filenbr > 1 then                 { mark "edit" calls by number }
    begin
        j := length(name) + 1;  name[j] := minus;
        nd := itoc(filenbr, name, j+1)
    end;
    loguse(name)
end;  {startlog}
 
 
{ doedit -- edit new file, clears buffer and reads in file }
function doedit
        : stcode;
var
    junk : stcode;
begin
    scopy(newfile, 1, savefile, 1);
    clrbuf;
    startlog;
    setbuf;
    vtitle[1] := newline;  vtitle[2] := endstr;     { clear any title }
    doedit := doread(0, savefile, false, ioerror);  { read in the file }
    if jfout <> ioerror then
    begin                               { log only after recovery! }
        jfcontrol(iowrite);
        journal(0, 0, lete, savefile);
    end;
    curln := min(1, lastln);
    changed := false;
    if appstate = fsereq then
    begin                               { autoview, already in "v" }
        topln := 1;
        fsrow := toprow;
        fscol := 0;
        fschanged := false;
        fsline := 0;
        fetch(fsrow);                   { make sure top line in buffer }
        changed := false;               { reset if just one blank line }
        curln := topln;
        checkpoint;
        header;                         { new filename }
        viewstate(normal);              { just in case }
        fileimage;                      { new file image }
        if not msgdone then
            linestat
    end
    else if autoview then
    begin                               { autoview, image to change }
        status := doview(curln, plus);
        lastcb
    end
end;  {doedit}
 
 
{ ****************************************************** clshcmd **** }
{ *                                                                 * }
{ *                      CURLEW :: "sh" (show)                      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ doshow -- show editor profile }
function doshow
        : stcode;
var
    junk : stcode;
    j : integer;
    first : boolean;
    s : chstring;
 
 
{ shtext -- show text description for each profile entry }
procedure shtext (txt : textlit;
                  letter : isochar);
var
    s : chstring;
    ccol, pcol, tcol : coltype;
begin
    if first then
        first := false
    else
    begin
        ccol := showposn;
        pcol := (maxcol div 2);
        if ccol >= pcol then
            showc(newline)
        else
            for tcol := ccol+1 to pcol do showc(blank);
    end;
    showc(blank);  showc(blank);
    showlit(txt);
    if letter <> nul then
    begin
        showlit('  :  &                  ');
        showc(letter)
    end
end;  {shtext}
 
 
{ shswitch -- show value of boolean as plus or minus }
procedure shswitch (txt : textlit;
                    letter : isochar;
                    sw : boolean);
begin
    shtext(txt, letter);
    if sw then
        showc(plus)
    else
        showc(minus)
end;  {shswitch}
 
 
{ shnumber -- show numerical value }
procedure shnumber (txt : textlit;
                    letter : isochar;
                    nbr : integer);
begin
    shtext(txt, letter);
    showdec(nbr, 1, 0)
end;  {shnumber}
 
 
{ shtstops -- show tabulation stops }
procedure shtstops (txt : textlit;
                    letter : isochar);
var
    tc : coltype;
begin
    shtext(txt, letter);
    cindent := 10;
    if tabrpt > 0 then
    begin
        showc(star);
        showdec(tabrpt, 1, 0)
    end
    else
    begin
        for tc := 0 to maxcol do
        if tabcols[tc] = tabset then
        begin
            showdec(tc+1, 1, 0);
            showc(blank)
        end
    end
end;  {shtstops}
 
 
{ shfnkey -- show function key string }
procedure shfnkey (nbr : integer);
var
    k : integer;
    c : isochar;
begin
    k := kptrs[nbr];
    c := kdefs[k];
    if c <> newline then
    begin
        shtext('  F&                    ', nul);
        showdec(nbr, 1, 3);
        if nbr < 10 then
            showc(blank);
        cindent := 10;
        repeat
            showc(c);
            k := k + 1;
            c := kdefs[k]
        until c = newline
    end
end;  {shfnkey}
 
 
begin  { doshow main routine }
    junk := exitview;
    showc(newline);  first := true;
    shswitch('Append line on RETURN   ', leta, rappend);
    shswitch('Block mode paragraphing ', letb, blkpara);
    shswitch('Character insertion set ', letc, ciview);
    shswitch('Detab file buffer text  ', letd, detab);
    shswitch('Entab when writing file ', lete, entab);
    shswitch('Horizontal tab keys     ', leth, htkeys);
    shswitch('Image updating by host  ', leti, autoimage);
    shswitch('Justify both margins    ', letj, gblfmt);
    shswitch('Loop search over buffer ', letl, loopsearch);
    shnumber('Mask control characters ', letm, mlevel);
    shswitch('Anycase at pattern start', letn, acsearch);
    shnumber('Formatted text offset   ', leto, gbloset);
    shnumber('Paragraph indentation   ', letp, gblpara);
    shnumber('Rendition (alternate)   ', letr, rrend);
    shnumber('Sentence separation     ', lets, gbleos+1);
    shtstops('Tabulation stops        ', lett);
    shswitch('UNIX (tm) metacharacters', letu, alttracks);
    shswitch('View command on entry   ', letv, autoview);
    shnumber('Width of paragraph      ', letw, gblwidth);
    shnumber('Left margin offset      ', letx, xoset);
    shnumber('Vertical cursor action  ', lety, cscroll);
    shswitch('Word wrap (power-typing)', letz, inswrap);
 
    showc(newline);  showc(newline);  first := true;
    shtext('Function key strings    ', capf);
    showdec(minkey, 1, 0);
    showc(period);  showc(period);
    showdec(maxkey, 1, -1);
    first := true;
    for j := minkey to maxkey do
        shfnkey(j);
 
    showc(newline);  showc(newline);
    showlit('  Version code :  pr188 ');    { curlew source code }
    showlit('&   (interface : ?????) ');    { system interface }
    getinf(clprofile, s, maxstr);
    showlit('@n  Profile file :  &   ');
    cindent := 18;
    showstr(s);  showc(newline);
 
    doshow := ok
end;  {doshow}
 
 
{ ****************************************************** clhcmd ***** }
{ *                                                                 * }
{ *                      CURLEW :: "h" (help)                       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ help -- display help summary information }
function help (var lin : chstring;
               i : integer)
        : stcode;
var
    fd : filedesc;
    s, hfn : chstring;
    stat, junk : stcode;
    cmdrc : integer;
begin
    stat := ok;
    getinf(clhelpcmd, s, maxstr);
    if s[1] <> endstr then
    begin                               { call system help utility }
        syscmd(s, cmdrc);
        if appstate = fsereq then
            linestat
    end
    else
    begin
        getinf(clhelpfn, hfn, maxstr);
        fd := openf(hfn, ioread);
        if fd = ioerror then
        begin
            showlit('  *** Cannot read the he');
            showlit('lp file :  &            ');
            showstr(hfn);
            showc(newline);
            msgdone := true;
            stat := err
        end
        else
        begin
            junk := exitview;
            while getline(s, fd, maxstr) do
                showstr(s);
            closef(fd);
            showlit('@n@nFILES@n&            ');
            getinf(clprofile, s, maxstr);
            showlit('@n  Profile file :  &   ');
            cindent := 18;
            showstr(s);
            showlit('@n  Summary file :  &   ');
            showstr(hfn);
            showc(newline)
        end
    end;
    help := stat
end;  {help}
 
 
{ ****************************************************** clnulcmd *** }
{ *                                                                 * }
{ *              CURLEW :: null command (relocation)                * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ nullcmd -- null command in either context or full-screen operation }
function nullcmd (glob : boolean)
        : stcode;
var
    up : boolean;
    nr, mr, cs : integer;
    junk : stcode;
begin
    if glob then
    begin
        cs := curln;  junk := exitview;  curln := cs
    end;
    if appstate = fsereq then
    begin                               { full-screen relocation }
        if nlines = 0 then
        begin
            showlit('  Request cancelled@n&  ');
            nullcmd := ok
        end
        else if line2 < 1 then
            nullcmd := err
        else
        begin
            up := true;
            nr := line2 - topln;
            if line2 <> topln then
            begin
                if nr < 0 then
                begin
                    nr := - nr;
                    up := false
                end;
                mr := (maxrow div 4) * 3;    { scrolling limit }
                if nr <= mr then
                    if (nlines = 1) or (not topused) then
                begin
                    if up then
                        scrollup(toprow, botrow, nr)
                    else
                        scrolldown(toprow, botrow, nr)
                end;
                topln := line2
            end;
            if topused then             { ..was "(nlines = 1) and ..." }
            begin                       { check for char still in view }
                if up then
                begin
                    if (fsrow - toprow) > nr then
                        fsrow := fsrow - nr
                    else
                        fsrow := toprow
                end
                else
                begin
                    if (botrow - fsrow) > nr then
                        fsrow := fsrow + nr
                    else
                        fsrow := botrow
                end;
            end
            else
                fsrow := toprow;        { otherwise cursor to top }
            linestat;
            nullcmd := ok
        end
    end
    else
    begin                               { context null command }
        if nlines = 0 then
        begin
            line2 := curln;
            if not glob then
            begin
                line2 := nextln(curln);
                if line2 <> 0 then
                    cfirst := cfirst + 1    { suppress null cmd echo }
                else
                begin
                    if lastln < 1 then
                        showlit('  *** Buffer is empty@n&')
                    else
                        showlit('  *** At end of buffer@n');
                    msgdone := true
                end
            end
        end;
        nullcmd := doprint(line2, line2, true);
    end
end;  {nullcmd}
 
 
{ ****************************************************** clcmd ****** }
{ *                                                                 * }
{ *       CURLEW :: Recognition of commands other than globals      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ testverb -- test command verb against possible matches }
procedure testverb (var lin : chstring;
                    var i : integer;
                    guess : cmdtype;
                    cmdlist : textlit;
                    var verb : cmdtype);
var
    j, jmax, k : integer;
    cl : chstring;
    ch : isochar;
    found, looking : boolean;
begin
    verb := guess;
    setstring(cl, cmdlist);
    j := i;
    jmax := j;
    k := 1;
    looking := true;
    repeat
        ch := lowercase(lin[j]);
        found :=  (not islower(ch))
            or (cl[k] = slash) or (cl[k] = endstr);
        if found then
            i := j - 1
        else
        begin
            if ch = cl[k] then
                j := j + 1              { point at next character }
            else
            begin
                jmax := max(jmax, j);
                repeat
                    k := k + 1
                until (cl[k] = slash) or (cl[k] = endstr);
                if cl[k] = endstr then
                    looking := false    { no more in list }
                else
                begin
                    j := i;             { start again for next }
                    verb := succ(verb)  { bump command guess }
                end
            end;
            k := k + 1
        end
    until found or (not looking);
 
    if not found then
    begin
        verb := badcmd;
        if guess = yesrep then
            showlit('  *** Invalid reply (&  ')
        else
            showlit('  *** Invalid command (&');
        for j := i to jmax do
            showc(lowercase(lin[j]));
        showc(rparen);
        if cl[1] <> question then
        begin
            showc(semicol);  showc(blank);
            showstr(cl);
            showlit(' intended?&             ')
        end;
        showc(newline);
        msgdone := true
    end
end;  {testverb}
 
 
{ cmdverb -- identify context editor command verb }
function cmdverb (var lin : chstring;
                  var i : integer)
        : cmdtype;
var
    firstch : isochar;
    verb : cmdtype;
    badmask : textlit;
begin
    verb := badcmd;
    badmask := '?&                      ';
    firstch := lowercase(lin[i]);
    if isletter(firstch) then
    case firstch of
 
    leta:   testverb(lin, i, acmd, 'append&                 ', verb);
    letb:   testverb(lin, i, badcmd, badmask, verb);
    letc:   testverb(lin, i, ccmd, 'change/copy/curlew/cl&  ', verb);
    letd:   testverb(lin, i, dcmd, 'delete&                 ', verb);
    lete:   testverb(lin, i, ecmd, 'edit/exit&              ', verb);
    letf:   testverb(lin, i, fcmd, 'filename/format&        ', verb);
    letg:   testverb(lin, i, badcmd, badmask, verb);
    leth:   testverb(lin, i, hcmd, 'help&                   ', verb);
    leti:   testverb(lin, i, icmd, 'insert&                 ', verb);
    letj:   testverb(lin, i, badcmd, badmask, verb);
    letk:   testverb(lin, i, kcmd, 'keep&                   ', verb);
    letl:   testverb(lin, i, lcmd, 'list&                   ', verb);
    letm:   testverb(lin, i, mcmd, 'move&                   ', verb);
    letn, leto:
            testverb(lin, i, badcmd, badmask, verb);
    letp:   testverb(lin, i, pcmd, 'print/prompt&           ', verb);
    letq:   testverb(lin, i, qcmd, 'quit&                   ', verb);
    letr:   testverb(lin, i, rcmd, 'read&                   ', verb);
    lets:   testverb(lin, i, scmd, 'substitute/set/show/stop', verb);
    lett:   testverb(lin, i, badcmd, badmask, verb);
    letu:   testverb(lin, i, ucmd, 'undo&                   ', verb);
    letv:   testverb(lin, i, vcmd, 'view&                   ', verb);
    letw:   testverb(lin, i, wcmd, 'write&                  ', verb);
    letx, lety, letz:
            testverb(lin, i, badcmd, badmask, verb);
 
    end; {case}
 
    cmdverb := verb
end;  {cmdverb}
 
 
{ docmd -- handle all commands except globals }
function docmd (var lin : chstring;
                var i : integer;
                glob : boolean;
                var status : stcode)
        : stcode;
var
    fil, sub : chstring;
    line3, cs : integer;
    gflag, pflag, lflag : boolean;
    ch, nextch : isochar;
    junk : stcode;
begin
    pflag := false;
    lflag := true;
    status := err;
    ch := lowercase(lin[i]);
    if ch = newline then
        status := nullcmd(glob)     { null command }
    else
    begin                           { command letter? }
        case cmdverb(lin, i) of
 
        badcmd: ;                   { error }
 
        acmd:                       { append command }
            begin
                if lin[i+1] = newline then
                    status := exitview;
                status := doappend(line2, lin, i+1, glob)
            end;
 
        ccmd:                       { change command }
            begin
                if default(curln, curln, status) = ok then
                    if lndelete(line1, line2, status) = ok then
                begin
                    if lin[i+1] = newline then
                        status := exitview;
                    status := doappend(prevln(line1), lin, i+1, glob)
                end
            end;
 
        cocmd:                      { copy command }
            begin
                pflag := (not glob) and (appstate <> fsereq);
                i := i + 1;
                if getone(lin, i, line3, status) = enddata then
                begin
                    line3 := curln;
                    status := ok
                end;
                if lin[i] <> newline then status := err;
                if status = ok then
                    if default(curln, curln, status) = ok then
                        status := copy(line3, glob)
            end;
 
        dcmd:                       { delete command }
            begin
                pflag := (not glob) and (appstate <> fsereq);
                if lin[i+1] = newline then
                    if default(curln, curln, status) = ok then
                        status := dodelete(line1, line2, glob);
                if lastln <= 0 then
                    pflag := false
            end;
 
        ecmd, cucmd, clcmd:         { edit (curlew, cl) command }
            begin
                if nlines = 0 then
                begin
                    if getfn(lin, i, fil) = ok then
                    begin
                        if (not autoview) or changed then
                            status := exitview;
                        scopy(fil, 1, newfile, 1);
                        if not changed then
                            status := doedit    { just do it }
                        else
                        begin
                            status := ok;
                            cstate := conecmd   { check first }
                        end
                    end
                end
            end;
 
        excmd:                      { exit command }
            begin
                if (lin[i+1] = newline) and (nlines = 0)
                    and (not glob) then
                begin
                    status := exitview;
                    status := dowrite(1, lastln, savefile);
                    if status = ok then
                        status := enddata
                    else
                    begin
                        status := ok;
                        cstate := conqcmd   { check first }
                    end
                end
            end;
 
        fcmd:                       { filename command }
            begin
                if nlines = 0 then
                begin
                    scopy(savefile, 1, sub, 1);
                    if getfn(lin, i, fil) = ok then
                        scopy(fil, 1, savefile, 1);
                    if (savefile[1] <> endstr) and
                        (not equal(sub, savefile)) then
                    begin
                        journal(0, 0, letf, savefile);
                        changed := true
                    end;
                    filestat;
                    status := ok
                end
            end;
 
        focmd:                      { format command }
            begin
                if not glob then
                begin
                    if fmtdef(status) = ok then
                        status := dofmt(line1, line2, lin, i+1)
                end
            end;
 
        hcmd:                       { help command }
            begin
                if (nlines = 0) and (not glob) then
                    status := help(lin, i+1)
            end;
 
        icmd:                       { insert command }
            begin
                if lin[i+1] = newline then
                    status := exitview;
                if line2 = 0 then
                    status := doappend(0, lin, i+1, glob)
                else
                    status := doappend(prevln(line2), lin, i+1, glob)
            end;
 
        kcmd:                       { keep command }
            begin
                if (nlines = 0) and (lin[i+1] = newline)
                    and (not glob) then
                begin
                    checkpoint;
                    if not rebuild then
                        jfcontrol(ioappend);
                    showlit('  Buffer checkpointed@n&');
                    status := ok
                end
            end;
 
        lcmd:                       { list command }
            begin
                if lin[i+1] = newline then
                    if default(curln, curln, status) = ok then
                begin
                    status := exitview;
                    status := doprint(line1, line2, true)
                end
            end;
 
        mcmd:                       { move command }
            begin
                pflag := (not glob) and (appstate <> fsereq);
                i := i + 1;
                if getone(lin, i, line3, status) = enddata then
                    status := err;
                if lin[i] <> newline then status := err;
                if status = ok then
                    if default(curln, curln, status) = ok then
                        status := move(line3, glob)
            end;
 
        pcmd:                       { print command }
            begin
                if lin[i+1] = newline then
                    if default(curln, curln, status) = ok then
                begin
                    status := exitview;
                    status := doprint(line1, line2, false)
                end
            end;
 
        prcmd:                      { prompt command }
            begin
                if (appstate = fsereq) and (nlines = 0) and
                    (lin[i+1] = newline) and (not glob) then
                begin
                    appstate := fsecmd;     { next time, read command }
                    cmdcol := 0;
                    status := ok
                end
            end;
 
        qcmd, stcmd:                { quit (stop) command }
            begin
                if (lin[i+1] = newline) and (nlines = 0)
                    and (not glob) then
                begin
                    status := exitview;
                    status := enddata;
                    if changed then
                    begin
                        status := ok;
                        cstate := conqcmd   { check first }
                    end
                end
            end;
 
        rcmd:                       { read command }
            begin
                status := getfn(lin, i, fil);
                status := doread(line2, fil, glob, jfout)
            end;
 
        scmd:                       { substitute command }
            begin
                i := i + 1;
                skipbl(lin, i);
                if optpat(lin, i) = ok then
                    if getrhs(lin, i, sub, gflag) = ok then
                        if ckp(lin, i+1, pflag, lflag, status) = ok then
                           if default(curln, curln, status) = ok then
                           begin
                               if (appstate = fsereq) and pflag then
                               begin
                                   cs := curln;  junk := exitview;
                                   curln := cs
                               end;
                               status := subst(sub, gflag, glob)
                           end
            end;
 
        secmd:                      { set command }
            begin
                if (nlines = 0) and (not glob) then
                    status := doset(lin, i+1)
            end;
 
        shcmd:                      { show command }
            begin
                if (lin[i+1] = newline)
                    and (nlines = 0) and (not glob) then
                        status := doshow
            end;
 
        ucmd:                       { undo command }
            begin
                if (nlines = 0) and (lin[i+1] = newline)
                    and (not glob) then
                begin
                    restore;            { exchange checkpoints }
                    journal(0, 0, letu, lin);
                    showlit('  Buffer restored from l');
                    showlit('ast checkpoint@n&       ');
                    filestat;
                    status := ok
                end
            end;
 
        vcmd:                       { view command }
            begin
                if not glob then
                begin
                    i := i + 1;
                    skipbl(lin, i);
                    status := default(curln, curln, status);
                    if lin[i] = plus then
                        scopy(lin, i+1, vtitle, 1);
                    status := doview(line2, lin[i]);
                    if appstate = coned then
                        cfirst := cfirst + 1    { suppress cmd echo }
                end
            end;
 
        wcmd:                       { write command }
            begin
                if not glob then
                begin
                    status := getfn(lin, i, fil);
                    if default(1, lastln, status) = ok then
                        status := dowrite(line1, line2, fil)
                end
            end;
 
        end   {case}
    end;
 
    if (status = ok) and (pflag) then
        status := doprint(curln, curln, lflag);
    docmd := status
end;  {docmd}
 
 
{ ****************************************************** clglob ***** }
{ *                                                                 * }
{ *             CURLEW :: "g" (global) and "x" (xglobal)            * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ function ckglob -- if global prefix, mark lines to be affected }
function ckglob (var lin : chstring;
                 var i : integer;
                 var status : stcode)
        : stcode;
var
    n : integer;
    gflag : boolean;
    temp : chstring;
    ch : isochar;
    verb : cmdtype;
begin
    status := ok;
    ch := lowercase(lin[i]);
    if (ch = letg) or (ch = letx) then
    begin
        testverb(lin, i, gcmd, 'global/xglobal&         ', verb);
        if verb = badcmd then
            status := err
    end
    else
        status := enddata;
 
    if status = ok then
    begin
        gflag := (verb = gcmd);
        i := i + 1;
        skipbl(lin, i);
        if optpat(lin, i) = err then
            status := err
        else if default(1, lastln, status) <> err then
        begin                           { mark affected lines }
            i := i + 1;
            skipbl(lin, i);
            { mark affected lines }
            for n := line1 to line2 do
            begin
                gettxt(n, temp);
                putmark(n, (match(temp, pat) = gflag))
            end;
            { erase all other marks }
            for n := 0 to line1 - 1 do
                putmark(n, false);
            for n := line2 + 1 to lastln do
                putmark(n, false);
            status := ok
        end
    end;
    ckglob := status
end;  {ckglob}
 
 
{ doglob -- do command at lin[i] on all marked lines }
function doglob (var lin : chstring;
                 var i : integer;
                 var cursave : integer;
                 var status : stcode)
        : stcode;
var
    count, nproc, istart, n : integer;
begin
    checkpoint;
    status := ok;
    count := 0;
    nproc := 0;
    n := line1;
    istart := i;
    repeat
        if getmark(n) then
        begin
            nproc := nproc + 1;
            putmark(n, false);
            curln := n;
            cursave := curln;
            i := istart;
            if getlist(lin, i, status) = ok then
                if docmd(lin, i, true, status) = ok then
                    count := 0
        end
        else
        begin
            n := nextln(n);
            count := count + 1
        end
    until (count > lastln) or (status <> ok);
    if status = ok then
    begin
        showlit('  Text lines processed :');
        showc(blank);  showc(blank);
        showdec(nproc, 1, -1)
    end;
    doglob := status
end;  {doglob}
 
 
{ ****************************************************** clpfkey **** }
{ *                                                                 * }
{ *            CURLEW :: Program function key processing            * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ fnkey -- check token request code for program function key }
function fnkey (rc : integer;
                var key : integer)
        : integer;
var
    lc : isochar;
begin
    key := 0;
    if isdigit(rc) then
    begin
        key := rc - dig0;
        if key = 0 then key := 10
    end
    else
    if isletter(rc) then
    begin
        lc := lowercase(rc);
        case lc of
 
        letq:   key := 11;
        letw:   key := 12;
        lete:   key := 13;
        letr:   key := 14;
        lett:   key := 15;
        lety:   key := 16;
        letu:   key := 17;
        leti:   key := 18;
        leto:   key := 19;
        letp:   key := 20;
        leta:   key := 21;
        lets:   key := 22;
        letd:   key := 23;
        letf:   key := 24;              { last "Fawn Book" PF key }
        letg:   key := 25;
        leth:   key := 26;
        letj:   key := 27;
        letk:   key := 28;
        letl:   key := 29;
                                        { semi-colon is PF key 30 }
        letz:   key := 31;
        letx:   key := 32;
        letc:   key := 33;
        letv:   key := 34;
        letb:   key := 35;
        letn:   key := 36;
        letm:   key := 37;
 
        end  { case }
    end
    else if rc = semicol then
        key := 30;
    fnkey := key
end;  {fnkey}
 
 
{ getprevious -- pick up previous text and place on command line }
procedure getprevious;
var
    r : rowtype;
    c, mc : coltype;
    i, j : integer;
    ln : rowtext;
begin
    getloc(r, c);
    mc := maxcol;
    if r <> cmdrow then
    begin
        getrow(r, ln);
        i := 1;  j := c;
        while j <= mc do
        begin
            prevlin[i] := ln[j];
            i := i + 1;  j := j + 1
        end;
        prevlin[i] := newline;
        prevlin[i+1] := endstr
    end;
 
    setcursor(cmdrow, cmdcol);
    erasetoright;
    getrow(cmdrow, ln);
    slcopy(prevlin, 1, ln, cmdcol, maxcol+1-cmdcol);
    putrow(cmdrow, ln);
    getloc(r, c);
    if c < cmdcol then
        setcursor(cmdrow, cmdcol)
end;  {getprevious}
 
 
{ plantkeynbr -- place function key code in command line }
procedure plantkeynbr (n : integer);
var
    i, j : integer;
begin
    setcursor(cmdrow, cmdcol);
    textchar(keyleadin);
    i := n div 10;  j := n mod 10;
    textchar(i+dig0);
    textchar(j+dig0);
    erasetoright
end;  {plantkeynbr}
 
 
{ getkeydef -- return string s associated with Fn }
procedure getkeydef (n : integer;
                     var s : chstring);
var
    i, j : integer;
    c : isochar;
begin
    i := kptrs[n];
    j := 1;
    repeat
        c := kdefs[i];
        s[j] := c;
        j := j + 1;
        i := i + 1
    until c = newline;
    s[j] := endstr
end;  {getkeydef}
 
 
{ subkeytext -- substitute function key definition for "@n" }
procedure subkeytext (var lin : chstring);
var
    n  : integer;
begin
    n := 0;
    if isdigit(lin[2]) then
    begin
        n := lin[2] - dig0;
        if isdigit(lin[3]) then
            n := n*10 + lin[3] - dig0
    end;
    if (n >= minkey) and (n <= maxkey) then
        getkeydef(n, lin)
    else
    begin
        lin[1] := newline;  lin[2] := endstr
    end
end;  {subkeytext}
 
 
{ cfkcmd -- set up context editor command from function key literal }
procedure cfkcmd(lit : textlit);
var
    j : integer;
begin
    setstring(prevlin, lit);
    j := length(prevlin);
    prevlin[j+1] := newline;
    prevlin[j+2] := endstr;
    setcursor(cmdrow, cmdcol);
    getprevious
end;  {cfkcmd}
 
 
{ ****************************************************** clyesno **** }
{ *                                                                 * }
{ *                CURLEW :: Yes/No reply processing                * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ ckyes -- check for "y" reply to e/q prompt }
function ckyes (var lin : chstring)
        : stcode;
var
    i : integer;
    ch : isochar;
    verb : cmdtype;
    stat : stcode;
begin
    i := 1;
    skipbl(lin, i);
    verb := norep;              { all function keys cancel }
    if isletter(lin[i]) then
        testverb(lin, i, yesrep, 'yes/no/ok/cancel&       ', verb);
    if (verb = yesrep) or (verb = okrep) then
        stat := enddata
    else if (verb = norep) or (verb = canrep) then
    begin
        showlit('  *** Use a "write" comm');
        showlit('and to save your work.@n');
        stat := ok
    end
    else
        stat := err;
    if stat <> err then
        cstate := concmd;
    ckyes := stat
end;  {ckyes}
 
 
{ ****************************************************** clcontxt *** }
{ *                                                                 * }
{ *           CURLEW :: Context editor command dispatch             * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ context -- control passed to context editor }
procedure context (rc : smallint);
var
    ln : rowtext;
    lin, fks : chstring;
    i, j, k, len : integer;
    r : rowtype;
    c : coltype;
    acode : integer;
    junk : stcode;
    cmdrc : integer;
    cmasked, dopfkey, resend : boolean;
begin
    dopfkey := false;  resend := false;
    if rc > del then
    begin
        setmode(knextfld, 50);          { next field key ... }
        setmode(kprevfld, 53);          { prev field key ... }
        setmode(knextfld, 0);  setmode(kprevfld, 0);    { reset both }
        getloc(r, c);
        if appstate = coned then
            edname
        else
        begin
            ruler(toprow-1);
            ruler(botrow+1)
        end;
        setcursor(r, c);
        acode := nul
    end
    else if fnkey(rc, acode) = 0 then
    begin
        acode := rc;
        getloc(r, c);
        resend := (acode = ctlm) and (r <> cmdrow)
    end
    else
        dopfkey := true;
 
    if dopfkey or resend then
    begin
        if resend or kpick[acode] then
        begin                           { command string to pick up }
            getprevious;
            setmode(cursor, 0);  setmode(kenter, ctlm);
            if resend then
                setcursor(cmdrow, cmdcol)       { it's being executed }
            else
                acode := nul                    { it's ready to edit }
        end
        else
        begin                           { got command string already }
            plantkeynbr(acode);
            acode := ctlm
        end
    end;
 
    if acode <> ctlm then
    begin                           { not command entry }
        if acode = ctlk then
        begin
            setmode(cursor, 1);  setmode(kenter, 0);
            getloc(r, c);  setcursor(r-1, c)    { going back to pickup }
        end
        else if acode <> nul then
            soundalarm              { not cmd pickup; invalid request }
    end
    else
    begin                           { return key; command entered }
        getrow(cmdrow, ln);
        cmasked := false;
        for i := 0 to maxcol do
        if mask[ln[i]] = nul then
        begin
            ln[i] := blank;         { control character mask }
            cmasked := true
        end;
        if cmasked then
            putrow(cmdrow, ln);     { correct image before scroll }
        showcmd(ln);
 
        { read the command line from the screen image }
        i := maxcol;
        while (i > cmdcol) and (ln[i] = blank) do i := i - 1;
        j := cmdcol;  k := 1;
        while j <= i do
        begin
            lin[k] := ln[j];
            j := j + 1;  k := k + 1
        end;
        lin[k] := newline;
        lin[k+1] := endstr;
        if (cstate = concmd) or (cstate = conapp) then
            scopy(lin, 1, prevlin, 1);      { save for re-entry }
 
        { if this is one-shot from f/s operation, reset needed }
        if appstate = fsecmd then
        begin
            appstate := fsereq;
            viewstate(fstate)           { corrects mode array }
        end;
        if appstate = fsereq then
        begin
            setcursor(cmdrow, 0);
            erasetoright                { clears f/s command text }
        end;
 
        case cstate of
 
        conapp:
            status := newtext(lin);     { append new a/c/i text line }
        conecmd:
            begin                       { returned from e cmd prompt }
                status := ckyes(lin);
                if status = enddata then
                    status := doedit
            end;
        conqcmd:
            status := ckyes(lin);       { returned from q cmd prompt }
        concmd:
            begin                       { process new command line }
                msgdone := false;
                errcode := basic;
                if lin[1] = keyleadin then
                begin                   { function key evaluation }
                    subkeytext(lin);
                    len := length(lin) - 1;
                    if len < (maxcol-2) then
                    begin               { we can afford to show it }
                        scopy(lin, 1, prevlin, 1);
                        ln := blankrow;  ln[0] := cmdprompt;
                        slcopy(lin, 1, ln, 2, len);
                        showcmd(ln)
                    end
                end;
                i := 1;
                skipbl(lin, i);
                if lin[i] = exclam then
                begin                   { system command request }
                    checkpoint;
                    scopy(lin, i+1, fks, 1);
                    syscmd(fks, cmdrc);
                    if (appstate = fsereq) or (cmdrc > 0) then
                    begin
                        showlit('  Command completed&    ');
                        if cmdrc > 0 then
                        begin
                            showlit(' with code :  &         ');
                            showdec(cmdrc, 1, 0)
                        end;
                        showc(newline)
                    end;
                    status := ok
                end
                else
                begin                   { editor command }
                    cursave := curln;
                    if getlist(lin, i, status) = ok then
                    begin
                        if ckglob(lin, i, status) = ok then
                        begin
                            status := doglob(lin, i, cursave, status);
                            errcode := basic
                        end
                        else if status <> err then
                            status := docmd(lin, i, false, status)
                        { else err, do nothing }
                    end
                end
            end
        end;  {case}
 
        { command aftermath }
        if status = err then
        begin
            if not msgdone then
            begin
                case errcode of
                basic:
                    showlit('  *** Invalid command@n&');
                search:
                    showlit('  *** Search failed@n&  ');
                lrange:
                    showlit('  *** Line range error@n')
                end
            end;
            curln := min(cursave, lastln);
            if (appstate <> fsereq) and (cstate = concmd) then
                junk := doprint(curln, curln, true)
        end
        else if status = enddata then
        begin
            screenmode := false;
            if (vtitle[1] = newline) and (savefile[1] <> endstr) then
            begin
                showlit('  Last edit filename :  ');
                showstr(savefile);  showc(newline)
            end
        end;
 
        if appstate = fsereq then
        begin
            lastcb;                                     { message line }
            topln := min(topln, lastln);
            topln := max(1, topln);
            fetch(toprow);
            fileimage;                                  { corrections }
            setcursor(fsrow, fscol);                    { put it back }
            setupdate(toprow, botrow, 0, maxcol)        { make sure }
        end
        else
        begin
            if appstate <> fsecmd then
                flushcb;        { show verification of last command }
 
            { if still active, prompt for the next command }
            if status <> enddata then
                edprompt
            else
            begin
                jfcontrol(nul);         { empty journal file }
                setcursor(cmdrow, 0);  erasetoright;
                literal('  End of editor session.')
            end
        end
    end;
end;  {context}
 
 
{ ****************************************************** clreport *** }
{ *                                                                 * }
{ *     CURLEW :: Full-screen editor change report processing       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ repchar -- replacement character in full-screen mode }
procedure repchar (c : isochar);
var
    i, j, k : integer;
begin
    fetch(fsrow);
    i := length(fstext) - 1;                { existing text length }
    j := fscol + 1 + xoset;
    if j > i then
    begin                                   { make the text longer }
        for k := i+1 to j do fstext[k] := blank;
        fstext[j+1] := newline;
        fstext[j+2] := endstr
    end;
    if fstext[j] <> c then
    begin                                   { true replacement }
        if mask[c] <> nul then                  { ...not masked out }
        begin
            fstext[j] := c;
            fschanged := true
        end
        else
            fscmask := true                     { fix-up required }
    end;
    getloc(fsrow, fscol)                    { track cursor }
end;  {repchar}
 
 
{ gettoken -- request premature return of the token }
procedure gettoken;
begin
    if not tokreq then
    begin
        if autoimage then
            reqtoken;
        tokreq := true
    end
end;  {gettoken}
 
 
{ deltoeol -- deltoeol line before cursor position }
procedure deltoeol;
var
    j, q : integer;
begin
    fetch(fsrow);
    j := length(fstext) - 1;
    q := fscol + xoset;
    if j > q then
    begin                               { truncation necessary }
        fstext[q+1] := newline;
        fstext[q+2] := endstr;
        fschanged := true
    end
end;  {deltoeol}
 
 
{ insspaces -- correct file from spaces inserted report }
procedure insspaces (nsp : integer);
var
    i, j, k, q, lim : integer;
    rem : chstring;
begin
    fetch(fsrow);
    i := length(fstext) - 1;                { existing text length }
    q := fscol + xoset;
    if i > q then
    begin                                   { insertion within text }
        k := q + 1;
        scopy(fstext, k, rem, 1);
        j := 1;
        lim := maxstr - 2;
        while (j <= nsp) and (k < lim) do
        begin
            fstext[k] := blank;
            j := j + 1;
            k := k + 1
        end;
        j := 1;
        while (rem[j] <> endstr) and (k <= lim) do
        begin
            fstext[k] := rem[j];
            j := j + 1;
            k := k + 1
        end;
        fstext[k-1] := newline;         { make sure }
        fstext[k] := endstr;
        fschanged := true
    end
end;  {insspaces}
 
 
{ delchars -- correct file from characters deleted report }
procedure delchars (nch : integer);
var
    rem : chstring;
    i, k, q : integer;
begin
    fetch(fsrow);
    i := length(fstext) - 1;                { existing text length }
    q := fscol + xoset;
    if i > q then
    begin                                   { characters deleted }
        k := q + 1;
        if nch > (i-k) then
        begin                               { rest of line taken out }
            fstext[k] := newline;
            fstext[k+1] := endstr
        end
        else
        begin                               { chars at/beyond cursor }
            scopy(fstext, k+nch, rem, 1);
            scopy(rem, 1, fstext, k);
            if fstate <> blkmode then       { not from bdelchars call }
                if i > (maxcol+xoset+1) then
                    gettoken                { for image correction }
        end;
        fschanged := true
    end
end;  {delchars}
 
 
{ bserases -- correct file from backspace erasure report }
procedure bserases (nch : integer);
var
    ecol : coltype;
    j : integer;
begin
    ecol := fscol;
    for j := 1 to nch do
    begin
        ecol := ecol - 1;
        fscol := ecol;
        repchar(blank)
    end
end;  {bserases}
 
 
{ inslines -- correct file from lines inserted report }
procedure inslines (nln : integer);
var
    stat : stcode;
    bs : chstring;
    j : integer;
begin
    fetch(fsrow);                       { reload; may be beyond eof }
    replace;                            { dump cache }
    curln := topln + fsrow - toprow - 1;
    bs[1] := newline;  bs[2] := endstr;
    for j := 1 to nln do
        stat := puttxt(bs)              { before cursor line }
end;  {inslines}
 
 
{ dellines -- correct file from lines deleted report }
procedure dellines (nln : integer);
var
    i, j, oldlast, lastdel : integer;
    stat : stcode;
begin
    replace;                            { dump cache }
    i := topln + fsrow - toprow;
    if i <= lastln then
    begin
        oldlast := lastln;
        lastdel := min(lastln, i+nln-1);
        stat := lndelete(i, lastdel, stat);
        if (fsrow = toprow) and (topln > lastln) then
            fetch(fsrow);               { make it a blank line }
        j := topln + botrow - toprow;
        if (lastdel < oldlast) and (oldlast > j) then
            gettoken                    { for image correction }
    end
end;  {dellines}
 
 
{ apponeline -- correct file from line appended report }
procedure apponeline;
var
    stat : stcode;
    bs : chstring;
begin
    fetch(fsrow);                       { reload; may be beyond eof }
    curln := topln + fsrow - toprow;
    bs[1] := newline;  bs[2] := endstr;
    stat := puttxt(bs);                 { after previous cursor line }
    if fsrow >= pinrow then
        topln := topln + 1;             { text displaced upwards }
    getloc(fsrow, fscol)                { track new cursor position }
end;  {apponeline}
 
 
{ splitoneline -- correct file from line split report }
procedure splitoneline;
var
    rem : chstring;
    i, k, q, p : integer;
    ic : coltype;
begin
    ic := fscol;
    fetch(fsrow);                       { reload; may be beyond eof }
    rem[1] := newline;  rem[2] := endstr;
    i := length(fstext) - 1;            { existing text length }
    q := fscol + xoset;
    if i > q then
    begin                               { line split within text }
        k := q + 1;
        p := 0;
        while p < xoset do
        begin                           { blanks to left of margin }
            p := p + 1;
            rem[p] := blank
        end;
        scopy(fstext, k, rem, p+1)
    end;
    deltoeol;                           { truncate the old line }
    replace;                            { dump cache }
    apponeline;                         { add the new line }
    fetch(fsrow);                       { reload with it }
    scopy(rem, 1, fstext, 1);           { move the text in }
    fschanged := true;                  { cache changed }
    if (length(rem)-xoset) > (maxcol-ic+2) then
        gettoken                        { for image correction }
end;  {splitoneline}
 
 
{ ****************************************************** clhostrq *** }
{ *                                                                 * }
{ *      CURLEW :: Full-screen editor host request processing       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ blockset -- set block mode }
procedure blockset;
var
    ln : rowtext;
begin
    checkpoint;
    blktopln := topln;
    blkrow := fsrow;  blkcol := fscol;  blkoset := xoset;
    viewstate(blkmode)
end;  {blockset}
 
 
{ blockget -- return line limits for block mode action }
procedure blockget (var start : integer;
                    var fin : integer;
                    vreset : boolean);
var
    temp : integer;
begin
    fin := topln + fsrow - toprow;
    if fstate <> blkmode then
    begin
        start := fin;
        blktopln := topln;  blkrow := fsrow;  blkcol := fscol
    end
    else
    begin
        if vreset then
            vbmreset;
        start := blktopln + blkrow - toprow;
        if start > fin then
        begin
            temp := start;  start := fin;  fin := temp
        end
    end
end;  {blockget}
 
 
{ blockreset -- reset state after block mode action }
procedure blockreset (reloc : boolean);
begin
    if fstate = blkmode then
    begin
        viewstate(normal);  vbmreset;
        begin
        end;
        if reloc then
        begin
            topln := min(blktopln, lastln);
            topln := max(topln, 1);
            fetch(toprow);
            if xoset <> blkoset then
            begin
                xoset := blkoset;  ruler(toprow-1)
            end;
            fileimage;
            fsrow := blkrow;  fscol := blkcol
        end;
        setupdate(toprow, botrow, 0, maxcol);
        mousetrap := safe
    end
end;  {blockreset}
 
 
{ verify -- change screen image to reflect change to file }
procedure verify;
var
    ir : rowtype;
    ic : coltype;
begin
    fschanged := true;                  { cache changed }
    replace;                            { buffer updated }
    if fstate <> blkmode then
    begin
        ir := fsrow;  ic := fscol;
        filetext(fsrow);                { correct the screen image }
        fsrow := ir;  fscol := ic       { but don't lose cursor posn }
    end
end;  {verify}
 
 
{ align -- align first non-blank with cursor }
procedure align;
var
    rem : chstring;
    start, fin, cl, j, k, lim : integer;
begin
    blockget(start, fin, true);
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        fetch(fsrow);
        j := 1;
        while fstext[j] = blank do
            j := j + 1;
        k := fscol + 1 + xoset;
        if (fstext[j] <> newline) and (k <> j) then
        begin
            scopy(fstext, j, rem, 1);
            for j := 1 to k-1 do
                fstext[j] := blank;
            lim := maxstr - 2;
            j := 1;
            while (rem[j] <> endstr) and (k <= lim) do
            begin
                fstext[k] := rem[j];
                j := j + 1;  k := k + 1
            end;
            fstext[k] := endstr;
            verify                      { correct the screen image }
        end
    end;
    blockreset(true)
end;  {align }
 
 
{ deltosol -- delete from cursor to start of line }
procedure deltosol;
var
    start, fin, cl, j, k : integer;
    rem : chstring;
begin
    blockget(start, fin, true);
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        fetch(fsrow);
        j := length(fstext) - 1;
        if j > 0 then
        begin
            k := fscol + 1 + xoset;
            if j > k then
            begin
                scopy(fstext, k+1, rem, 1);
                scopy(rem, 1, fstext, 1)
            end
            else
            begin
                fstext[1] := newline;  fstext[2] := endstr
            end;
            verify                      { correct the screen image }
        end
    end;
    blockreset(true)
end;  {deltosol}
 
 
{ bdeltoeol -- block delete to end of line }
procedure bdeltoeol;
var
    start, fin, cl : integer;
begin
    blockget(start, fin, true);
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        deltoeol                        { use the local report code }
    end;
    blockreset(true)
end;  {bdeltoeol}
 
 
{ bdellines -- block delete lines }
procedure bdellines;
var
    start, fin, botln : integer;
    stat : stcode;
begin
    blockget(start, fin, true);
    if start <= lastln then
    begin
        fin := min(fin, lastln);
        stat := lndelete(start, fin, stat)
    end;
    if (topln + fsrow) < (blktopln + blkrow) then
    begin                   { leave at next line after deleted group }
        blkrow := fsrow;
        blkcol := fscol;
        blktopln := topln
    end;
    if blktopln = topln then
    begin                               { possible optimisation here }
        botln := topln + botrow - toprow;
        if (start < botln) and (fin < botln) then
            scrollup(toprow+(start-topln), botrow, fin-start+1)
    end;
    blockreset(true)
end;  {bdellines}
 
 
{ binsspaces -- block insert spaces }
procedure binsspaces;
var
    start, fin, cl, nsp : integer;
begin
    blockget(start, fin, true);
    nsp := blkcol + blkoset - fscol - xoset;
    if nsp >= 0 then
        nsp := nsp + 1
    else
    begin                               { turn it round }
        nsp := 1 - nsp;
        fscol := blkcol;  xoset := blkoset
    end;
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        insspaces(nsp)                  { use the local report code }
    end;
    blockreset(true)
end;  {binsspaces}
 
 
{ bdelchars -- block delete characters }
procedure bdelchars;
var
    start, fin, cl, nch : integer;
begin
    blockget(start, fin, true);
    nch := blkcol + blkoset - fscol - xoset;
    if nch >= 0 then
        nch := nch + 1
    else
    begin                               { turn it round }
        nch := 1 - nch;
        fscol := blkcol;  xoset := blkoset
    end;
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        delchars(nch)                   { use the local report code }
    end;
    blockreset(true)
end;  {bdelchars}
 
 
{ delblanks -- on one line, delete from cursor to next non-blank }
procedure delblanks;
var
    j, k, kmark : integer;
    rem : chstring;
begin
    fetch(fsrow);
    j := length(fstext) - 1;
    k := fscol + 1 + xoset;
    if j >= k then
        if fstext[k] = blank then
    begin
        kmark := k;
        while fstext[k] = blank do
            k := k + 1;
        scopy(fstext, k, rem, 1);
        scopy(rem, 1, fstext, kmark);
        verify                      { correct the screen image }
    end
end;  {delblanks}
 
 
{ bdelblanks -- delete from cursor to next non-blank }
procedure bdelblanks;
var
    start, fin, cl : integer;
begin
    blockget(start, fin, true);
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        delblanks
    end;
    blockreset(true)
end;  {bdelblanks}
 
 
{ deloneword -- delete word at cursor }
procedure deloneword;
var
    j, k : integer;
begin
    fetch(fsrow);
    j := length(fstext) - 1;
    k := fscol + xoset + 1;
    if j >= k then
        if fstext[k] <> blank then
    begin
        while (fstext[k] <> blank) and (fstext[k] <> newline) do
            k := k + 1;
        k := k - 1;
        while (k > 1) and (fstext[k] <> blank) do
        begin
            fstext[k] := blank;  k := k - 1
        end;
        if fstext[k] <> blank then
        begin
            fstext[k] := blank;  k := k - 1
        end;
        k := max(k-xoset, 0);
        fscol := k;                     { at start of former word }
        delblanks                       { close up to next word }
    end
end;  {deloneword}
 
 
{ delwords -- delete word or block delete words }
procedure delwords;
var
    start, fin, lastdel, i, j, k, l, toset, q : integer;
    stat : stcode;
    tcol, svcol : coltype;
begin
    if fstate <> blkmode then
        deloneword
    else
    begin
        blockget(start, fin, true);
        if start <> fin then
        begin                           { not on same line }
            if (topln + fsrow) > (blktopln + blkrow) then
            begin
                tcol := fscol;  fscol := blkcol;
                toset := xoset;  xoset := blkoset
            end
            else
            begin
                tcol := blkcol;  toset := blkoset;
                blkrow := fsrow;  blktopln := topln
            end;
            topln := start - fsrow + toprow;
            svcol := fscol;  repchar(star);     { cursor over a word }
            fscol := svcol;  deloneword;        { first word in block }
            deltoeol;                   { remainder of first line }
            blkcol := fscol;
            replace;                    { dump cache }
            if (start < lastln)
                and ((fin - start) > 1) then
            begin                       { delete intermediate lines }
                lastdel := min(fin-1, lastln);
                stat := lndelete(start+1, lastdel, stat)
            end;
            topln := topln + 1;
            fscol := tcol;  xoset := toset;
            repchar(star);  fscol := tcol;
            q := fscol + xoset + 1;
            for k := 1 to q do
                fstext[k] := star;      { make sol all one word }
            fscol := tcol;
            deloneword                  { delete the giant word }
        end
        else
        begin                           { on the same line }
            if (fscol + xoset) <= (blkcol + blkoset) then
            begin
                i := fscol + xoset;
                j := blkcol + blkoset - i + 1
            end
            else
            begin
                i := blkcol + blkoset;
                j := fscol + xoset - i + 1
            end;
            fetch(fsrow);
            l := length(fstext);
            for k := 1 to j do
                fstext[k+i] := star;
            if l <= (i+j) then
            begin
                fstext[i+j+1] := newline;  fstext[i+j+2] := endstr
            end;
            deloneword;                 { now delete it }
            blkcol := fscol
        end;
        blockreset(true)
    end
end;  {delwords}
 
 
{ splitline -- split line before cursor, don't move cursor }
procedure splitline;
var
    rem : chstring;
    start, fin, cl, i, k, q : integer;
    stat : stcode;
begin
    blockget(start, fin, true);
    for cl := fin downto start do
    begin
        topln := cl - fsrow + toprow;
        fetch(fsrow);                   { reload; may be beyond eof }
        rem[1] := newline;  rem[2] := endstr;
        i := length(fstext) - 1;        { existing text length }
        q := fscol + xoset;
        if i > q then
        begin                           { line split within text }
            k := q + 1;
            scopy(fstext, k, rem, 1);
            fstext[k] := newline;
            fstext[k+1] := endstr;
            fschanged := true
        end;
        curln := topln + fsrow - toprow;
        stat := puttxt(rem);            { after previous cursor line }
 
        if fstate <> blkmode then
        begin
            erasetoright;               { first image correction }
            if fsrow < botrow then
            begin                       { second image correction }
                if fsrow < (botrow-1) then
                    scrolldown(fsrow+1, botrow, 1);
                filetext(fsrow+1)
            end
        end
    end;
    blockreset(true)
end;  {splitline}
 
 
{ combinelines -- combine cursor line with next, don't move cursor }
procedure combinelines;
var
    rem : chstring;
    start, fin, cl, i, j, k, lim, q : integer;
    stat : stcode;
begin
    blockget(start, fin, true);
    fin := start + ((fin - start) div 2);
    for cl := start to fin do
    begin
        topln := cl - fsrow + toprow;
        fetch(fsrow+1);                 { next row; will be deleted }
        scopy(fstext, 1, rem, 1);
        i := topln + fsrow - toprow + 1;
        if i <= lastln then
        begin
            stat := lndelete(i, i, stat);
            if fstate <> blkmode then
            begin
                if fsrow < botrow then
                begin                   { first correction to image }
                    if fsrow < (botrow-1) then
                        scrollup(fsrow+1, botrow, 1);
                    filetext(botrow)
                end
            end
        end;
        fetch(fsrow);                   { cursor row; append text }
        k := length(fstext) - 1;
        q := fscol + xoset;
        if k < q then
        begin
            for j := k+1 to q do
                fstext[j] := blank;
            k := q
        end;
        lim := maxstr - 2;
        j := 1;
        k := k + 1;
        while (rem[j] <> endstr) and (k <= lim) do
        begin
            fstext[k] := rem[j];
            j := j + 1;
            k := k + 1
        end;
        fstext[k] := endstr;
        verify                          { final correction to image }
    end;
    blockreset(true)
end;  {combinelines}
 
 
{ paralines -- alternative processing for block combine }
procedure paralines;
var
    start, fin, pwid, i, savwidth, savpara, savoset : integer;
    savfmt : boolean;
    fclin : chstring;
    stat : stcode;
begin
    { save global profile settings }
    savfmt   := gblfmt;   savwidth := gblwidth;
    savpara  := gblpara;  savoset  := gbloset;
 
    blockget(start, fin, true);
    pwid := blkcol + blkoset - fscol - xoset;
    if pwid >= 0 then
    begin                                   { "fo b" if width > 0 }
        pwid := pwid + 1;  gblfmt := pwid > 1
    end
    else
    begin                                   { turn it round, "fo l" }
        pwid := 1 - pwid;  gblfmt := false;
        fscol := blkcol;  xoset := blkoset
    end;
    if pwid >= 24 then
    begin
        gblwidth := pwid;  gbloset := fscol + xoset
    end;
 
    if start <= lastln then
    begin
        fin := min(fin, lastln);
        fclin[1] := newline;  fclin[2] := endstr;  i := 1;
        stat := dofmt(start, fin, fclin, i)
    end;
 
    { restore global profile settings}
    gblfmt   := savfmt;   gblwidth := savwidth;
    gblpara  := savpara;  gbloset  := savoset;
 
    blockreset(false);  fileimage
end;  {paralines}
 
 
{ tabinsert -- insert a new line leaving cursor at current indent }
procedure tabinsert;
var
    bs : chstring;
    stat : stcode;
    ln : rowtext;
    trow : rowtype;
    tcol : coltype;
    found : boolean;
begin
    { first insert the line }
    fetch(fsrow);                       { reload; may be beyond eof }
    replace;                            { dump cache }
    curln := topln + fsrow - toprow;
    bs[1] := newline;  bs[2] := endstr;
    stat := puttxt(bs);                 { after cursor line }
 
    { next update the screen image }
    if fsrow >= pinrow then
    begin
        topln := topln + 1;             { text displaced upwards }
        scrollup(toprow, fsrow, 1)
    end
    else
    begin                               { text displaced downwards }
        fsrow := fsrow + 1;
        scrolldown(fsrow, botrow, 1)
    end;
 
    { now find out where to put the cursor }
    fscol := 0;  trow := fsrow;  found := false;
    while not found do
    begin
        trow := trow - 1;
        getrow(trow, ln);
        tcol := 0;
        while (tcol < maxcol) and (ln[tcol] = blank) do
            tcol := tcol + 1;
        if ln[tcol] <> blank then   { will stop on ruler if not before }
        begin
            fscol := tcol;  found := true
        end
    end
end;  {tabinsert}
 
 
{ ****************************************************** clclone **** }
{ *                                                                 * }
{ *         CURLEW :: Full-screen editor clone processing           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ cmessage -- output bottom line messages for clone actions }
procedure cmessage (txt : textlit;
                    n : integer;
                    w : integer);
begin
    setcursor(maxrow, 0);  erasetoright;
    textchar(lbrack);  textchar(blank);
    literal(txt);  outdec(n);
    if w > 0 then
    begin
        literal(' line&                  ');
        if n > 1 then
            textchar(lets);
        literal(' of width &             ');
        outdec(w)
    end;
    textchar(blank);  textchar(rbrack)
end;  {cmessage}
 
 
{ openclone -- open clone file for reading or writing }
function openclone (openmode : integer)
        : filedesc;
var
    cname : chstring;
    fd : filedesc;
begin
    getinf(clclone, cname, maxstr);
    if openmode = ioread then
    begin
        fd := openf(cname, ioread);
        if fd = ioerror then
            fd := create(cname, ioread)
    end
    else
        fd := create(cname, iowrite);
    cloneexists := true;
    openclone := fd
end;  {openclone}
 
 
{ clonetext -- block save of lines or a rectangle of characters }
procedure clonetext (chsave : boolean);
var
    start, fin, j, k, si, w : integer;
    fd : filedesc;
    rem : chstring;
    stat : stcode;
begin
    charclone := chsave;                { remember clone type }
    if charclone then
    begin
        if (fscol + xoset) < (blkcol + blkoset) then
        begin
            si := fscol + xoset + 1;
            w := blkcol + blkoset - fscol - xoset + 1
        end
        else
        begin
            si := blkcol + blkoset + 1;
            w := fscol + xoset - blkcol - blkoset + 1
        end;
        w := min(w, maxstr-3)           { can't quite save full width }
    end;
 
    blockget(start, fin, false);
    fetch(fsrow);
    fileclone := (start <> fin);
    if fileclone then
        fd := openclone(iowrite);
    j := start;
    stat := ok;
    repeat
        if j <= lastln then
        begin
            gettxt(j, sclone);
            if charclone then
            begin
                for k := length(sclone) to si+w-1 do
                    sclone[k] := blank;
                sclone[si+w] := endstr;
                scopy(sclone, si, rem, 1);
                scopy(rem, 1, sclone, 1);
                sclone[w+1] := dollar;
                sclone[w+2] := newline;
                sclone[w+3] := endstr
            end;
            if fileclone then
                putstr(sclone, fd);
            j := j + 1
        end
        else
            stat := err
    until (stat <> ok) or (j > fin);
    if fileclone then
        closef(fd);
    if charclone then
        cmessage('Characters saved :  &   ', (j-start), w)
    else
        cmessage('Text lines saved :  &   ', j-start, -1);
 
    { don't leave town till the mousetrap is armed }
    mousetrap := armed;
    putmode(bblkmode);
    setupdate(fsrow, fsrow, fscol, fscol)
end;  {clonetext}
 
 
{ insclone -- insert a copy of the saved text at cursor position }
procedure insclone;
var
    j, k, svtopln, tl, p, q : integer;
    svcol : coltype;
    t : boolean;
    fd : filedesc;
    stat : stcode;
begin
    checkpoint;
    if fstate = blkmode then
        blockreset(false);              { reset, but stay here }
 
    if fileclone then
        fd := openclone(ioread);
    if charclone then                   { character rectangle }
    begin
        svtopln := topln;  svcol := fscol;      { where we are }
        fetch(fsrow);
        curln := topln + fsrow - toprow - 1;
        j := 0;
        if fileclone then
            t := getline(sclone, fd, maxstr)
        else
            t := true;                  { internal; already in sclone }
        while t do
        begin
            tl := max(length(sclone)-2, 1);         { at least one }
            tl := min(tl, maxstr-svcol-xoset-2);    { not beyond m/str }
            insspaces(tl);              { use local report code }
            q := svcol + xoset + 1;
            p := length(fstext);
            if p < q then
            begin                       { leading spaces needed }
                while p < q do
                begin
                    fstext[p] := blank;
                    p := p + 1
                end;
                fstext[p] := newline;
                fstext[p+1] := endstr
            end;
            for k := 1 to tl do
            begin
                if fstext[q] = newline then
                begin                       { make the line longer }
                    fstext[q+1] := newline;
                    fstext[q+2] := endstr
                end;
                fstext[q] := sclone[k];     { put the text in }
                q := q + 1
            end;
            fschanged := true;
            replace;                    { dump cache }
            j := j + 1;
            fscol := svcol;
            topln := topln + 1;
            if fileclone then
                t := getline(sclone, fd, maxstr)
            else
                t := false              { internal; once only }
        end;
        topln := svtopln;               { where we came from }
        cmessage('Characters inserted :  &', j, tl)
    end
    else
    begin                               { line range }
        fetch(fsrow);
        curln := topln + fsrow - toprow - 1;
        j := 0;  stat := ok;
        repeat
            if fileclone then
                t := getline(sclone, fd, maxstr)
            else
                t := true;              { internal; already in sclone }
            if t then
            begin
                stat := puttxt(sclone);
                if stat = ok then
                    j := j + 1
            end;
            if not fileclone then
                t := false
        until (stat <> ok) or (not t);
        k := (botrow - toprow) div 2;
        if (j < (botrow - fsrow)) and (j <= k) then
            scrolldown(fsrow, botrow, j);   { assist image correction }
        cmessage('Text lines inserted :  &', j, -1)
    end;
    if fileclone then
        closef(fd);
    fileimage                           { final image correction }
end;  {insclone}
 
 
{ ****************************************************** clfsmisc *** }
{ *                                                                 * }
{ *       CURLEW :: Full-screen editor miscellaneous requests       * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ lmtmsg -- show file limit reached message }
procedure lmtmsg (firstln : boolean);
begin
    setcursor(maxrow, 0);
    erasetoright;
    textchar(lbrack);
    literal(' *** Image top row is & ');
    if firstln then
        literal('first line in buffer &  ')
    else
        literal('last line in buffer &   ');
    textchar(rbrack)
end;  {lmtmsg }
 
 
{ goup -- upwards cursor movement from u/l violation }
procedure goup;
var
    oldtopln : integer;
begin
    if fsrow > toprow then
        fsrow := fsrow - 1
    else if cscroll <= 0 then
        fsrow := botrow
    else
    begin
        oldtopln := topln;
        topln := topln - cscroll;
        topln := max(topln, 1);
        if topln = oldtopln then
        begin
            lmtmsg(true);
            fsrow := botrow
        end
        else
        begin
            scrolldown(toprow, botrow, oldtopln-topln);
            fileimage;
            fsrow := fsrow + (oldtopln - topln - 1)
        end
    end
end;  {goup}
 
 
{ godown -- downwards cursor movement from u/l violation }
procedure godown;
var
    oldtopln : integer;
begin
    if fsrow < botrow then
        fsrow := fsrow + 1
    else if cscroll <= 0 then
        fsrow := toprow
    else
    begin
        oldtopln := topln;
        topln := topln + cscroll;
        topln := min(topln, lastln);
        topln := max(topln, 1);
        if topln = oldtopln then
        begin
            lmtmsg(false);
            fsrow := toprow
        end
        else
        begin
            scrollup(toprow, botrow, topln-oldtopln);
            fileimage;
            fsrow := fsrow - (topln - oldtopln - 1)
        end
    end
end;  {godown}
 
 
{ goleft -- left cursor movement from u/l violation }
procedure goleft;
begin
    if fscol > 0 then
        fscol := fscol - 1
    else
    begin
        goup;
        fscol := maxcol
    end
end;  {goleft}
 
 
{ goright -- right cursor movement from u/l violation }
procedure goright;
begin
    if fscol < maxcol then
        fscol := fscol + 1
    else
    begin
        godown;
        fscol := 0
    end
end;  {goright}
 
 
{ wordright -- cursor movement to start of next word }
procedure wordright;
var
    irow, trow : rowtype;
    icol : coltype;
    ln : rowtext;
    found, looped : boolean;
    savscroll : integer;
begin
    irow := fsrow;  icol := fscol;  trow := fsrow;
    savscroll := cscroll;
    if cscroll = 1 then
        cscroll := 2;                   { avoids looping problem }
    getrow(trow, ln);
    looped := false;
    if ln[fscol] <> blank then
        repeat                          { find blank }
            goright;
            if fsrow <> trow then
            begin
                trow := fsrow;
                getrow(trow, ln)
            end;
            found := ln[fscol] = blank;
            looped := (fsrow = irow) and (fscol = icol)
        until found or looped;
    if not looped then
        repeat                          { find non-blank }
            goright;
            if fsrow <> trow then
            begin
                trow := fsrow;
                getrow(trow, ln)
            end;
            found := ln[fscol] <> blank;
            looped := (fsrow = irow) and (fscol = icol)
        until found or looped;
    cscroll := savscroll
end;  {wordright}
 
 
{ wordleft -- cursor movement to start of previous word }
procedure wordleft;
var
    irow, trow : rowtype;
    icol : coltype;
    ln : rowtext;
    found, looped : boolean;
    savscroll : integer;
begin
    irow := fsrow;  icol := fscol;  trow := fsrow;
    savscroll := cscroll;
    if cscroll = 1 then
        cscroll := 2;                   { avoids looping problem }
    getrow(trow, ln);
    looped := false;
    if ln[fscol] <> blank then
        repeat                          { find blank }
            goleft;
            if fsrow <> trow then
            begin
                trow := fsrow;
                getrow(trow, ln)
            end;
            found := ln[fscol] = blank;
            looped := (fsrow = irow) and (fscol = icol)
        until found or looped;
    if not looped then
        repeat                          { find non-blank }
            goleft;
            if fsrow <> trow then
            begin
                trow := fsrow;
                getrow(trow, ln)
            end;
            found := ln[fscol] <> blank;
            looped := (fsrow = irow) and (fscol = icol)
        until found or looped;
    if not looped then
        repeat                          { find blank }
            goleft;
            if fsrow <> trow then
            begin
                trow := fsrow;
                getrow(trow, ln)
            end;
            found := ln[fscol] = blank;
            looped := (fsrow = irow) and (fscol = icol)
        until found or looped;
    if found then
    begin
        cscroll := 0;  goright;         { forward to start of word }
    end;
    cscroll := savscroll
end;  {wordleft}
 
 
{ textlocate -- host assisted text location in basic block operation }
procedure textlocate (start : boolean);
var
    ln : rowtext;
    tcol : coltype;
begin
    getrow(fsrow, ln);
    if start then
    begin
        tcol := 0;
        while (tcol < maxcol) and (ln[tcol] = blank) do
            tcol := tcol + 1;
        if ln[tcol] = blank then
            tcol := 0
    end
    else
    begin
        tcol := maxcol;
        while (tcol > 0) and (ln[tcol] = blank) do
            tcol := tcol - 1;
        if (ln[tcol] <> blank) and (tcol < maxcol) then
            tcol := tcol + 1;
    end;
    fscol := tcol
end;  {textlocate}
 
 
{ wordwrap -- transfer word at end of line to new next line }
procedure wordwrap;
var
    i, j, k, p, q : integer;
    ncol : coltype;
    rem : chstring;
    stat : stcode;
begin
    if fstate = normal then
    begin
        fetch(fsrow);
        rem[1] := newline;  rem[2] := endstr;
        ncol := 0;
        if inswrap then
        begin
            j := length(fstext) - 1;
            q := maxcol + xoset;
            if j > q then
            begin
                j := q + 1;  k := j;  i := j - (maxcol div 2);
                while (j > i) and (fstext[j] <> blank) do
                    j := j - 1;
                if fstext[j] = blank then
                    j := j + 1
                else
                    j := k + 1;
                p := 0;
                while p < xoset do
                begin                   { blanks to left of margin }
                    p := p + 1;
                    rem[p] := blank
                end;
                scopy(fstext, j, rem, p+1);
                fstext[j] := newline;
                fstext[j+1] := endstr;
                verify;                 { first image correction }
                j := j - xoset - 2;
                ncol := maxcol - j
            end
        end;
        curln := topln + fsrow - toprow;
        stat := puttxt(rem);            { after previous cursor line }
        if fsrow >= pinrow then
        begin
            topln := topln + 1;
            scrollup(toprow, fsrow, 1)
        end
        else
        begin
            fsrow := fsrow + 1;
            scrolldown(fsrow, botrow, 1)
        end;
        filetext(fsrow);                { second image correction }
        fscol := ncol
    end
    else
        goright;
end;  {wordwrap}
 
 
{ delkey -- handle DEL keystroke at left screen margin }
procedure delkey;
var
    fsc : coltype;
begin
    goleft;
    textlocate(false);                  { after end of text }
    setcursor(fsrow, fscol)
end;  {delkey}
 
 
{ ****************************************************** clctrl ***** }
{ *                                                                 * }
{ *      CURLEW :: T-TOKEN from CTRL key or data u/l violation      * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ control -- token return (full-screen) from control key }
procedure control (rc : smallint);
begin
    case rc of
 
    nul:    if fscol = maxcol then
                wordwrap                { power-typing support }
            else
                goright;                { block mode mousetrap }
 
    ctla:   align;                      { align text with cursor }
 
    ctlb:   if fstate <> blkmode then
                blockset                { set block mode }
            else
                blockreset(true);       { reset block mode }
 
    ctlc:   textlocate(false);          { text end (basic block) }
 
    ctld:   bdelblanks;                 { delete blanks from cursor }
 
    ctle:   bdelchars;                  { block delete characters }
 
    ctlf:   if htkeys then
                goleft                  { kprevtab u/l violation }
            else
                wordleft;               { cursor left to previous word }
 
    ctlg:   begin                       { home (basic block) }
                fsrow := toprow;
                fscol := 0
            end;
 
    ctlh:   goleft;                     { kcsrleft u/l violation }
 
    ctli:   if htkeys then
                goright                 { knexttab u/l violation }
            else
            begin
                if fstate = blkmode then
                    soundalarm          { not going to play }
                else
                    tabinsert           { insertion at current indent }
            end;
 
    ctlj:   godown;                     { kcsrdown u/l violation }
 
    ctlk:   goup;                       { kcsrup u/l violation }
 
    ctll:   goright;                    { kcsrright u/l violation }
 
    ctlm:   begin                       { RETURN (basic block) }
                fscol := 0;
                if fsrow >= botrow
                    then fsrow := toprow
                    else fsrow := fsrow + 1;
            end;
 
    ctln:   insclone;                   { insert saved text }
 
    ctlo:   splitline;                  { split line before cursor }
 
    ctlp:   if (fstate = blkmode) and blkpara then
                paralines               { paragraph line group }
            else
                combinelines;           { combine line with next }
 
 
    ctlq:   clonetext(false);           { block save lines }
 
    ctlr:   delwords;                   { delete word }
 
    ctls:   binsspaces;                 { block insert spaces }
 
    ctlt:   deltosol;                   { delete to start of line }
 
    ctlu:   bdellines;                  { block delete lines }
 
    ctlv:   wordright;                  { cursor right to next word }
 
    ctlw:   clonetext(true);            { block save characters }
 
    ctlx:   textlocate(true);           { text start (basic block) }
 
    ctly:   bdeltoeol;                  { block delete to end of line }
 
    ctlz:   fscol := 0;                 { line start (basic block) }
 
    end;  { case}
    setcursor(fsrow, fscol)
end;  {control}
 
 
{ ****************************************************** clfsreq **** }
{ *                                                                 * }
{ *         CURLEW :: Full-screen editor T-TOKEN dispatch           * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ fsrequest -- full-screen editor request }
procedure fsrequest (rc : smallint);
var
    acode : integer;
    fks : chstring;
begin
    replace;                            { safety }
    getloc(fsrow, fscol);
    if fstate = normal then
        getmode(nfsomode);              { logs "icharmode" setting }
    if tokreq or fscmask then
    begin                               { correct the file image }
        fileimage;
        setcursor(fsrow, fscol);
        tokreq := false;
        fscmask := false
    end;
 
    if mousetrap = armed then
        mousetrap := sprung;            { block mode WILL be reset! }
 
    if rc > del then
    begin                               { reqtoken or session restart }
        if (rc > 128) and (rrend <> defrend) then
        begin                               { session restart fix }
            setmode(knextfld, 50);          { next field key ... }
            setmode(kprevfld, 53);          { prev field key ... }
            viewstate(fstate);              { now correct mode array }
            ruler(toprow-1);
            ruler(botrow+1);
            setcursor(fsrow, fscol)
        end
    end
    else if (rc >= nul) and (rc <= ctlz) then
        control(rc)                     { control key or u/l violation }
    else if rc = del then
        delkey                          { del key at left margin }
    else if fnkey(rc, acode) = 0 then
        soundalarm                      { failed function key test }
    else
    begin                               { it's a function key }
        if mousetrap = sprung then
            blockreset(false);          { no point in leaving it set }
        edprompt;
        plantkeynbr(acode);
        curln := min(lastln, topln+fsrow-toprow);
        context(ctlm)
    end;
 
    if appstate = fsereq then
    begin
        getloc(fsrow, fscol);           { track cursor }
        if mousetrap = sprung then
        begin
            blockreset(false);
            setcursor(fsrow, fscol)
        end
    end
end;  {fsrequest}
 
 
{ ****************************************************** clinit ***** }
{ *                                                                 * }
{ *           CURLEW :: Editor initialisation routines              * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ initmodes -- set up mode array copies for each editor state }
procedure initmodes;
begin
    setmode(reqshift, 1);           { request host shift operations }
 
    { set up session control functions as recommended }
    setmode(kinthost, 33);          { interrupt host;   ESC then "!" }
    setmode(ksuspend, 62);          { suspend session;  ESC then ">" }
    setmode(krestart, 63);          { restart session;  ESC then "?" }
 
    getmode(bblkmode);              { save the embryo mode array }
 
    { next three will be reset, but may leave codes on terminal keys }
    setmode(kenter, 13);            { separate enter key;  RETURN }
    setmode(knextfld, 50);          { next field key;  ESC then "2" }
    setmode(kprevfld, 53);          { prev field key;  ESC then "5" }
 
    { set up the other elements common to each state }
    bblkmode[kcsrup]    := ctlk;    { cursor up }
    bblkmode[kcsrdown]  := ctlj;    { cursor down;  LINEFEED }
    bblkmode[kcsrleft]  := ctlh;    { cursor left;  BACKSPACE }
    bblkmode[kcsrright] := ctll;    { cursor right }
    bblkmode[knexttab]  := ctli;    { next tab;  TAB }
    bblkmode[kprevtab]  := ctlf;    { previous tab }
    bblkmode[kleftupd]  := ctlz;    { line start }
    bblkmode[kfirstns]  := ctlx;    { text start }
    bblkmode[kalastns]  := ctlc;    { text end }
    bblkmode[keraprev]  := del;     { erase previous;  DEL }
    bblkmode[khomefld]  := ctlg;    { home field }
 
    { set up the mode array for context operation }
    ctxtmode := bblkmode;
    ctxtmode[kenter]    := ctlm;    { enter;  RETURN }
    ctxtmode[kinsmode]  := ctlw;    { insertion toggle }
    ctxtmode[keraright] := ctly;    { erase to right }
    ctxtmode[kinsspac]  := ctls;    { insert space }
    ctxtmode[kdelchar]  := ctle;    { delete character }
    ctxtmode[keraline]  := ctlu;    { erase line }
 
    { set up the common elements for line and character operation }
    nfsomode := bblkmode;
    nfsomode[ilinerow]  := pinrow;  { preferred insertion row }
    nfsomode[kinsmode]  := ctlw;    { insertion toggle }
    nfsomode[keraright] := ctly;    { erase to right }
    nfsomode[kinsspac]  := ctls;    { insert space }
    nfsomode[kdelchar]  := ctle;    { delete character }
    nfsomode[kinsline]  := ctlq;    { insert line }
    nfsomode[kdelline]  := ctlu;    { delete line }
    nfsomode[ksplline]  := ctlm;    { split line;  RETURN }
    { set from "initprofile" : kappline (from a+) and notify (from i+) }
 
    { set up the mode array for block operation }
    blokmode := bblkmode;
    blokmode[knewline]  := ctlm;    { new line;  RETURN }
 
    { now do the resets for basic block operation }
    bblkmode[kleftupd]  := nul;     { line start }
    bblkmode[kfirstns]  := nul;     { text start }
    bblkmode[kalastns]  := nul;     { text end }
    bblkmode[khomefld]  := nul;     { home field }
end;  {initmodes}
 
 
{ parsecmd -- prime argument list from command parameters }
procedure parsecmd;
var
    idx : integer;
begin
    getinf(cmdpars, cmdline, maxstr);
    if cmdline[1] <> endstr then
    begin
        idx := 1;
        skipbl(cmdline, idx);
        if cmdline[idx] <> newline then
        begin                           { filename given }
            nbrcmdargs := 1;
            cmdargidx[1] := idx;
            while (cmdline[idx] <> blank)
                and (cmdline[idx] <> newline) do
                    idx := idx + 1;
            cmdline[idx] := endstr;
            idx := idx + 1;
            skipbl(cmdline, idx);
            if (cmdline[idx] <> newline)
                and (cmdline[idx] <> endstr) then
            begin                       { initial command given }
                nbrcmdargs := 2;
                cmdargidx[2] := idx
            end
        end
    end
end;  {parsecmd}
 
 
{ setrkey -- set up relocation function key string }
procedure setrkey (var pars : chstring;
                   n : integer;
                   reloc : integer);
var
    tkey : chstring;
    j, rval : integer;
begin
    setstring(tkey, 'f?/#+&                  ');
    tkey[2] := dig0 + n;
    rval := reloc;
    if rval < 0 then
    begin
        tkey[5] := minus;
        rval := -rval
    end;
    j := itoc(rval, tkey, 6);
    tkey[j] := slash;
    tkey[j+1] := blank;
    tkey[j+2] := endstr;
    scopy(tkey, 1, pars, length(pars)+1)
end;  {setrkey}
 
 
{ seteobkey -- set up end of buffer function key string }
procedure seteobkey (var pars : chstring;
                     n : integer);
var
    tkey : chstring;
    j, k : integer;
begin
    setstring(tkey, 'f??/$;#-&               ');
    k := n div 10;  tkey[2] := dig0 + k;
    k := n mod 10;  tkey[3] := dig0 + k;
    j := itoc(botrow-toprow, tkey, 9);
    tkey[j] := slash;
    tkey[j+1] := blank;
    tkey[j+2] := endstr;
    scopy(tkey, 1, pars, length(pars)+1)
end;  {seteobkey}
 
 
{ initprofile -- initialise editor global parameters }
procedure initprofile;
var
    pars, pfile : chstring;
    litfile : isochar;
    fd : filedesc;
    j, ht : integer;
    junk : stcode;
begin
    { must initialise the following before a doset f/r/s/x call }
    for j := minkey to maxkey do
    begin
        kdefs[j] := newline;  kptrs[j] := j;
        kpick[j] := false
    end;
    kdmax := maxkey;
    rrend := 99;  gbleos := 0;  xoset := 0;
 
    { basic profile }
    setstring(pars, 'a+ b- c- d- e- h+ i+ j+ ');
    appstring(pars, 'l+ m2 n- o0 p0 r7 s1 t* ');
    appstring(pars, 'u- v- w70 x0 y0 z+&     ');
    ht := botrow - toprow + 1;
    setrkey(pars, 1, ht div 2);
    setrkey(pars, 2, ht);
    appstring(pars, 'f3/./ &                 ');
    setrkey(pars, 4, -(ht div 2));
    setrkey(pars, 5, -ht);
    appstring(pars, 'f6/prompt/ f7://: &     ');
    appstring(pars, 'f8/keep/ &              ');
    appstring(pars, 'f9/view =/ f10/view/ &  ');
    junk := doset(pars, 1);
 
    { predefined formatting keys }
    setstring(pars, 'f11/format p5/ &        ');
    appstring(pars, 'f12/format/ &           ');
    appstring(pars, 'f13/format p-5/ &       ');
    appstring(pars, 'f14/format i5/ &        ');
    appstring(pars, 'f15/format i5p-5/ &     ');
    appstring(pars, 'f16/format i10/ &       ');
    appstring(pars, 'f17/format lp0/ &       ');
    appstring(pars, 'f18/. format lp0/ &     ');
    appstring(pars, 'f19/.,. format c/ &     ');
    appstring(pars, 'f20/.,. format r/ &     ');
    junk := doset(pars, 1);
 
    { predefined tab stop groups, absolute relocation, windowing }
    setstring(pars, 'f21/set t10 16 35 40 45 ');
    appstring(pars, '50 71/ &                ');
    appstring(pars, 'f22/set t*4/ &          ');
    appstring(pars, 'f23/set t*5/ &          ');
    appstring(pars, 'f24/set t*8/ &          ');
    appstring(pars, 'f25/1/ &                ');
    seteobkey(pars, 26);
    appstring(pars, 'f27/set x0/ &           ');
    appstring(pars, 'f28/set x40-/ &         ');
    appstring(pars, 'f29/set x40+/ &         ');
    appstring(pars, 'f30/filename/ &         ');
    junk := doset(pars, 1);
 
    { does any site dare to override the chosen default settings? }
    getinf(clsitedef, pfile, maxstr);
    if pfile[1] <> endstr then
        junk := doset(pfile, 1);        { (how sad...) }
 
    { now look for user overrides }
    getinf(litfchar, pfile, maxstr);
    litfile := pfile[1];                { save literal file character }
    getinf(clprofile, pfile, maxstr);
    if pfile[1] <> endstr then
    begin                               { process user profile file }
        if pfile[1] = litfile then
            junk := doset(pfile, 2)         { literal file }
        else
        begin                               { disk file }
            fd := openf(pfile, ioread);
            if fd <> ioerror then
            begin
                while getline(pars, fd, maxstr) do
                    junk := doset(pars, 1);
                closef(fd)
            end
        end
    end
end;  {initprofile}
 
 
{ resumption -- check for journal log from previous session }
function resumption
        : boolean;
var
    islog, eof : boolean;
    i : integer;
    lin : chstring;
    stat : stcode;
    warnrow : rowtype;
    warncol : coltype;
begin
    islog := getline(lin, jfin, maxstr);
    if not islog then
    begin                               { fresh session }
        jfcontrol(iowrite);
        if jfout = ioerror then
        begin
            showlit('  No journal file is ava');
            showlit('ilable for this session&');
            showc(newline);  showc(newline)
        end
    end
    else
    begin                               { previous session rebuild }
        { first run up a flag }
        warnrow := maxrow div 2;
        warncol := (maxcol - 48) div 2;
        setcursor(warnrow, warncol);
        setmode(selectgr, rrend);
        literal(' Last session rebuild in');
        literal(' progress; please wait! ');
        setmode(selectgr, defrend);
        { ... file read will flush this message out to the terminal }
 
        { now rebuild session from journal file }
        autoview := false;              { no auto "v" if "edit" }
        rebuild := true;
        repeat
            showcmd(blankrow);          { reset conversation buffer }
            i := 1;
            cursave := curln;
            if getlist(lin, i, status) = ok then
                if status <> err then
                    status := docmd(lin, i, false, status);
            appstate := coned;
            eof := not getline(lin, jfin, maxstr);
            if cstate <> concmd then
            begin
                if cstate = conapp then
                begin
                    stat := ok;
                    repeat
                        if (lin[1] = period) and (lin[2] = newline)
                        then
                            stat := enddata
                        else
                            stat := puttxt(lin);
                        eof := not getline(lin, jfin, maxstr);
                    until (stat <> ok) or eof
                end;
                cstate := concmd
            end;
        until eof;
        rebuild := false;
        jfcontrol(ioappend);            { continue from there }
 
        { report status to the user }
        setcursor(warnrow, 0);
        erasetoright;
        showcmd(blankrow);
        showlit('  T A K E   N O T E@n@n&');
 
        showlit('  CURLEW has rebuilt you');
        showlit('r interrupted last sessi');
        showlit('on as far as possible.@n');
 
        showlit('  Please check the file ');
        showlit('buffer contents carefull');
        showlit('y before proceeding.@n@n');
        filestat
    end;
    resumption := islog
end;  {resumption}
 
 
{ edstart -- start up editor }
procedure edstart;
var
    j : integer;
    junk : stcode;
    avsave : boolean;
begin
    appstate := coned;
    cstate := concmd;
    msgdone := false;
    toprow := 2;                { top of conversation or file display }
    botrow := maxrow - 2;       { bottom of file display }
    topused := false;           { top row not used }
    pinrow := botrow - 2;       { preferred insertion row }
    vtitle[1] := newline;  vtitle[2] := endstr; { no title yet }
    initmodes;                  { set up the various mode arrays }
 
    jfcontrol(ioread);          { journal file recovery check open }
    setbuf;                     { sets up the file buffer }
    pat[1] := endstr;           { no last pattern yet }
    savefile[1] := endstr;      { no saved filename yet }
 
    fileclone := true;          { no internal string clone }
    cloneexists := false;       { no clone file }
    charclone := false;         { but if we use it, it's a line clone }
    mousetrap := safe;          { not near block ^Q or ^W }
    rebuild := false;           { not rebuilding a session }
 
    tokreq := false;            { no token request outstanding }
    fscmask := false;           { ...and no control characters masked }
    cmdrow := maxrow;           { command entry row }
    cmdcol := 0;                { force setupdate from edprompt }
    erasedisplay;
    getrow(0, blankrow);        { this row is, of course, blank }
 
    initprofile;                { editor profile }
 
    cbrows := cbmax + 1;        { rows in conversation buffer }
    for j := 0 to cbmax do      { clear conversation buffer }
        cbuf[j] := blankrow;
    ctxtimage;
    showcmd(blankrow);
 
    parsecmd;                   { get command parameters }
    avsave := autoview;
    if resumption then          { session rebuilt from journal file }
        nbrcmdargs := 0;                { ignore user parameters }
 
    if getarg(1, savefile, maxstr) then
    begin
        showlit('  Reading from file  :  ');
        showstr(savefile);
        showc(newline);
        junk := doread(0, savefile, false, ioerror);
        curln := min(1, lastln);
        changed := false;
        journal(0, 0, lete, savefile)
    end;
 
    if getarg(2, prevlin, maxstr) then
    begin
        flushcb;                        { flush file read verification }
        setcursor(cmdrow, cmdcol);      { cursor on command line }
        getprevious;                    { pick up command ... }
        context(ctlm);                  { ... and execute it }
        showcmd(blankrow)               { re-prime conversation buffer }
    end
    else
    begin
        prevlin[1] := newline;
        prevlin[2] := endstr
    end;
 
    if appstate = coned then
    begin
        if autoview then
        begin                           { direct entry to "v" command }
            junk := doview(curln, plus);
            lastcb                          { for bottom line }
        end
        else
        begin                           { prompt for commands }
            showc(newline);
            showlit('  Enter commands...@n@n&');
            flushcb;
            setcursor(cmdrow, cmdcol)
        end
    end;
    autoview := avsave
end;  {edstart}
 
 
{ ****************************************************** cldispat *** }
{ *                                                                 * }
{ *     CURLEW :: Fetch and primary dispatch of SSMP primitives     * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ service -- application T-TOKEN processing }
procedure service (rc : smallint);
begin
    case appstate of
 
    entry:
        if (maxrow < 15) or (maxcol < 71) then
        begin
            setcursor(maxrow, 0);
            literal('Needs 16 rows by 72 colu');
            literal('mns minimum screen size.');
            screenmode := false
        end
        else edstart;               { start up editor }
 
    coned:      context(rc);        { context editor line entry }
    fsereq:     fsrequest(rc);      { full-screen editor request }
    fsecmd:     context(rc);        { context cmd from f/s editor }
 
    end;  {case}
 
    { candle still burning?  return the token! }
    if screenmode then sendtoken(tokencode);
end;  {service}
 
 
{ dispatch -- host application, fetch and dispatch T-primitives }
procedure dispatch;
var
    pc : isochar;
    pars : primpar;
begin
    getprimitive(pc, pars);   { fetch next primitive }
    if pc = capa then
        service(pars[1])              { *must* act on T-TOKEN(reqcode) }
    else if appstate = fsereq then
    begin
        case pc of
 
        star:       { T-CHARACTER(ch);  replace character }
            repchar(pars[1]);
 
        capb:       { T-SETCURSOR(newrow, newcol);  track cursor }
            getloc(fsrow, fscol);
 
        capc:   ;   { T-SETMODE(index, ivalue);  already logged }
 
        capd:       { T-ERASETORIGHT;     delete from cursor to eol }
            deltoeol;
 
        cape:       { T-INSERTSPACE(nsp); insert spaces before cursor }
            insspaces(pars[1]);
 
        capf:       { T-DELETECHAR(nch);  delete characters at cursor }
            delchars(pars[1]);
 
        capg:       { T-ERASEPREV(nch) }
            bserases(pars[1]);
 
        caph:       { T-INSERTLINE(nln);  insert lines before cursor }
            inslines(pars[1]);
 
        capi:       { T-DELETELINE(nln);  delete lines at cursor }
            dellines(pars[1]);
 
        capj:       { T-APPENDLINE;       append one line at cursor }
            apponeline;
 
        capk:       { T-SPLITLINE;        split one line before cursor }
            splitoneline;
 
        capl:       { T-SETFIELD(fidx);   track cursor }
            getloc(fsrow, fscol);
 
        end   {case}
    end
end;  {dispatch}
 
 
{ ****************************************************** clmain ***** }
{ *                                                                 * }
{ *          CURLEW :: Main program entry and input loop            * }
{ *                                                                 * }
{ ******************************************************************* }
 
 
{ startapp -- application initialisation }
procedure startapp;
begin
    filenbr := 0;  startlog;
    appstate := entry;  tokencode := 0;
end;  {startapp}
 
 
{ stopapp -- application closedown }
procedure stopapp;
var
    cname : chstring;
    junk : boolean;
begin
    clrbuf;
    if cloneexists then
    begin
        getinf(clclone, cname, maxstr);
        junk := remove(cname)
    end
end;  {stopapp}
 
 
{ formprompt -- set up the ssmp negotiation user text prompt }
procedure formprompt (var ps : chstring);
begin
    setstring(ps, 'Please press the RETURN ');
    appstring(ps, 'key to continue.&       ')
end;  {formprompt}
 
 
begin  { editor main routine }
    formprompt(lin);                    { "Please press RETURN ..." }
    startssmp(screenmode, lin);         { session entry negotiation }
    if screenmode then
    begin
        startapp;                       { application initialisation }
        while screenmode do dispatch;   { fetch and process primitives }
        stopapp;                        { application closedown }
        stopssmp                        { ssmp session exit }
    end
    else
    begin
        setstring(lin, '*** Curlew can only be u');
        appstring(lin, 'sed from a terminal whic');
        appstring(lin, 'h supports SSMP.@n&     ');
        putstr(lin, stderr)
    end
end;  {editor}
 
 
begin  { curlew main program }
    initsoft(idef);                 { software tools environment }
    editor;                         { call the editor }
    closesoft                       { close the environment }
end.   {main program}
