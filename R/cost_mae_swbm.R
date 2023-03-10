cost_mae_swbm <- function(
    par,
    obs,
    drivers
  ){
  
  # predefine variables for CRAN check compliance
  sitename <- data <- NULL
  
  ## execute model for this parameter set
  params_modl <- list(
    kphio                 = 0.08718,
    soilm_par_a           = 0.0,
    soilm_par_b           = 0.73300,
    tau_acclim_tempstress = 10,
    par_shape_tempstress  = 0,
    exp_et                = par[1],
    beta_et               = par[2],
    rwsc                  = par[3]
  )
  
  # run the model
  df <- runread_pmodel_f(
    drivers, 
    par = params_modl,
    makecheck = TRUE,
    parallel = FALSE
  )
  
  # cleanup
  df <- df %>%
    dplyr::select(sitename, data) %>% 
    tidyr::unnest(data) %>%
    dplyr::rename(
      'le_mod' = 'latenth'
    )
  # output[output$sitename=='FR-Pue',]$data[[1]][[1]] # alternative base R option
  
  obs <- obs %>%
    dplyr::select(sitename, data) %>% 
    tidyr::unnest(data)
  
  # left join with observations
  df <- dplyr::left_join(df, obs, by = c('sitename', 'date'))
  
  # Calculate cost (RMSE)
  cost <- mean( abs(df$le - df$le_mod ), na.rm = TRUE )

  # print(paste(c(par, cost), collapse = " "))
        
  return(cost)
}