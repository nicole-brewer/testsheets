test_that("google sheets example works", {
  ss <- testsheets::testsheets_example("google sheets")
  expect_equal(ss,"https://docs.google.com/spreadsheets/d/1vR1aUlKMGtZIJOZaHNk7kePgeYYrkhoy0PFmZxs8wt4/edit?usp=sharing")
})

test_that("excel example works", {
  path <- testsheets::testsheets_example("excel")
  expect_equal(basename(path), "testsheets_example.xlsx")
})

test_that("default example works", {
  expect_error()
})
