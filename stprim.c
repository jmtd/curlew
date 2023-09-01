/*********************************************************************
*
*       Software Tools -- UNIX primitives
*
**********************************************************************
*
*   SGETSTE   --  get software tools environment
*   SRELSTE   --  release software tools environment
*   SINTRPT   --  select attention interrupt (break) processing
*   SOPEN     --  open a file, return file descriptor
*   SCREATE   --  create file, open it, return file descriptor
*   SCLOSE    --  close a file
*   SREMOVE   --  remove a file
*   SRENAME   --  rename a file
*   SGETLIN   --  get next line from file descriptor
*   SGETCF    --  get next character from file descriptor
*   SPUTSTR   --  put string to file descriptor
*   SPUTCF    --  put character to file descriptor
*   SGETIDX   --  return get/put next i/o index for later get
*   SSEEK     --  set position of next get
*   SGETFDS   --  get file descriptor status
*   SPROMPT   --  set standard input prompt string
*   SGETINF   --  return information according to index
*   SSYSCMD   --  execute command string
*   SFFCOPY   --  copy from one file descriptor to another (dummy)
*   SLOGUSE   --  log use of software tools application    (dummy)
*   STWAIT    --  delay execution for a time
*   SIOCTRL   --  set state of opened file descriptor
*   SSECURE   --  secure disk copy of opened file. (dummy)
*   SIXCOPY   --  copy specified record from one fd to another
*   SITOXPC   --  internal (binary) to external (text) file pointer
*   SXTOIPC   --  external (text) to internal (binary) file pointer
*   SMAILER   --  interface to e-mail spooler (dummy)
*   SREWIND   --  rewind (read) or reset (write, append) file desc
*
*********************************************************************/

#include <stdio.h>

#include "st.typ.h"
#include "local.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <signal.h>
#ifdef UTS
#include <time.h>
#else
#include <sys/time.h>
#endif
#include <errno.h>
#include <pwd.h>
#include <utmp.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#ifdef SYSV
#include <termio.h>
#endif
#include <sys/file.h>

#include "iso.h"

/*
** Character conversion tables from natural code to iso standard
** In some systems, these convert EBCDIC to ISO, here all that
** is required is to strip parity bits.
*/
static char isonat[] = {
NUL,     CTLA,    CTLB,    CTLC,    CTLD,    CTLE,    CTLF,    CTLG,
CTLH,    CTLI,    CTLJ,    CTLK,    CTLL,    CTLM,    CTLN,    CTLO,
CTLP,    CTLQ,    CTLR,    CTLS,    CTLT,    CTLU,    CTLV,    CTLW,
CTLX,    CTLY,    CTLZ,    ESC,     28,      29,      30,      31,
BLANK,   EXCLAM,  DQUOTE,  SHARP,   DOLLAR,  PERCENT, AMPER,   SQUOTE,
LPAREN,  RPAREN,  STAR,    PLUS,    COMMA,   MINUS,   PERIOD,  SLASH,
DIG0,    DIG1,    DIG2,    DIG3,    DIG4,    DIG5,    DIG6,    DIG7,
DIG8,    DIG9,    COLON,   SEMICOL, LESS,    EQUALS,  GREATER, QUESTION,
ATSIGN,  CAPA,    CAPB,    CAPC,    CAPD,    CAPE,    CAPF,    CAPG,
CAPH,    CAPI,    CAPJ,    CAPK,    CAPL,    CAPM,    CAPN,    CAPO,
CAPP,    CAPQ,    CAPR,    CAPS,    CAPT,    CAPU,    CAPV,    CAPW,
CAPX,    CAPY,    CAPZ,    LBRACK,  BAKSLASH,RBRACK,  CFLEX,   USCORE,
GRAVE,   LETA,    LETB,    LETC,    LETD,    LETE,    LETF,    LETG,
LETH,    LETI,    LETJ,    LETK,    LETL,    LETM,    LETN,    LETO,
LETP,    LETQ,    LETR,    LETS,    LETT,    LETU,    LETV,    LETW,
LETX,    LETY,    LETZ,    LBRACE,  BAR,     RBRACE,  CTILDE,  DEL,
NUL,     CTLA,    CTLB,    CTLC,    CTLD,    CTLE,    CTLF,    CTLG,
CTLH,    CTLI,    CTLJ,    CTLK,    CTLL,    CTLM,    CTLN,    CTLO,
CTLP,    CTLQ,    CTLR,    CTLS,    CTLT,    CTLU,    CTLV,    CTLW,
CTLX,    CTLY,    CTLZ,    ESC,     28,      29,      30,      31,
BLANK,   EXCLAM,  DQUOTE,  SHARP,   DOLLAR,  PERCENT, AMPER,   SQUOTE,
LPAREN,  RPAREN,  STAR,    PLUS,    COMMA,   MINUS,   PERIOD,  SLASH,
DIG0,    DIG1,    DIG2,    DIG3,    DIG4,    DIG5,    DIG6,    DIG7,
DIG8,    DIG9,    COLON,   SEMICOL, LESS,    EQUALS,  GREATER, QUESTION,
ATSIGN,  CAPA,    CAPB,    CAPC,    CAPD,    CAPE,    CAPF,    CAPG,
CAPH,    CAPI,    CAPJ,    CAPK,    CAPL,    CAPM,    CAPN,    CAPO,
CAPP,    CAPQ,    CAPR,    CAPS,    CAPT,    CAPU,    CAPV,    CAPW,
CAPX,    CAPY,    CAPZ,    LBRACK,  BAKSLASH,RBRACK,  CFLEX,   USCORE,
GRAVE,   LETA,    LETB,    LETC,    LETD,    LETE,    LETF,    LETG,
LETH,    LETI,    LETJ,    LETK,    LETL,    LETM,    LETN,    LETO,
LETP,    LETQ,    LETR,    LETS,    LETT,    LETU,    LETV,    LETW,
LETX,    LETY,    LETZ,    LBRACE,  BAR,     RBRACE,  CTILDE,  DEL,
};

