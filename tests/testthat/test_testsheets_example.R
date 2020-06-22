test_that("google sheets example works", {
  googledrive::drive_deauth()
  ss <- testsheets::testsheets_example("google sheets")
  expect_true(googledrive::is_dribble(ss))
  expect_true(googledrive::single_file(ss))
})

test_that("excel example works", {
  path <- testsheets::testsheets_example("excel")
  expect_equal(basename(path), "testsheets_example.xlsx")
})

test_that("default example works", {
  expect_error()
})


