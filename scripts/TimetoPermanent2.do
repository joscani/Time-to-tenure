
/// TIME TO PERMANENT
//two options: 1. Hazard models (Gaughan & Robin, 2004). 2. logistic regression time to tenure (cruz-castro)

// DEPENDENT VARIABLE. Find first time position.
//Problem. The question about the career is really weak but fortunately they answered correctly "outline your research career from 2000, starting with your current position". So not clear if we have the first position. Check there is always a solution. Do not consider cases with all positions answered if the mean of number of years in taking a permanent position is higher than the average.
// Q8_x2 start should be our source of data 

tab number_jobs
tab Q8_5x2

tab prova

// HOW PROVA WAS BUILT

* if positive you have worked and studied
* if negative you have a gap between PhD and first Job OR you had more than 5 jobs.
*The variable "prova" is used to check who finished the PhD after starting their first reported job. We will exclude from our analysis those who started working before finishing their phd. This is because we are using "PhD_lenght" as a proxy for ability. For those who were working and doing the PhD the variable is biased".
 
 
* gen prova= .
 
* replace prova=Q5_4x2- Q8_2x2 if number_jobs==1
 
* replace prova=Q5_4x2- Q8_3x2 if number_jobs==2
 
* replace prova=Q5_4x2- Q8_4x2 if number_jobs==3
 
* replace prova=Q5_4x2- Q8_5x2 if number_jobs==4
 
* replace prova=Q5_4x2- Q8_6x2 if number_jobs==5 “

//PROVA EQUALS TO TIME FROM PHD TO FIRST JOB IN OUR DATABASE
//CAREFUL if number of jobs equals to 5 if they are not in the average.

tab prova if number_jobs==5

// Just need to know if they are permanent or no. PROBLEM WHAT CRITERION WE SHOULD USE 1. self reported Q9_Xx2; 2. Time (more than 5 years); 3. Positon; 4 a combitation of them

// year of first position

gen firstPyear= .
 
replace firstPyear=Q8_2x2 if number_jobs==1
 
replace firstPyear=Q8_3x2 if number_jobs==2
 
replace firstPyear=Q8_4x2 if number_jobs==3
 
replace firstPyear=Q8_5x2 if number_jobs==4

replace firstPyear=Q8_6x2 if number_jobs==5 

**** xxxxx   NEW AVOIDING MISSING CASES. should I re-do everything or solving negative cases. I think that is more sistematic starting from the scratch

gen number_jobsAPHD= .
 
replace number_jobsAPHD=5 if number_jobs==5 & Q8_6x2>=Q5_4x2
replace number_jobsAPHD=4 if number_jobs==4 & Q8_5x2>=Q5_4x2 & number_jobsAPHD!=5
replace number_jobsAPHD=4 if number_jobs==5 & Q8_5x2>=Q5_4x2 & number_jobsAPHD!=4 & number_jobsAPHD!=5

replace number_jobsAPHD=3 if number_jobs==3 & Q8_4x2>=Q5_4x2 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=3 if number_jobs==4 & Q8_4x2>=Q5_4x2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5 
replace number_jobsAPHD=3 if number_jobs==5 & Q8_4x2>=Q5_4x2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5 

replace number_jobsAPHD=2 if number_jobs==2 & Q8_3x2>=Q5_4x2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=2 if number_jobs==3 & Q8_3x2>=Q5_4x2 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=2 if number_jobs==4 & Q8_3x2>=Q5_4x2 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=2 if number_jobs==5 & Q8_3x2>=Q5_4x2 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5

replace number_jobsAPHD=1 if number_jobs==1 & Q8_2x2>=Q5_4x2 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=1 if number_jobs==2 & Q8_2x2>=Q5_4x2 & number_jobsAPHD!=1 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=1 if number_jobs==3 & Q8_2x2>=Q5_4x2 & number_jobsAPHD!=1 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=1 if number_jobs==4 & Q8_2x2>=Q5_4x2 & number_jobsAPHD!=1 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5
replace number_jobsAPHD=1 if number_jobs==5 & Q8_2x2>=Q5_4x2 & number_jobsAPHD!=1 & number_jobsAPHD!=2 & number_jobsAPHD!=3 & number_jobsAPHD!=4 & number_jobsAPHD!=5

tab number_jobsAPHD number_jobs

// Gosh!!!!!!!! Problem. there are people that do not report promotions. then they start at a university before phd they become professors at the same university. WHAT TO DO WITH THIS CASES. iT WOULD LEAD TO MISLEADING INFORMATION IN ANY CASE (e.g. 919).They have 2 positions after phd but they appear as having one. I could use ending dates. It will lead us to negative cases but number of jobs would be correct. Should i consider that they got a permanent position the same year after phd??? OK
// checking other cases// I create a variable to see what cases have changed. Except previous cases it looks more or less OK. We should report here they are late PhDs., and intersectorial cases.
 
gen cheknumjobs= number_jobs- number_jobsAPHD
tab cheknumjobs
// TYING TO SOLVE THESE CASES. I try to identify them.
gen tenuretrackBPHD=.
replace tenuretrackBPHD=5 if Q8_6x2<Q5_4x2 & Q8_6x3>Q5_4x2 & duration5p>=5
replace tenuretrackBPHD=4 if Q8_5x2<Q5_4x2 & Q8_5x3>Q5_4x2 & duration4p>=5
replace tenuretrackBPHD=3 if Q8_4x2<Q5_4x2 & Q8_4x3>Q5_4x2 & duration3p>=5
replace tenuretrackBPHD=2 if Q8_3x2<Q5_4x2 & Q8_3x3>Q5_4x2 & duration2p>=5
replace tenuretrackBPHD=1 if Q8_2x2<Q5_4x2 & Q8_2x3>Q5_4x2 & duration1p>=5

tab tenuretrackBPHD
*** Careful it has to be duration after PHD. and check what happens with intermediate positions
// I build a variable of reverse duration using ending years. Ending years the same as starting years. Need to decide where to count the year otherwise the year would be counted twice (half??) SHOULD I DO IT??? CHECK HOW MANY CASES WOOULD BE AFFECTED???

gen Q8_6x3_5= Q8_6x3-5
gen Q8_5x3_5= Q8_5x3-5
gen Q8_4x3_5= Q8_4x3-5
gen Q8_3x3_5= Q8_3x3-5
gen Q8_2x3_5= Q8_2x3-5

list Q8_2x3_5 Q8_2x3 in 1/5

gen tenuretrackBPHD_2=.
replace tenuretrackBPHD_2=5 if Q8_6x2<Q5_4x2 & Q8_6x3_5>Q5_4x2
replace tenuretrackBPHD_2=4 if Q8_5x2<Q5_4x2 & Q8_5x3_5>Q5_4x2
replace tenuretrackBPHD_2=3 if Q8_4x2<Q5_4x2 & Q8_4x3_5>Q5_4x2
replace tenuretrackBPHD_2=2 if Q8_3x2<Q5_4x2 & Q8_3x3_5>Q5_4x2
replace tenuretrackBPHD_2=1 if Q8_2x2<Q5_4x2 & Q8_2x3_5>Q5_4x2 

tab tenuretrackBPHD_2

gen tenuretrackBPHD_2=.
replace tenuretrackBPHD_2=5 if Q8_6x2<Q5_4x2 & Q8_6x3_5>Q5_4x2 & duration5p>=5
replace tenuretrackBPHD_2=4 if Q8_5x2<Q5_4x2 & Q8_5x3_5>Q5_4x2 & duration4p>=5
replace tenuretrackBPHD_2=3 if Q8_4x2<Q5_4x2 & Q8_4x3_5>Q5_4x2 & duration3p>=5
replace tenuretrackBPHD_2=2 if Q8_3x2<Q5_4x2 & Q8_3x3_5>Q5_4x2 & duration2p>=5
replace tenuretrackBPHD_2=1 if Q8_2x2<Q5_4x2 & Q8_2x3_5>Q5_4x2 & duration1p>=5


***** Now realise that I should consider ending contract year in order to calculate number of jobs after PHD for everybody.

gen number_jobsAPHD_2= .
 
replace number_jobsAPHD_2=5 if number_jobs==5 & Q8_6x3>=Q5_4x2
replace number_jobsAPHD_2=4 if number_jobs==4 & Q8_5x3>=Q5_4x2 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=4 if number_jobs==5 & Q8_5x3>=Q5_4x2 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5

replace number_jobsAPHD_2=3 if number_jobs==3 & Q8_4x3>=Q5_4x2 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=3 if number_jobs==4 & Q8_4x3>=Q5_4x2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5 
replace number_jobsAPHD_2=3 if number_jobs==5 & Q8_4x3>=Q5_4x2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5 

replace number_jobsAPHD_2=2 if number_jobs==2 & Q8_3x3>=Q5_4x2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=2 if number_jobs==3 & Q8_3x3>=Q5_4x2 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=2 if number_jobs==4 & Q8_3x3>=Q5_4x2 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=2 if number_jobs==5 & Q8_3x3>=Q5_4x2 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5

replace number_jobsAPHD_2=1 if number_jobs==1 & Q8_2x3>=Q5_4x2 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=1 if number_jobs==2 & Q8_2x3>=Q5_4x2 & number_jobsAPHD_2!=1 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=1 if number_jobs==3 & Q8_2x3>=Q5_4x2 & number_jobsAPHD_2!=1 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=1 if number_jobs==4 & Q8_2x3>=Q5_4x2 & number_jobsAPHD_2!=1 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5
replace number_jobsAPHD_2=1 if number_jobs==5 & Q8_2x3 >=Q5_4x2 & number_jobsAPHD_2!=1 & number_jobsAPHD_2!=2 & number_jobsAPHD_2!=3 & number_jobsAPHD_2!=4 & number_jobsAPHD_2!=5

tab number_jobsAPHD_2 number_jobs
tab number_jobsAPHD_2 number_jobsAPHD, miss

//I have to replace begining years Phd for starting year for the ones that the contract start before PhD but continues after it. 
gen intermediateP=.
replace intermediateP=1 if number_jobsAPHD_2!=number_jobsAPHD & number_jobsAPHD_2!=. 
replace intermediateP=0 if intermediateP!=1 & number_jobsAPHD_2!=.
tab intermediateP, miss

/// Goshhh!!! I am carring mistakes from number_jobs. It appears that It hasn't built only with years information. (eg. 3012) 2 number of jobs but only year information for 1
//256 cases changed
gen number_jobs2=.
replace number_jobs2=1 if number_jobs==1 & Q8_2x2!=.
replace number_jobs2=2 if number_jobs==2 & Q8_3x2!=.
replace number_jobs2=3 if number_jobs==3 & Q8_4x2!=.
replace number_jobs2=4 if number_jobs==4 & Q8_5x2!=.
replace number_jobs2=5 if number_jobs==5 & Q8_6x2!=.

tab number_jobs2 number_jobs, miss

sort number_jobs number_jobs2
list  CodeNumber Q8_2x2 Q8_3x2 Q8_4x2 Q8_5x2 Q8_6x2 number_jobs number_jobs2 if number_jobs!=number_jobs2 & number_jobs2==. & number_jobs!=.

// I have some missing cases from people with more infomation other positions 
// Ahh!! no unic code numbers I create ID. And manually change these cases false missing cases. 


rename  var347 ID
sort  number_jobs ID
list ID Q8_2x2 Q8_3x2 Q8_4x2 Q8_5x2 Q8_6x2 number_jobs number_jobs2 if number_jobs!=number_jobs2 & number_jobs2==. & number_jobs!=.

replace number_jobs2=1 if ID==251 | ID==1771| ID==1836 | ID==2050 | ID==2584 | ID==2766 | ID==3353 | ID==3358 | ID==3824 | ID==3995 | ID==4713 | ID==4991 | ID==5313 | ID==5392 | ID==5533 |ID==4299 | ID==4765 | ID==501 | ID==2005
replace number_jobs2=2 if ID==440 | ID==488 | ID==831| ID==919| ID==974| ID==2411| ID==3776| ID==4085| ID==4308| ID==4539 | ID==2504 |ID== 668
replace number_jobs2=3 if ID== 212| ID== 1140|ID==1309 |ID==3399 |ID==4654 |ID==5078 |ID==5311 | ID==6024 | ID==1870 | ID==2230 | ID==2389
replace number_jobs2=4 if ID== 303| ID==316 | ID==1061 | ID==2890 | ID==3439 | ID==3960 | ID==4026 | ID==4443 | ID==4653 | ID==4938    

replace number_jobs2=1 if ID==5579
replace number_jobs3=1 if ID==5579
gen number_jobs3= number_jobs2

// there are missing cases in number_jobs that it shouldn't be. Apparently it was built with country. 
// CAREFUL WITH MOBILITY EVENTS IN THIS CASES. NO LAND. I create another variable. I cant consider mobility without land. I keep them separated, just in case we want to impute land for missing cases
list ID Q8_2x2 Q8_3x2 Q8_4x2 Q8_5x2 Q8_6x2 number_jobs number_jobs2 if number_jobs==. & Q8_2x2!=. 

replace number_jobs3=1 if ID==633 | ID==1107 | ID==1815 |ID==2327 |ID==2680 |ID==2721 |ID==3160|ID==4676 |ID==5279 |ID==5357
replace number_jobs3=2 if ID==390 |ID==571 | ID==935 |ID==1871 |ID==2724 |ID==3097 |ID==3221 |ID==3548 |ID==3729|ID==4420 |ID==4816 |ID==5005 |ID==5516 |ID==5765 |ID==5800 |ID==5942
replace number_jobs3=3 if ID== 236|ID==499 | ID==765 |ID==932 |ID==1360 |ID==2242 |ID==2972 |ID==3240 |ID==3796 |ID==4385|ID==4452 |ID==4497 |ID==5006 |ID==5664 |ID==5971 |ID==6073
replace number_jobs3=4 if ID==444 |ID==1030 | ID==1259 |ID==1331 |ID==1371 |ID==1546 |ID==1743 |ID==2241 |ID==2331 |ID==2883 |ID==2922|ID==3469 |ID==4094 |ID==4476 |ID==4537 |ID==4727 |ID==4747 |ID==5455 |ID==5563 |ID==5922
replace number_jobs3=5 if ID== 166|ID==374 | ID== 376|ID==792 |ID==1722 |ID==1728 |ID==1948 |ID==1986 |ID==2037 |ID==2059 |ID==2629 |ID==3138 |ID==3227 |ID==3302 |ID==3443 |ID==3751 |ID==3810 |ID==4115 |ID==4378 |ID==5047 |ID==5194 |ID==5255 |ID==5303 |ID==5512 |ID==5537 |ID==5629 