static isochar natiso[] = {
GRAVE,   CTLA,    CTLB,    CTLC,    CTLD,    CTLE,    CTLF,    CTLG,
CTLH,    CTLI,    CTLJ,    CTLK,    CTLL,    CTLM,    CTLN,    CTLO,
CTLP,    CTLQ,    CTLR,    CTLS,    CTLT,    CTLU,    CTLV,    CTLW,
CTLX,    CTLY,    CTLZ,    ESC,     28,      29,      30,      31,
BLANK,   EXCLAM,  DQUOTE,  SHARP,   DOLLAR,  PERCENT, AMPER,   SQUOTE,
LPAREN,  RPAREN,  STAR,    PLUS,    COMMA,   MINUS,   PERIOD,  SLASH,
DIG0,    DIG1,    DIG2,    DIG3,    DIG4,    DIG5,    DIG6,    DIG7,
DIG8,    DIG9,    COLON,   SEMICOL, LESS,    EQUALS,  GREATER, QUESTION,
ATSIGN,  CAPA,    CAPB,    CAPC,    CAPD,    CAPE,    CAPF,    CAPG,
CAPH,    CAPI,    CAPJ,    CAPK,    CAPL,    CAPM,    CAPN,    CAPO,
CAPP,    CAPQ,    CAPR,    CAPS,    CAPT,    CAPU,    CAPV,    CAPW,
CAPX,    CAPY,    CAPZ,    LBRACK,  BAKSLASH,RBRACK,  CFLEX,   USCORE,
GRAVE,   LETA,    LETB,    LETC,    LETD,    LETE,    LETF,    LETG,
LETH,    LETI,    LETJ,    LETK,    LETL,    LETM,    LETN,    LETO,
LETP,    LETQ,    LETR,    LETS,    LETT,    LETU,    LETV,    LETW,
LETX,    LETY,    LETZ,    LBRACE,  BAR,     RBRACE,  CTILDE,  DEL,
GRAVE,   CTLA,    CTLB,    CTLC,    CTLD,    CTLE,    CTLF,    CTLG,
CTLH,    CTLI,    CTLJ,    CTLK,    CTLL,    CTLM,    CTLN,    CTLO,
CTLP,    CTLQ,    CTLR,    CTLS,    CTLT,    CTLU,    CTLV,    CTLW,
CTLX,    CTLY,    CTLZ,    ESC,     28,      29,      30,      31,
BLANK,   EXCLAM,  DQUOTE,  SHARP,   DOLLAR,  PERCENT, AMPER,   SQUOTE,
LPAREN,  RPAREN,  STAR,    PLUS,    COMMA,   MINUS,   PERIOD,  SLASH,
DIG0,    DIG1,    DIG2,    DIG3,    DIG4,    DIG5,    DIG6,    DIG7,
DIG8,    DIG9,    COLON,   SEMICOL, LESS,    EQUALS,  GREATER, QUESTION,
ATSIGN,  CAPA,    CAPB,    CAPC,    CAPD,    CAPE,    CAPF,    CAPG,
CAPH,    CAPI,    CAPJ,    CAPK,    CAPL,    CAPM,    CAPN,    CAPO,
CAPP,    CAPQ,    CAPR,    CAPS,    CAPT,    CAPU,    CAPV,    CAPW,
CAPX,    CAPY,    CAPZ,    LBRACK,  BAKSLASH,RBRACK,  CFLEX,   USCORE,
GRAVE,   LETA,    LETB,    LETC,    LETD,    LETE,    LETF,    LETG,
LETH,    LETI,    LETJ,    LETK,    LETL,    LETM,    LETN,    LETO,
LETP,    LETQ,    LETR,    LETS,    LETT,    LETU,    LETV,    LETW,
LETX,    LETY,    LETZ,    LBRACE,  BAR,     RBRACE,  CTILDE,  DEL,
};

/*********************************************************************
*
*   Static variables for remembering our file status etc
*
*********************************************************************/
#define MAXIOLEN MAXSTR         /* Less NEWLINE + ENDSTR */
#define P_LEN   20          /* Length of prompt string */
#define IOREAD  1       /* File open request codes */
#define IOWRITE 2
#define IOAPPEND 3
#define MAXINFO 64
#define IOMDDEFLT 0         /* Default file io mode */
#define IOMDASIS  1         /* SMP packets ready to write as is */
#define IOMDMSG   2         /* Message mode, CRLF modd off */

static  int     f_iostat[_NFILE]; /* IO MODE of an opened file */
static  int     f_stat[_NFILE];   /* Array of file statuses */
static  int     f_mode[_NFILE];   /* Array of open modes */
static  FILE    *fileptr[_NFILE] = {
    stdin, stdout, stderr
};                                /* Array of file pointers. Not needed in some
                                     systems, but good for portibility */
static  int     ucount;           /* No of times this user signed on */
static  char    prompt[MAXSTR+1]; /* Stored prompt string */
static  char    buf1[MAXSTR+1];   /* Buffers for string conversion */
static  char    buf2[MAXSTR+1];
static  struct sgttyb sttymode;   /* Mode to restore to terminal at exit */
static  int     fcntlflags;       /* Flags to restore fcntl mode at exit

/* Definitions for the various offsets of info items for SGETINF */

