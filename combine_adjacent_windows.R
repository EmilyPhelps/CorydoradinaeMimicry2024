#If the outlier rows are next to each other combine them. If they have less than 100 sites, combine with the two adjacent rows. 
#Split by population

test <- df %>% filter(pop =="AL") %>% mutate(og_index=rownames(.))

#Look at a row and two rows before and after

 %>% filter(between(as.numeric(og_index), 1207 - 2, 1207 + 2)) 
       
#1. Combine adjacent outlier sites
  # 1.1. print an outlier. If the line before and after have the next OG index combine hte regions printing new scaffold, start and combined site number to new df called window_merged
#2. Combine outlier sites that have a site number of less than 50 with the neighbouring windows.
  # 2.1. Print a focal site and the site before and after.
  # 2.2. If the sum of the sites is over 50, take the whole site and write to a new df called window_merged
  # 2.3. If the sum of sites is under 50, print the next two rows and add until 50

outlier.df <- test %>% filter(outlier == "outlier" & sites < 50)
output.df <- data.frame()
for (i in seq(1, nrow(outlier.df))){
  focal.outlier <- outlier.df[i,]
  output <- test %>% 
            filter(between(as.numeric(og_index), as.numeric(focal.outlier$og_index) -1, as.numeric(focal.outlier$og_index)+ 1)) %>%
            mutate(focal_outlier= focal.outlier$og_index)
  output.df <- rbind(output, output.df)
  } 

#Then set this as outlier.df and re_run!
output.df %>% group_by(focal_outlier) %>% summarize(new.sites=sum(sites), scaffold=max(scaffold), start=min(start), end=max(end))

#If it is within 3 adjacent windows replace the end
outlier.df <- test %>% filter(outlier == "outlier") %>% arrange(og_index)

combine_outliers <- function(df) {
  window_merged <- df %>%
    group_by(scaffold, cluster) %>%
    summarize(
      start = first(start),
      end = last(end),
      combined_sites = sum(sites),
    )
  
  return(window_merged)
}

data <- data.frame(scaffold = character(0), start = numeric(0), end = numeric(0))

for (i in seq(1, nrow(outlier.df) - 1)) {
  if(outlier.df[i,]$og_index + 1 == outlier.df[i + 1,]$og_index) {
    start <- as.numeric(outlier.df[i,]$start)
    end <- as.numeric(outlier.df[i + 1,]$end)
    scaffold <- as.character(outlier.df[i,]$scaffold)
    new_row <- data.frame(scaffold = scaffold, start = start, end = end)
    
    data <- rbind(data, new_row)
  } else {
    start <- as.numeric(outlier.df[i,]$start)
    end <- as.numeric(outlier.df[i,]$end)
    scaffold <- as.character(outlier.df[i,]$scaffold)
    new_row <- data.frame(scaffold = scaffold, start = start, end = end)
    data <- rbind(data, new_row)
  }
}

# Handle the last row if needed
if(outlier.df[nrow(outlier.df),]$og_index != outlier.df[nrow(outlier.df) - 1,]$og_index + 1) {
  start <- as.numeric(outlier.df[nrow(outlier.df),]$start)
  end <- as.numeric(outlier.df[nrow(outlier.df),]$end)
  scaffold <- as.character(outlier.df[nrow(outlier.df),]$scaffold)
  new_row <- data.frame(scaffold = scaffold, start = start, end = end)
  data <- rbind(data, new_row)
}



if(between(outlier.df[i,]$og_index, outlier.df[i-1,]$og_index, outlier.df[i+1,]$og_index)){
  
}
#What I could do is create a list of dataframe and if the focal outlier is less than 50 sites add together and print line to a new dataframe.
   
  if ( ) {
  # Code block to execute if the condition is TRUE
} else {
  # Code block to execute if the condition is FALSE (optional)
}

#If an outlier + 5000 bp either side, collapse into one region and add the number of sites
