# deploy_pkg_api generates the expected endpoint

    Code
      deploy_pkg_api("myPackage", "my_api")
    Output
      [1] "library(myPackage)"                                                       
      [2] "plumber::plumb_api(\"myPackage\", \"my_api\") |>"                         
      [3] "plumber::pr_get(\"/cookie\", function(req) {"                             
      [4] "cookie_nm <- req$argsQuery[[\"cookie_name\"]]"                            
      [5] "if (is.null(cookie_nm)) cookie_nm <- \"therealshinyapps\""                
      [6] "cookie_value <- req$cookies[[cookie_nm]]"                                 
      [7] "glue::glue(\"httr2::req_headers(Cookie = '{cookie_nm}={cookie_value}')\")"
      [8] "}, serializer = plumber::serializer_text())"                              

# redeploy_pkg_api generates the expected endpoint

    Code
      redeploy_pkg_api("myPackage", "my_api", 12345)
    Output
      [1] "library(myPackage)"                           
      [2] "plumber::plumb_api(\"myPackage\", \"my_api\")"

