%let pgm=utl-simultaneous-row-and-column-problems-best-solved-using-r;

Simultaneous row and column problems best solved using r

github
https://tinyurl.com/mu7udk7u
https://github.com/rogerjdeangelis/utl-simultaneous-row-and-column-problems-best-solved-using-r

select only the columns that contain at least on missing and count the missings in eac column

Not as elegant in SQL or datastep

https://stackoverflow.com/questions/76879844/r-filter-by-column-given-a-particular-row-value

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;

libname sd1 "d:/sd1";

data sd1.have;
  input a b c  d;
cards4;
1 0 1  0
0 1 0  .
. 1 1  1
0 1 0  .
;;;;
run;quit;


/**************************************************************************************************************************/
/*                                                                 |                                                      */
/* SD1.HAVE total obs=4           RULES                            |   OUTPUT                                             */
/*                                                                 |                                                      */
/*   Obs    A    B    C    D      select only columns A & D        |  Obs    A    D                                       */
/*                                only columns with at least       |                                                      */
/*    1     1    0    1    0      1 missing,                       |   1     1    0                                       */
/*    2     0    1    0    .                                       |   2     0    .                                       */
/*    3     .    1    1    1      Add a rum with the missing count |   3     .    1                                       */
/*    4     0    1    0    .                                       |   4     0    .                                       */
/*                                                                 |                                                      */
/*                                                                 |   5     1    2  => missing count                     */
/*                                                                 |                                                      */
/**************************************************************************************************************************/

/*         _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| `_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

*/

proc datasets lib=sd1 nolist nodetails;delete want; run;quit;

%utl_submit_wps64x('
libname sd1 "d:/sd1";
proc r;
export data=sd1.have r=df;
submit;
library(dplyr);
df1<-df %>% select(where(anyNA));
want<-rbind(df1,colSums(is.na(df1)));
want;
endsubmit;
import data=sd1.want r=want;
run;quit;
proc print data=sd1.want;
run;quit;
');

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R                                                                                                                      */
/*                                                                                                                        */
/*  The WPS System                                                                                                        */
/*                                                                                                                        */
/*     A  D                                                                                                               */
/*  1  1  0                                                                                                               */
/*  2  0 NA                                                                                                               */
/*  3 NA  1                                                                                                               */
/*  4  0 NA                                                                                                               */
/*                                                                                                                        */
/*  5  1  2  Missing count                                                                                                */
/*                                                                                                                        */
/* WPS                                                                                                                    */
/*                                                                                                                        */
/*  Obs    A    D                                                                                                         */
/*                                                                                                                        */
/*   1     1    0                                                                                                         */
/*   2     0    .                                                                                                         */
/*   3     .    1                                                                                                         */
/*   4     0    .                                                                                                         */
/*                                                                                                                        */
/*   5     1    2                                                                                                         */
/*                                                                                                                        */
/**************************************************************************************************************************/


/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
