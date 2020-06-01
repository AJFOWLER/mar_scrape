# base functions to clean MAR data #


initial_clean_mar = function(dat){
  # remove entirely NA rows
  dt_r = dat[rowSums(is.na(dat)) != ncol(dat),] # 
  # remove entirely NA cols
  drop_cols = which(colSums(is.na(dat)) == nrow(dat))
  # remove Na columns
  if(length(drop_cols) >= 1){
    dt_r = dt_r[,-drop_cols]
  }
  # there are rows at the bottom which are notes, drop these
  a = rowSums(is.na(dt_r))
  bottom_drop = which(max(a) - a <5 )
  dt_r = dt_r[-bottom_drop,]
  return(dt_r)
}

assign_header_mar = function(dat){
  potential_headers = find_header_hes(dat)
  View(dat[1:max(potential_headers)])
  selected_header = type_integer('Enter the row number of header row::')
  selected_total_row = type_integer('Enter the row number of total row, N if no total row::')
  rows_ = selected_header:nrow(dat)
  rows_no_tot = rows_[rows_ != selected_total_row]
  fresh_dt = dat[rows_no_tot,] 
  colnames(fresh_dt) = fresh_dt[1,]
  fresh_dt = fresh_dt[-1,]
  return(fresh_dt)
}

# find header
find_header_mar = function(dat){
  # to find header rows, identify which rows have the same number 
  a = rowSums(!is.na(dat))
  # should have <10 missing
  potential_headers = which(mean(a) - a <10)[1:3]
  return(potential_headers)
}

# return values from typed options
type_integer = function(prompt_text){
  n = readline(prompt = prompt_text)
  if(tolower(n) == 'n'){
    n = 'No total'
  }
  else{
    n = as.integer(n)
  }
  return(n)
}