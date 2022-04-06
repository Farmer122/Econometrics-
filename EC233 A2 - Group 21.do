
//intro

set scheme sj

sum// summary of all statistics 
sum days, d //detailed summary of days
sum poverty_index, d// detailed summary of poverty_index


//installing relevant packages 
ssc inst rdplot //downloading packages for rdplot 
search rdplot
search rdplot

//Question B DATASET 1


histogram poverty_index // visulation of the shape of poverty_index 

sum days if enrolled == 1
sum days if enrolled == 0 //statistical difference between means of those who enrolled and those who did not in the program on days absent


ttest days, by(enrolled) //ttest of no difference heavily rejected

rdplot days poverty_index, c(58)//creates an rdplot to visualise the discontinuity 

rdbwselect days poverty_index, c(58)//bandwidth selection

rdplot days poverty_index, c(58)  graph_options(xline(51.101) xline(64.899))// creates an rdplot to also visualise the cutoffs given to us with the rdbwselect.

//rd estimates are sensititve to choice of bandwidth, we have used default bandwidth selection here: mserd


regress days poverty_index enrolled //rdd regression
gen poverty_index2 = (poverty_index*poverty_index)//creating new variable 
regress days poverty_index poverty_index2 enrolled //controlling for hospital distance
regress days poverty_index poverty_index2 enrolled dirtfloor//controlling for dirtfloor
regress days poverty_index poverty_index2 enrolled dirtfloor hhsize//controlling for household size




rddensity poverty_index, c(58)// tests for manipulation of the treatment effect 
rdrobust days poverty_index, c(58)// robustness check

//Robustness checks


rdrobust days poverty_index, p(2) c(58) // robustness check second order polynomial
//above squares the x variable - passed robustness check, point estimate is similar 

   //Below are placebo points 
rdrobust days poverty_index, c(68) // treatment effect is not significant at the 10% level
rdrobust days poverty_index, c(48) // treatment effect not significant at the 10% level


sum if enrolled == 1 & poverty_index <58 & poverty_index > 51.101 //to create balance tests

sum if enrolled == 1 & poverty_index <64.899 & poverty_index > 58// to create balance test


//Question C DATASET 2

reg days enrolled
reg enrolled hhsize //weak instrument
reg enrolled bathroom //weak instrument
reg enrolled promotion_locality //significant
ivregress 2sls days (enrolled = promotion_locality)
regress days (enrolled = promotion_locality) age age_s educ educ_s female indigenous hhsize dirtfloor bathroom hospital_distance hospital



esttab m1 m2 m3 m4, title(Regression Table) lable r2 mtitles("A" "B" "C" "D") coeflabel (days "School days missed" poverty_index "Poverty Index (1-100)" poverty_index2 " Poverty Index Squared" dirtfloor "House has dirtfloor (=1,0)" hhsize "no of household members") nonumbers b(3) se(3) star (* 0.1 ** 0.05 *** 0.01) 
