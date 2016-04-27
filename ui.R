# webapp UI 

library(shiny)
library(mstate) 
library("survival")

yesno=c("","yes","no")

fluidPage(

#  titlePanel("HF Risk Calculator"),

  sidebarPanel(
  	h3(a("Reset Values",href=".")),
	numericInput('AGE', 'Age (18-100)',NULL,18,100,step=1),
	selectInput('Female', 'Gender', c("","male","female")),
	numericInput('LVEF', 'Left Ventricular Ejection Fraction (0-45%)', NULL, 0, 45, step=1),
	selectInput('NYHA3', 'New York Heart Associaton class', c("","II","III")),
	selectInput('DIABETES', 'History of Diabetes', yesno),
	selectInput('ISCHEMIC', 'Ischemic etiology of heart failure', yesno),
	selectInput('ATFIB', 'History of atrial fibrillation', yesno),
	selectInput('CVA', 'History of stroke', yesno),
	numericInput('sodium', 'Serum sodium (115-155 mEq/L)', NULL,115,155,step=1),
	numericInput('creatinine', 'Serum creatinine (0.3-4.0 mg/dl  /  22.8-305 mmol/L)', NULL),
	selectInput('creatinine_units', 'creatinine units', c("mg/dl","mmol/L")),
	numericInput('WEIGHT', 'Weight (30-200kg / 66-440lb)', NULL,30,200,step=1),
	selectInput('weight_units', 'Weight units', c("lbs","kg")),
	numericInput('SBP', 'Systolic Blood Pressure (70-200mmHg)', NULL, 70, 200, step=1),
	selectInput('ICD', 'Implantable Cardioverter Defibrillator', yesno),
	h3(a("Reset Values",href="."))
  ),

  mainPanel(
	plotOutput("plot1",width="800px",height="600px"),
 	h1("Risk Prediction"),
    	div(
 	   h3("One year risk:"),
 	   p("Alive after heart failure hospitalization: ", textOutput("year1_hf",inline=TRUE)),
 	   p("All cause mortality (with or without preceding heart failure hospitalization): ", textOutput("year1_mort",inline=TRUE)),
 	   p("Composite of HFH or mortality: ", textOutput("year1_comp",inline=TRUE))
	),
    	div(
 	   h3("Two year risk:"),
 	   p("Alive after heart failure hospitalization: ", textOutput("year2_hf",inline=TRUE)),
 	   p("All cause mortality (with or without preceding heart failure hospitalization): ", textOutput("year2_mort",inline=TRUE)),
 	   p("Composite of HFH or mortality: ", textOutput("year2_comp",inline=TRUE))
	),
	div(
 	   h3("Five year risk:"),
 	   p("Alive after heart failure hospitalization: ", textOutput("year5_hf",inline=TRUE)),
 	   p("All cause mortality (with or without preceding heart failure hospitalization): ", textOutput("year5_mort",inline=TRUE)),
 	   p("Composite of HFH or mortality: ", textOutput("year5_comp",inline=TRUE))
	)
  )
)
