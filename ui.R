library(shiny)
library(mstate) 
library("survival")

yesno=c("","yes","no")

fluidPage(

  titlePanel("HF Risk Calulator"),

  sidebarPanel(
	numericInput('AGE', 'Age',NULL,18,100,step=1),
    selectInput('Female', 'Gender', c("","male","female")),
    numericInput('LVEF', 'Left Ventricular', 40,0,45,step=1),
    selectInput('NYHA3', 'New York Heart Assoc. class', c("","II","III")),
    selectInput('DIABETES', 'History of Diabetes', yesno),
    selectInput('ISCHEMIC', 'History of Ischemic', yesno),
    selectInput('ATFIB', 'History of Atrial', yesno),
    selectInput('CVA', 'History of Stroke', yesno),
	numericInput('sodium', 'Sodium (mEq/L)', NULL,115,155,step=1),
	numericInput('creatinine', 'creatinine', NULL,0.3,4,step=.1),
    selectInput('creatinine_units', 'creatinine units', c("mg/dl","mmol/L")),
	numericInput('WEIGHT', 'Weight', NULL,30,200,step=1),
	selectInput('weight_units', 'Weight units', c("lbs","kg")),
	numericInput('SBP', 'Systolic Blood Pressure', NULL,70,200,step=1),
    selectInput('ICD', 'Implantable Defib', yesno)
  ),

  mainPanel(
    plotOutput("plot1",width="800px",height="600px"),
 	h3("Risk Prediction"),
    div(
 	   p("One year risk:"),
 	   p("Heart failure hospitalization: ", textOutput("year1_hf",inline=TRUE)),
 	   p("All cause mortality: ", textOutput("year1_mort",inline=TRUE)),
 	   p("Composite of HFH or mortality: ", textOutput("year1_comp",inline=TRUE))
    ),
    div(
 	   p("Two year risk:"),
 	   p("Heart failure hospitalization: ", textOutput("year2_hf",inline=TRUE)),
 	   p("All cause mortality: ", textOutput("year2_mort",inline=TRUE)),
 	   p("Composite of HFH or mortality: ", textOutput("year2_comp",inline=TRUE))
    ),
    div(
 	   p("Five year risk:"),
 	   p("Heart failure hospitalization: ", textOutput("year5_hf",inline=TRUE)),
 	   p("All cause mortality: ", textOutput("year5_mort",inline=TRUE)),
 	   p("Composite of HFH or mortality: ", textOutput("year5_comp",inline=TRUE))
    )


  )
)