//careful with cases 376 3302 3443 3751 4115 5303 missing with .a. the last position is missing but the information is in Q_x3 I move all the answer one positon to correct this. 

list ID Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 Q8_6x2 Q8_6x3 number_jobs number_jobs2 if ID==376|ID==3302| ID==3443|ID==3751|ID==4115|ID==5303

//I change number of jobs  but CAREFUL WITH OTHER VARIABLES BUILT. IT MIGHT HAVE BEEN AFFECTED. CHECK WHEN USIN PREVIOUSLY BUILT VARIABLES  

durPhd>06|ID==3302| ID==3443|ID==3751|ID==4115|ID==5303
durPhd>0ID==3302| ID==3443|ID==3751|ID==4115|ID==5303
replace number_jobs3=4 if ID==376|ID==3302| ID==3443|ID==3751|ID==4115|ID==5303

// dealing with PHD. missing cases (598) using Masters (missing cases reduced up to 84) using both MS and BA (missing cases reduced to 48). If I use BA there will be less information. Mean 6  years after Phd 9 after BA.

tab Q5_4x2, miss
tab Q5_3x2, miss
tab Q5_2x2, miss

tab Q5_3x2 if Q5_4x2==.
tab Q5_2x2 if Q5_4x2==. &  Q5_3x2==.
tab Q5_2x2 if Q5_4x2==. 

gen durPhd=Q5_4x2-Q5_3x2
tab durPhd, miss
sum durPhd
sum durPhd if durPhd>0
gen durPhd2=Q5_4x2-Q5_2x2
tab durPhd2, miss
sum durPhd2
sum durPhd2 if durPhd2>0

list ID Q24 Q5_4x2 Q5_3x2 Q5_2x2 durPhd durPhd2 if durPhd<0
// Some mistakes in PhD year . I use the average 

sum Q5_4x2 if Q24==38

replace Q5_4x2=2003 if ID==1385 
replace durPhd=5 if ID==1385 
replace durPhd2=10 if ID==1385 
list ID Q24 Q5_4x2 Q5_3x2 Q5_2x2 durPhd durPhd2 if  ID==1385 

// I check PhD year missing cases// average changes by cohort. I should consider in order to imput
// I check before if this group is affected by other things late masters, etc. by chequing durations masters BA
// Careful average of durPhd3 much higher for missing cases. According to the data on duration it makes more sense to use Masters year when PHD is not available. If I calculate Phd year with duration I will introduce more biases. It appears as they were mistakes


gen durPhd3=Q5_3x2-Q5_2x2
tab durPhd3
sum durPhd3 
sum durPhd2
sum durPhd
sum durPhd3 if Q5_4x2==.
tab Q24 


list ID Q24 Q5_4x2 Q5_3x2 Q5_2x2 durPhd durPhd2 if  Q5_4x2==.

sum Q5_4x2 if Q24>=70
sum Q5_4x2 if Q24>=60 & Q24<70
sum Q5_4x2 if Q24>=50 & Q24<60
sum Q5_4x2 if Q24>=40 & Q24<50
sum Q5_4x2 if Q24>=30 & Q24<40
sum Q5_4x2 if Q24<30

sum durPhd if Q24>=70
sum durPhd if Q24>=60 & Q24<70
sum durPhd if Q24>=50 & Q24<60
sum durPhd if Q24>=40 & Q24<50
sum durPhd if Q24>=30 & Q24<40
sum durPhd if Q24<30

sum durPhd2 if Q24>=70
sum durPhd2 if Q24>=60 & Q24<70
sum durPhd2 if Q24>=50 & Q24<60
sum durPhd2 if Q24>=40 & Q24<50
sum durPhd2 if Q24>=30 & Q24<40
sum durPhd2 if Q24<30

sum durPhd3 if Q24>=70
sum durPhd3 if Q24>=60 & Q24<70
sum durPhd3 if Q24>=50 & Q24<60
sum durPhd3 if Q24>=40 & Q24<50
sum durPhd3 if Q24>=30 & Q24<40
sum durPhd3 if Q24<30

//Curious duration from Ba to master has not change so much across cohorts
// I check again with duration3 to see if there is a bias of this missing group. Again durations much more higher consistently across cochorts supporting (and quite similar to durPHd supporting the idea that its a mistake.
sum durPhd3 if Q24>=70 & Q5_4x2==.
sum durPhd3 if Q24>=60 & Q24<70 & Q5_4x2==.
sum durPhd3 if Q24>=50 & Q24<60 & Q5_4x2==.
sum durPhd3 if Q24>=40 & Q24<50 & Q5_4x2==.
sum durPhd3 if Q24>=30 & Q24<40 & Q5_4x2==.
sum durPhd3 if Q24<30 & Q5_4x2==.

//I last degree year using Master year for missing cases. After checking that the BA year appears to be correct I decide to impute missing cases with duration (9 years). As many cases are over 40 by cohort (I should impute 9,11,11,10) there should not be a biase in averages. I create a second variable just in case.
// 36 missing cases. I decide not to impute this cases.
gen last_degree_year=Q5_4x2
replace last_degree_year=Q5_3x2 if Q5_4x2==.

tab last_degree_year, miss
list ID Q24 Q5_4x2 Q5_3x2 Q5_2x2 durPhd durPhd2 if  last_degree_year==.
sum Q5_2x2 Q5_3x2 Q5_4x2
sum Q5_2x2 if last_degree_year==.
sum Q5_2x2 if Q24>=70 & last_degree_year==.
sum Q5_2x2 if Q24>=60 & Q24<70 & last_degree_year==.
sum Q5_2x2 if Q24>=50 & Q24<60 & last_degree_year==.
sum Q5_2x2 if Q24>=40 & Q24<50 & last_degree_year==.
sum Q5_2x2 if Q24>=30 & Q24<40 & last_degree_year==.
sum Q5_2x2 if Q24<30 & last_degree_year==.
sum Q5_2x2  
sum Q5_2x2 if Q24>=70  
sum Q5_2x2 if Q24>=60 & Q24<70  
sum Q5_2x2 if Q24>=50 & Q24<60  
sum Q5_2x2 if Q24>=40 & Q24<50  
sum Q5_2x2 if Q24>=30 & Q24<40  
sum Q5_2x2 if Q24<30  

gen last_degree_year2=last_degree_year
replace last_degree_year2=Q5_2x2+9 if  last_degree_year==. 
tab last_degree_year2, miss


// I start again with number_jobs3

tab number_jobs3 , miss
tab number_jobs2 , miss
tab number_jobs, miss
list ID Q5_2x2 Q5_3x2 Q5_4x2 Q8_2x2 Q8_2x3 Q8_3x2 if number_jobs3==.


/////////////////////7zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz///////////////////////////




// year of first position

gen firstPyearG= .
 
replace firstPyearG=Q8_2x2 if number_jobs3==1
 
replace firstPyearG=Q8_3x2 if number_jobs3==2
 
replace firstPyearG=Q8_4x2 if number_jobs3==3
 
replace firstPyearG=Q8_5x2 if number_jobs3==4

replace firstPyearG=Q8_6x2 if number_jobs3==5 

tab firstPyearG

