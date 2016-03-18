library(shiny)
library(mstate) 
library("survival")

function(input, output) {
	
	
dervcohort<-read.csv("derivationcohort_long.csv", header=T)

tmat<-trans.illdeath(names=c("Alive without HFH", "Alive after HFH", "Death"))

msmodel<-coxph(Surv(Tstart, Tstop, status) ~Female.1 + Female.2 + Female.3 + AGEdec.1 + AGEdec.2 +  AGEdec.3 + NYHA3.1 + NYHA3.2 + NYHA3.3 + LVEF10.1 +LVEF10.2 +LVEF10.3 + creatinine.1 + creatinine.2 + creatinine.3 + DIABETES.1 + DIABETES.2 + DIABETES.3 + ISCHEMIC.1 +ISCHEMIC.2 +ISCHEMIC.3 + CVA.1 +CVA.2+ CVA.3 + ATFIB.1 + ATFIB.2 + ATFIB.3 + sodium10  + SBP10.1 + SBP10.2 + SBP10.3 + WEIGHT10.1 + WEIGHT10.2 + WEIGHT10.3 + hfh + strata(to), data=dervcohort, method="breslow")
model_sum <-capture.output(summary(msmodel))

fields <- c("Female","AGE","NYHA3","LVEF","ISCHEMIC","CVA","ATFIB","DIABETES","creatinine","sodium","SBP","WEIGHT","ICD")
prob <- reactive({
	
	
	user_data<-c(if(input$Female=="female") {1}else{0},
				input$AGE,
				input$NYHA3,
				input$LVEF,
				input$ISCHEMIC,
				input$CVA,
				input$ATFIB,
				input$DIABETES,
				input$creatinine,
				input$sodium,
				input$SBP,
				input$WEIGHT,
				input$ICD)
	 P<-data.frame(fields,user_data)
	

	P$AGEdec <-input$AGE/10
	P$WEIGHT10<-input$WEIGHT/10
	P$SBP10<-input$SBP/10
	P$LVEF10<-input$LVEF/10

	P<-P[rep(1,3),]
	P$trans<-1:3
	P$strata<-c(1,2,2)
	attr(P, "trans")<-tmat
# class(P)<-c("msdata", "data.frame")
# covsx<-c("Female", "AGEdec", "NYHA3", "LVEF10", "creatinine", "ISCHEMIC", "CVA", "ATFIB", "DIABETES", "SBP10", "WEIGHT10")
 # P<-expand.covs(P,covsx)
 # P$hfh<-0
# P$hfh[P$trans==3]<-1
# msf<-msfit(object=msmodel, newdata=P, trans=tmat)
# recal.effect<-P$ICD*c(0,-0.2605817,-0.2605817)
# for (i in 1:3) msf$Haz$Haz[msf$Haz$trans==i]<-msf$Haz$Haz[msf$Haz$trans==i]*exp(recal.effect[i])
# probtrans(msf, predt=0,variance=FALSE) 
 P	
})



 output$summary <- renderPrint({
    model_sum
  })

output$display <-renderText(capture.output(prob()))



 

}
