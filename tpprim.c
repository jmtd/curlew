/***********************************************************************
**                                                                    **
**     tpprim    - terminal handling primatives for ssmp emulation    **
**                 using the UNIX termcap database.                   **
**                                                                    **
***********************************************************************/

#include <stdio.h>

#include "st.typ.h"
#include "local.h"

#include <sys/ioctl.h>
#include <fcntl.h>
#include <signal.h>

#include "iso.h"

/*
**  definitions for all mode array indexes
*/

#define TLEVEL    0
#define TMAXROW   1
#define TMAXCOL   2
#define DSINVALID 3
#define NOTIFY    4
#define SELECTGR  5
#define REQSHIFT  6
#define CURSOR    7
#define ICHARMODE 8
#define ILINEROW  9
#define INTSIGNAL 10
#define KINTHOST  11
#define KSUSPEND  12
#define KRESTART  13
#define KENTER    14
#define KCSRUP    15
#define KCSRDOWN  16
#define KCSRLEFT  17
#define KCSRRIGHT 18
#define KNEXTTAB  19
#define KPREVTAB  20
#define KLEFTUPD  21
#define KFIRSTNS  22
#define KALASTNS  23
#define KINSMODE  24
#define KERARIGHT 25
#define KINSSPAC  26
#define KDELCHAR  27
#define KERAPREV  28
#define KINSLINE  29
#define KDELLINE  30
#define KERALINE  31
#define KAPPLINE  32
#define KSPLLINE  33
#define KNEXTFLD  34
#define KPREVFLD  35
#define KHOMEFLD  36
#define KNEWLINE  37

static char tempstr[ZMAXCOL+1];
static char bline[ZMAXCOL+1];
static char tcbuf[1024];
static char iobuffer[BUFSIZ];
static char *AL;
static char *BC;
static char *CE;
static char *CM;
static char *DC;
static char *DL;
static int  HZ;
static char *IC;
static char *SE;
static char *SO;
static char *UE;
static char *US;
static int  CO = 0;
static int  LI = 0;
static int  concealed = 0;
static imtype imptr;
static modearray mptr;

/***********************************************************************
**                                                                    **
**  UINITSCRN - initialise the screen, and look up a series of useful **
**              values from the termcap database                      **
**                                                                    **
***********************************************************************/
UINITSCRN(im,mod)
imtype im;
modearray mod;
{
#define INITBUF 128
        char *getenv();
        char *s;
        char buf[INITBUF];
        register int rc;
        register char *term;
        int fd;
        register int c;
        static char tcdata[1024];     /* decoded termcap buffer */
        static char *tcptr;            /* and its pointer */
        char *tgetstr();

/*
**  first pick up the terminal type and its capability array
*/
        if ( (term = getenv("TERM")) == 0)
                return(-1);
        if ( (rc = tgetent(tcbuf,term)) < 1)
                return(-2);
/*
**  Set the terminal as buffered
*/
        setbuf(stdout,iobuffer);
/*
**  Now look for some initialisation string for the terminal
*/
        tcptr = tcdata;
        if (s = tgetstr("is",&tcptr))
                pwrite(s);
        else if (s = tgetstr("if",&tcptr))
        {
                fd = open(s,0);
                while ( (c = read(fd,buf,INITBUF)) > 0)
                        pwrite(buf);
                close(fd);
        }
        /* else assume no initialisation needed */
/*
**  Now look up the capabilities that are used later
*/
        if (    !(      (CM = tgetstr("cm",&tcptr))
                &&      (DC = tgetstr("dc",&tcptr))
                &&      (IC = tgetstr("ic",&tcptr))
                ) )
        {
                pwrite("\r\nError bad termcap entry\r\n");
                fflush(stdout);
                kill(getpid(),15);
                return(-3);
        }

        AL = tgetstr("al",&tcptr);
        CE = tgetstr("ce",&tcptr);
        DL = tgetstr("dl",&tcptr);
        HZ = tgetflag("hz");
        SE = tgetstr("se",&tcptr);
        SO = tgetstr("so",&tcptr);
        UE = tgetstr("ue",&tcptr);
        US = tgetstr("us",&tcptr);

        if ( (CO = tgetnum("co")) < 0)
                CO = 0;

        if ( (LI = tgetnum("li")) < 0)
                LI = 0;
        else
                LI--;

/*
**  save our pointer to the screen image for rowcopy etc.
**  save our pointer to the mode array for character substitution etc.
*/
        imptr = im;
        mptr = mod;
/*
**  Set up a line of spaces for UERASEROW
*/
        for (c=0; c<=ZMAXCOL; c++)
                bline[c] = ' ';
/*
**  Perform the necessary stty operations
*/
        raw(1);
        return(0);
}

