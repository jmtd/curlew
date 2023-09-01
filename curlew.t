.TH curlew 1 local
.SH NAME
curlew,cl \- SSMP Screen Editor
.SH SYNOPSIS
.B curlew
file [command]
.SH Essential context editor commands
.TS
l l.
write	Write file buffer contents to edited file
quit	End the editor session
edit myotherfile	Edit a new disk file "myotherfile"
view	Enter (or exit) full-screen operation
.TE
.LP
From full-screen operation, first press ESC then 6 to get a command
prompt.  When complete, press RETURN to enter the command.  If a
filename is given with a "write" command the file buffer will be
written to the specified file instead of the edited file.
.SH Control key action during full-screen operation
.TS
l l l l l l.
^Q	insert line	^A	align text	^Z	cursor line start
^W	char/line toggle	^S	insert space	^X	cursor text start
^E	delete character	^D	delete blanks	^C	cursor text end
^R	delete word	^F	previous tab	^V	cursor next word
^T	delete line start	^G	home cursor	^B	block toggle
^Y	delete line end	^H	cursor left	^N	ins saved text
^U	delete line	^J	cursor down	^M	(RETURN) append
^I	next tab	^K	cursor up		or split line
^O	split line	^L	cursor right
^P	combine with next
.TE
.LP
Note that "^Q" means hold down "CTRL", press "Q" once and release.
.SH Line number parameters and image relocation
In full-screen operation, first press F6 (ESC then 6) to get the
command prompt.  Press RETURN when the parameter is complete.
.LP
.TS
l l l.
n	Line n in the file buffer, for example:	563
.	The current line (or cursor line).
+n	n lines after the current line, example:	+60
-n	n lines before the current line, example:	-125
$	The last line in the file buffer.
#	The top-of-file image line number.
/pat/	Next line matching the pattern, example:	/Edinburgh/
\epat\e	Previous line matching pattern, example:	\ecity\e
.TE
.LP
Several line parameters may be grouped together separated by commas or
semicolons.  A semicolon updates the current line pointer.
.SH Patterns
Patterns are an extension of the "Software Tools" scheme where
?=any,
%=start-of-line,
$=end-of-line,
[]=char-class,
*=closure,
@=literal,
~=case-sensitivity-toggle.
The UNIX (tm) set is available via a "set u+" command.
.LP
Examples of patterns used in searches:
.LP
.TS
l lw(4i).
/procedure/	next line containing "procedure"
/~joe/	next line containing "joe", "JOE", "Joe", etc.
//	next line containing last pattern specified
\e\e	previous line containing last pattern
/%Name:/	next line starting with "Name:"
/%$/	next line with no text on it
/%[0-9][0-9]*./	next line starting with one or more digits
	followed by a period, "."
/@*@*@*/	next line containing three consecutive
	asterisks ("@" overrides metacharacters)
.TE
.SH Full-screen operation in block mode
Block start (or end) is marked by a ^B.  Move the cursor to the other
end of the block.  The editing keys ^[QWERTYUOPASD], but not RETURN or
DEL, now operate on the block of text.
.LP
For the "character" operations the block is a rectangle, for "line"
operation the group of lines, for "delete word" the serial
intermediate text.  ^Q and ^W save lines or a character rectangle in
block mode; to insert a copy of the text that has been saved press ^N.
Note that RETURN is "start-of-next-line" after ^B.
.SH Context editor commands
.LP
These are:
.LP
append, change, copy, delete, edit, exit, filename, format, global,
help, insert, keep, move, list, print, prompt, quit, read, set, show,
stop, substitute, undo, view, write, xglobal
.LP
Examples:
.LP
.TS
l lw(4i).
g/type/list	list all lines containing "type"
g/%[0-9]/list	list all lines starting with a digit
1,$sub/Joe/Joseph/g	replace every "Joe" by "Joseph"
1,$sub/% *//	remove all leading blanks
+,$delete	delete lines beyond the cursor line
1,-delete	delete lines before the cursor line
g/%$/delete	delete all blank lines
x/%[0-9]/sub/%/\ \ \ \ \ /	for lines not starting with a digit,
	shift right five spaces
.TE
.SH Function keys and their default settings
A function keystroke is signalled by pressing "ESC" once then a second
key once.  The second key for each function key is:
.LP
.TS
c c c c c c c c c c
c c c c c c c c c c
c c c c c c c c c c
c c c c c c c c c c
c c c c c c c c c c
c c c c c c c c c c
c c c c c c c c c c
c c c c c c c c c c.
1	2	3	4	5	6	7	8	9	0
F1	F2	F3	F4	F5	F6	F7	F8	F9	F10

Q	W	E	R	T	Y	U	I	O	P
F11	F12	F13	F14	F15	F16	F17	F18	F19	F20

A	S	D	F	G	H	J	K	L	;
F21	F22	F23	F24	F25	F26	F27	F28	F29	F30

Z	X	C	V	B	N	M
F31	F32	F33	F34	F35	F36	F37
.TE
.LP
The default settings are (key, keystrokes, command, action):
.LP
.TS
l l l l.
F1	ESC 1	#+10	forward half of screen height
F2	ESC 2	#+20	forward by full screen height
F3	ESC 3	.	forward to cursor line
F4	ESC 4	#-10	backward half of screen height
F5	ESC 5	#-20	backward by full screen height
F6	ESC 6	prompt	command prompt or pickup previous
F7	ESC 7	//	scan forward using last pattern
F8	ESC 8	keep	checkpoint the file buffer
F9	ESC 9	view =	refresh image
F10	ESC 0	view	toggle full-screen <--> context