#define GINSFPFX    1   /*  Scratch filename  prefix           */
#define GINCMPAR    2   /*  Command parameter string           */
#define GINTDATE    3   /*  Time and date, #822 format         */
#define GINUNAME    4   /*  Username                           */
#define GINMAXFN    5   /*  SSMP maximum frames/packet         */
#define GINSORTD    6   /*  time and date, sortable format     */
#define SPARE2      7   /*  (not in use)                       */
#define GINLTFCH    8   /*  Literal file character, if any     */
#define GINFFCPY    9   /*  Fast file copy provided?           */
#define GINIXCPY   10   /*  Indexed copy provided?             */
#define GINCLEBF   11   /*  CURLEW :: edit buffer filename     */
#define GINCLCBF   12   /*  CURLEW :: clone buffer filename    */
#define GINCLPFN   13   /*  CURLEW :: profile filename         */
#define GINCLFN1   14   /*  CURLEW :: first safety filename    */
#define GINCLFN2   15   /*  CURLEW :: second safety filename   */
#define GINCLJFN   16   /*  CURLEW :: journal filename         */
#define GINCLHCM   17   /*  CURLEW :: system help command      */
#define GINCLHFN   18   /*  CURLEW :: simple help filename     */
#define GINCLLCL   19   /*  CURLEW :: local site override      */
#define GINCLRSV   20   /*  CURLEW :: rename save file switch  */
#define GINWIDCK   21   /*  CURLEW :: check line width overflow */
#define GINFOMAX   21   /*  Info items from 1 .. GINFOMAX are known */

static  char *   staticinfo[GINFOMAX + 1] = {
    0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0
};

static  struct passwd *info_pw;   /*  The user's password file entry        */
static  int info_pid;     /*  The current process id            */

/*********************************************************************
*
*   definitions of objects from the system libraries
*
*********************************************************************/

extern  int     errno;
char            *getenv();
struct  tm      *localtime();
long            time();
char            *malloc();

/*********************************************************************
*
*   badend -- Restore the modes of the terminal,
*             print a message and exit abnormally.
*
*********************************************************************/
badend(signum)
int signum;
{
    tidyup();
    fprintf(stderr,"\n\rError exit %d -- please a report fault\n\r",signum);
    signal(SIGQUIT,SIG_DFL);
    kill(getpid(),SIGQUIT);
}

/*********************************************************************
*
*   goodend -- Restore the modes of the terminal, exit normally.
*
*********************************************************************/
goodend() {
    tidyup();
    exit(1);
}

/*********************************************************************
*
*   tidyup -- Restore the modes of the terminal.
*
*********************************************************************/
tidyup() {
    fcntl(0,F_SETFL,fcntlflags);
    ioctl(1,TIOCSETP,&sttymode);
}