/***********************************************************************
**                                                                    **
**  UENDSCRN - tidy up for end of session                             **
**                                                                    **
***********************************************************************/
UENDSCRN()
{
        int rc;

        USETMODE(0,&rc);
        UTOKEN(0);
        USETCURSOR(LI,0);
        UERASEROW(LI,0,(CO-1));
        raw(0);
}

/***********************************************************************
**                                                                    **
**  UINTHOST - send an interrupt signal to the host (current process) **
**                                                                    **
***********************************************************************/
UINTHOST()
{
        int pid;

        pid = getpid();
        kill(pid,SIGINT);
}

/***********************************************************************
**                                                                    **
**  USETCURSOR - set cursor to specified row, col                     **
**                                                                    **
***********************************************************************/
USETCURSOR(row,col)
rowtype row;
coltype col;
{
        char *ostring;
        char *tgoto();

        ostring = tgoto(CM,col,row);
        pwrite(ostring);
}

/***********************************************************************
**                                                                    **
**  UERASEROW - erase specified row, over column range                **
**                                                                    **
***********************************************************************/
UERASEROW(row,cola,colb)
rowtype row;
coltype cola;
coltype colb;
{
        register int count;

        USETCURSOR(row,cola);
        if (colb == (CO-1) && CE)
                pwrite(CE);
        else
        {
                count = colb - cola + 1;
                strncpy(tempstr,bline,count);
                tempstr[count] = '\0';
                pwrite(tempstr);
        }
}

/***********************************************************************
**                                                                    **
**  UROWCOPY - copy rowa to rowb over column range                    **
**                                                                    **
***********************************************************************/
UROWCOPY(rowa,rowb,cola,colb)
rowtype rowa;
rowtype rowb;
coltype cola;
coltype colb;
{
        register int count;
        register imtype rowp;

        USETCURSOR(rowb,cola);
        rowp = imptr + ((ZMAXCOL+1) * rowa);
        rowp += cola;
        count = colb - cola + 1;
        while( count-- ) {
            UCHAR( (isochar) *rowp++);
        }
}

/***********************************************************************
**                                                                    **
**  URIGHTSHIFT - shift specified row right by num character          **
**                positions, over column range                        **
**                                                                    **
***********************************************************************/
URIGHTSHIFT(row,cola,colb,num)
rowtype row;
coltype cola;
coltype colb;
int num;
{
        register int i;

        if (colb < CO)
        {
                USETCURSOR(row, (colb - num + 1) );
                for (i = 0; i< num; i++)
                        pwrite(DC);
        }
        USETCURSOR(row,cola);
        for (i = 0; i < num; i++)
                pwrite(IC);
}

/***********************************************************************
**                                                                    **
**  ULEFTSHIFT - shift row left num character places between          **
**               specified column limits                              **
**                                                                    **
***********************************************************************/
ULEFTSHIFT(row,cola,colb,num)
rowtype row;
coltype cola;
coltype colb;
int num;
{
        register int i;

        USETCURSOR(row,cola);
        for (i = 0; i < num; i++)
                pwrite(DC);
        if (colb < CO)
        {
                USETCURSOR(row, (colb - num + 1) );
                for (i = 0; i< num; i++)
                        pwrite(IC);
        }
}

/***********************************************************************
**                                                                    **
**  USCROLLUP - scroll box up by specified number of lines            **
**                                                                    **
***********************************************************************/
USCROLLUP(rowa, rowb, cola, colb, num)
rowtype rowa;
rowtype rowb;
coltype cola;
coltype colb;
int num;
{
        register rowtype trow;

        if (cola == 0 && colb == (CO-1) && AL && DL)
        {
                for(trow = 0; trow < num; trow++)
                {
                        USETCURSOR(rowa,0);
                        pwrite(DL);
                        USETCURSOR(rowb,0);
                        pwrite(AL);
                }
        }
        else
        {
                for (trow = rowa; trow <= (rowb - num); trow++)
                {
                        UROWCOPY( (trow + num), trow, cola, colb);
                }
                for ( (trow = rowb - num + 1); trow <= rowb; trow++)
                {
                        UERASEROW(trow,cola,colb);
                }
        }
}

