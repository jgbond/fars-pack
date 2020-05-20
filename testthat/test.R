# Run test to ensure that the FARS summarize function outputs a Tibble
test_that(fars_summarize_years(list(2013,2014,2015)), is_a("tbl_df"))