F11	ESC Q	format p5	letter-style paragraph
F12	ESC W	format	square paragraph
F13	ESC E	format p-5	outer list item
F14	ESC R	format i5	outer list continued
F15	ESC T	format i5p-5	inner list item
F16	ESC Y	format i10	inner list continued
F17	ESC U	format lp0	tidy paragraph (left-justified)
F18	ESC I	. format lp0	tidy to paragraph end (left-j)
F19	ESC O	.,. format c	centre cursor line
F20	ESC P	.,. format r	right justify cursor line

F21	ESC A	set t10 ...	assembler tabs
F22	ESC S	set t*4	tabs every 4th column
F23	ESC D	set t*5	tabs every 5th column
F24	ESC F	set t*8	tabs every 8th column
F25	ESC G	1	to first line
F26	ESC H	$;#-19	to last line, at screen bottom
F27	ESC J	set x0	leftmost window
F28	ESC K	set x40-	window left 40 columns
F29	ESC L	set x40+	window right 40 columns
F30	ESC ;	filename	cursor location, buffer name
.TE
.LP
F31..F37 are initially undefined.  The values of 10 and 20 in the
strings for F1/2/4/5 are for a 24 row screen; they are determined from
the screen height.  Key strings can be redefined using "set".
.SH Profile options in the "set" command
The second column gives the set parameter argument type; the third
column gives the default value.
.LP
.TS
l l l l.
a	switch	a+	Append line when RETURN pressed ("a-"=split-line)
b	switch	b-	Simple block combine action ("b+"=format-lines)
c	switch	c-	Characters overstrike text ("c+"=insertion)
d	switch	d-	Detab buffer text action ("d+"=expand-to-spaces)
e	switch	e-	Entab written text action ("e+"=compress-to-tabs)
f	nbr/defn/		Function key definitions, already listed
h	switch	h+	Horiz tab keys ("h-"=tab-insert-&-previous-word)
i	switch	i+	Automatic image updating ("i-"=await-request)
j	switch	j+	"format" both margins aligned ("j-"=left-only)
l	switch	l+	Loop search action over buffer ("l-"=do-not-loop)
m	number	m2	Controls mask allows HT and DEL (0=none, 4=all)
n	switch	n-	Anycase toggle is off ("n+"=anycase-toggle-on)
o	number	o0	"format" overall text offset
p	number	p0	"format" default paragraph first line indent
r	number	r7	Alternative rendition is reverse (0=def, 1=bold)
s	number	s1	"format" default sentence separation (0..4)
t	tabdef	t*8	Set tabulation stop columns every 8th column
u	switch	u-	"Software Tools" metacharacters ("u+"=UNIX)
v	switch	v-	No automatic view command on entry to editor
w	number	w70	"format" default paragraph width
x	number	x0	Left margin offset in full-screen operation
y	number	y0	Vertical cursor movement wraps (>0=scroll)
z	switch	z+	Word wrap -- "power-typing" -- action ("z-"=off)
.TE
.LP
Arguments for "set" are the single letter followed by one of:
.LP
.TS
l l.
switch	"+" or "-"
number	A signed integer.  A "+" or "-" postfix increments
	or decrements the current value. The result is
	always constrained to be legal.
nbr/defn/	For a function key definition; an unsigned integer,
	1..37, followed by delimiter, characters, delimiter.
tabdef	A list of unsigned integers separated by spaces;
	or an asterisk (*) followed by a single unsigned
	integer giving the regular tab stop interval.
.TE
.LP
Examples:
.LP
.TS
l l.
enable both tab expansion and compression:	set d+e+
make format left-j, width 65, offset 1:	set j-w65o1
work with character insertion, RETURN splits:	set c+a-
set tab stops at columns 5, 25 and 45:	set t5 25 45
increase the left margin offset by 64:	set x64+
set function key 33 (ESC C) to "quit":	set f33/quit/
.TE
.LP
Use "show" to see the current editor profile.  Non-default profile
settings which will almost always be required can be stored in a
profile file; see below for details.
.SH Files
In the following descriptions,
<uuu> represents your numeric userid,
<ppp> represents the current process id, and
$HOME represents your home directory (taken from password file).
Note that the use of the userid prevents the use of curlew twice
from the same signon id,
however it makes recovery (nearly) automatic after machine or line failure.
.LP
.TS
l l.
$HOME/.curlewrc	curlew profile file
/tmp/cl<ppp>ebuf	edit buffer
/tmp/cl<ppp>clon	saved block (clone) buffer
/tmp/cl<ppp>safe	safety filename during write command
\.cl<uuu>safe	second safety file during write command
\.cl<uuu>jrnl	journal filename
.TE
.SH RESTRICTIONS
.LP
Curlew  is  a text editor, suitable for editing natural language text,
program source and data, and similar tasks.  It is  not  suitable  for
files  containing  binary  data  such as executable object programs or
encoded data produced by some applications packages.
.LP
Curlew cannot handle files with more than 16,383 lines of information,
nor  can  it  handle  files  in  which any line contains more than 509
characters.  All versions of Curlew will refuse to "write" a file once
the 16,383 lines limit has been passed.
.LP
Users  of  files  whose  sharing  attributes  allow  concurrent  write
(modify) access by more than one user (or  process)  should  be  aware
that  Curlew  does not lock (reserve) the file for the duration of the
editing session.
.LP
Curlew can only be used once from any given login id.
If it is invoked a second time, no
journalling can take place, so no recovery will be possible,
and the u(undo) command will be useless.