/*********************************************************************
*
*   SGETSTE(envlocn, littoiso, isotolit)
*
*   The first parameter is an integer.  SGETSTE returns the
*   address of the environment storage used by the primitives.
*   This should be supplied by the caller as the first parameter
*   of all of the other primitives.  SGETSTE must be called only
*   once, and before any other primitive.
*
*   The second two parameters are 256-byte translate tables set up
*   to allow the calling routine to perform literal (native code)
*   to ISO 646 translations, and vice versa.
*
*********************************************************************/
SGETSTE(env,littoiso,isotolit)
int *env;
itable littoiso;
chtable isotolit;
{
    register int i;
    register int utfd;
    struct utmp utbuf;
    register struct utmp *utptr;
    char *p;
    char * gincmpar();

    fcntl(0, F_GETFL, fcntlflags);
    ioctl(1, TIOCGETP, &sttymode);

    signal(SIGTERM, goodend);            /* Normal termination signal */
    signal(SIGHUP,  goodend);            /* Network disconnect */
    signal(SIGINT,  goodend);            /* Interrupt */

    signal(SIGQUIT, badend);             /* Abnormal exit */
    signal(SIGILL,  badend);             /* Illegal instruction */
    signal(SIGFPE,  badend);             /* Floating point exception */
    signal(SIGBUS,  badend);             /* Bus error - bad address */
    signal(SIGSEGV, badend);             /* Segmentation violation */

    *env = 0;
    for (i=0; i<256; i++) {
        littoiso[i] = natiso[i & 0377];
        isotolit[i] = isonat[i & 0377];
    }
/*
**  Initialise the file statuses.
*/
    for (i=0; i<_NFILE; i++)
        f_stat[i] = 0;
/*
**  Save some useful info for SGETINF calls
*/
    info_pw = getpwuid( getuid() );
    info_pid = getpid();

    if (staticinfo[GINSFPFX ] = malloc(13))
        sprintf(staticinfo[GINSFPFX ], "/tmp/tk%05d",info_pid);

    staticinfo[GINCMPAR ] = gincmpar();

    if (staticinfo[GINUNAME ] = malloc(strlen(info_pw->pw_name) + 1 ) )
        strcpy(staticinfo[GINUNAME ],info_pw->pw_name);

    if (staticinfo[GINMAXFN ] = malloc(2))
        strcpy(staticinfo[GINMAXFN ], "2");

    if (staticinfo[GINIXCPY ] = malloc(2))
        strcpy(staticinfo[GINIXCPY ], "y");

    if (staticinfo[GINCLEBF ] = malloc(17))
        sprintf(staticinfo[GINCLEBF ], "/tmp/cl%05.5debuf",info_pid);

    if (staticinfo[GINCLCBF ] = malloc(17))
        sprintf(staticinfo[GINCLCBF ], "/tmp/cl%05.5dclon",info_pid);

    if (staticinfo[GINCLPFN ] = malloc(strlen(info_pw->pw_dir) + 11));
        sprintf(staticinfo[GINCLPFN ], "%s/.curlewrc",info_pw->pw_dir);

    if (staticinfo[GINCLFN1 ] = malloc(17))
        sprintf(staticinfo[GINCLFN1 ], "/tmp/cl%05.5dsafe",info_pid);

    if (staticinfo[GINCLFN2 ] = malloc(15))
        sprintf(staticinfo[GINCLFN2 ], "./.cl%05.5dsafe",info_pid);

    if (staticinfo[GINCLHFN ] = malloc(strlen(HELPDIR) + 13) )
        sprintf(staticinfo[GINCLHFN], "%s/curlew.help", HELPDIR);

    if (staticinfo[GINCLRSV ] = malloc(2))
        strcpy(staticinfo[GINCLRSV ], "y");

/*
**  To disable the line length check in Curlew's pascal, comment out next
**  two lines.
*/
    if (staticinfo[GINWIDCK ] = malloc(2))
        strcpy(staticinfo[GINWIDCK ], "y");

/*
**  Decide if it is ok to have a journal file. Some work here into
**  checking if the user can use journaling - to allow it to be automatic
**  most of the time.
**
**  If the journal file already exists, the following must hold true, and
**  automatic recovery will be attempted if the file is not empty:-
**  -  The user must only be signed on once.
**  -  The file is writeable by this user.
**  -  The directory containing the file is writeable.
**
**  If the journal file does not exist, the following must hold true, and
**  a journal file will be used for this edit.
**  -  The directory where the file will be placed is writeable.
**
**  This is not a perfect set of tests, in particular race conditions can occur
**  if the same user starts up two curlew sessions in the same directory
**  at the same time.
*/
/*
**  Create the proposed journal file name, and check if it exists.
*/
    if (staticinfo[GINCLJFN ] = malloc(15))
        sprintf(staticinfo[GINCLJFN ], "./.cl%05.5djrnl",info_pw->pw_uid);
    else
        staticinfo[GINCLJFN] = "";

    if (access(staticinfo[GINCLJFN], F_OK) == 0) {
/*
**  The file exists, be carefull not to mes up another session.
**
**  Check how many times this user is signed on.
*/
        utptr = &utbuf;
        ucount = 0;
        utfd = open("/etc/utmp",0);
        while(read(utfd,utptr,sizeof utbuf) == sizeof utbuf)
        if (strcmp(staticinfo[GINUNAME ],utptr->ut_name) == 0)
            ucount++;
        close(utfd);
        if (ucount > 1)
            staticinfo[GINCLJFN] = (char *) 0;
/*
**  Check that the file is writeable by this user.
*/
        else if (access(staticinfo[GINCLJFN], W_OK))
            staticinfo[GINCLJFN] = (char *) 0;
    }
/*
**  Check that the directory containing the file is writeable.
*/
    if (access(".", W_OK))
        staticinfo[GINCLJFN] = (char *) 0;
}

/*********************************************************************
*
*   SRELSTE(envlocn, action)
*
*   Called to release resources acquired by SGETSTE and other
*   primitives.  No other primitive may be called after SRELSTE.
*   If action=1, this is an emergency exit call :: don't return.
*
*********************************************************************/
SRELSTE(env,act)
int env;
int act;
{
    tidyup();
    if (act)
        exit(act);
}

/*********************************************************************
*
*   SINTRPT(envlocn, reqcode)
*
*   Called to select the type of processing required when an
*   interrupt signal is processed.  The parameter reqcode
*   specifies the action required:
*
*   reqcode=0      default processing by operating system
*   reqcode=1      mask interrupt; just continue execution
*   reqcode=2      kill execution; return to o/s command state
*
*********************************************************************/
SINTRPT(env,req)
int env;
int req;
{
    switch(req) {
    case 0:     /* Return to default (close files and die) */
    case 2:
        signal(SIGINT,goodend);
        break;
    case 1:
        signal(SIGINT,SIG_IGN);
        break;
    }
}

/*********************************************************************
*
*   SOPEN(envlocn, name, mode, fd)
*
*    Open  the  file called name.  If access mode is IOWRITE, the file
*    will be  emptied.   Any  error  condition  results  in  fd  being
*    returned with the value IOERROR.
*
*********************************************************************/
SOPEN(env,name,mode,fd)
int env;
chstring name;
int mode;
filedesc *fd;
{
    struct stat junk;
    FILE *fptr;
    char * litname;

    litname = buf1;
    makelit(name, litname);
    if (stat(litname,&junk) < 0) {
        *fd = -1;
        return;
    }
    switch(mode) {
    case IOREAD:
        fptr = fopen(litname,"r");
        break;
    case IOWRITE:
        fptr = fopen(litname,"w");
        break;
    case IOAPPEND:
        fptr = fopen(litname,"a");
        break;
    default:
        *fd = -1;
        return;
    }
    if (fptr == (FILE *) NUL)
        *fd = -1;
    else {
        *fd = fileno(fptr);
        fileptr[*fd] = fptr;
        f_stat[*fd] = 0;
        f_mode[*fd] = mode;
    }
}