/***********************************************************************
**                                                                    **
**  USCROLLDOWN - scroll box down by specified number of lines        **
**                                                                    **
***********************************************************************/
USCROLLDOWN(rowa, rowb, cola, colb, num)
rowtype rowa;
rowtype rowb;
coltype cola;
coltype colb;
int num;
{
        register rowtype trow;

        if (cola == 0 && colb == (CO-1) && AL && DL)
        {
                for(trow = 0; trow < num; trow++)
                {
                        USETCURSOR(rowb,0);
                        pwrite(DL);
                        USETCURSOR(rowa,0);
                        pwrite(AL);
                }
        }
        else
        {
                for (trow = rowb; trow >= (rowa + num); trow--)
                {
                        UROWCOPY( (trow - num), trow, cola, colb);
                }
                for ( (trow = rowa + num - 1); trow >= rowa; trow--)
                {
                        UERASEROW(trow,cola,colb);
                }
        }
}

/***********************************************************************
**                                                                    **
**  UDELETECHAR - delete one char at current cursor position          **
**                                                                    **
***********************************************************************/
UDELETECHAR()
{
        pwrite(DC);
}

/***********************************************************************
**                                                                    **
**  UINSERTSPACE - insert one space at current character position     **
**                                                                    **
***********************************************************************/
UINSERTSPACE()
{
        pwrite(IC);
}

/***********************************************************************
**                                                                    **
**  UCHAR    - output character at current cursor position            **
**                                                                    **
***********************************************************************/
UCHAR(ch)
isochar ch;
{
        if (ch < BLANK || ch >= (HZ ? CTILDE : DEL) )
                ch = GRAVE;
        if (concealed)
                ch = BLANK;
        fputc(ch, stdout);
}

/***********************************************************************
**                                                                    **
**  UALARM    - sound alarm bell                                      **
**                                                                    **
***********************************************************************/
UALARM()
{
        static char bell = CTLG;

                write(2,&bell,1);
}

/***********************************************************************
**                                                                    **
**  USETMODE - set graphic mode                                       **
**                                                                    **
***********************************************************************/

USETMODE(mode,rc)
smallint mode;
int *rc;
{
        static smallint c_mode = 0;

        *rc = c_mode;
        if (mode == c_mode)
                return;
        /*
        **  first un-set the current mode
        */
        switch(c_mode)
        {
        case 4: /* underlined */
                pwrite(UE);
                break;
        case 7: /* negativeimage */
                pwrite(SE);
                break;
        case 8: /* concealed */
                concealed = 0;
                break;
        }
        switch(mode)
        {
        case 0: /* default */
                c_mode = 0;
                break;
        case 4: /* underlined */
                if ( US && UE ) {
                    pwrite(US);
                    c_mode = 4;
                } else {
                    c_mode = 0;
                    *rc = -1;
                }
                break;
        case 7: /* negativeimage */
                if ( SO && SE) {
                    pwrite(SO);
                    c_mode = 7;
                } else {
                    c_mode = 0;
                    *rc = -1;
                }
                break;
        case 8: /* concealed */
                concealed = 1;
                c_mode = 8;
                break;
        default:
                *rc = -1;
                c_mode = 0;
                break;
        }
}

/***********************************************************************
**                                                                    **
**  UGETSIZE - get screen sizes                                       **
**                                                                    **
***********************************************************************/
UGETSIZE(row,col)
rowtype *row;
coltype *col;
{
        *row = (rowtype) LI;
        *col = (coltype) CO;
}

/***********************************************************************
**                                                                    **
**  UERASEPREV - erase previous char                                  **
**                                                                    **
***********************************************************************/
UERASEPREV()
{
        UCHAR('\b');
        UCHAR(' ');
        UCHAR('\b');
}

/***********************************************************************
**                                                                    **
**  UTOKEN - Transfer the token to/from the host (logically). In this **
**           local implementation the actions performed are:-         **
**                                                                    **
**           Flag == 1 (token -> host):                               **
**                     Switch on the token light                      **
**                     Make the output of characters buffered         **
**                                                                    **
**           Flag == 0 (token -> user/terminal):                      **
**                     Switch off the token light                     **
**                     Un-buffer the output                           **
**                                                                    **
***********************************************************************/

