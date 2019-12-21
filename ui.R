fluidPage(
  theme = "diabesity.css",
  shinyjs::useShinyjs(),
  br(),
  fluidRow(
    column(
      6,
      shinyBS::bsButton("refresh", "Refresh Database", style="primary"), br(), br(),
      shinyjs::hidden(
        div(
          id = "refresh_msg",
          class = "alert alert-info",
          h2("Refresh in progress...", icon("spinner", class = "fa-pulse"), style = "margin-top: 0"),
          "This will take several minutes. Please wait until the data update is completed and then refresh the browser before viewing the dashboards."
        )
      ),
      tags$strong("Last Refresh:"), br(),
      textOutput("last_updated")
    )
  )
)