/*********************************************************************
*
*   SCREATE(envlocn, name, mode, fd)
*
*   Create the file called name if it doesn't already exit, then
*   open it exactly as for SOPEN returning the file descriptor fd.
*
*********************************************************************/
SCREATE(env,name,mode,fd)
int env;
chstring name;
int mode;
filedesc *fd;
{
    FILE *fptr;
    char * litname;

    litname = buf1;
    makelit(name, litname);
    switch(mode) {
    case IOREAD:
        fptr = fopen(litname,"r");
        break;
    case IOWRITE:
        fptr = fopen(litname,"w");
        break;
    case IOAPPEND:
        fptr = fopen(litname,"a");
        break;
    default:
        *fd = -1;
        return;
    }
    if (fptr == (FILE *) NUL)
        *fd = -1;
    else {
        *fd = fileno(fptr);
        fileptr[*fd] = fptr;
        f_stat[*fd] = 0;
        f_mode[*fd] = mode;
    }
}

/*********************************************************************
*
*   SCLOSE(envlocn, fd)
*
*   The file associated with the file descriptor parameter is
*   closed; that is it is no longer available for access by any of
*   SGETLIN, SPUTSTR or SPUTCF as appropriate.
*
*********************************************************************/
SCLOSE(env,fd)
int env;
filedesc fd;
{
    register FILE *f;

    if (fd < 0 || fd >= _NFILE)
        return;

    f = fileptr[fd];

    fclose(fileptr[fd]);
    f_mode[fd] = f_stat[fd] = -1;
    fileptr[fd] = (FILE *) 0;
}

/*********************************************************************
*
*   SREMOVE(envlocn, name, rc)
*
*   The file with the specified name is removed (destroyed).
*   The return code rc is returned as 0 to mark success; any other
*   value signifies an error.
*
*********************************************************************/
SREMOVE(env,name,rc)
int env;
chstring name;
int *rc;
{
    char * litname;

    litname = buf1;
    makelit(name, litname);
    *rc = unlink(litname);
}

/*********************************************************************
*
*   SRENAME(envlocn, oldname, newname, rc)
*
*    The  file  called  oldname  is renamed to be newname.  The return
*    code rc is returned  as  0  to  mark  success;  any  other  value
*    signifies an error.  Files with more than one link are renamed by
*    copying,  rather than moving, to avoid breaking the link.  If the
*    file newname  already  exists,  its  access  mode  is  explicitly
*    preserved.
*
*********************************************************************/
SRENAME(env,old,new,rc)
int env;
chstring old;
chstring new;
int *rc;
{
    char * litold;
    char * litnew;
    char * cmdbuf;
    struct stat statbuf;

    *rc = -1;
    litold = buf1;
    litnew = buf2;
    makelit(old,litold);
    makelit(new,litnew);

    if ( stat(litnew, &statbuf) < 0 ) {
        statbuf.st_nlink = 0;
        statbuf.st_mode  = 0;
    }

    if ( statbuf.st_nlink < 2 ) {
        if (rename(litold, litnew) == 0) {
            *rc = 0;
        }
    }
    if ( *rc != 0 ){
        /* Else we'll have to do a copy and delete */
        cmdbuf = malloc( strlen(litold) + strlen(litnew) + 21 );
        if (cmdbuf != (char *) 0) {
            sprintf(cmdbuf,"cp %s %s >/dev/null 2>&1", litold, litnew);
            if ( system(cmdbuf) == 0 ) {
                unlink(litold);
                *rc = 0;
            }
            free(cmdbuf);
        }
    }
    if ( *rc == 0 )
        if (statbuf.st_mode)
            chmod(litnew, statbuf.st_mode);
}

/*********************************************************************
*
*   SGETLIN(envlocn, str, fd, maxlen, rc)
*
*   Reads characters from the file until a NEWLINE is encountered.
*   Not more than maxlen characters will be returned in str.
*   On end of file, the string contains only an ENDFILE character
*   (no NEWLINE) and rc will be set to 4.  On success, rc is zero.
*
*********************************************************************/
SGETLIN(env, dest, fd, maxlen, rc)
int env;
chstring dest;
filedesc fd;
int maxlen;
int *rc;
{
    register FILE *f;
    register int c;
    register char * s;
    char *ret;

    *rc = -1;
    if (fd < 0 || fd >= _NFILE)
        return;
    f = fileptr[fd];
/*
**  maxlen is the calling code's idea of a full line,
**  MAXSTR is our idea of the same from buffer sizes etc.
**  Both include space for a trailing newline/null (ie read 2 chars less
**  than the greater of maxlen and MAXSTR
*/
    if ( maxlen > (MAXSTR) )
        maxlen = MAXSTR;

    if ( (f == stdin) && (f_iostat[fd] != IOMDASIS) ) {
        fputs(prompt, stderr);
        fflush(stderr);
    }
    errno = 0;
    ret = fgets(buf1, (maxlen-1), f);
#ifdef UTSBUGS
    if ( errno == ENOTTY )
        errno = 0;
#endif
    if ( errno )
        return;

    s = buf1;
    /* Check for end of file */
    if ( ret == (char*) 0) {
        *s++ = ENDFILE;
        *s++ = ENDSTR;
        *rc = 4;
    } else {
        *rc = 0;
    /* Check for an overlength line and skip over the rest of it */
        while ( *s != '\0')
            s++;
        if ( *(s-1) != '\n' ){
            *s++ = '\n';
            *s = '\0';
            errno = 0;
            do {
                c = fgetc(f);
            } while ( (c != '\n') && (c != EOF) && (errno == 0) );
        }
    }

    if (f_iostat[fd] == IOMDASIS)
        cvtmsg(buf1);
    trim(buf1);
    makeiso(buf1, dest);
}

