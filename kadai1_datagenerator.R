#gender, bmi, age, sbp, dbp, bpcat(normal, elevated, stage1, stage2, crisis)

dat <- tibble(
  gender = sample(c("Male","Female"), 3000, replace = TRUE),
  bmi = runif(3000, 16, 30),
  age = runif(3000, 20, 80) %>% round(0),
  bpseed = runif(3000,0,100)
) %>% 
  mutate(sbp = round(bpseed + 80, 0),
         dbp = round(80 + (bpseed * 0.40), 0) ) %>% 
  mutate(bpcat = case_when(
    sbp >= 180             | dbp >= 110             ~ "Htn Stage3",
    sbp >= 160 & sbp < 180 | dbp >= 100 & dbp < 109 ~ "Htn Stage2",
    sbp >= 140 & sbp < 160 | dbp >= 90  & dbp <  99 ~ "Htn Stage1",
    sbp >= 130 & sbp < 140 | dbp >= 80  & dbp <  90 ~ "Elevated",
    TRUE ~ "normal"
  )) %>% 
  mutate(treatment = sample(c("treat","control"), 3000, replace = TRUE)) %>% 
  select(-bpseed)

#View(dat)

write_csv(dat,"practice_data1.csv")
