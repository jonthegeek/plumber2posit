#' Deploy a Package's API to Posit
#'
#' [plumber::plumb_api()] was added in plumber 1.0.0 to standardize the process
#' to wrap an API inside a package. However, deploying that API takes some extra
#' steps. This function streamlines that process.
#'
#' @param package Character. The name of the package that contains the API.
#' @param folder_name Character. The name of the folder that contains the API.
#' @param ... Additional arguments to [rsconnect::deployApp()].
#' @param cookie_endpoint_src Character. The source code for the cookie
#'   endpoint, such as those returned by [cookie_endpoint_httr2()] (the default)
#'   and [cookie_endpoint_simple()].
#' @param server Character. The server to deploy to. Defaults to "posit.cloud".
#' @param api_name Character. The name of the API. Defaults to `folder_name`.
#'
#' @return Whether the deployment was successful, invisibly.
#' @export
deploy_pkg_api <- function(package,
                           folder_name,
                           ...,
                           cookie_endpoint_src = cookie_endpoint_httr2(),
                           server = "posit.cloud",
                           api_name = folder_name) {
  entry <- .generate_pkg_entrypoint(package, folder_name, cookie_endpoint_src)
  .deploy_entrypoint(entry, appName = api_name, server = server, ...)
}

#' Redeploy a Package's API to Posit
#'
#' Once an API has been deployed to Posit Cloud, deploying something with the
#' same name will *not* automatically update the existing API. Instead, you must
#' supply the `appId` argument to [rsconnect::deployApp()], and *not* the
#' `appName` argument. This function walks you through that process.
#'
#' @param package Character. The name of the package that contains the API.
#' @param folder_name Character. The name of the folder that contains the API.
#' @param app_id Character or numeric. The number that identifies your API. You
#'   can find this number in the URL of your API's page on Posit Cloud. For
#'   example, for the app at `posit.cloud/content/12345`, the id is "12345".
#' @param ... Additional arguments to [rsconnect::deployApp()].
#' @param cookie_endpoint_src Character. The source code for the cookie
#'   endpoint, such as those returned by [cookie_endpoint_httr2()] and
#'   [cookie_endpoint_simple()]. By default this is `NULL` here to remove the
#'   cookie endpoint.
#' @param server Character. The server to deploy to. Defaults to "posit.cloud".
#'
#' @return Whether the deployment was successful, invisibly.
#' @export
redeploy_pkg_api <- function(package,
                             folder_name,
                             app_id,
                             ...,
                             cookie_endpoint_src = NULL,
                             server = "posit.cloud") {
  dots <- rlang::list2(...)
  dots$appName <- NULL

  entry <- .generate_pkg_entrypoint(package, folder_name, cookie_endpoint_src)
  rlang::inject(
    .deploy_entrypoint(entry, appId = app_id, server = server, !!!dots)
  )
}

.generate_pkg_entrypoint <- function(package,
                                     folder_name,
                                     cookie_endpoint_src) {
  entrypoint_text <- glue::glue(
    'library({package})',
    'plumber::plumb_api("{package}", "{folder_name}")',
    .sep = "\n"
  )
  if (!is.null(cookie_endpoint_src)) {
    entrypoint_text <- paste(
      paste(entrypoint_text, "|>"),
      cookie_endpoint_src,
      sep = "\n"
    )
  }
  return(entrypoint_text)
}

.deploy_entrypoint <- function(entrypoint_text, ...) {
  api_dir <- withr::local_tempdir("api")
  file_path <- paste0(api_dir, "/entrypoint.R")
  writeLines(entrypoint_text, file_path)
  .rsc_deploy_api(api_dir, appMode = "api", ...)
}

.rsc_deploy_api <- function(...) {
  # wrap for cleaner mocking.
  rsconnect::deployAPI(...) # nocov
}
