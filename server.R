shinyServer(function(input, output) {
  
  # initialize log file
  logVitals <- "/srv/shiny-server/apps/diabesity/data_refresh/runlog/runlogVitals.csv"
  createLogFile(logVitals,"runTime")
  logAll <- "/srv/shiny-server/apps/diabesity/data_refresh/runlog/runlogAll.csv"
  createLogFile(logAll,"runTime")
  lock <- "/srv/shiny-server/apps/diabesity/data_refresh/runlog/lock.csv"
  
  # latest vitals and meds data refresh button
  output$UiVitals <- renderUI({
    input$refreshVitals
    input$refreshAll
    runLog <- read.csv(logVitals, header=TRUE, stringsAsFactors=FALSE)
    lastrun.time <- ifelse(is.na(runLog[1,1]), "", runLog[1,1])
    tags$div(
      br(),bsButton("refreshVitals", "Refresh Vitals and GTT Meds Data", style="primary"), br(),
      tags$span("Last Refresh:", style="font-weight:bold"), br(), 
      lastrun.time
    )
  })
  
  # latest all data refresh button
  output$UiAll <- renderUI({
    input$refreshVitals
    input$refreshAll
    runLog <- read.csv(logAll, header=TRUE, stringsAsFactors=FALSE)
    lastrun.time <- ifelse(is.na(runLog[1,1]), "", runLog[1,1])
    tags$div(
      br(),bsButton("refreshAll", "Refresh Entire Database", style="primary"), br(),
      tags$span("Last Refresh:", style="font-weight:bold"), br(),
      lastrun.time
    )
  })
  
  # after vitals refresh: update timestamp, refresh derived datasets
  observeEvent(input$refreshVitals, {
    if(!file.exists(lock)){  
      file.create(lock)  
          withProgress(message='Updating vitals and meds data', 
                 detail='Please wait until data update is completed and then refresh the browser before viewing the dashboards.', value=1, {
         
                   system("/analytics/cronjobs/diabesity/diabesity_plate_module_update_vitals_gttmeds >/dev/null")
                   file.remove(lock)
                   source("/srv/shiny-server/apps/diabesity/patient_report/dataprep/dataprep.R")
                   source("/srv/shiny-server/apps/diabesity/patient_report_update/dataprep/dataprep.R")
                   updateLogFile(date(), logVitals)
                 })
      }
  })
  
  # after all data refresh: update timestamp, refresh derived datasets  
  observeEvent(input$refreshAll, {
    if(!file.exists(lock)){
    file.create(lock)
    withProgress(message='Updating entire database', 
                 detail='This might take a while. Please wait until data update is completed and then refresh the browser before viewing the dashboards.', value=1, {
                                        
                   system("/analytics/cronjobs/diabesity/diabesity_plate_module_update >/dev/null")
                   file.remove(lock)
                   source("/srv/shiny-server/apps/diabesity/patient_report/dataprep/dataprep.R")
                   source("/srv/shiny-server/apps/diabesity/patient_report_update/dataprep/dataprep.R")
                   updateLogFile(date(), logAll)
                 })
    }
  })
})