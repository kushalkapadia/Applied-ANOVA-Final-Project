dm "output;clear;log;clear";
options ps=100 ls=78 formdlim='*' nodate nonumber;

data diet;
input diets age weight gain;
cards;
1	1	50	1.47
1	1	45	1.55
1	1	41	1.57
1	1	40	1.26
1	2	61	1.4 
1	2	59	1.79
1	2	76	1.72
1	2	61	1.26
1	2	54	1.28
1	2	57	1.34
2	1	48	1.35
2	1	52	1.29
2	1	43	1.43
2	1	50	1.29
2	1	40	1.26
2	2	74	1.61
2	2	75	1.31
2	2	64	1.12
2	2	62	1.29
2	2	42	1.24
3	1	47	1.23
3	1	47	1.39
3	1	52	1.39
3	1	40	1.56
3	1	40	1.36
3	2	80	1.67
3	2	61	1.41
3	2	62	1.73
3	2	59	1.49
3	2	42	1.22
4	1	62	1.4 
4	1	55	1.47
4	1	43	1.15
4	1	41	1.31
4	1	40	1.27
4	1	45	1.22
4	1	39	1.36
4	2	62	1.37
4	2	57	1.22
4	2	51	1.48
;
run;

ods graphics on;
proc glm data=diet;
class diets;
model gain = weight diets age|diets/solution clparm alpha=0.05; *for parameter estimates;
estimate 'mu_2(xbar)' intercept 1 diets 0 1 0 0 age 0.75 0.25 age*diets 0 0.75 0 0 0 0.25 0 0  weight 56;
run;
ods graphics off;


title "Test for parallel slopes";
ods graphics on;
proc glm data=diet;
 class diets;
 model gain=weight diets weight*diets;
run;
ods graphics off;

title "full model: multiple comparisons";
proc glm data = diet alpha=0.1;
 class diets;
 model gain = weight diets;
 lsmeans diets / cl adjust=scheffe;
 lsmeans diets / cl adjust=bon;
run;

*Doing the 4th and the last one now. Hope it goes well;

proc glm data=diet order=data alpha=0.1;
class age diets;
model gain = weight age diets age|diets/ss3 clparm; *for parameter estimates;
estimate 'L1' intercept 1 diets 1 0 0 0 age 0.75 0.25 age*diets 0.75 0 0 0 0.25 0 0 0 ;
estimate 'L2' intercept 1 diets 0 1 0 0 age 0.75 0.25 age*diets 0 0.75 0 0 0 0.25 0 0 ;
estimate 'L3' intercept 1 diets 0 0 1 0 age 0.75 0.25 age*diets 0 0 0.75 0 0 0 0.25 0 ;
estimate 'L4' intercept 1 diets 0 0 0 1 age 0.75 0.25 age*diets 0 0 0 0.75 0 0 0 0.25 ;
run; 

*contrast 'H0'
diets 4 -4 0 0 age*diets 0.75 -0.75 0 0 0.25 -0.25 0 0,
diets 4 0 -4 0 age*diets 0.75 0 -0.75 0 0.25 0 -0.25 0,
diets 4 0 0 -4 age*diets 0.75 0 0 -0.75 0.25 0 0 -0.25;

*contrast 'H0 again'
age 4 -4 diets 0.5 0.5 0.5 0.5 age*diets 0.75 0.75 0.75 0.75 -0.25 -0.25 -0.25 -0.25;
run;

ods graphics on;
proc glm data=diet;
class diets;
model gain = weight age/solution clparm alpha=0.1; *for parameter estimates;
estimate 'mu_2(xbar)' intercept 1 diets 0 1 0 0 weight 56;
run;
ods graphics off;

*Part (b) of the 4th question;

ods graphics on;
proc glm data=diet;
class diets;
model gain = weight age diets age*diets/solution clparm alpha=0.1; *for parameter estimates;
estimate 'L1' intercept 1 age 0.75 0.25 diets 1 0 0 0 age*diets 1 1 0 0 0 0 0 0; 
 estimate 'mu_2(xbar)' intercept 1 diets 0 1 0 0 weight 56;
run;
ods graphics off;

proc freq data=diet;
tables age;
run;

data diet;
format age percent52.50;
age=0.75;
run;
