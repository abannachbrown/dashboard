#----------------------------------------------------------------------
# oddpub data loading & preprocessing functions
#----------------------------------------------------------------------

make_oddpub_plot_data <- function(data_table)
{
  od_manual_pos <- (!is.na(data_table$open_data_manual_check) & data_table$open_data_manual_check)
  data_table[od_manual_pos,]$is_open_data <- TRUE
  oddpub_plot_data <- data_table %>%
    #only take the categories mentioned first, as there is no space to show all combinations in the plots
    mutate(open_data_category_priority = (open_data_category_manual %>% (function(x)
      x %>% str_split(",") %>% map_chr(head, 1)))) %>%
    mutate(open_code_category_priority = (open_code_category_manual %>% (function(x)
      x %>% str_split(",") %>% map_chr(head, 1)))) %>%
    group_by(year) %>%
    summarize(open_data_manual_count = sum(open_data_manual_check, na.rm = TRUE),
              open_data_neg_count = sum(!open_data_manual_check, na.rm = TRUE),
              open_data_NA_count = sum(is.na(open_data_manual_check), na.rm = TRUE),

              open_code_manual_count = sum(open_code_manual_check, na.rm = TRUE),
              open_code_neg_count = sum(!open_code_manual_check, na.rm = TRUE),
              open_code_NA_count = sum(is.na(open_code_manual_check), na.rm = TRUE),

              OD_field_specific_count = sum(open_data_category_priority == "field-specific repository", na.rm = TRUE),
              OD_general_purpose_count = sum(open_data_category_priority == "general-purpose repository", na.rm = TRUE),
              OD_supplement_count = sum(open_data_category_priority == "supplement", na.rm = TRUE),
              OC_github_count = sum(open_code_category_priority == "github", na.rm = TRUE),
              OC_other_count = sum(open_code_category_priority == "other repository/website", na.rm = TRUE),
              OC_supplement_count = sum(open_code_category_priority == "supplement", na.rm = TRUE),
              total = sum(!is.na(is_open_data) | (open_data_manual_check == TRUE), na.rm = TRUE)) %>%

    mutate(open_data_manual_perc = round(open_data_manual_count/total * 100, 1)) %>%
    mutate(open_code_manual_perc = round(open_code_manual_count/total * 100, 1)) %>%
    mutate(OD_field_specific_perc = round(OD_field_specific_count/total * 100, 1)) %>%
    mutate(OD_general_purpose_perc = round(OD_general_purpose_count/total * 100, 1)) %>%
    mutate(OD_supplement_perc = round(OD_supplement_count/total * 100, 1)) %>%
    mutate(OC_github_perc = round(OC_github_count/total * 100, 1)) %>%
    mutate(OC_other_perc = round(OC_other_count/total * 100, 1)) %>%
    mutate(OC_supplement_perc = round(OC_supplement_count/total * 100, 1))

  return(oddpub_plot_data)
}
