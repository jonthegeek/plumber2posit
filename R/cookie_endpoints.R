#' Source code for a simple cookie endpoint
#'
#' Posit Cloud uses a cookie to identify the user. The output of this function
#' can be used to add a "/cookie" endpoint to an api in order to allow users to
#' easily extract their Posit Cloud cookie for your endpoint.
#'
#' @param default_cookie_name Character. The name of the cookie to use if the
#'   user does not request a different cookie.
#'
#' @return The source code for a simple cookie endpoint as character.
#' @export
#'
#' @examples
#' cookie_endpoint_simple()
#' cookie_endpoint_simple("another_cookie_name")
cookie_endpoint_simple <- function(default_cookie_name = "therealshinyapps") {
  .src_endpoint(
    "cookie",
    .src_get_cookie(default_cookie_name),
    "plumber::serializer_text"
  )
}

#' Source code for a cookie endpoint that uses httr2
#'
#' Posit Cloud uses a cookie to identify the user. The output of this function
#' can be used to add a "/cookie" endpoint to an api in order to allow users to
#' easily extract their Posit Cloud cookie for your endpoint and use that cookie
#' with the httr2 package.
#'
#' @param default_cookie_name Character. The name of the cookie to use if the
#'   user does not request a different cookie.
#'
#' @return The source code for a cookie endpoint as character.
#' @export
#'
#' @examples
#' cookie_endpoint_httr2()
#' cookie_endpoint_httr2("another_cookie_name")
cookie_endpoint_httr2 <- function(default_cookie_name = "therealshinyapps") {
  .src_endpoint(
    "cookie",
    .src_get_cookie_httr2(default_cookie_name),
    "plumber::serializer_text"
  )
}

.src_endpoint <- function(path, fn_src, serializer_name) {
  glue::glue(
    'plumber::pr_get("/{path}", {fn_src}, serializer = {serializer_name}())'
  )
}

.src_get_cookie <- function(default_cookie_name = "therealshinyapps",
                            call = rlang::caller_env()) {
  .check_arg_not_null(default_cookie_name, call = call)
  glue::glue(
    'function(req) {',
    'cookie_nm <- req$argsQuery[["cookie_name"]]',
    'if (is.null(cookie_nm)) cookie_nm <- "<<default_cookie_name>>"',
    'req$cookies[[cookie_nm]]',
    '}',
    .sep = "\n",
    .open = "<<", .close = ">>"
  )
}

.src_get_cookie_httr2 <- function(default_cookie_name = "therealshinyapps",
                                  call = rlang::caller_env()) {
  .check_arg_not_null(default_cookie_name, call = call)
  glue::glue(
    'function(req) {',
    'cookie_nm <- req$argsQuery[["cookie_name"]]',
    'if (is.null(cookie_nm)) cookie_nm <- "<<default_cookie_name>>"',
    'cookie_value <- req$cookies[[cookie_nm]]',
    'glue::glue("httr2::req_headers(Cookie = \'{cookie_nm}={cookie_value}\')")',
    '}',
    .sep = "\n",
    .open = "<<", .close = ">>"
  )
}

# TODO: Use {stbl} once it's stable.
.check_arg_not_null <- function(x,
                                arg = rlang::caller_arg(x),
                                call = rlang::caller_env()) {
  if (is.null(x)) {
    cli::cli_abort(
      "{.arg {arg}} must be a length-1 character vector.",
      class = "error_pkg2cloud_null_arg",
      call = call
    )
  }
}