/*********************************************************************
*
*   SGETCF(envlocn, c, fd)
*
*   Reads one character from the file.  If end-of-file is reached,
*   this character will be ENDFILE.
*
*********************************************************************/
SGETCF(env,cc,fd)
int env;
isochar *cc;
filedesc fd;
{
    register FILE *f;
    register int c;

    if (fd < 0 || fd >= _NFILE) {
        *cc = ENDFILE;
        return;
    }
    f = fileptr[fd];
    errno = 0;
    c = fgetc(f);
#ifdef UTSBUGS
    if ( errno == ENOTTY )
        errno = 0;
#endif
    if ( errno ) {
        f_stat[fd] = errno;
        *cc = ENDFILE;
        return;
    }
    if ( c == EOF ) {
        f_stat[fd] = -1;
        c = ENDFILE;
    }
    *cc = natiso[c & 0377];
}

/*********************************************************************
*
*   SPUTSTR(envlocn, str, fd)
*
*   Write the characters from string str to the file associated
*   with the file descriptor fd.  Lines are terminated by NEWLINE.
*
*********************************************************************/
SPUTSTR(env,src,fd)
int env;
chstring src;
filedesc fd;
{
    register FILE *f;
    char * s;

    s = buf1;
    if (fd < 0 || fd >= _NFILE)
        return;
    f = fileptr[fd];
    errno = 0;
    makelit(src,s);
    trim(s);
    if (f_iostat[fd] == IOMDMSG)
        cvtasis(s);
    fputs(s, f);
#ifdef UTSBUGS
    if ( errno == ENOTTY )
        errno = 0;
#endif
    fflush(f);
    if (errno)
        f_stat[fd] = errno;
}

/*********************************************************************
*
*   SPUTCF(envlocn, c, fd)
*
*   Outputs the character c to the file associated with fd.
*   The action is identical to that for a call to SPUTSTR where
*   the string contains only the single character c.
*
*********************************************************************/
SPUTCF(env,cc,fd)
int env;
isochar cc;
filedesc fd;
{
    register FILE *f;
    register int c;

    c = cc;
    if (fd < 0 || fd >= _NFILE)
        return;
    f = fileptr[fd];
    errno = 0;
    fputc(isonat[c & 0377 ],f);
#ifdef UTSBUGS
    if ( errno == ENOTTY )
        errno = 0;
#endif
    fflush(f);
    if (errno)
        f_stat[fd] = errno;
}

/*********************************************************************
*
*   SIOCTRL(envlocn, newstate, fd)
*
*   This entry sets the io state of an opened file descriptor,
*   depending on the value of newstate:-
*   IOMDDEFLT - Default file mode (with echo, no translation)
*   IOMDASIS  - Packets ready to write "as is",
*               reverse system provided CR/LF translation on
*               output.
*   IOMDMSG   - message mode reverse CR/LF translation on input,
*               no echo.
*
*********************************************************************/
SIOCTRL(envlocn, newstate, fd)
int envlocn;
int newstate;
filedesc fd;
{
    struct sgttyb ttymode;
    register FILE *f;

    if (fd < 0 || fd >= _NFILE)
        return;
    f = fileptr[fd];
    errno = 0;
    fflush(f);
    switch ( (f_iostat[fd] = newstate) ) {
    case IOMDDEFLT: /* switch on echo again just in case */
        ioctl(fd,TIOCGETP,&ttymode);
        ttymode.sg_flags |= ECHO;
        ioctl(fd,TIOCSETP,&ttymode);
        break;
    case IOMDMSG:
        if ( (strcmp("x29",getenv("TERM")) != 0) && (fd == 0) ) {
            /* Then switch off echo, we are a direct line and this is stdin */
            ioctl(fd,TIOCGETP,&ttymode);
            ttymode.sg_flags &= (~ECHO);
            ioctl(fd,TIOCSETP,&ttymode);
        }
        break;
    case IOMDASIS:
        break;
    }
}

/*********************************************************************
*
*   SGETIDX(envlocn, index, fd, rc)
*
*   This entry returns an index number suitable for use with SSEEK.
*   If fd is open for write or append access, the index is that of
*   the first character of next record to be written.  For read
*   access, the index is of the next record to be read; it is
*   permissible to pre-fetch the record to determine the read index.
*   The last parameter should be set to zero if index is usable.
*
*********************************************************************/
SGETIDX(env,num,fd,rc)
int env;
fdpointer *num;
filedesc fd;
int *rc;
{
    register FILE *f;

    if (fd < 0 || fd >= _NFILE) {
        *rc = -1;
        return;
    }
    f = fileptr[fd];
    errno = 0;
    *num = (fdpointer) ftell(f);
    if (errno)
        *rc = f_stat[fd] = errno;
    else
        *rc = 0;
}

/*********************************************************************
*
*   SSEEK(envlocn, index, fd)
*
*   For stream fd the read operation forced by SGETLIN or SGETCF
*   will read the record numbered index rather than the next one
*   in sequence.  The index'th record is the one which ends with
*   the index'th NEWLINE character.
*
*********************************************************************/
SSEEK(env,num,fd)
int env;
fdpointer num;
filedesc fd;
{
    register FILE *f;

    if (fd < 0 || fd >= _NFILE)
        return;
    f = fileptr[fd];
    errno = 0;
    fseek(f, ((long)num), 0);
    if ( errno )
        f_stat[fd] = errno;
}

