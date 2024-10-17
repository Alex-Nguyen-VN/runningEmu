
<!-- README.md is generated from README.Rmd. Please edit that file -->

# runningEmu

<!-- badges: start -->
<!-- badges: end -->

``` r
Rcpp::cppFunction('double un(NumericMatrix m) {
  int n = m.nrow();
  double sum = 0;
  for (int i = 0; i < n; i++) {
    double row_mean = 0;
    for (int j = 0; j < n; j++) {
      row_mean += m(i, j);
    }
    sum += row_mean / n;
  }
  return sum;
}')
Rcpp::cppFunction('IntegerVector deux(IntegerVector vec) {
  IntegerVector longest_seq;
  IntegerVector current_seq;
  
  for (int i = 0; i < vec.size(); i++) {
    if (i == 0 || vec[i] > vec[i - 1]) {
      current_seq.push_back(vec[i]);
    } else {
      if (current_seq.size() > longest_seq.size()) {
        longest_seq = current_seq;
      }
      current_seq = IntegerVector();
      current_seq.push_back(vec[i]);
    }
  }
  
  if (current_seq.size() > longest_seq.size()) {
    longest_seq = current_seq;
  }
  
  return longest_seq;
}')
Rcpp::cppFunction('IntegerVector trois(IntegerVector vec) {
  IntegerVector out(10);
  for (int i = 0; i < vec.size(); i++) {
    out[vec[i] - 1]++;
  }
  return out;
}')
```

The goal of runningEmu is to create an environment for a Hacky Hour
competition

## Example

There are 3 functions to be optimized in this package.

Below are the runtimes for one evaluation of these functions

``` r
bigM <- 1e6
m <- matrix(rnorm(bigM), nrow=as.integer(sqrt(bigM)))
bench::system_time(un(m))
#> process    real 
#>       0  2.01ms
v <- sample(1:10, bigM, replace=TRUE)
bench::system_time(deux(v))
#> process    real 
#>   578ms   724ms
vv <- sample(1:10, bigM, replace=TRUE, prob=sample(seq(0.1,0.9,by=0.1), 10, replace = TRUE))
bench::system_time(trois(vv))
#> process    real 
#>       0  2.83ms
```

And here are the runtimes for 50 evaluations of these functions.

``` r
bench::mark(un(m), iterations = 10)
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 un(m)         955µs    984µs      969.    18.2KB        0
bench::mark(deux(v), iterations = 10)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 deux(v)       815ms    831ms      1.16    6.62KB     22.9
bench::mark(trois(vv), iterations = 10)
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 trois(vv)    2.76ms   2.79ms      355.    6.62KB        0
```
