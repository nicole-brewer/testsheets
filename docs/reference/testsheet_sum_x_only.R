test_that( "you can specify "include" as TRUE or just leave it blank", {
	actual <- sum(
		x = 4
	)
	expect_equal(actual$result, "16.0")
})