/*********************************************************************
*
*   SGETFDS(envlocn, fdstat, fd)
*
*   This routine returns the status of the file descriptor fd in
*   the integer fdstat.  Values are:
*
*    -1  End of file reached on input.
*    0   No input/output error since SOPEN, SCREATE or SGETFDS.
*    >0  A serious error has occured (see definition of errno)
*
*   Positive values are cleared to zero by the SGETFDS call, also
*   -1 (end of file) for standard input.
*
*********************************************************************/
SGETFDS(env,fdstat,fd)
int env;
int *fdstat;
filedesc fd;
{
    *fdstat = f_stat[fd];
    if ( (f_stat[fd] == -1) && ( fileptr[fd] == stdin ) && isatty(fd) ) {
        errno = 0;
        f_stat[fd] = 0;
        freopen("/dev/tty","r",stdin);
        if (errno)
            f_stat[fd] = errno;
    }
    else if (f_stat[fd] > 0)
        f_stat[fd] = 0;
}

/*********************************************************************
*
*   SPROMPT(envlocn, pstr)
*
*   Sets the input line prompt string for reads from standard
*   input (fd = 0) only.  The default string is null.
*
*********************************************************************/
SPROMPT(env,pstr)
int env;
chstring pstr;
{
    makelit(pstr,prompt);
}

/*********************************************************************
*
*   SGETINF(envlocn, index, info, maxlen)
*
*   The index parameter specifies the information required by the
*   calling package.  Up to maxlen bytes of this will be returned
*   in the info parameter; maxlen may be asssumed >= 128.
*
*********************************************************************/
SGETINF(env,ind,info,maxlen)
int env;
int ind;
chstring info;
int maxlen;
{
    char * gintdate();
    char * gsortdate();

    info[0] = ENDSTR;
    if ( (ind > GINFOMAX) || (ind < 0) )
        ind = 0;    /* Guaranteed not to be defined */
    if (staticinfo[ind])
        makeiso(staticinfo[ind], info);
    else switch(ind) {
    case GINTDATE :
        makeiso(gintdate(), info);
        break;
    case GINSORTD :
        makeiso(gsortdate(), info);
        break;
    }
}

/*********************************************************************
*
*   SSYSCMD(envlocn, cmd, rc)
*
*   The command string cmd should be presented to the system for
*   execution.  This routine need not return control to the caller.
*   If it does not, the caller may assume that its environment is
*   automatically released.
*
*   A command starting with an exclamation mark is intended for the
*   native operating system and should be dealt with appropriately.
*   Otherwise the command is assumed to be for Software Tools.
*
*********************************************************************/
SSYSCMD(env,cmd,rc)
int env;
chstring cmd;
int *rc;
{
    char str[MAXINFO];

    makelit(cmd, str);
    *rc = system(str);
}

/*********************************************************************
*
*   GINCMPAR  --  return command line parameter string
*
*   Up to maxlen characters from the command line string are
*   placed into the string pointed to info
*
*********************************************************************/
char *
gincmpar()
{
    static char arg[MAXINFO];
    char *envarg;

    envarg = getenv("ARGV");
    if (envarg != 0)
        sprintf(arg,"%s\n\0",envarg);
    else
        sprintf(arg,"\n\0");
    return(arg);
}

/*********************************************************************
*
*   gintdate  --  return the date and time
*
*   The day of the week, date, time and zone are returned in DARPA
*   Internet format as in "Wed, 13 Nov 85  15:35:24 GMT".  The
*   result is returned as a pointer.
*
*********************************************************************/

static  char *daynam[] = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
static  char *monnam[] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun",
              "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };
static  char *tznam[] =  { "GMT", "BST" };

char *
gintdate()
{
    struct tm *tptr;
    long tloc;

    time(&tloc);
    tptr = localtime(&tloc);
    sprintf(buf1, "%s, %02d %s %02d  %02d:%02d:%02d %s\0",
        daynam[tptr->tm_wday],
        tptr->tm_mday,
        monnam[tptr->tm_mon],
        tptr->tm_year % 100,
        tptr->tm_hour,
        tptr->tm_min,
        tptr->tm_sec,
        (tptr->tm_isdst ? tznam[1] : tznam[0]) );
    return(buf1);
}

/*********************************************************************
*
*   gsortdate  --  return the date and time in a sortable format.
*
*   The date and time are returned in GMT, and in sortable format
*   YYYY.MMDD.HHMM.SS.
*   The result is returned as a pointer.
*
*********************************************************************/

char *
gsortdate()
{
    struct tm *tptr;
    long tloc;

    time(&tloc);
    tptr = gmtime(&tloc);
    sprintf(buf1, "%04d.%02d%02d.%02d%02d.%02d\0",
        tptr->tm_year,
        tptr->tm_mon,
        tptr->tm_mday,
        tptr->tm_hour,
        tptr->tm_min,
        tptr->tm_sec );
    return(buf1);
}

/*********************************************************************
*
*   makelit -- convert a string from iso to literal.
*
*   The first argument points to a null terminated iso string.
*   The second argument points to the destination.
*
*********************************************************************/
makelit(iso,lit)
chstring iso;
char *lit;
{
    register chstring s;
    register char *d;

    s = iso;
    d = lit;
    while (*s)
        *d++ = isonat[ (*s++) & 0377];
    *d = '\0';
}

/*********************************************************************
*
*   makeiso -- convert a string from literal to iso.
*
*   The first argument points to a null terminated character string.
*   The second argument points to the destination.
*
*********************************************************************/
makeiso(lit,iso)
char *lit;
chstring iso;
{
    register char *s;
    register chstring d;

    s = lit;
    d = iso;
    while (*s)
        *d++ = natiso[ (*s++) & 0377];
    *d = ENDSTR;
}

