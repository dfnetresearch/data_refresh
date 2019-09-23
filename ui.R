shinyUI(
  fluidPage(theme="diabesity.css",
            br(),
            fluidRow(
              column(3, 
                     uiOutput("UiVitals") 
              ),
              column(3, 
                     uiOutput("UiAll") 
              )
            ),
            br(),
            fluidRow(
              tags$strong("PLEASE NOTE:"),"Please wait until the data update is complete and then refresh the browser before viewing the dashboards."
            )
  )
)