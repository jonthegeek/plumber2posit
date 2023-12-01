test_that("cookie_endpoint_simple fails for NULL default.", {
  expect_error(
    {cookie_endpoint_simple(default_cookie_name = NULL)},
    class = "error_pkg2cloud_null_arg"
  )
})

test_that("cookie_endpoint_httr2 fails for NULL default.", {
  expect_error(
    {cookie_endpoint_httr2(default_cookie_name = NULL)},
    class = "error_pkg2cloud_null_arg"
  )
})

test_that("cookie_endpoint_simple returns the expected string.", {
  expect_snapshot({cookie_endpoint_simple()})
})

test_that("cookie_endpoint_httr2 returns the expected string.", {
  expect_snapshot({cookie_endpoint_httr2()})
})
