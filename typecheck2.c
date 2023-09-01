#include "st.typ.h"

SIZBYTE(ret, x, y)
int *ret;
byte x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "byte");
    }
}

SIZCOLTYPE(ret, x, y)
int *ret;
coltype x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "coltype");
    }
}

SIZFDPOINTER(ret, x, y)
int *ret;
fdpointer x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "fdpointer");
    }
}

SIZFIELDINDEX(ret, x, y)
int *ret;
fieldindex x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "fieldindex");
    }
}

SIZFILEDESC(ret, x, y)
int *ret;
filedesc x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "filedesc");
    }
}

SIZISOCHAR(ret, x, y)
int *ret;
isochar x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "isochar");
    }
}

SIZMODEINDEX(ret, x, y)
int *ret;
modeindex x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "modeindex");
    }
}

SIZROWTYPE(ret, x, y)
int *ret;
rowtype x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "rowtype");
    }
}

SIZSMALLINT(ret, x, y)
int *ret;
smallint x, y;
{
    if ( (x != 17) || (y != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "smallint");
    }
}

SIZCHSTRING(ret, a)
int *ret;
chstring a;
{
    if ( (a[0] != 17) || (a[1] != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "chstring");
    }
}

SIZCHTABLE(ret, a)
int *ret;
chtable a;
{
    if ( (a[0] != 17) || (a[1] != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "chtable");
    }
}

SIZIMTYPE(ret, a)
int *ret;
imtype a;
{
    if ( (a[0] != 17) || (a[1] != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "imtype");
    }
}

SIZITABLE(ret, a)
int *ret;
itable a;
{
    if ( (a[0] != 17) || (a[1] != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "itable");
    }
}

SIZMODEARRAY(ret, a)
int *ret;
modearray a;
{
    if ( (a[0] != 17) || (a[1] != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "modearray");
    }
}

SIZTEXTLIT(ret, a)
int *ret;
textlit a;
{
    if ( (a[0] != 17) || (a[1] != 19) ) {
        *ret += 1;
        printf("Error in definition of %s\n", "textlit");
    }
}

CRASHOUT(ret)
int *ret;
{
    if ( *ret > 0 ){
        printf("%d errors detected in verification of st.typ.h\n", *ret);
        exit(1);
    } else {
        printf("st.typ.h verification ok\n");
    }
}
