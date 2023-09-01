 
 
{ ****************************************************** unixprim *** }
{ *                                                                 * }
{ *   Terminal handling primitives for local SSMP -- UNIX version   * }
{ *                                                                 * }
{ ******************************************************************* }
 
{ %% external references converted for 4.2bsd Pascal (SUN) }
 
 
 
{ UINITSCRN -- initialise screen and any associated data structures }
procedure UINITSCRN (var image : imtype;
                     var mode : modearray);
        external;
 
 
{ UENDSCRN -- tidy up for end of session }
procedure UENDSCRN;
        external;
 
 
{ USETCURSOR -- set cursor to specified row & col }
procedure USETCURSOR (row : rowtype;
                      col : coltype);
        external;
 
 
{ UERASEROW -- erase specified row, over column range }
procedure UERASEROW (row : rowtype;
                     cola, colb : coltype);
        external;
 
 
{ UROWCOPY -- copy rowa to rowb over column range }
procedure UROWCOPY (rowa, rowb : rowtype;
                    cola, colb : coltype);
        external;
 
 
{ URIGHTSHIFT -- shift row right num characters over column range }
procedure URIGHTSHIFT (row : rowtype;
                       cola, colb : coltype;
                       num : integer);
        external;
 
 
{ ULEFTSHIFT -- shift row left num characters over column range }
procedure ULEFTSHIFT (row : rowtype;
                      cola, colb : coltype;
                      num : integer);
        external;
 
 
{ UCHAR -- output character at current cursor position }
procedure UCHAR (ch : isochar);
        external;
 
 
{ UALARM -- sound the terminal's alarm bell }
procedure UALARM;
        external;
 
 
{ UREAD -- read next character from keyboard }
procedure UREAD (var inchar : isochar);
        external;
 
 
{ USETMODE -- tell keyboard drivers about mode array changes }
procedure USETMODE (mode : smallint;
                    var rc : integer);
        external;
 
 
{ UGETSIZE -- get screen sizes }
procedure UGETSIZE (var row : rowtype;
                    var col : coltype);
        external;
 
 
{ UTOKEN -- show token state ("host" light) }
procedure UTOKEN (flag : integer);
        external;
 
 
{ USCROLLUP -- scroll region up }
procedure USCROLLUP (rowa, rowb : rowtype;
                     cola, colb : coltype;
                     count : integer);
        external;
 
 
{ USCROLLDOWN -- scrollregion down }
procedure USCROLLDOWN (rowa, rowb : rowtype;
                       cola, colb : coltype;
                       count : integer);
        external;
 
 
{ UINTHOST -- interrupt the m/c (this task) }
procedure UINTHOST;
        external;