**** As some firstposition start befor phd. I build avariable indicating number of jobs after phd (I will consider start and ending year in order to avoid cases that start before phd but keep on working in the same university until permanent. Otherwise someone that start as assistant before phd but become professor would not be counted. CAREFUL I might be including after PHd jobs that do not deserve to be included. is it better to do starting???


gen number_jobsAPHD_G= .
 
replace number_jobsAPHD_G=5 if number_jobs3==5 & Q8_6x2>= last_degree_year2
replace number_jobsAPHD_G=4 if number_jobs3==4 & Q8_5x2>= last_degree_year2 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=4 if number_jobs3==5 & Q8_5x2>= last_degree_year2 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5

replace number_jobsAPHD_G=3 if number_jobs3==3 & Q8_4x2>= last_degree_year2 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=3 if number_jobs3==4 & Q8_4x2>= last_degree_year2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5 
replace number_jobsAPHD_G=3 if number_jobs3==5 & Q8_4x2>= last_degree_year2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5 

replace number_jobsAPHD_G=2 if number_jobs3==2 & Q8_3x2>= last_degree_year2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=2 if number_jobs3==3 & Q8_3x2>= last_degree_year2 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=2 if number_jobs3==4 & Q8_3x2>= last_degree_year2 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=2 if number_jobs3==5 & Q8_3x2>= last_degree_year2 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5

replace number_jobsAPHD_G=1 if number_jobs3==1 & Q8_2x2>= last_degree_year2 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=1 if number_jobs3==2 & Q8_2x2>= last_degree_year2 & number_jobsAPHD_G!=1 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=1 if number_jobs3==3 & Q8_2x2>= last_degree_year2 & number_jobsAPHD_G!=1 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=1 if number_jobs3==4 & Q8_2x2>= last_degree_year2 & number_jobsAPHD_G!=1 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=1 if number_jobs3==5 & Q8_2x2>= last_degree_year2 & number_jobsAPHD_G!=1 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5
replace number_jobsAPHD_G=0 if number_jobs3!=. & number_jobsAPHD_G!=1 & number_jobsAPHD_G!=2 & number_jobsAPHD_G!=3 & number_jobsAPHD_G!=4 & number_jobsAPHD_G!=5 & last_degree_year2!=.


tab number_jobsAPHD_G , miss
tab Q8_2x2 number_jobs3 , miss
tab last_degree_year2, miss
tab last_degree_year2 Q5_3x2, miss
list ID last_degree_year2 Q5_2x2 Q5_3x2 Q5_4x2 if last_degree_year2==2015 | last_degree_year2==2013 | last_degree_year2==2012
//I adjust some cases imputed that make last_degree_year2 2015 2013. I change them for 2012. There might be questionable cases (phd year imputed with master year 2012. These are 1502 5345 5476. BA is old enough to have a phd so I dont change them but check that do not bias results)

replace last_degree_year2= 2012 if ID==2324 | ID==3226 | ID==4013

list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 if number_jobsAPHD_G==0
list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 if number_jobsAPHD_G==.


// I use ending years lower than last degree. Otherwise I get many cases that end the position and move that are counted as false position after phd
// I add 0 category fot the ones that have positions but all of them ending in last degree year or before (Otherwise are false missing cases
gen number_jobsAPHD_2G= .
 
replace number_jobsAPHD_2G=5 if number_jobs3==5 & Q8_6x3> last_degree_year2
replace number_jobsAPHD_2G=4 if number_jobs3==4 & Q8_5x3> last_degree_year2 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=4 if number_jobs3==5 & Q8_5x3> last_degree_year2 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5

replace number_jobsAPHD_2G=3 if number_jobs3==3 & Q8_4x3> last_degree_year2 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=3 if number_jobs3==4 & Q8_4x3> last_degree_year2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5 
replace number_jobsAPHD_2G=3 if number_jobs3==5 & Q8_4x3> last_degree_year2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5 

replace number_jobsAPHD_2G=2 if number_jobs3==2 & Q8_3x3> last_degree_year2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=2 if number_jobs3==3 & Q8_3x3> last_degree_year2 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=2 if number_jobs3==4 & Q8_3x3> last_degree_year2 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=2 if number_jobs3==5 & Q8_3x3> last_degree_year2 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5

replace number_jobsAPHD_2G=1 if number_jobs3==1 & Q8_2x3> last_degree_year2 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=1 if number_jobs3==2 & Q8_2x3> last_degree_year2 & number_jobsAPHD_2G!=1 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=1 if number_jobs3==3 & Q8_2x3> last_degree_year2 & number_jobsAPHD_2G!=1 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=1 if number_jobs3==4 & Q8_2x3> last_degree_year2 & number_jobsAPHD_2G!=1 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=1 if number_jobs3==5 & Q8_2x3 > last_degree_year2 & number_jobsAPHD_2G!=1 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5
replace number_jobsAPHD_2G=0 if number_jobs3!=. & number_jobsAPHD_2G!=1 & number_jobsAPHD_2G!=2 & number_jobsAPHD_2G!=3 & number_jobsAPHD_2G!=4 & number_jobsAPHD_2G!=5 & last_degree_year2!=.

 
tab  number_jobsAPHD_2G, miss

list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 if number_jobsAPHD_2G==0
list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 if number_jobsAPHD_2G==.
 


tab number_jobsAPHD_2G number_jobsAPHD_G, miss
tab number_jobsAPHD_2G, miss
tab number_jobs3, miss 
list ID last_degree_year2 Q5_4x2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 if number_jobs3!=. & number_jobsAPHD_G==. 
list ID last_degree_year2 Q5_4x2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 number_jobsAPHD_G number_jobsAPHD_2G if number_jobsAPHD_G>number_jobsAPHD_2G
tab ID if number_jobsAPHD_G>number_jobsAPHD_2G

//There are some cases (103) that number_jobsAPHD_G > number_jobsAPHD_2G for one year positions that are in the PHD year. I should consider G in these cases.
replace number_jobsAPHD_2G=number_jobsAPHD_G if number_jobsAPHD_G>number_jobsAPHD_2G


//I have to replace begining years Phd for starting year position for the ones that the contract start before PhD but continues after it. With 0 positions doesnt work


gen intermediateP_G=.
replace intermediateP_G=1 if number_jobsAPHD_2G!=number_jobsAPHD_G & number_jobsAPHD_2G!=. & number_jobsAPHD_2G!=0
replace intermediateP_G=0 if intermediateP_G!=1 & number_jobsAPHD_2G!=. & number_jobsAPHD_G!=.
tab intermediateP_G, miss

// 64 cases go to missing (number_jobsAPHD_2G==0 I can identify them with number_jobsAPHD_G==0 ). They finish their position in the PhD year.  We might have imputed ending year
 list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G if Q8_2x2G==. & number_jobsAPHD_2G==0
 list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G if Q8_2x2!=. & number_jobsAPHD_G==0
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G number_jobsAPHD_2G if Q8_2x2==Q8_2x3 | Q8_3x2==Q8_3x3 in 1/50

// checking if 1 year positions are counted in other cases. Yes. Therefore I have to include them
list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 number_jobsAPHD_2G if Q8_2x2==Q8_2x3 & Q8_3x2!=.  in 1/500
// checking if these cases are imputed last_degree_year2. Some of them are but I think is worse not to do it

list ID last_degree_year2 Q5_4x2 Q5_3x2 Q8_2x2 Q8_2x3  Q8_3x2  Q8_3x3   if  number_jobsAPHD_G==0

replace number_jobsAPHD_2G=1 if number_jobsAPHD_2G==0 & ID!=712 & ID!=716 & ID!=1694  & ID!=1921 & ID!=3029 & ID!=5993
replace intermediateP_G=1 if   ID==203 | ID==263 | ID==380 | ID==404 | ID==443 | ID==755 | ID==807 | ID==939 | ID==1258 | ID==1398 | ID==1399 | ID==1431 | ID==1502| ID==	1510 | ID==	1569 | ID==	1588 | ID==	1850 | ID==	1863 | ID==	2087 | ID==	2097 | ID==	2324 | ID==	2404| ID==	2499 | ID==	2587 | ID==	2627 | ID==	2646 | ID==	2797 | ID==	2838 | ID==	2870 | ID==	3014 | ID==	3106| ID==	3126 | ID==	3170 | ID==	3208 | ID==	3226 | ID==	3227 | ID==	3245 | ID==	3271 | ID==	3416 | ID==	3532| ID==	3555| ID==	3593 | ID==	3595 | ID==	3833 | ID==	3879 | ID==	3889 | ID==	3890 | ID==4011  | ID==4013| ID==	4066 | ID==	4123 | ID==	4484 | ID==	4719 | ID==	4744 | ID==	4820 | ID==	4920 | ID==	5108 | ID==	5163| ID==	5164 | ID==	5200 | ID==	5345 | ID==	5466 | ID==	5476 | ID==	5610 | ID==	5968
list intermediateP_G ID if   ID==203 | ID==263 | ID==380 | ID==404 | ID==443 | ID==755 | ID==807 | ID==939 | ID==1258 | ID==1398 | ID==1399 | ID==1431 | ID==1502| ID==	1510 | ID==	1569 | ID==	1588 | ID==	1850 | ID==	1863 | ID==	2087 | ID==	2097 | ID==	2324 | ID==	2404| ID==	2499 | ID==	2587 | ID==	2627 | ID==	2646 | ID==	2797 | ID==	2838 | ID==	2870 | ID==	3014 | ID==	3106| ID==	3126 | ID==	3170 | ID==	3208 | ID==	3226 | ID==	3227 | ID==	3245 | ID==	3271 | ID==	3416 | ID==	3532| ID==	3555| ID==	3593 | ID==	3595 | ID==	3833 | ID==	3879 | ID==	3889 | ID==	3890 | ID==4011  | ID==4013| ID==	4066 | ID==	4123 | ID==	4484 | ID==	4719 | ID==	4744 | ID==	4820 | ID==	4920 | ID==	5108 | ID==	5163| ID==	5164 | ID==	5200 | ID==	5345 | ID==	5466 | ID==	5476 | ID==	5610 | ID==	5968




tab number_jobsAPHD_2G, miss
tab intermediateP_G, miss
tab number_jobsAPHD_G, miss
list ID number_jobsAPHD_2G number_jobsAPHD_G intermediateP_G last_degree_year2 if number_jobsAPHD_G==0

list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 in 1/30 if intermediateP_G==1
list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 intermediateP_G  if intermediateP_G==.
list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if ID==23 | ID==3

// there are 1333 intermediate positions (they got phd degree in the middle of a position). Is it worth to distinguish the ones that are finishing contracts (eg. case 23 in the fourth position) from promotions (eg. case 3)??
// USE number_jobsAPHD_2G and I will consider that the begining of this position is the phdyear for these cases in order not to have negative cases. I will distinguish promotions afterwards

replace number_jobsAPHD_2G=1 if ID==5006
replace number_jobsAPHD_G=1 if ID==5006
replace number_jobs3=1 if ID==5006

replace number_jobsAPHD_2G=1 if ID==3227
replace number_jobsAPHD_G=1 if ID==3227
replace number_jobs3=1 if ID==3227

replace number_jobsAPHD_2G=3 if ID==5047
replace number_jobsAPHD_G=3 if ID==5047
replace number_jobs3=3 if ID==5047


replace  Q8_6x2=. if Q8_6x2==.a
replace  Q8_6x3=. if Q8_6x3==.a

gen Q8_2x2G=. 
replace Q8_2x2G=Q8_2x2 if intermediateP_G==0 & number_jobsAPHD_2G>=1
replace Q8_2x2G=Q8_2x2 if intermediateP_G==1 & number_jobsAPHD_2G>1
replace Q8_2x2G=last_degree_year2 if intermediateP_G==1 & number_jobsAPHD_2G==1

gen Q8_3x2G=. 
replace Q8_3x2G=Q8_3x2 if intermediateP_G==0 & number_jobsAPHD_2G>=2
replace Q8_3x2G=Q8_3x2 if intermediateP_G==1 & number_jobsAPHD_2G>2
replace Q8_3x2G=last_degree_year2 if intermediateP_G==1 & number_jobsAPHD_2G==2

gen Q8_4x2G=. 
replace Q8_4x2G=Q8_4x2 if intermediateP_G==0 & number_jobsAPHD_2G>=3
replace Q8_4x2G=Q8_3x2 if intermediateP_G==1 & number_jobsAPHD_2G>3
replace Q8_4x2G=last_degree_year2 if intermediateP_G==1 & number_jobsAPHD_2G==3

gen Q8_5x2G=. 
replace Q8_5x2G=Q8_5x2 if intermediateP_G==0 & number_jobsAPHD_2G>=4
replace Q8_5x2G=Q8_5x2 if intermediateP_G==1 & number_jobsAPHD_2G>4
replace Q8_5x2G=last_degree_year2 if intermediateP_G==1 & number_jobsAPHD_2G==4

gen Q8_6x2G=. 
replace Q8_6x2G=Q8_6x2 if intermediateP_G==0 & number_jobsAPHD_2G>=5
replace Q8_6x2G=last_degree_year2 if intermediateP_G==1 & number_jobsAPHD_2G==5

 


 
tab Q8_2x2G, miss
tab Q8_2x2, miss
tab Q8_2x2G number_jobsAPHD_2G, miss
tab Q8_3x2G, miss
tab Q8_3x2G number_jobsAPHD_2G, miss 
tab Q8_4x2G, miss
tab Q8_4x2G number_jobsAPHD_2G, miss 
tab Q8_5x2G, miss
tab Q8_5x2G number_jobsAPHD_2G, miss 
tab Q8_6x2G, miss
tab Q8_6x2G number_jobsAPHD_2G, miss 
// there are 2 mising cases with number of jobs after phd 3 and 5. IT cant be I check the cases
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 Q8_6x2 Q8_6x3 intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 if number_jobsAPHD_2G==3 & Q8_3x2G==.
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 Q8_6x2 Q8_6x3 intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 if number_jobsAPHD_2G==5 & Q8_3x2G==.
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 Q8_6x2 Q8_6x3 intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 if number_jobsAPHD_2G==5 & Q8_5x2G==.

tab Q8_2x2G Q8_2x2, miss
list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 Q8_6x2 Q8_6x3   
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3  Q8_3x2 Q8_3x2G Q8_3x3 intermediateP_G number_jobsAPHD_2G if Q8_2x2G!=Q8_2x2 & last_degree_year2!=. 
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3  Q8_3x2 Q8_3x2G Q8_3x3 intermediateP_G number_jobsAPHD_2G if Q8_3x2G!=Q8_3x2 & last_degree_year2!=. 
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3  Q8_3x2 Q8_3x2G Q8_3x3 Q8_4x2 Q8_4x2G Q8_4x3 intermediateP_G number_jobsAPHD_2G if Q8_4x2G!=Q8_4x2 & last_degree_year2!=.
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3  Q8_3x2 Q8_3x2G Q8_3x3 intermediateP_G number_jobsAPHD_2G if Q8_2x2!=. & Q8_2x2G==.
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3  Q8_3x2 Q8_3x2G Q8_3x3 Q8_4x2 Q8_4x2G Q8_4x3 intermediateP_G number_jobsAPHD_2G in 1/30
list ID last_degree_year2 Q8_4x2 Q8_4x2G Q8_4x3 Q8_5x2 Q8_5x2G Q8_5x3 Q8_6x2 Q8_6x2G Q8_6x3 intermediateP_G number_jobsAPHD_2G in 1/30
list ID last_degree_year2 Q8_4x2 Q8_4x2G Q8_4x3 Q8_5x2 Q8_5x2G Q8_5x3 Q8_6x2 Q8_6x2G Q8_6x3 intermediateP_G number_jobsAPHD_2G if number_jobsAPHD_2G==5 
 
 
//GOOOD. OK missings in new variables are because they don't have phd information or they are after phd number_jobsAPHD_2G==0 also includes positions that end at Phd year. // check one year positions and missing with information.


gen Q8_2x3G=. 
replace Q8_2x3G=Q8_2x3 if Q8_2x2G!=.

gen Q8_3x3G=. 
replace Q8_3x3G=Q8_3x3 if Q8_3x2G!=.

gen Q8_4x3G=. 
replace Q8_4x3G=Q8_4x3 if Q8_4x2G!=.

gen Q8_5x3G=. 
replace Q8_5x3G=Q8_5x3 if Q8_5x2G!=.

gen Q8_6x3G=. 
replace Q8_6x3G=Q8_6x3 if Q8_6x2G!=.

list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G  intermediateP_G number_jobsAPHD_2G in 1/30
list ID last_degree_year2 Q8_4x2 Q8_4x2G Q8_4x3 Q8_4x3G Q8_5x2 Q8_5x2G Q8_5x3 Q8_5x3G Q8_6x2 Q8_6x2G Q8_6x3 Q8_6x3G  intermediateP_G number_jobsAPHD_2G in 1/30

list ID last_degree_year2 Q8_2x2 Q8_2x3 Q8_3x2 Q8_3x3 Q8_4x2 Q8_4x3 Q8_5x2 Q8_5x3 intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if ID==14
list ID last_degree_year2 Q8_2x2G Q8_2x3G Q8_3x2G Q8_3x3G Q8_4x2G Q8_4x3G Q8_5x2G Q8_5x3G intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if ID==14

list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_3x2 Q8_3x2G Q8_3x3 Q8_4x2 Q8_4x2G Q8_4x3 intermediateP_G number_jobsAPHD_2G if intermediateP_G==0 in 1/30

list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_5x2 Q8_5x2G Q8_5x3 Q8_6x2 Q8_6x2G Q8_6x3 intermediateP_G number_jobsAPHD_2G if intermediateP_G==0 in 1/30

 list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 in 1/50
 list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q8_2x3G Q8_3x2 Q8_3x2G Q8_3x3 Q8_3x3G Q8_4x2 Q8_4x2G Q8_4x3 Q8_4x3G intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 in 1/50
 list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_4x2 Q8_4x2G Q8_4x3 Q8_4x3G Q8_5x2 Q8_5x2G Q8_5x3 Q8_5x3G intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G number_jobs3 in 1/50

/// NEW FIRST PERMANENT POSITION. READ THIs
// use number_jobs3 for correct number of jobs with year information. Some of them won't have land CAREFUL
// use number_jobsAPHD_2G for number of jobs after phd
// use number_jobsAPHD_G for checking 0 cases that are not really missing but have information before phd
// use n_jobsUPPosG for changes up to permanent position. 0 category includes the ones that did not get the permanent position, but also 0

// use intermediateP_G 1 for identifying cases in which starting year has been replace by last_degree_year2 in order not to have negative cases and considering cases that start positions before phd but become professor (promotions are not considering)
// Q8_2x2G for after phd positions and intermediate corrected

 
 // YEAR fist permanent position
//1. TRYING FIRST WITH SELF REPORTED AS IT WAS DONE IN THE PREVIOUS ARTICLE
// As i should include missing conditions of Q82G for aplying Q9 properly. I create new variable as it's quicker. DO IT WHEN CONSIDERING OTHER VARIABLES.



// gosh information on permanent in Q9_3x2 is not recognised. IT IS codified differently. I change it (4=5 and 5=5)

codebook Q9_2x2 Q9_3x2 Q9_4x2 Q9_5x2 Q9_6x2
recode Q9_3x2 (1=1) (2=2) (3=3) (4=5) (5=4)
 


gen Q9_2x2G=. 
replace Q9_2x2G=Q9_2x2 if Q8_2x2G!=.

gen Q9_3x2G=. 
replace Q9_3x2G=Q9_3x2 if Q8_3x2G!=.

gen Q9_4x2G=. 
replace Q9_4x2G=Q9_4x2 if Q8_4x2G!=.

gen Q9_5x2G=. 
replace Q9_5x2G=Q9_5x2 if Q8_5x2G!=.

gen Q9_6x2G=. 
replace Q9_6x2G=Q9_6x2 if Q8_6x2G!=.








gen firstPermPyearG= .
 
replace firstPermPyearG=Q8_2x2G if number_jobsAPHD_2G==1 & Q9_2x2G==4
 
replace firstPermPyearG=Q8_3x2G if number_jobsAPHD_2G==2 & Q9_3x2G==4
 
replace firstPermPyearG=Q8_4x2G if number_jobsAPHD_2G==3 & Q9_4x2G==4
 
replace firstPermPyearG=Q8_5x2G if number_jobsAPHD_2G==4 & Q9_5x2G==4

replace firstPermPyearG=Q8_6x2G if number_jobsAPHD_2G==5 & Q9_6x2G==4

 

// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace firstPermPyearG=Q8_2x2G if number_jobsAPHD_2G==2 & Q9_2x2G==4 & Q9_3x2G!=4
replace firstPermPyearG=Q8_3x2G if number_jobsAPHD_2G==3 & Q9_3x2G==4 & Q9_4x2G!=4
replace firstPermPyearG=Q8_2x2G if number_jobsAPHD_2G==3 & Q9_2x2G==4 & Q9_4x2G!=4 & Q9_3x2G!=4

replace firstPermPyearG=Q8_4x2G if number_jobsAPHD_2G==4 & Q9_4x2G==4 & Q9_5x2G!=4
replace firstPermPyearG=Q8_3x2G if number_jobsAPHD_2G==4 & Q9_3x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4
replace firstPermPyearG=Q8_2x2G if number_jobsAPHD_2G==4 & Q9_2x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4

replace firstPermPyearG=Q8_5x2G if number_jobsAPHD_2G==5 & Q9_5x2G==4 & Q9_6x2G!=4  
replace firstPermPyearG=Q8_4x2G if number_jobsAPHD_2G==5 & Q9_4x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4
replace firstPermPyearG=Q8_3x2G if number_jobsAPHD_2G==5 & Q9_3x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & Q9_4x2G!=4
replace firstPermPyearG=Q8_2x2G if number_jobsAPHD_2G==5 & Q9_2x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4


list ID last_degree_year2 Q8_2x2G Q9_2x2G  Q8_3x2G  Q9_3x2G Q8_4x2G Q9_4x2G Q8_5x2G Q9_5x2G Q8_6x2G Q9_6x2G firstPermPyearG number_jobsAPHD_2G if Q8_4x2G==. & firstPermPyearG!=.
tab firstPermPyearG, miss


// NUMBER OF POSITIONS FOR PERMANENT WITH SELF DECLARED DEFINITION
 
gen n_jobsUPPSG=.
replace  n_jobsUPPSG=1 if  number_jobsAPHD_2G==1 & Q9_2x2G==4

replace n_jobsUPPSG=2 if  number_jobsAPHD_2G==2 & Q9_3x2G==4
 
replace n_jobsUPPSG=3 if  number_jobsAPHD_2G==3 & Q9_4x2G==4
 
replace n_jobsUPPSG=4 if  number_jobsAPHD_2G==4 & Q9_5x2G==4

replace n_jobsUPPSG=5 if  number_jobsAPHD_2G==5 & Q9_6x2G==4


// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace n_jobsUPPSG=1 if  number_jobsAPHD_2G==2 & Q9_2x2G==4 & Q9_3x2G!=4

replace n_jobsUPPSG=2 if  number_jobsAPHD_2G==3 & Q9_3x2G==4 & Q9_4x2G!=4
replace n_jobsUPPSG=1 if  number_jobsAPHD_2G==3 & Q9_2x2G==4 & Q9_4x2G!=4 & Q9_3x2G!=4

replace n_jobsUPPSG=3 if  number_jobsAPHD_2G==4 & Q9_4x2G==4 & Q9_5x2G!=4
replace n_jobsUPPSG=2 if  number_jobsAPHD_2G==4 & Q9_3x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 
replace n_jobsUPPSG=1 if  number_jobsAPHD_2G==4 & Q9_2x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4

replace n_jobsUPPSG=4 if  number_jobsAPHD_2G==5 & Q9_5x2G==4 & Q9_6x2G!=4  
replace n_jobsUPPSG=3 if  number_jobsAPHD_2G==5 & Q9_4x2G==4 & Q9_6x2G!=4  & Q9_5x2G!=4
replace n_jobsUPPSG=2 if  number_jobsAPHD_2G==5 & Q9_3x2G==4 & Q9_6x2G!=4  & Q9_5x2G!=4 & Q9_4x2G!=4
replace n_jobsUPPSG=1 if  number_jobsAPHD_2G==5 & Q9_2x2G==4 & Q9_6x2G!=4  & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4

replace n_jobsUPPSG=0 if  number_jobsAPHD_2G!=. & n_jobsUPPSG==.   



tab n_jobsUPPSG , miss
tab number_jobsAPHD_2G, miss
tab n_jobsUPPSG number_jobsAPHD_2G, miss



////////////////////////zzzz
/// SOME CHECKING POSTIONS AFETER PHD ARE NEGATIVE // PROBLEM WITH OVERLAPPING POSITIONS. WHAT TO DO WITH THEM??? SHOULD I CHANGE MANUALLY (I check and year permanent is correct)
/// it could affect duration
// these are the cases 25 cases q8_2x ( 807 1431 2646 3014 4744 4820) q8_3x (67 150 957 1000 1895 2392 2646 2769 3189 3333 3424 4059) q8_4x ( 2646 4934) q8_5x (183 1270 3707 4295 4934)
//Of these 25 cases only these 5 affect firstPermPOsition 183 1895 2769 4744 4820. THINK IF IT IS BETTER ONLY TO CHANGE THIS. I check first time perm manually for rest and it is corres. I could introduce more biases if I change more things

gen prudur= Q8_2x2G-last_degree_year2
tab prudur
gen prudur2= Q8_3x2G-last_degree_year2
gen prudur3= Q8_4x2G-last_degree_year2
gen prudur4= Q8_5x2G-last_degree_year2
gen prudur5= Q8_6x2G-last_degree_year2
tab prudur
tab prudur2
tab prudur3
tab prudur4
tab prudur5

gen pruTimPer= firstPermPyearG-last_degree_year2
tab pruTimPer, miss
list ID if pruTimPer<0




list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q9_2x2 Q8_3x2  Q8_3x2G Q8_3x3 Q9_3x2 Q8_4x2 Q8_4x2G Q8_4x3 Q9_4x2 prudur  firstPermPyearG intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if prudur<0
 list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q9_2x2 Q8_3x2  Q8_3x2G Q8_3x3 Q9_3x2 Q8_4x2 Q8_4x2G Q8_4x3 Q9_4x2 prudur  firstPermPyearG intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if prudur2<0
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q9_2x2 Q8_3x2  Q8_3x2G Q8_3x3 Q9_3x2 Q8_4x2 Q8_4x2G Q8_4x3 Q9_4x2 prudur  firstPermPyearG intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if prudur3<0
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q9_2x2 Q8_3x2  Q8_3x2G Q8_3x3 Q9_3x2 Q8_4x2 Q8_4x2G Q8_4x3 Q9_4x2 Q8_5x2 Q8_5x2G Q8_5x3 Q9_5x2 Q8_6x2 Q8_6x2G Q8_6x3 Q9_6x2 prudur  firstPermPyearG intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if prudur4<0
list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q9_2x2 Q8_3x2  Q8_3x2G Q8_3x3 Q9_3x2 Q8_4x2 Q8_4x2G Q8_4x3 Q9_4x2 Q8_5x2 Q8_5x2G Q8_5x3 Q9_5x2 Q8_6x2 Q8_6x2G Q8_6x3 Q9_6x2 prudur  firstPermPyearG intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G if ID==183 |ID==1895 |ID== 2769|ID== 4744|ID== 4820

list ID    prudur  if prudur<0
 list ID  prudur2   if prudur2<0
list ID  prudur3 if prudur3<0
list ID prudur4 if prudur4<0
list ID prudur5 if prudur5<0

replace Q8_5x2G=last_degree_year2 if ID==183
replace firstPermPyearG=last_degree_year2 if ID==183

replace Q8_3x2G=last_degree_year2 if ID==1895
replace firstPermPyearG=last_degree_year2 if ID==1895

 
replace Q8_3x2G=last_degree_year2 if ID==2769
replace firstPermPyearG=last_degree_year2 if ID==2769

replace Q8_2x2G=last_degree_year2 if ID==4744
replace firstPermPyearG=last_degree_year2 if ID==4744

replace Q8_2x2G=last_degree_year2 if ID==4820
replace firstPermPyearG=last_degree_year2 if ID==4820


// Problem with missing cases in Q9_Xx2. They appear as missing cases but we have information on positions.I use duration in order to consider permanent positions with duration equal or higher than 5 years
// I create firstPermPyear2 in order to have both variables
// I calculate the duration of all the positions

// I complete end year = 2012 when they have the starting year. Most of the cases were already done but some of them remained.
//Very long duration(these might have been retired, but i think that we include 2012 as ending year)
/

gen duration1pG=.
replace duration1pG= Q8_2x3G - Q8_2x2G
gen duration2pG=.
replace duration2pG= Q8_3x3G - Q8_3x2G
gen duration3pG=.
replace duration3pG= Q8_4x3G - Q8_4x2G
gen duration4pG=.
replace duration4pG= Q8_5x3G - Q8_5x2G
gen duration5pG=.
replace duration5pG= Q8_6x3G - Q8_6x2G


// I order to avoid mistakes of overlapping positions i create a duration2 that "clean these cases" after checking that condition only affect to these cases

gen duration1p2G=. 
replace duration1p2G= Q8_2x3G - Q8_2x2G if Q8_2x2G>=last_degree_year2
replace duration1p2G= Q8_2x3G - last_degree_year2 if Q8_2x2G<last_degree_year2
gen duration2p2G=.
replace duration2p2G= Q8_3x3G - Q8_3x2G if Q8_3x2G>=last_degree_year2
replace duration2p2G= Q8_3x3G - last_degree_year2 if Q8_3x2G<last_degree_year2
gen duration3p2G=.
replace duration3p2G= Q8_4x3G - Q8_4x2G if Q8_4x2G>=last_degree_year2
replace duration3p2G= Q8_4x3G -last_degree_year2 if Q8_4x2G<last_degree_year2
gen duration4p2G=.
replace duration4p2G= Q8_5x3G - Q8_5x2G if Q8_5x2G>=last_degree_year2
replace duration4p2G= Q8_5x3G -last_degree_year2 if Q8_5x2G<last_degree_year2
gen duration5p2G=.
replace duration5p2G= Q8_6x3G - Q8_6x2G if Q8_6x2G>=last_degree_year2
replace duration4p2G= Q8_5x3G -last_degree_year2 if Q8_6x2G<last_degree_year2


tab duration1pG, miss
tab duration1p2G, miss
tab duration1pG duration1p2G

tab Q8_2x2G if Q8_2x2G<last_degree_year2
tab Q8_3x2G if Q8_3x2G<last_degree_year2
tab Q8_4x2G if Q8_4x2G<last_degree_year2
tab Q8_5x2G if Q8_5x2G<last_degree_year2
tab Q8_6x2G if Q8_6x2G<last_degree_year2

list ID if duration1p2G!=duration1pG 
list ID if duration2p2G!=duration2pG
list ID if duration3p2G!=duration3pG
list ID if duration4p2G!=duration4pG
list ID if duration5p2G!=duration5pG
list ID if Q8_2x2G<last_degree_year2
tab Q8_2x3G<last_degree_year2



gen firstPermPyear2G=firstPermPyearG
replace firstPermPyear2G=Q8_2x2G if firstPermPyearG==. & duration1p2G>=5 & number_jobsAPHD_2G==1
replace firstPermPyear2G=Q8_3x2G if firstPermPyearG==. & duration2p2G>=5 & number_jobsAPHD_2G==2
replace firstPermPyear2G=Q8_4x2G if firstPermPyearG==. & duration3p2G>=5 & number_jobsAPHD_2G==3
replace firstPermPyear2G=Q8_5x2G if firstPermPyearG==. & duration4p2G>=5 & number_jobsAPHD_2G==4
replace firstPermPyear2G=Q8_6x2G if firstPermPyearG==. & duration5p2G>=5 & number_jobsAPHD_2G==5


replace firstPermPyear2G=Q8_2x2G if firstPermPyearG==. & duration1p2G>=5 & number_jobsAPHD_2G==2 & duration2p2G<5

replace firstPermPyear2G=Q8_3x2G if firstPermPyearG==. & duration2p2G>=5 & number_jobsAPHD_2G==3 & duration3p2G<5
replace firstPermPyear2G=Q8_2x2G if firstPermPyearG==. & duration1p2G>=5 & number_jobsAPHD_2G==3 & duration3p2G<5 & duration2p2G<5

replace firstPermPyear2G=Q8_4x2G if firstPermPyearG==. & duration3p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5
replace firstPermPyear2G=Q8_3x2G if firstPermPyearG==. & duration2p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5 & duration3pG<5
replace firstPermPyear2G=Q8_2x2G if firstPermPyearG==. & duration1p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5 & duration3pG<5 & duration2pG<5

replace firstPermPyear2G=Q8_5x2G if firstPermPyearG==. & duration4p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5
replace firstPermPyear2G=Q8_4x2G if firstPermPyearG==. & duration3p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5
replace firstPermPyear2G=Q8_3x2G if firstPermPyearG==. & duration2p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace firstPermPyear2G=Q8_2x2G if firstPermPyearG==. & duration1p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

tab firstPermPyear2G, miss
gen pruTimPer2= firstPermPyear2G-last_degree_year2
tab pruTimPer2, miss
list ID if pruTimPer2<0
drop pruTimPer2
 
 

// NUMBER OF POSITIONS FOR PERMANENT WITH SELD DECLARED 2 DEFINITION NOT DONE BECAUSE NOT MANY CASES
 
 
gen n_jobsUPPS2G=n_jobsUPPSG

replace n_jobsUPPS2G=1 if number_jobsAPHD_2G==1 & n_jobsUPPSG==. & duration1p2G>=5  
replace n_jobsUPPS2G=2 if  number_jobsAPHD_2G==2 & n_jobsUPPSG==. & duration2p2G>=5
replace n_jobsUPPS2G=3 if  number_jobsAPHD_2G==3 & n_jobsUPPSG==. & duration3p2G>=5
replace n_jobsUPPS2G=4 if  number_jobsAPHD_2G==4 & n_jobsUPPSG==. & duration4p2G>=5
replace n_jobsUPPS2G=5 if  number_jobsAPHD_2G==5 & n_jobsUPPSG==. & duration5p2G>=5


// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace n_jobsUPPS2G=1 if  number_jobsAPHD_2G==2 & n_jobsUPPSG==. &  duration1p2G>=5  & duration2p2G<5

replace n_jobsUPPS2G=2 if  number_jobsAPHD_2G==3 & n_jobsUPPSG==. & duration2p2G>=5   & duration3p2G<5
replace n_jobsUPPS2G=1 if  number_jobsAPHD_2G==3 & n_jobsUPPSG==.  & duration1p2G>=5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPS2G=3 if  number_jobsAPHD_2G==4 & n_jobsUPPSG==. & duration3p2G>=5  & duration4p2G<5
replace n_jobsUPPS2G=2 if  number_jobsAPHD_2G==4 & n_jobsUPPSG==. & duration2p2G>=5  & duration4p2G<5 & duration3pG<5 
replace n_jobsUPPS2G=1 if  number_jobsAPHD_2G==4 & n_jobsUPPSG==. & duration1p2G>=5 & duration4p2G<5 & duration3pG<5 & duration2pG<5

replace n_jobsUPPS2G=4 if  number_jobsAPHD_2G==5 & n_jobsUPPSG==. & duration4p2G>=5 & duration5p2G<5 
replace n_jobsUPPS2G=3 if  number_jobsAPHD_2G==5 & n_jobsUPPSG==. & duration3p2G>=5  & duration5p2G<5 & duration4p2G<5
replace n_jobsUPPS2G=2 if  number_jobsAPHD_2G==5 & n_jobsUPPSG==. & duration2p2G>=5   & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace n_jobsUPPS2G=1 if  number_jobsAPHD_2G==5 & n_jobsUPPSG==. & duration1p2G>=5   & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPS2G=0 if  number_jobsAPHD_2G!=. & n_jobsUPPS2G==.   



tab n_jobsUPPS2G , miss
tab number_jobsAPHD_2G, miss
tab n_jobsUPPS2G number_jobsAPHD_2G, miss

 
 
 
 
 
 
 
 //FIRST PERMANENT BY TYPE OF POSITION 
// I think that this is the best obpion.
// Duration doesn't work if they have get a permanent position recently (check with position). Lecturer
//MORE OBSERVATION IN POSITION. DON'T KNOW WHY WE USE SELF REPORTED


//CHECKING IF DURATIONS ARE CONSISTENT WITH POSITIONS// It appears that they make sense non-tenure track sorter than 5 generally

gen Q8_2x7G=. 
replace Q8_2x7G=Q8_2x7 if Q8_2x2G!=.

gen Q8_3x7G=. 
replace Q8_3x7G=Q8_3x7 if Q8_3x2G!=.

gen Q8_4x7G=. 
replace Q8_4x7G=Q8_4x7 if Q8_4x2G!=.

gen Q8_5x7G=. 
replace Q8_5x7G=Q8_5x7 if Q8_5x2G!=.

gen Q8_6x7G=. 
replace Q8_6x7G=Q8_6x7 if Q8_6x2G!=.



sort Q8_2x7G
by Q8_2x7G: sum duration1p2G duration2p2G duration3p2G duration4p2G duration5p2G
sort Q8_3x7G
by Q8_3x7G: sum duration1p2G duration2p2G duration3p2G duration4p2G duration5p2G
sort Q8_4x7G
by Q8_4x7G: sum duration1p2G duration2p2G duration3p2G duration4p2G duration5p2G
sort Q8_5x7G
by Q8_5x7G: sum duration1p2G duration2p2G duration3p2G duration4p2G duration5p2G
sort Q8_6x7G
by Q8_6x7G: sum duration1p2G duration2p2G duration3p2G duration4p2G duration5p2G


// There are inconsistencies some supposetely non-permanent are declared as permantent positions WHAT TO DO USE ONE CRITERION OR EXCLUDE THE INCONSISTENCIES
tab  Q8_2x7G Q9_2x2G


// I consider permanent positions-tenure track  1. Associate Professor; 2. Lecturer; 5. Professor; 6. Senior Research Fellow

recode Q8_2x7G (1 2 5 7 =1) (3 4 6 7 =0) (missing = .) , gen(Q8_2x7PermG)
recode Q8_3x7G (1 2 5 7 =1) (3 4 6 7 =0) (missing = .) , gen(Q8_3x7PermG)
recode Q8_4x7G (1 2 5 7 =1) (3 4 6 7 =0) (missing = .) , gen(Q8_4x7PermG)
recode Q8_5x7G (1 2 5 7 =1) (3 4 6 7 =0) (missing = .) , gen(Q8_5x7PermG)
recode Q8_6x7G (1 2 5 7 =1) (3 4 6 7 =0) (missing = .) , gen(Q8_6x7PermG)

//Are all Associate Professor answers really tenure track positions??
tab Q8_2x7G Q9_2x2G, row
tab Q8_4x7G Q9_4x2G, row
*Percentages look OK. "Senior Lecturer looks more problematic". I checked by country just in case.
sort Countryb
by Countryb: tab Q8_2x7G Q9_2x2G, row
*GOSH. By country some categories change. Eg. Spain the number of permanent lecturers is suspitiously low. WHAT TO DO??? Include also a combination of POSITION PLUSS 5 YEARS??? OR SELF REPORTED?? I will reduce the sample because the missing cases

 

gen firstPermPyearPosG= .
 
replace firstPermPyearPosG=Q8_2x2G if  number_jobsAPHD_2G==1 & Q8_2x7PermG==1
 
replace firstPermPyearPosG=Q8_3x2G if  number_jobsAPHD_2G==2 & Q8_3x7PermG==1
 
replace firstPermPyearPosG=Q8_4x2G if  number_jobsAPHD_2G==3 & Q8_4x7PermG==1
 
replace firstPermPyearPosG=Q8_5x2G if  number_jobsAPHD_2G==4 & Q8_5x7PermG==1

replace firstPermPyearPosG=Q8_6x2G if  number_jobsAPHD_2G==5 & Q8_6x7PermG==1

// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace firstPermPyearPosG=Q8_2x2G if  number_jobsAPHD_2G==2 & Q8_2x7PermG==1 & Q8_3x7PermG!=1
replace firstPermPyearPosG=Q8_3x2G if  number_jobsAPHD_2G==3 & Q8_3x7PermG==1 & Q8_4x7PermG!=1
replace firstPermPyearPosG=Q8_2x2G if  number_jobsAPHD_2G==3 & Q8_2x7PermG==1 & Q8_4x7PermG!=1 & Q8_3x7PermG!=1

replace firstPermPyearPosG=Q8_4x2G if  number_jobsAPHD_2G==4 & Q8_4x7PermG==1 & Q8_5x7PermG!=1
replace firstPermPyearPosG=Q8_3x2G if  number_jobsAPHD_2G==4 & Q8_3x7PermG==1 & Q8_5x7PermG!=1 & Q8_4x7PermG!=1 
replace firstPermPyearPosG=Q8_2x2G if  number_jobsAPHD_2G==4 & Q8_2x7PermG==1 & Q8_5x7PermG!=1 & Q8_4x7PermG!=1 & Q8_3x7PermG!=1

replace firstPermPyearPosG=Q8_5x2G if  number_jobsAPHD_2G==5 & Q8_5x7PermG==1 & Q8_6x7PermG!=1  
replace firstPermPyearPosG=Q8_4x2G if  number_jobsAPHD_2G==5 & Q8_4x7PermG==1 & Q8_6x7PermG!=1  & Q8_5x7PermG!=1
replace firstPermPyearPosG=Q8_3x2G if  number_jobsAPHD_2G==5 & Q8_3x7PermG==1 & Q8_6x7PermG!=1  & Q8_5x7PermG!=1 & Q8_4x7PermG!=1
replace firstPermPyearPosG=Q8_2x2G if  number_jobsAPHD_2G==5 & Q8_2x7PermG==1 & Q8_6x7PermG!=1  & Q8_5x7PermG!=1 & Q8_4x7PermG!=1 & Q8_3x7PermG!=1

//checking new way of addressing number of job_changes.

// NUMBER OF POSITIONS FOR PERMANENT WITH POSITION DEFINITION

gen n_jobsUPPosG=.
replace  n_jobsUPPosG=1 if  number_jobsAPHD_2G==1 & Q8_2x7PermG==1

replace n_jobsUPPosG=2 if  number_jobsAPHD_2G==2 & Q8_3x7PermG==1
 
replace n_jobsUPPosG=3 if  number_jobsAPHD_2G==3 & Q8_4x7PermG==1
 
replace n_jobsUPPosG=4 if  number_jobsAPHD_2G==4 & Q8_5x7PermG==1

replace n_jobsUPPosG=5 if  number_jobsAPHD_2G==5 & Q8_6x7PermG==1


// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace n_jobsUPPosG=1 if  number_jobsAPHD_2G==2 & Q8_2x7PermG==1 & Q8_3x7PermG!=1

replace n_jobsUPPosG=2 if  number_jobsAPHD_2G==3 & Q8_3x7PermG==1 & Q8_4x7PermG!=1
replace n_jobsUPPosG=1 if  number_jobsAPHD_2G==3 & Q8_2x7PermG==1 & Q8_4x7PermG!=1 & Q8_3x7PermG!=1

replace n_jobsUPPosG=3 if  number_jobsAPHD_2G==4 & Q8_4x7PermG==1 & Q8_5x7PermG!=1
replace n_jobsUPPosG=2 if  number_jobsAPHD_2G==4 & Q8_3x7PermG==1 & Q8_5x7PermG!=1 & Q8_4x7PermG!=1 
replace n_jobsUPPosG=1 if  number_jobsAPHD_2G==4 & Q8_2x7PermG==1 & Q8_5x7PermG!=1 & Q8_4x7PermG!=1 & Q8_3x7PermG!=1

replace n_jobsUPPosG=4 if  number_jobsAPHD_2G==5 & Q8_5x7PermG==1 & Q8_6x7PermG!=1  
replace n_jobsUPPosG=3 if  number_jobsAPHD_2G==5 & Q8_4x7PermG==1 & Q8_6x7PermG!=1  & Q8_5x7PermG!=1
replace n_jobsUPPosG=2 if  number_jobsAPHD_2G==5 & Q8_3x7PermG==1 & Q8_6x7PermG!=1  & Q8_5x7PermG!=1 & Q8_4x7PermG!=1
replace n_jobsUPPosG=1 if  number_jobsAPHD_2G==5 & Q8_2x7PermG==1 & Q8_6x7PermG!=1  & Q8_5x7PermG!=1 & Q8_4x7PermG!=1 & Q8_3x7PermG!=1

replace n_jobsUPPosG=0 if  number_jobsAPHD_2G!=. & n_jobsUPPosG==.   



tab n_jobsUPPosG , miss
tab number_jobsAPHD_2G, miss
tab n_jobsUPPosG number_jobsAPHD_2G, miss

 

// Dealing with the problem of consistency (positions wrowngly considered as) across countries and/or missing information. I use duration in order to creaty a firstPermPyearPo
// I create firstPermPyearPos2 in order to have both variables
// I calculate the duration of all the positions

//Dealing with missing cases for type of position using duration

gen firstPermPyearPos2G=firstPermPyearPos
replace firstPermPyearPos2G=Q8_2x2G if firstPermPyearPosG==. & duration1p2G>=5 & number_jobsAPHD_2G==1
replace firstPermPyearPos2G=Q8_3x2G if firstPermPyearPosG==. & duration2p2G>=5 & number_jobsAPHD_2G==2
replace firstPermPyearPos2G=Q8_4x2G if firstPermPyearPosG==. & duration3p2G>=5 & number_jobsAPHD_2G==3
replace firstPermPyearPos2G=Q8_5x2G if firstPermPyearPosG==. & duration4p2G>=5 & number_jobsAPHD_2G==4
replace firstPermPyearPos2G=Q8_6x2G if firstPermPyearPosG==. & duration5p2G>=5 & number_jobsAPHD_2G==5


replace firstPermPyearPos2G=Q8_2x2G if firstPermPyearPosG==. & duration1p2G>=5 & number_jobsAPHD_2G==2 & duration2p2G<5

replace firstPermPyearPos2G=Q8_3x2G if firstPermPyearPosG==. & duration2p2G>=5 & number_jobsAPHD_2G==3 & duration3p2G<5
replace firstPermPyearPos2G=Q8_2x2G if firstPermPyearPosG==. & duration1p2G>=5 & number_jobsAPHD_2G==3 & duration3p2G<5 & duration2p2G<5

replace firstPermPyearPos2G=Q8_4x2G if firstPermPyearPosG==. & duration3p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5
replace firstPermPyearPos2G=Q8_3x2G if firstPermPyearPosG==. & duration2p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5 & duration3p2G<5
replace firstPermPyearPos2G=Q8_2x2G if firstPermPyearPosG==. & duration1p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace firstPermPyearPos2G=Q8_5x2G if firstPermPyearPosG==. & duration4p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5
replace firstPermPyearPos2G=Q8_4x2G if firstPermPyearPosG==. & duration3p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5
replace firstPermPyearPos2G=Q8_3x2G if firstPermPyearPosG==. & duration2p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace firstPermPyearPos2G=Q8_2x2G if firstPermPyearPosG==. & duration1p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5


/// I don't calculate number of job positions for this definition because there are not many missing cases. It is more interesting to check consistency.


// Dealing with consistency (people that anwer a type of position that is not really permanent e.g lecturer Spain) AND duration >= 5 LESS CASES. Using
//AND
// *this doesnt work in the cases that I have to sustitute for other years. I need to check if it compensates with the people I miss (eg. Professors that change jobs before 5 years) This could be also country biased.
 gen  firstPermPyearPos4G=.
replace  firstPermPyearPos4G=firstPermPyearPosG if duration1p2G>=5 & number_jobsAPHD_2G==1
replace  firstPermPyearPos4G=firstPermPyearPosG if duration2p2G>=5 & number_jobsAPHD_2G==2
replace  firstPermPyearPos4G=firstPermPyearPosG if duration3p2G>=5 & number_jobsAPHD_2G==3
replace  firstPermPyearPos4G=firstPermPyearPosG if duration4p2G>=5 & number_jobsAPHD_2G==4
replace  firstPermPyearPos4G=firstPermPyearPosG if duration5p2G>=5 & number_jobsAPHD_2G==5


replace  firstPermPyearPos4G=firstPermPyearPosG if  duration1p2G>=5 & number_jobsAPHD_2G==2 & duration2p2G<5

replace  firstPermPyearPos4G=firstPermPyearPosG if  duration2p2G>=5 & number_jobsAPHD_2G==3 & duration3p2G<5
replace  firstPermPyearPos4G=firstPermPyearPosG if  duration1p2G>=5 & number_jobsAPHD_2G==3 & duration3p2G<5 & duration2p2G<5

replace  firstPermPyearPos4G=firstPermPyearPosG if  duration3p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5
replace  firstPermPyearPos4G=firstPermPyearPosG if  duration2p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5 & duration3p2G<5
replace  firstPermPyearPos4G=firstPermPyearPosG if  duration1p2G>=5 & number_jobsAPHD_2G==4 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace  firstPermPyearPos4G=firstPermPyearPosG if  duration4p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5
replace  firstPermPyearPos4G=firstPermPyearPosG if  duration3p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5
replace  firstPermPyearPos4G=firstPermPyearPosG if  duration2p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace  firstPermPyearPos4G=firstPermPyearPosG if duration1p2G>=5 & number_jobsAPHD_2G==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5


// NUMBER OF POSITIONS FOR PERMANENT WITH POSITION DEFINITION 4 consistency with duration

gen n_jobsUPPos4G=.
replace  n_jobsUPPos4G=1 if  number_jobsAPHD_2G==1& n_jobsUPPosG==1 & duration1p2G>=5
replace n_jobsUPPos4G=2 if  number_jobsAPHD_2G==2 & n_jobsUPPosG==2 & duration2p2G>=5
replace n_jobsUPPos4G=3 if  number_jobsAPHD_2G==3 & n_jobsUPPosG==3 & duration3p2G>=5
replace n_jobsUPPos4G=4 if  number_jobsAPHD_2G==4 & n_jobsUPPosG==4 & duration4p2G>=5
replace n_jobsUPPos4G=5 if  number_jobsAPHD_2G==5 & n_jobsUPPosG==5 & duration5p2G>=5


// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace n_jobsUPPos4G=1 if  number_jobsAPHD_2G==2 & duration1p2G>=5 & n_jobsUPPosG==2 & duration2p2G<5

replace n_jobsUPPos4G=2 if  number_jobsAPHD_2G==3 & duration2p2G>=5 & n_jobsUPPosG==3 & duration3p2G<5
replace n_jobsUPPos4G=1 if  number_jobsAPHD_2G==3 & duration1p2G>=5 & n_jobsUPPosG==3 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPos4G=3 if  number_jobsAPHD_2G==4 & duration3p2G>=5 & n_jobsUPPosG==4 & duration4p2G<5
replace n_jobsUPPos4G=2 if  number_jobsAPHD_2G==4 & duration2p2G>=5 & n_jobsUPPosG==4 & duration4p2G<5 & duration3p2G<5
replace n_jobsUPPos4G=1 if  number_jobsAPHD_2G==4 & duration1p2G>=5 & n_jobsUPPosG==4 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPos4G=4 if  number_jobsAPHD_2G==5 & duration4p2G>=5 & n_jobsUPPosG==5 & duration5p2G<5
replace n_jobsUPPos4G=3 if  number_jobsAPHD_2G==5 & duration3p2G>=5 & n_jobsUPPosG==5 & duration5p2G<5 & duration4p2G<5
replace n_jobsUPPos4G=2 if  number_jobsAPHD_2G==5 & duration2p2G>=5 & n_jobsUPPosG==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace n_jobsUPPos4G=1 if  number_jobsAPHD_2G==5 & duration1p2G>=5 & n_jobsUPPosG==5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPos4G=0 if  number_jobsAPHD_2G!=. & n_jobsUPPos4G==.   



tab n_jobsUPPos4G , miss
tab number_jobsAPHD_2G, miss
tab n_jobsUPPos4G number_jobsAPHD_2G, miss




// Use firstPermPyearPos3 firstPermPyearPos4 for checking consistency. Careful firstPermPyearPos4 has problems (see above) But firstPermPyearPos3 is very low and I havent check carefully the results
// I THINK THAT THE CONDITIONS DOESNT WORK WE SHOULD DO IT AGAIN.

gen firstPermPyearPos3G= .
 
replace firstPermPyearPos3G=Q8_2x2G if number_jobsAPHD_2G==1 & Q9_2x2G==4 & duration1p2G>=5
 
replace firstPermPyearPos3G=Q8_3x2G if number_jobsAPHD_2G==2 & Q9_3x2G==4 & duration2p2G>=5
 
replace firstPermPyearPos3G=Q8_4x2G if number_jobsAPHD_2G==3 & Q9_4x2G==4 & duration3p2G>=5
 
replace firstPermPyearPos3G=Q8_5x2G if number_jobsAPHD_2G==4 & Q9_5x2G==4 & duration4p2G>=5

replace firstPermPyearPos3G=Q8_6x2G if number_jobsAPHD_2G==5 & Q9_6x2G==4 & duration5p2G>=5

// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace firstPermPyearPos3G=Q8_2x2G if number_jobsAPHD_2G==2 & Q9_2x2G==4 & Q9_3x2G!=4 & duration1p2G>=5 & duration2p2G<5

replace firstPermPyearPos3G=Q8_3x2G if number_jobsAPHD_2G==3 & Q9_3x2G==4 & Q9_4x2G!=4 & duration2p2G>=5 & duration3p2G<5
replace firstPermPyearPos3G=Q8_2x2G if number_jobsAPHD_2G==3 & Q9_2x2G==4 & Q9_4x2G!=4 & Q9_3x2G!=4 & duration1p2G>=5 & duration2p2G<5 & duration3p2G<5

replace firstPermPyearPos3G=Q8_4x2G if number_jobsAPHD_2G==4 & Q9_4x2G==4 & Q9_5x2G!=4 & duration3p2G>=5 & duration4p2G<5
replace firstPermPyearPos3G=Q8_3x2G if number_jobsAPHD_2G==4 & Q9_3x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 & duration2p2G>=5 & duration4p2G<5 & duration3p2G<5
replace firstPermPyearPos3G=Q8_2x2G if number_jobsAPHD_2G==4 & Q9_2x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4  & duration1p2G>=5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace firstPermPyearPos3G=Q8_5x2G if number_jobsAPHD_2G==5 & Q9_5x2G==4 & Q9_6x2G!=4  & duration4p2G>=5 & duration5p2G<5
replace firstPermPyearPos3G=Q8_4x2G if number_jobsAPHD_2G==5 & Q9_4x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & duration3p2G>=5 & duration5p2G<5 & duration4p2G<5
replace firstPermPyearPos3G=Q8_3x2G if number_jobsAPHD_2G==5 & Q9_3x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & Q9_4x2G!=4 & duration2p2G>=5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace firstPermPyearPos3G=Q8_2x2G if number_jobsAPHD_2G==5 & Q9_2x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4  & duration1p2G>=5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5


 

sum firstPermPyearPos3G firstPermPyearPos4G firstPermPyearPosG


//WITH DURATION 

gen firstPermPyearDurG=.
 
replace firstPermPyearDurG=Q8_2x2G if number_jobsAPHD_2G==1 & duration1p2G>=5
 
replace firstPermPyearDurG=Q8_3x2G if number_jobsAPHD_2G==2 & duration2p2G>=5
 
replace firstPermPyearDurG=Q8_4x2G if number_jobsAPHD_2G==3 & duration3p2G>=5
 
replace firstPermPyearDurG=Q8_5x2G if number_jobsAPHD_2G==4 & duration4p2G>=5

replace firstPermPyearDurG=Q8_6x2G if number_jobsAPHD_2G==5 & duration5p2G>=5

// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace firstPermPyearDurG=Q8_2x2G if number_jobsAPHD_2G==2 & duration1p2G>=5 & duration2p2G<5

replace firstPermPyearDurG=Q8_3x2G if number_jobsAPHD_2G==3 & duration2p2G>=5 & duration3p2G<5
replace firstPermPyearDurG=Q8_2x2G if number_jobsAPHD_2G==3 & duration1p2G>=5 & duration3p2G<5 & duration2p2G<5

replace firstPermPyearDurG=Q8_4x2G if number_jobsAPHD_2G==4 & duration3p2G>=5 & duration4p2G<5
replace firstPermPyearDurG=Q8_3x2G if number_jobsAPHD_2G==4 & duration2p2G>=5 & duration4p2G<5 & duration3p2G<5
replace firstPermPyearDurG=Q8_2x2G if number_jobsAPHD_2G==4 & duration1p2G>=5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace firstPermPyearDurG=Q8_5x2G if number_jobsAPHD_2G==5 & duration4p2G>=5 & duration5p2G<5
replace firstPermPyearDurG=Q8_4x2G if number_jobsAPHD_2G==5 & duration3p2G>=5 & duration5p2G<5 & duration4p2G<5
replace firstPermPyearDurG=Q8_3x2G if number_jobsAPHD_2G==5 & duration2p2G>=5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace firstPermPyearDurG=Q8_2x2G if number_jobsAPHD_2G==5 & duration1p2G>=5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5


// NUMBER OF POSITIONS FOR PERMANENT WITH POSITION DEFINITION 3 consistency with duration

gen n_jobsUPPos3G=.
replace  n_jobsUPPos3G=1 if number_jobsAPHD_2G==1 & Q9_2x2G==4 & duration1p2G>=5
replace n_jobsUPPos3G=2 if  number_jobsAPHD_2G==2 & Q9_3x2G==4 & duration2p2G>=5
replace n_jobsUPPos3G=3 if  number_jobsAPHD_2G==3 & Q9_4x2G==4 & duration3p2G>=5
replace n_jobsUPPos3G=4 if  number_jobsAPHD_2G==4 & Q9_5x2G==4 & duration4p2G>=5
replace n_jobsUPPos3G=5 if  number_jobsAPHD_2G==5 & Q9_6x2G==4 & duration5p2G>=5


// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?
/// CHECK 0 O dont know if it is correct



replace n_jobsUPPos3G=1 if  number_jobsAPHD_2G==2 & Q9_2x2G==4 & Q9_3x2G!=4 & duration1p2G>=5 & duration2p2G<5

replace n_jobsUPPos3G=2 if  number_jobsAPHD_2G==3 & Q9_3x2G==4 & Q9_4x2G!=4 & duration2p2G>=5 & duration3p2G<5
replace n_jobsUPPos3G=1 if  number_jobsAPHD_2G==3 & Q9_2x2G==4 & Q9_4x2G!=4 & Q9_3x2G!=4 & duration1p2G>=5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPos3G=3 if  number_jobsAPHD_2G==4 & Q9_4x2G==4 & Q9_5x2G!=4 & duration3p2G>=5 & duration4p2G<5
replace n_jobsUPPos3G=2 if  number_jobsAPHD_2G==4 & Q9_3x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 & duration2p2G>=5 & duration4p2G<5 & duration3p2G<5
replace n_jobsUPPos3G=1 if  number_jobsAPHD_2G==4 & Q9_2x2G==4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4 & duration1p2G>=5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPos3G=4 if  number_jobsAPHD_2G==5 & Q9_5x2G==4 & Q9_6x2G!=4 & duration4p2G>=5 & duration5p2G<5
replace n_jobsUPPos3G=3 if  number_jobsAPHD_2G==5 & Q9_4x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & duration3p2G>=5 & duration5p2G<5 & duration4p2G<5
replace n_jobsUPPos3G=2 if  number_jobsAPHD_2G==5 & Q9_3x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & Q9_4x2G!=4 & duration2p2G>=5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5
replace n_jobsUPPos3G=1 if  number_jobsAPHD_2G==5 & Q9_2x2G==4 & Q9_6x2G!=4 & Q9_5x2G!=4 & Q9_4x2G!=4 & Q9_3x2G!=4 & duration1p2G>=5 & duration5p2G<5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPPos3G=0 if  number_jobsAPHD_2G!=. & n_jobsUPPos3G==.   



tab n_jobsUPPos3G , miss
tab number_jobsAPHD_2G, miss
tab n_jobsUPPos3G number_jobsAPHD_2G, miss






 




// NUMBER OF POSITIONS FOR PERMANENT WITH DURATION DEFINITION
 
gen n_jobsUPDURG=.
replace  n_jobsUPDURG=1 if  number_jobsAPHD_2G==1 & duration1p2G>=5

replace n_jobsUPDURG=2 if  number_jobsAPHD_2G==2 & duration2p2G>=5
 
replace n_jobsUPDURG=3 if  number_jobsAPHD_2G==3 & duration3p2G>=5
 
replace n_jobsUPDURG=4 if  number_jobsAPHD_2G==4 & duration4p2G>=5

replace n_jobsUPDURG=5 if  number_jobsAPHD_2G==5 & duration5p2G>=5


// SOLVING problem. what happens with cases like the one that has 3 jobs and got permanent in the second (here they appear as missing cases)?

replace n_jobsUPDURG=1 if  number_jobsAPHD_2G==2 & duration1p2G>=5 & duration2p2G<5

replace n_jobsUPDURG=2 if  number_jobsAPHD_2G==3 & duration2p2G>=5 & duration3p2G<5
replace n_jobsUPDURG=1 if  number_jobsAPHD_2G==3 & duration1p2G>=5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPDURG=3 if  number_jobsAPHD_2G==4 & duration3p2G>=5 & duration4p2G<5
replace n_jobsUPDURG=2 if  number_jobsAPHD_2G==4 & duration2p2G>=5 & duration4p2G<5 & duration3p2G<5 
replace n_jobsUPDURG=1 if  number_jobsAPHD_2G==4 & duration1p2G>=5 & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPDURG=4 if  number_jobsAPHD_2G==5 & duration4p2G>=5 & duration5p2G<5  
replace n_jobsUPDURG=3 if  number_jobsAPHD_2G==5 & duration3p2G>=5 & duration5p2G<5  & duration4p2G<5
replace n_jobsUPDURG=2 if  number_jobsAPHD_2G==5 & duration2p2G>=5 & duration5p2G<5  & duration4p2G<5 & duration3p2G<5
replace n_jobsUPDURG=1 if  number_jobsAPHD_2G==5 & duration1p2G>=5 & duration5p2G<5  & duration4p2G<5 & duration3p2G<5 & duration2p2G<5

replace n_jobsUPDURG=0 if  number_jobsAPHD_2G!=. & n_jobsUPDURG==.   



tab n_jobsUPDURG , miss
tab number_jobsAPHD_2G, miss
tab n_jobsUPDURG number_jobsAPHD_2G, miss






//I SHOULD CHECK MISSING AND CONSISTENCY. DO IT IF positions doesn't work as expected


rename firstPyearG Y1posG
rename firstPermPyearG Y1PermPSG
rename firstPermPyear2G Y1PermPS2G
rename firstPermPyearPosG Y1PermPPosG
rename firstPermPyearPos2G Y1PermPPos2G
rename firstPermPyearPos4G Y1PermPPos4G
rename firstPermPyearPos3G Y1PermPPos3G
rename firstPermPyearDurG Y1PermPDurG
 
label var Y1posG "fist year position"
label var Y1PermPSG "fist year permanent position (self-declared)"
label var Y1PermPS2G "fist year permanent position (self-declared) (using duration for missing cases)"
label var Y1PermPPosG "fist year permanent position by type of position"
label var Y1PermPPos2G "fist year permanent position by type of position (using duration for missing cases"
label var Y1PermPPos4G "fist year permanent position by type of position (Consistency with duration-careful)2"
label var Y1PermPPos3G "fist year permanent position by type of position (Consistency with duration-careful)"
label var Y1PermPDurG "fist year permanent position by duration"
 
 

list ID last_degree_year2 Q8_2x2 Q8_2x2G Q8_2x3 Q9_2x2 Q8_2x7 Q8_3x2  Q8_3x2G Q8_3x3 Q9_3x2 Q8_3x7 Q8_4x2 Q8_4x2G Q8_4x3 Q9_4x2 Q8_4x7 Q8_5x2 Q8_5x2G Q8_5x3 Q9_5x2 Q8_6x2 Q8_6x2G Q8_6x3 Q9_6x2 prudur  Y1PermPPosG intermediateP_G number_jobsAPHD_2G number_jobsAPHD_G TimeTenurePosG TimeTenurePos2G TimeTenurePos4G if TimeTenurePosG<0 | TimeTenurePos2G<0 | TimeTenurePos4G<0
list ID  Y1PermPPosG Y1PermPPos2G Y1PermPPos4G  TimeTenurePosG TimeTenurePos2G TimeTenurePos4G if    TimeTenurePosG<0| TimeTenurePos2G<0| TimeTenurePos4G<0



replace Y1PermPPosG=last_degree_year2 if ID==67|ID==1431|ID==2392| ID==3189
 replace Y1PermPPos2G=last_degree_year2 if ID==67|ID==1431|ID==2392| ID==3189
 replace Y1PermPPos4G=last_degree_year2 if  ID==3189
 
 
 //In check time to first position and tenure with the different options
gen Time1PosG=.
replace Time1PosG= Y1posG - last_degree_year2
gen TimeTenureSG= .
replace TimeTenureSG=Y1PermPSG-last_degree_year2
gen TimeTenureS2G= .
replace TimeTenureS2G=Y1PermPS2G-last_degree_year2
gen TimeTenurePosG=.
replace TimeTenurePosG=Y1PermPPosG-last_degree_year2
gen TimeTenurePos2G=.
replace TimeTenurePos2G=Y1PermPPos2G-last_degree_year2
gen TimeTenurePos4G=.
replace TimeTenurePos4G=Y1PermPPos4G-last_degree_year2
gen TimeTenurePos3G=.
replace TimeTenurePos3G=Y1PermPPos3G-last_degree_year2
gen TimeTenureDurG=.
replace TimeTenureDurG=Y1PermPDurG-last_degree_year2
 
// missing cases in TimeTenurePosG (4 neg)  TimeTenurePos2G (4 neg)  tab TimeTenurePos4G (1 neg). I change for last degree year. 2392 case is weird (I dont think is a permanet position) but I want to be consistant
tab Time1PosG, miss
tab TimeTenureSG, miss
tab TimeTenureS2G, miss
tab TimeTenurePosG, miss
tab TimeTenurePos2G, miss
tab TimeTenurePos4G, miss
tab TimeTenurePos3G, miss
tab TimeTenureDurG, miss

 
********** NEW TIME***

gen TimeCG=2012-last_degree_year2
gen TimePermCG=.
replace TimePermCG=TimeTenurePosG if TimeTenurePosG!=.
replace TimePermCG=TimeCG if TimeTenurePosG==.
gen PermanentCG=1
replace PermanentCG=0 if TimeTenurePosG==.
// I am including in 0 also missing cases (no las degree year))
tab TimePermCG, miss
tab PermanentCG, miss



gen TimePermCG2=.
replace TimePermCG2=TimeTenureSG if TimeTenureSG!=.
replace TimePermCG2=TimeCG if TimeTenureSG==.
gen PermanentCG2=1
replace PermanentCG2=0 if TimeTenureSG==.
 


gen TimePermCG3=.
replace TimePermCG3=TimeTenureS2G if TimeTenureS2G!=.
replace TimePermCG3=TimeCG if TimeTenureS2G==.
gen PermanentCG3=1
replace PermanentCG3=0 if TimeTenureS2G==.


gen TimePermCG4=.
replace TimePermCG4=TimeTenurePos2G if TimeTenurePos2G!=.
replace TimePermCG4=TimeCG if TimeTenurePos2G==.
gen PermanentCG4=1
replace PermanentCG4=0 if TimeTenurePos2G==.


gen TimePermCG5=.
replace TimePermCG5=TimeTenurePos4G if TimeTenurePos4G!=.
replace TimePermCG5=TimeCG if TimeTenurePos4G==.
gen PermanentCG5=1
replace PermanentCG5=0 if TimeTenurePos4G==.


gen TimePermCG6=.
replace TimePermCG6=TimeTenurePos3G if TimeTenurePos3G!=.
replace TimePermCG6=TimeCG if TimeTenurePos3G==.
gen PermanentCG6=1
replace PermanentCG6=0 if TimeTenurePos3G==.

gen TimePermCG7=.
replace TimePermCG7=TimeTenureDurG if TimeTenureDurG!=.
replace TimePermCG7=TimeCG if TimeTenureDurG==.
gen PermanentCG7=1
replace PermanentCG7=0 if TimeTenureDurG==.




tab TimePermCG TimeTenurePosG
tab PermanentCG, miss


 
 

sum  Time1PosG TimeTenureSG TimeTenureS2G TimeTenurePosG TimeTenurePos2G TimeTenurePos4G TimeTenurePos3G TimeTenureDurG
sum duration1p2G duration2p2G duration3p2G duration4p2G duration5p2G

 

//WORKING WITH DEP IND VARIABLES

// Gaughan and Robin, 2004 restricted the observations up to a period of 3 years after the Phd. They don't give a reason therefore it should be  methodological one
//Mixed proportional hazard model (Van den Berg, 2001) in discrete-time framework (allison, 1995; Jenkings, 1995) to estimate the effects of covariates on teh hazard of entering blah, blah

//Following this example I think that they build a yes/no variable dep and a "time variable" ind with 3 categ (1 per year)

//INDEPENDIENT VARIABLES: 

* MOBILITY (Main independent variable -"treated"):
//I need to check what the different options are
**NATIONAL/INTERNATIONAL MOBILITY-Postdoc
**SECTORAL
**IMBREDING (no-change of inst)

* INTERDISCIPLINARY MOBILITY
 generate multidisc=.
 replace multidisc=0 if Q7==Q6
 replace multidisc=0 if Q7==0
 replace multidisc=1 if Q7!=Q6
*INTERNATIONAL EDUCATION

generate foreignEdu=.
replace foreignEdu=0 if Q3==Q5_2x3 & Q3==Q5_3x3 & Q3==Q5_4x3
replace foreignEdu=1 if foreignEdu!=0 & Q3!=. & Q5_2x3!=. & Q5_3x3!=. & Q5_4x3!=.
tab foreignEdu
list  foreignEdu Q3 Q5_2x3 Q5_3x3 Q5_4x3 in 1/5

// we lost information if we do not have infomration on master or degree (prefious include missing). I create a less restricting using only the ones that do not have missing cases in phd and keeping previous 0
// USE this
generate foreignEdu2=.
replace foreignEdu2=0 if Q3==Q5_4x3 | foreignEdu==0
replace foreignEdu2=1 if foreignEdu2!=0 & Q3!=Q5_4x3 & Q3!=. & Q5_4x3!=.
tab foreignEdu2
list  foreignEdu2 Q3 Q5_2x3 Q5_3x3 Q5_4x3 in 1/5

* FOREIGN (if you get the permanent position in a foreign country??) I 
tab foreign

*GENDER Q23

* DISCIPLINE Q6

* PUBLICATIONS
**PUBBEFORE PHD. Gosh we don't have them. Use "duration of phd - abil" as a proxy for ability. I could calculate Pub before Phd using summing yearly publications for positions before Phd. Self funded.
**PUB until tenure. Use Q12_2x2 we have more information

//list  Q12_2x2 Q12_2x3 in 1/20 
//tab  Q12_2x2, miss
//tab  Q12_2x3, miss
 

* Other QUALITY FOR POSTDOC?? (e.g. funding source)
* AUTONOMY IN POSTDOC??
*BY COUNTRY??? Check if we can pool all countries (at least for one specification)
*Temporary mobility


* Interesting questions for descriptives?? Increasing number of postdoct?? Delay in taing a permanent position over time (vintage effect)?? labour market effect: unemployment among high skilled

*ABILITY


* MOTIVATION
**Previous conceptualisation
//generate Q21_5_1_countb=.
//replace Q21_5_1_countb=1 if Q21_5_1_count==5
//replace Q21_5_1_countb=2 if Q21_5_1_count==4
//replace Q21_5_1_countb=3 if Q21_5_1_count==3
//replace Q21_5_1_countb=4 if Q21_5_1_count==2
//replace Q21_5_1_countb=5 if Q21_5_1_count==1



//generate Q21_2_1_countb=.
//replace Q21_2_1_countb=1 if Q21_2_1_count==5
//replace Q21_2_1_countb=2 if Q21_2_1_count==4
//replace Q21_2_1_countb=3 if Q21_2_1_count==3
//replace Q21_2_1_countb=4 if Q21_2_1_count==2
//replace Q21_2_1_countb=5 if Q21_2_1_count==1


*PARENTHOOD
**Is the youngest child but is what we have.
gen Parenthood=Q24-Q27
tab Parenthood, miss
 
 
 

 



**MOBILITY INTERNATIONAL-  

** Phd land Q5_4x3  positions Q8_2x4

//there are 500 cases that do not use PHD See MobilityDef in order to check how was created (it considers all degrees).   
tab last_degree_land if last_degree_land!=Q5_4x3


gen Q8_2x4G=. 
replace Q8_2x4G=Q8_2x4 if Q8_2x2G!=.

gen Q8_3x4G=. 
replace Q8_3x4G=Q8_3x4 if Q8_3x2G!=.

gen Q8_4x4G=. 
replace Q8_4x4G=Q8_4x4 if Q8_4x2G!=.

gen Q8_5x4G=. 
replace Q8_5x4G=Q8_5x4 if Q8_5x2G!=.

gen Q8_6x4G=. 
replace Q8_6x4G=Q8_6x4 if Q8_6x2G!=.

// WE SHOULD REDO IT FOR EACH CONCEPTUALISATION OF MOBILITY. GOSHHHHH!!!!!!!!!!!

**WE NEED TO DEFINE NUMBER OF JOBS BEFORE PERMANTEN** USE THIS VARIABLE ONLY TO BUILD MOBILITY CATEGORIES*** 
/// n_jobsUPPosG see above   
 
 
 -
 // I check with mobility variables per each job change. I might be easy. First is compared to doctorate ¿is is really job-change?// careful missings included// 
 
 generate mobility1G=.
 replace mobility1G=0 if last_degree_land==Q8_2x4G
 replace mobility1G=1 if last_degree_land!=Q8_2x4G
 
 generate mobility2G=.
 replace mobility2G=0 if Q8_2x4G==Q8_3x4G
 replace mobility2G=1 if Q8_2x4G!=Q8_3x4G
 

 generate mobility3G=.
 replace mobility3G=0 if Q8_3x4G==Q8_4x4G
 replace mobility3G=1 if Q8_3x4G!=Q8_4x4G
 
 generate mobility4G=.
 replace mobility4G=0 if Q8_4x4G==Q8_5x4G
 replace mobility4G=1 if Q8_4x4G!=Q8_5x4G
 
 generate mobility5G=.
 replace mobility5G=0 if Q8_5x4G==Q8_6x4G
 replace mobility5G=1 if Q8_5x4G!=Q8_6x4G

generate mobilityTG=mobility1G+mobility2G+mobility3G+mobility4G+mobility5G


tab mobilityTG

// In order to take into account the missing cases, I create a second one to control for miss but probably not worth to use it. Missing cases cant be summed

 generate mobility1G2=.
 replace mobility1G2=0 if last_degree_land==Q8_2x4G & last_degree_land!=.
 replace mobility1G2=1 if last_degree_land!=Q8_2x4G & last_degree_land!=.
 tab mobility1G mobility1G2, miss
 
 generate mobility2G2=.
 replace mobility2G2=0 if Q8_2x4G==Q8_3x4G & Q8_2x4G!=.
 replace mobility2G2=1 if Q8_2x4G!=Q8_3x4G & Q8_2x4G!=.
 

 generate mobility3G2=.
 replace mobility3G2=0 if Q8_3x4G==Q8_4x4G & Q8_3x4G!=.
 replace mobility3G2=1 if Q8_3x4G!=Q8_4x4G & Q8_3x4G!=.
 
 generate mobility4G2=.
 replace mobility4G2=0 if Q8_4x4G==Q8_5x4G & Q8_4x4G!=.
 replace mobility4G2=1 if Q8_4x4G!=Q8_5x4G & Q8_4x4G!=.
 
 generate mobility5G2=.
 replace mobility5G2=0 if Q8_5x4G==Q8_6x4G & Q8_5x4G!=.
 replace mobility5G2=1 if Q8_5x4G!=Q8_6x4G & Q8_5x4G!=.

 


 
//I generate a basic categorisation stayers yes/no for checking result. This is general GEOGRAPHICAL mobility after Phd. I need before permanent.

/// MOBILITY CATEGORISATIONS WITH POSITION

generate mobilityPG=.

*stayers2*
replace mobilityPG=0 if  last_degree_land==Q8_2x4G & number_jobsAPHD_2G==1
replace mobilityPG=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & number_jobsAPHD_2G==2
replace mobilityPG=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & number_jobsAPHD_2G==3
replace mobilityPG=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & number_jobsAPHD_2G==4
replace mobilityPG=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & number_jobsAPHD_2G==5

//I include mobile with missing condition otherwise (I don't know why) all go to 1.
replace mobilityPG=1 if mobilityPG!=0 & number_jobsAPHD_2G>=1 & number_jobsAPHD_2G!=.
replace mobilityPG=0 if number_jobsAPHD_2G==0 
 
tab mobilityPG, miss
 

 

list ID mobilityPG mobilityPG2 last_degree_year last_degree_land Y1PermPPosG Q8_2x4G Q8_2x2G Q8_3x4G Q8_3x2G Q8_4x4G Q8_4x2G Q8_5x4G Q8_5x2G Q8_6x4G Q8_6x2G number_jobsAPHD_2G number_jobsUPG in 1/15





// tying to address previous problem. THIS IS GEOGRAPHICAL MOBILITY. SHOULD I CONSIDER ALL TYPES OF MOBILITY. ??
//CAREFUL This is variable is only available for the ones that got a permanent position!!!! Use mobilityb for the rest of the cases.

generate mobilityPG2=.
**stayers

replace mobilityPG2=0 if  last_degree_land==Q8_2x4G & n_jobsUPPosG==1
replace mobilityPG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & n_jobsUPPosG==2
replace mobilityPG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & n_jobsUPPosG==3
replace mobilityPG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & n_jobsUPPosG==4
replace mobilityPG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & n_jobsUPPosG==5

//Including mobile with permanent (1621 mobile and permanent) (579 mobile after permanent??)
replace mobilityPG2=1 if mobilityPG2!=0 & n_jobsUPPosG>=1 & n_jobsUPPosG!=.
//Including non-mobile without permanent
replace mobilityPG2=0 if n_jobsUPPosG==0  & mobilityPG==0
replace mobilityPG2=1 if n_jobsUPPosG==0 & mobilityPG==1


tab mobilityPG mobilityPG2, miss

 
 

 list ID mobilityPG mobilityPG2 last_degree_year last_degree_land Y1PermPPosG Q8_2x4G Q8_2x2G Q8_3x4G Q8_3x2G Q8_4x4G Q8_4x2G Q8_5x4G Q8_5x2G Q8_6x4G Q8_6x2G number_jobsAPHD_2G n_jobsUPPosG if n_jobsUPPosG==0

list ID mobilityPG mobilityPG2 last_degree_year last_degree_land Y1PermPPosG Q8_2x4G Q8_2x2G Q8_2x7PermG Q8_3x4G Q8_3x2G Q8_3x7PermG Q8_4x4G Q8_4x2G Q8_4x7PermG Q8_5x4G Q8_5x2G Q8_5x7PermG Q8_6x4G Q8_6x2G number_jobsAPHD_2G n_jobsUPPosG TimeTenurePosG if TimeTenurePosG==0
list ID mobilityPG mobilityPG2 last_degree_year last_degree_land Y1PermPPosG Q8_2x4G Q8_2x2G Q8_3x4G Q8_3x2G Q8_4x4G Q8_4x2G Q8_5x4G Q8_5x2G Q8_6x4G Q8_6x2G number_jobsAPHD_2G n_jobsUPPosG  
 
/// Read this. mobilityPG2 considers only mobility after phd and before permanent position (mobilities after permanent are considered as 0) Use mobilityPG for analysing the differences.
/// use n_jobsUPPosG==0 to identify non permanent posisitions. Y1PermPPosG appear as missing cases


// checking results???

tab TimeTenurePosG n_jobsUPPosG, missing
tab mobilityPG2, miss

sort mobilityPG2
by mobilityPG2: sum TimePermCG
tab mobilityPG2 PermanentCG, exp col
 
ttest  TimePermCG, by (mobilityPG2)
 
 
 /// STAYERS WITH POSITION 4 AND CONSISTENCY USING  n_jobsUPPos4G
 
 generate mobilityPG24=.
**stayers

replace mobilityPG24=0 if  last_degree_land==Q8_2x4G & n_jobsUPPos4G==1
replace mobilityPG24=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & n_jobsUPPos4G==2
replace mobilityPG24=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & n_jobsUPPos4G==3
replace mobilityPG24=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & n_jobsUPPos4G==4
replace mobilityPG24=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & n_jobsUPPos4G==5

//Including mobile with permanent (1621 mobile and permanent) (579 mobile after permanent??)
replace mobilityPG24=1 if mobilityPG24!=0 & n_jobsUPPos4G>=1 & n_jobsUPPos4G!=.
//Including non-mobile without permanent
replace mobilityPG24=0 if n_jobsUPPos4G==0  & mobilityPG==0
replace mobilityPG24=1 if n_jobsUPPos4G==0 & mobilityPG==1


tab mobilityPG mobilityPG24, miss

// checking results???



sort mobilityPG24
by mobilityPG24: sum TimePermCG5
tab mobilityPG24 PermanentCG5, exp col
 
ttest  TimePermCG5, by (mobilityPG24)



 /// STAYERS WITH POSITION 3 AND CONSISTENCY USING n_jobsUPPos3G


generate mobilityPG23=.
**stayers

replace mobilityPG23=0 if  last_degree_land==Q8_2x4G & n_jobsUPPos3G==1
replace mobilityPG23=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & n_jobsUPPos3G==2
replace mobilityPG23=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & n_jobsUPPos3G==3
replace mobilityPG23=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & n_jobsUPPos3G==4
replace mobilityPG23=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & n_jobsUPPos3G==5

//Including mobile with permanent (1621 mobile and permanent) (579 mobile after permanent??)
replace mobilityPG23=1 if mobilityPG23!=0 & n_jobsUPPos3G>=1 & n_jobsUPPos3G!=.
//Including non-mobile without permanent
replace mobilityPG23=0 if n_jobsUPPos3G==0  & mobilityPG==0
replace mobilityPG23=1 if n_jobsUPPos3G==0 & mobilityPG==1


tab mobilityPG mobilityPG23, miss

// checking results???



sort mobilityPG23
by mobilityPG23: sum TimePermCG6
tab mobilityPG23 PermanentCG6, exp col
 
ttest  TimePermCG6, by (mobilityPG23)

 
 //// STAYERS WITH SELF DECLARED /// CHANGES VARIABLE USED FOR NUMBER OF JOB CHANGES HERE n_jobsUPPSG

 
 generate mobilityPPSG2=.


**stayers

replace mobilityPPSG2=0 if  last_degree_land==Q8_2x4G & n_jobsUPPSG==1
replace mobilityPPSG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & n_jobsUPPSG==2
replace mobilityPPSG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & n_jobsUPPSG==3
replace mobilityPPSG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & n_jobsUPPSG==4
replace mobilityPPSG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & n_jobsUPPSG==5

//Including mobile with permanent (1621 mobile and permanent) (579 mobile after permanent??)
replace mobilityPPSG2=1 if mobilityPPSG2!=0 & n_jobsUPPSG>=1 & n_jobsUPPSG!=.
//Including non-mobile without permanent
replace mobilityPPSG2=0 if n_jobsUPPSG==0  & mobilityPG==0
replace mobilityPPSG2=1 if n_jobsUPPSG==0 & mobilityPG==1


tab mobilityPG mobilityPPSG2, miss
 
 // CHECKING RESULTS
 
sort mobilityPPSG2
by mobilityPPSG2: sum TimePermCG2
tab mobilityPPSG2 PermanentCG2, exp col
 
ttest  TimePermCG2, by (mobilityPPSG2)
 
  
 
 
 
//// STAYERS WITH SELF DECLARED 2 compliting with duration missing cases /// CHANGES VARIABLE USED FOR NUMBER OF JOB CHANGES HERE n_jobsUPPS2G
 
 
 generate mobilityPPSG22=.


**stayers

replace mobilityPPSG22=0 if  last_degree_land==Q8_2x4G & n_jobsUPPS2G==1
replace mobilityPPSG22=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & n_jobsUPPS2G==2
replace mobilityPPSG22=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & n_jobsUPPS2G==3
replace mobilityPPSG22=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & n_jobsUPPS2G==4
replace mobilityPPSG22=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & n_jobsUPPS2G==5

//Including mobile with permanent (1621 mobile and permanent) (579 mobile after permanent??)
replace mobilityPPSG22=1 if mobilityPPSG22!=0 & n_jobsUPPS2G>=1 & n_jobsUPPS2G!=.
//Including non-mobile without permanent
replace mobilityPPSG22=0 if n_jobsUPPS2G==0  & mobilityPG==0
replace mobilityPPSG22=1 if n_jobsUPPS2G==0 & mobilityPG==1


tab mobilityPG mobilityPPSG22, miss
 
 // CHECKING RESULTS
 
sort mobilityPPSG22
by mobilityPPSG22: sum TimePermCG3
tab mobilityPPSG22 PermanentCG3, exp col
 
ttest  TimePermCG3, by (mobilityPPSG22)
 
 
 
 
 //// STAYERS WITH DURATION /// n_jobsUPDURG
 
  generate mobilityPDurG2=.


**stayers

replace mobilityPDurG2=0 if  last_degree_land==Q8_2x4G & n_jobsUPDURG==1
replace mobilityPDurG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G & n_jobsUPDURG==2
replace mobilityPDurG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G & n_jobsUPDURG==3
replace mobilityPDurG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & n_jobsUPDURG==4
replace mobilityPDurG2=0 if  last_degree_land==Q8_2x4G & Q8_2x4G==Q8_3x4G  & Q8_2x4G==Q8_4x4G  & Q8_2x4G==Q8_5x4G & Q8_2x4G==Q8_6x4G & n_jobsUPDURG==5

//Including mobile with permanent (1621 mobile and permanent) (579 mobile after permanent??)
replace mobilityPDurG2=1 if mobilityPDurG2!=0 & n_jobsUPDURG>=1 & n_jobsUPDURG!=.
//Including non-mobile without permanent
replace mobilityPDurG2=0 if n_jobsUPDURG==0  & mobilityPG==0
replace mobilityPDurG2=1 if n_jobsUPDURG==0 & mobilityPG==1


tab mobilityPG mobilityPDurG2, miss
 
 // CHECKING RESULTS
 
sort mobilityPDurG2
by mobilityPDurG2: sum TimePermCG7
tab mobilityPDurG2 PermanentCG7, exp col
 
ttest  TimePermCG7, by (mobilityPDurG2)
 
 
 
 
 
 
 

 
 

 tab mobilityPG2, miss
 tab mobilityPG24, miss
 tab mobility5G2, miss
 tab mobilityPPSG2, miss
 tab mobilityPPSG22, miss
 tab mobilityPDurG2, miss
 
 
 
 
 
 
 
 
 
 
 
 ///////////////////// THIS IS OLD//////////////////////////////////// DELETE IF NOT USED.
 

 
 

//TREATEMENT (MOBILITY) NEEDS TO CONSIDER TIME. SOME OF 1 SHOULD BE 0 DEPENDING ON THE TIME FRAME I check with 4 years.
/// 
generate mobilityPT4=.
replace mobilityPT4=0 if  Q5_4x3==Q8_2x4 & number_jobsUP==1 & TimeTenurePos<=4
replace mobilityPT4=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4 & number_jobsUP==2 & TimeTenurePos<=4
replace mobilityPT4=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4  & Q8_2x4==Q8_4x4 & number_jobsUP==3 & TimeTenurePos<=4
replace mobilityPT4=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4  & Q8_2x4==Q8_4x4  & Q8_2x4==Q8_5x4 & number_jobsUP==4 & TimeTenurePos<=4
replace mobilityPT4=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4  & Q8_2x4==Q8_4x4  & Q8_2x4==Q8_5x4 & Q8_2x4==Q8_6x4 & number_jobsUP==5 & TimeTenurePos<=4
 

replace mobilityPT4=1 if mobilityPT4!=0 & Y1PermPPos!=.
replace mobilityPT4=. if TimeTenurePos>4
//Version without missing cases. 18 cases less than PT4

generate mobilityPT42=.
replace mobilityPT42=0 if  Q5_4x3==Q8_2x4 & number_jobsUP==1 & TimeTenurePos<=4
replace mobilityPT42=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4 & number_jobsUP==2 & TimeTenurePos<=4
replace mobilityPT42=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4  & Q8_2x4==Q8_4x4 & number_jobsUP==3 & TimeTenurePos<=4
replace mobilityPT42=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4  & Q8_2x4==Q8_4x4  & Q8_2x4==Q8_5x4 & number_jobsUP==4 & TimeTenurePos<=4
replace mobilityPT42=0 if  Q5_4x3==Q8_2x4 & Q8_2x4==Q8_3x4  & Q8_2x4==Q8_4x4  & Q8_2x4==Q8_5x4 & Q8_2x4==Q8_6x4 & number_jobsUP==5 & TimeTenurePos<=4
 

replace mobilityPT42=1 if mobilityPT42!=0 & Y1PermPPos!=. & Q5_4x3!=.
replace mobilityPT42=. if TimeTenurePos>4

tab mobilityP mobilityPT42

//I do not include the other categories of mobility deffined in the previous paper. As it will depend on the definition and time-spam used. If it is 3-4 yerars it doesnt make too much sense (repeated)
//Do it with (Posdoc, authonomy, etc.)

//Is the window of 4 years correct? What to do with negative cases (here I exclude them. I can save some of the teating missing cases but in any case.

generate Time=.
replace Time=0 if TimeTenurePos==0
replace Time=1 if TimeTenurePos==1
replace Time=2 if TimeTenurePos==2
replace Time=3 if TimeTenurePos==3
replace Time=4 if TimeTenurePos==4


generate PermanentPT4=.
replace PermanentPT4=1 if Time!=.
replace PermanentPT4=0 if TimeTenurePos>4
 
tab TimeTenurePos PermanentPT4 
 
 
gen yearsAftPhD=.
replace yearsAftPhD=2012-Q5_4x2



// In Time i exclude all the cases that didn't get the position within 4 years. Done in order to built Permanent with time windows PermanentPT4 . I create time 2 to include these cases (all of them considered as 4) but this is not a correct time window. In addition, I am considering only cases that got a permanent position

generate Time2=.

replace Time2=0 if TimeTenurePos==0 
replace Time2=1 if TimeTenurePos==1
replace Time2=2 if TimeTenurePos==2
replace Time2=3 if TimeTenurePos==3
replace Time2=4 if TimeTenurePos==4
replace Time2=4 if TimeTenurePos>4

stset Time2, failure(PermanentPT4)
gen treated =  mobilityPT4 == 1
stcox treated
di _b[treated]

sort  Countryb
by Countryb: stcox treated

//Mobility increases  the "risk" of permanency by (I cant read these Hazar Ratios)% considering a time window of 4 years. 

//I add the ones that did the phd four years before 2012. Is this more a control for time??


generate Time3=.

replace Time3=0 if TimeTenurePos==0 | yearsAftPhD==0
replace Time3=1 if TimeTenurePos==1 | yearsAftPhD==1
replace Time3=2 if TimeTenurePos==2 | yearsAftPhD==2
replace Time3=3 if TimeTenurePos==3 | yearsAftPhD==3
replace Time3=4 if TimeTenurePos==4 | yearsAftPhD==4
replace Time3=4 if TimeTenurePos>4 | yearsAftPhD>4


stset Time3, failure(PermanentPT4)
gen treated = mobilityPT4 == 1
stcox treated
di _b[treated]

sort  Countryb
by Countryb: stcox treated

//WITHOUT TIME WINDOW.
// Again be careful with NEGATIVE CASES it might happen that the ones that do not move get permanent positions even before Phd


generate PermanentP=.
replace PermanentP=1 if TimeTenurePos>=0
replace PermanentP=0 if TimeTenurePos<0

/// TimeTenurePosition give us the information on time but only for the ones that got the permanent position. Include the ones that didn't get a permanent position. Try with duration.
// careful with missing cases.

gen TimeT=.
replace TimeT=TimeTenurePos if TimeTenurePos>=0
replace TimeT=yearsAftPhD if TimeTenurePos!=0

stset TimeT, failure(PermanentP)
gen treated = mobilityP == 1
stcox treated
di _b[treated]

sort  Countryb
by Countryb: stcox treated


// Same for mobilityP only gives informatio for the ones that got the permant. Stayers do not chang
/// Ahggg think about everyghing mobility if not permanent with and withougt window.

stset TimeT, failure(PermanentP)
gen treated = mobilityPT == 1
stcox treated
di _b[treated]



 /// checking cox
 stset TimePermCG5, failure(PermanentCG5)
gen treatedPos5 = mobilityPG24 == 1
stcox treatedPos5
di _b[treatedPos5]

sort  Countryb
by Countryb: stcox treatedPos5



// http://data.princeton.edu/eco572/CoxModel.html
//R (Cañi) http://socserv.mcmaster.ca/jfox/Books/Companion/appendix/Appendix-Cox-Regression.pdf


 
 
 
 
 

// what to do with Q1==0 Do not have been working as a researcher for the last 5 years (n= 475). I would not delete them
//last position permanent Q9_2x2==4

