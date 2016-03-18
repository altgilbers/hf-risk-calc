library(shiny)
library(mstate) 
library("survival")

fluidPage(

  titlePanel("Health Explorer"),

  sidebarPanel(
	numericInput('AGE', 'Age', NA,18,100,step=1),
    selectInput('Female', 'Gender', c("male","female")),
    numericInput('LVEF', 'Left Ventricular', NA,0,45,step=1),
    selectInput('NYHA3', 'New York Heart Assoc. class', c("II","III")),
    selectInput('DIABETES', 'History of Diabetes', c("yes","no")),
    selectInput('ISCHEMIC', 'History of Ischemic', c("yes","no")),
    selectInput('ATFIB', 'History of Atrial', c("yes","no")),
    selectInput('CVA', 'History of Stroke', c("yes","no")),
	numericInput('sodium', 'Sodium', NA,115,155,step=1),
	numericInput('creatinine', 'creatinine', NA,0.3,4,step=1),
    selectInput('creatinine_units', 'creatinine units', c("mg/dl","mmol/L")),
	numericInput('WEIGHT', 'Weight', NA,30,200,step=1),
	selectInput('weight_units', 'Weight units', c("lbs","kg")),
	numericInput('SBP', 'Systolic Blood Pressure', NA,70,200,step=1),
    selectInput('ICD', 'Implantable Defib', c("yes","no"))
  ),

  mainPanel(
    verbatimTextOutput("display"),
    verbatimTextOutput("summary")
  )
)