/*********************************************************************
*
*   trim -- trim trailing spaces and tabs from a line of text
*
*   The argument points to a string terminated by newline and null.
*
*********************************************************************/
trim(s)
char *s;
{
    register char *ptr;

    for (ptr = s; *ptr; ptr++)
        /* Null body */ ;
    ptr--;
    if ( *ptr != '\n')
        return; /* No trailing newline */
    ptr--;

    if( (*ptr != ' ') && (*ptr != '\t') )
        return; /* No trailing spaces */

    while ( ( (*ptr == ' ') || (*ptr == '\t') ) && (ptr >= s) )
        ptr--;
    ptr++;
    /* Now we point beyond the last non blank char */

    *ptr++ = '\n';
    *ptr++ = '\0';
}

/*********************************************************************
*
*  SFFCOPY -- copy from one file descriptor to another  DUMMY
*
*********************************************************************/
SFFCOPY( env, fdin, fdout, nrecds, rc )
int env;
filedesc fdin;
filedesc fdout;
int *nrecds;
int *rc;
{
    *rc = -1;
}

/*********************************************************************
*
*  SLOGUSE -- log use of software tools application DUMMY
*
*********************************************************************/
SLOGUSE(env, name)
int env;
chstring name;
{
}

/*********************************************************************
*
*  cvtmsg - convert input buffer to reverse CRLF translation
*
*********************************************************************/
cvtmsg(inbuf)
chstring inbuf;
{
#ifdef REMOTE
    register chstring cptr;

    for (cptr = inbuf; *cptr != ENDSTR; cptr++)
        if (*cptr == NEWLINE)
            *cptr = RETURN;
#endif
}

/*********************************************************************
*
*   cvtasis - convert output buffer to reverse CRLF translate
*
*********************************************************************/
cvtasis(outbuff)
chstring outbuff;
{
#ifdef REMOTE
    register chstring from, to;

    from = to = outbuff;
    while ( *from ) {
        if ( *from == RETURN
        &&   *(from + 1) == NEWLINE ) {
            *to++ = NEWLINE;
            from += 2;
        }
        else
            *to++ = *from++;
    }
    *to = ENDSTR;
#endif
}

/*********************************************************************
*
*   STWAIT - delay for a number of seconds.
*
*********************************************************************/
STWAIT(envlocn, secs)
int envlocn;
int secs;
{
    sleep(secs);
}

/*********************************************************************
*
*   SSECURE   --  secure disk copy of opened file. (dummy)
*
*********************************************************************/
SSECURE(envlocn, fd)
int envlocn;
filedesc fd;
{
}

/*********************************************************************
*
*   SIXCOPY   --  copy specified record from one fd to another
*
*********************************************************************/
SIXCOPY(envlocn, fdx, fdin, fdout, rc)
int envlocn;
fdpointer fdx;
filedesc fdin;
filedesc fdout;
int *rc;
{
    FILE *fin;
    FILE *fout;
    int c;

    *rc = -1;

    if (fdin < 0 || fdin >= _NFILE)
        return;
    fin = fileptr[fdin];

    if (fdout < 0 || fdout >= _NFILE)
        return;
    fout = fileptr[fdout];

    errno = 0;
    fseek(fin, ((long)fdx), 0);
    if ( errno )
    {
        f_stat[fdin] = errno;
        return;
    }
    do {
        c = fgetc(fin);
#ifdef UTSBUGS
        if ( errno == ENOTTY )
            errno = 0;
#endif
        if ( c == EOF )
        {
            f_stat[fdin] = -1;
            return;
        }
        fputc(c, fout);
#ifdef UTSBUGS
        if ( errno == ENOTTY )
            errno = 0;
#endif
        if ( errno )
        {
            f_stat[fdout] = errno;
            return;
        }
    } while (c != '\n');
    *rc = 0;
}

/*********************************************************************
*
*   SITOXPC   --  internal (binary) to external (text) file pointer
*
*********************************************************************/
SITOXPC(envlocn, str, sidx, fdx)
int envlocn;
chstring str;
int sidx;
fdpointer fdx;
{
    int ifdx;

    ifdx = fdx;
    sprintf(buf1,"%08x",ifdx);
    makeiso(buf1, &(str[sidx]));
}

/*********************************************************************
*
*   SXTOIPC   --  external (text) to internal (binary) file pointer (dummy)
*
*********************************************************************/
SXTOIPC(envlocn, str, sidx, fdx)
int envlocn;
chstring str;
int sidx;
fdpointer *fdx;
{
    int iidx;

    makelit(&(str[sidx]), buf1);
    sscanf(buf1,"%x",&iidx);
    *fdx = iidx;
}

/*********************************************************************
*
*   SMAILER   --  interface to e-mail spooler (dummy)
*
*********************************************************************/
SMAILER(envlocn, ix, info, rc)
int envlocn;
int ix;
chstring info;
int *rc;
{
}

/*********************************************************************
*
*   SREWIND -- rewind (read) or reset (write, append) file desc
*
*********************************************************************/
SREWIND(envlocn, fd, rc)
int envlocn;
filedesc fd;
int *rc;
{
    register FILE *f;

    if (fd < 0 || fd >= _NFILE)
        return;
    f = fileptr[fd];
    errno = 0;
    fseek(f, 0L, 0);
/*
** System V (UTS) does not provide the truncate system call.
** when this routine is required for the planned mail interface,
** changes will be required.
*/
#ifndef SYSV
    if ( errno == 0 && f_mode[fd] != IOREAD )
        ftruncate(fd, 0);
#endif

    if ( errno ) {
        f_stat[fd] = errno;
        *rc = -1;
    } else
        *rc = 0;
}
