dm "output;clear;log;clear;";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data wheat;
input block treat y;
cards;
1 1 9.7
1 2 11.8
1 3 6.3
1 4 4.6
2 1 6.6
2 2 9.7
2 3 5.3
2 4 3.4
3 1 7.6
3 2 10.9
3 3 4.7
3 4 2.3
4 1 8.1
4 2 11.3
4 3 5.5
4 4 3.6
5 1 6.4
5 2 10.7
5 3 4.5
5 4 2.8
;
run;

*** F-test, pairwise comparison & diagnostics;
ods graphics on;	
proc glm data=wheat plot= DIAGNOSTICS alpha=0.1 ;
 class block treat;
 model y = block treat;
 lsmeans treat/adjust=tukey cl;
 lsmeans treat/adjust=scheffe cl;
 lsmeans treat/adjust=bon cl;
run;
ods graphics off;

proc glm data=wheat;
 class block treat;
 model y = block treat;
 lsmeans treat/adjust=tukey cl;
run;

proc glm data=wheat;
class block treat;
model y = block treat;
random treat;
run;

proc mixed data=wheat;
class block;
model y = block treat;
random treat;
run;



quit;
