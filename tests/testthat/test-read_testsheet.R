test_that("read sum", {
  ss <- testsheets::testsheets_example("google sheets")
  testdata <- testsheets::read_testsheet(ss, "sum")
})
