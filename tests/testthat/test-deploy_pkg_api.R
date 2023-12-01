test_that("deploy_pkg_api generates the expected endpoint", {
  local_mocked_bindings(
    .rsc_deploy_api = function(api_dir, ...) {
      readLines(paste0(api_dir, "/entrypoint.R"))
    }
  )
  expect_snapshot({
    deploy_pkg_api("myPackage", "my_api")
  })
})

test_that("redeploy_pkg_api generates the expected endpoint", {
  local_mocked_bindings(
    .rsc_deploy_api = function(api_dir, ...) {
      readLines(paste0(api_dir, "/entrypoint.R"))
    }
  )
  expect_snapshot({
    redeploy_pkg_api("myPackage", "my_api", 12345)
  })
})
