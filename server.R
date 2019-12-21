function(input, output, session) {

  config <- config::get()

  logfile <- reactiveFileReader(1000, session, config$timelog_file,
                                readFunc = function(x) readLines(x, n = 1))

  output$last_updated <- renderText({
    logfile()
  })

  lock_checker <- reactiveTimer(1000)
  locked <- reactive({
    lock_checker()
    if (file.exists(config$lock_file)) {
      TRUE
    } else {
      FALSE
    }
  })

  observe({
    shinyjs::toggleState("refresh", condition = !locked())
    shinyjs::toggle("refresh_msg", condition = locked())
  })

  observeEvent(input$refresh, {
    system(paste0(config$script, " > ", config$log_file), wait = FALSE)
  })
}