UTOKEN(flag)
int flag;
{
        int rc;

        if (flag)
        {
                USETCURSOR(LI+1,0);
                USETMODE(7,&rc);
                pwrite(" TOKEN ");
                USETMODE(rc,&rc);
                fflush(stdout);
                setbuf(stdout,iobuffer);
        }
        else
        {
                USETCURSOR(LI+1,0);
                USETMODE(0,&rc);
                pwrite("       ");
                USETMODE(rc,&rc);
                fflush(stdout);
                setbuf(stdout,(char *)NULL);
        }
}


/***********************************************************************
**                                                                    **
**  UREAD - read the next character from the keyboard                **
**                                                                    **
***********************************************************************/

UREAD(ch)
isochar *ch;
{
        *ch = getkey();
}

/***********************************************************************
**                                                                    **
**  pwrite - put the supplied character string out to the terminal    **
**                                                                    **
***********************************************************************/

static pwrite(st)
char *st;
{
        printf("%s",st);
}

/***********************************************************************
**                                                                    **
**  UDEBUG - put out the arguments on standard error                  **
**                                                                    **
***********************************************************************/

UDEBUG(s,x,y,z)
char *s;
int x;
int y;
int z;
{
        register char *sp;
        char sc[25];
        char str[80];

        strncpy(sc,s,24);
        sc[24] = '\0';
        for (sp = sc; *sp; sp++)
                if ( *sp == '&' )
                        *sp = '\0';
        sprintf(str,"%s %d %d %d\r\n",sc,x,y,z);
        write(2,str,strlen(str));
}

static readtty()
{
    char c;

    if ( read(0,&c,1) <= 0)
        return (EOF);
    else
        return ( (int) (c & 0177) );
}

static getkey()
{
    int c;
    static  p1 = EOF;
    static  p2 = EOF;

    if (p1 != EOF)
    {
        c = p1;
        p1 = p2;
        p2 = EOF;
    }
    else
    {
        c = readtty();
    }
    if ( c == ESC )
    {
#ifdef MG1
        now(1);
#endif
        if (p1 == EOF)
            p1 = readtty();
        if (p1 == LBRACK || p1 == CAPO )
            p2 = readtty();
#ifdef MG1
        now(0);
#endif
        if (p1 == LBRACK)
        {
            switch (p2)
            {
            case CAPA:
                p1 = p2 = EOF;
                if (mptr[KCSRUP  ])
                    c = (char) mptr[KCSRUP  ];
                else
                    c = getkey();
                break;
            case CAPB:
                p1 = p2 = EOF;
                if (mptr[KCSRDOWN])
                    c = (char) mptr[KCSRDOWN];
                else
                    c = getkey();
                break;
            case CAPC:
                p1 = p2 = EOF;
                if (mptr[KCSRRIGHT])
                    c = (char) mptr[KCSRRIGHT];
                else
                    c = getkey();
                break;
            case CAPD:
                p1 = p2 = EOF;
                if (mptr[KCSRLEFT])
                    c = (char) mptr[KCSRLEFT];
                else
                    c = getkey();
                break;
            }   /* of switch */
        }   /* of LBRACK - cursor key processing */
        else if (p1 == CAPO)
        {
            switch (p2)
            {
            case CAPP:
            case CAPQ:
            case CAPR:
            case CAPS:
            case CAPT:
            case CAPU:
            case CAPV:
            case CAPW:
            case CAPX:
                p1 = p2 + DIG1 - CAPP;
                p2 = EOF;
                break;
            case CAPY:
                p1 = DIG0;
                p2 = EOF;
                break;
            }   /* of switch */
        }   /* of CAPO - Function key processing */
    }   /* of escape processing */
    if ( c == EOF )
        return ( ENDFILE );
    else
        return ( (isochar) c);
}

static raw(flag)
int flag;
{
    static struct sgttyb ttymode;
    static int ttyflags;

    if (flag)
    {
        ioctl(1,TIOCGETP,(char *)&ttymode);
        ttyflags = ttymode.sg_flags;
        ttymode.sg_flags = RAW;
        ioctl(1,TIOCSETP,(char *)&ttymode);
    }
    else
    {
        ttymode.sg_flags = ttyflags;
        ioctl(1,TIOCSETP,(char *)&ttymode);
    }
}

static now(flag)
int flag;
{
    int fcntl_flags;

    if (flag)
    {
        fcntl(0,F_GETFL,fcntl_flags);
        fcntl_flags |= FNDELAY;
        fcntl(0,F_SETFL,fcntl_flags);
    }
    else
    {
        fcntl(0,F_GETFL,fcntl_flags);
        fcntl_flags &= (~FNDELAY);
        fcntl(0,F_SETFL,fcntl_flags);
    }
}
