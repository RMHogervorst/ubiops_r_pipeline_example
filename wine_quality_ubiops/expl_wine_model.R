library(recipes)
library(magrittr)
library(workflows)
library(rsample)
library(parsnip)
library(earth)
winequality <- read.csv("data/winequality-red.csv")
split <- initial_split(winequality, prop = 0.8,strata = "quality")
train <- training(split)
test <- testing(split)

## make recipe
rec_wine <-
    training(split) %>%
    recipe(quality~.) %>%
    step_corr(all_predictors()) %>%
    step_nzv(all_predictors()) %>%
    step_center(all_predictors(), -all_outcomes()) %>%
    step_scale(all_predictors(), -all_outcomes()) %>%
    prep()

train_scaled <- juice(rec_wine)
test_scaled <- rec_wine %>%
    bake(testing(split))

marsmodel <- mars(mode = "regression") %>%
    set_engine("earth")

# model with MARS
mars_wf <-
    workflow() %>%
    add_recipe(rec_wine) %>%
    add_model(marsmodel)
fit_mars <- mars_wf %>%
    fit(data = train)

# predict

pred_test_mars <- fit_mars %>%
    predict(test) %>%
    bind_cols(test_scaled) %>%
    rename(actual = quality,
           prediction = .pred) %>%
    mutate(difference = actual-prediction,
           model = 'MARS') %>%
    select(model, actual, prediction, difference)

glimpse(pred_test_mars, width = 80)

# evaluate
fit_mars %>%
    predict(test) %>%
    bind_cols(test) %>%
    rmse(quality, .pred)
# 65%, pretty bad

#save model
saveRDS(fit_mars,'ubiops_deployment/deployment_package/fit_mars.RDS')
