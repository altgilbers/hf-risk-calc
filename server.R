# Shiny Heart Failure Calculator
# adapted from R code/data provided by tufts medical center

library("shiny")
library("mstate") 
library("survival")

function(input, output) {
	
## Read derivation cohort datafile into R
dervcohort<-read.csv("derivationcohort_long.csv", header=T)

tmat<-trans.illdeath(names=c("Alive without HFH", "Alive after HFH", "Death"))

msmodel<-coxph(Surv(Tstart, Tstop, status) ~Female.1 + Female.2 + Female.3 + AGEdec.1 + AGEdec.2 +  AGEdec.3 + NYHA3.1 + NYHA3.2 + NYHA3.3 + LVEF10.1 +LVEF10.2 +LVEF10.3 + creatinine.1 + creatinine.2 + creatinine.3 + DIABETES.1 + DIABETES.2 + DIABETES.3 + ISCHEMIC.1 +ISCHEMIC.2 +ISCHEMIC.3 + CVA.1 +CVA.2+ CVA.3 + ATFIB.1 + ATFIB.2 + ATFIB.3 + sodium10  + SBP10.1 + SBP10.2 + SBP10.3 + WEIGHT10.1 + WEIGHT10.2 + WEIGHT10.3 + hfh + strata(to), data=dervcohort, method="breslow")

# read in sample input to initialize data structure, fields all overwritten with usr provided data
user_data<-read.csv("Pt21.csv", header=T)


# generate prob data structure, reacting to changes in user input
prob<-reactive(
	{
	#validate user input - mulitple need() clauses can be 
	validate(
		need(input$CVA!="" && 
				input$DIABETES!="" && 
				input$ISCHEMIC!="" && 
				input$ATFIB!="" && 
				input$ICD!="" && 
				input$Female!="" && 
				input$NYHA3!="", "Please complete all fields")
	)

	validate(
		need(input$AGE>=18 && input$AGE<=100, "Please enter an age between 18 and 100"),
		need(input$LVEF>=0 && input$LVEF<=45, "Please enter a LVEF between 0 and 45"),
		need(input$SBP>=70 && input$SBP<=200, "Please enter a blood pressure between 70 and 200"),
		need(input$sodium>=115 && input$sodium<=155, "Please enter a sodium level between 115 and 155")
	)
	validate(
		need(
			(input$weight_units=="kg" && input$WEIGHT>=30 && input$WEIGHT<=200) ||
			(input$weight_units=="lbs" && input$WEIGHT>=66 && input$WEIGHT<=440),
			"Please select a weight between 30 and 200kg (66 and 440lbs)"
			)
	)
	
	
	# put user data into data structure, scaling where needed	
	user_data$AGEdec<-input$AGE/10
	user_data$Female<-if(input$Female=="female") {1}else{0}
	user_data$LVEF10<-input$LVEF/10
	user_data$NYHA3<-if(input$NYHA3=="II") {0} else {1}
	user_data$ISCHEMIC<-if(input$ISCHEMIC=="no") {0} else {1}
	user_data$CVA<-if(input$CVA=="no") {0} else {1}
	user_data$ATFIB<-if(input$ATFIB=="no") {0} else {1}
	user_data$DIABETES<-if(input$DIABETES=="no") {0} else {1}
    user_data$sodium10<-input$sodium/10
    user_data$WEIGHT10<-if(input$weight_units=="kg") {input$WEIGHT/10} else {input$WEIGHT/10/2.20462}
    user_data$SBP10<-input$SBP/10
	

	# code provided by jenica
	user_data<-user_data[rep(1,3),]
	user_data$trans<-1:3
	user_data$strata<-c(1,2,2)
	attr(user_data, "trans")<-tmat
	class(user_data)<-c("msdata", "data.frame")
	covsx<-c("Female", "AGEdec", "NYHA3", "LVEF10", "creatinine", "ISCHEMIC", "CVA", "ATFIB", "DIABETES", "SBP10", "WEIGHT10")
	user_data<-expand.covs(user_data,covsx)
	user_data$hfh<-0
	user_data$hfh[user_data$trans==3]<-1
	msf<-msfit(object=msmodel, newdata=user_data, trans=tmat)
	recal.effect<-user_data$ICD*c(0,-0.2605817,-0.2605817)
	for (i in 1:3) msf$Haz$Haz[msf$Haz$trans==i]<-msf$Haz$Haz[msf$Haz$trans==i]*exp(recal.effect[i])
	probtrans(msf, predt=0,variance=FALSE) 
	#end of reactive
	}
)


# Values that are sent back to the client to be displayed

output$plot1<-renderPlot(
	{
	plot(prob(),  
		type="filled", 
		ord=c(1,2,3), 
		cex=0.9, 
		cols =c("lightgreen", "yellow", "red"), 
		main="Prediction probabilities for patient", 
		ylab="Prediction probabilities", 
		xlab="Follow-up (years)", 
		legend= c("","",""))
	legend (0.5, 
		0.3, 
		cex=0.6, 
		c("Alive without HF Hospitalization", "Alive after HF Hospitalization", "Death"), 
		fill=c("lightgreen", "yellow", "red"), 
		bg="white")
	}
)

#Summary percentages - indexing into the output of probtrans() was a little confusing.. 
# prob() calls the closure than generates table, the first [[1]] gets the table summary
# the second [[]] is the state column and the final [] is the row of the table

output$year1_hf<-renderText(100*prob()[[1]][[3]][271])
output$year1_mort<-renderText(100*prob()[[1]][[4]][271])
output$year1_comp<-renderText(100*(prob()[[1]][[3]][271]+prob()[[1]][[4]][271]))

output$year2_hf<-renderText(100*prob()[[1]][[3]][529])
output$year2_mort<-renderText(100*prob()[[1]][[4]][529])
output$year2_comp<-renderText(100*(prob()[[1]][[3]][529]+prob()[[1]][[4]][529]))

output$year5_hf<-renderText(100*prob()[[1]][[3]][1194])
output$year5_mort<-renderText(100*prob()[[1]][[4]][1194])
output$year5_comp<-renderText(100*(prob()[[1]][[3]][1194]+prob()[[1]][[4]][1194]))





}
