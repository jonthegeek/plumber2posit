# cookie_endpoint_simple returns the expected string.

    Code
      cookie_endpoint_simple()
    Output
      plumber::pr_get("/cookie", function(req) {
      cookie_nm <- req$argsQuery[["cookie_name"]]
      if (is.null(cookie_nm)) cookie_nm <- "therealshinyapps"
      req$cookies[[cookie_nm]]
      }, serializer = plumber::serializer_text())

# cookie_endpoint_httr2 returns the expected string.

    Code
      cookie_endpoint_httr2()
    Output
      plumber::pr_get("/cookie", function(req) {
      cookie_nm <- req$argsQuery[["cookie_name"]]
      if (is.null(cookie_nm)) cookie_nm <- "therealshinyapps"
      cookie_value <- req$cookies[[cookie_nm]]
      glue::glue("httr2::req_headers(Cookie = '{cookie_nm}={cookie_value}')")
      }, serializer = plumber::serializer_text())

