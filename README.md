
<!-- README.md is generated from README.Rmd. Please edit that file -->

# runningEmu

<!-- badges: start -->
<!-- badges: end -->

``` r
library(Rcpp)
```

``` r
cppFunction('double un_ccp_new(NumericMatrix m) {
  int n = m.nrow();        // Number of rows
  int p = m.ncol();        // Number of columns
  double sum_col = 0;      // Initialize column sum
  double sum_row = 0;      // Initialize row sum

  for (int i = 0; i < n; i++) {
    // Sum over each row
    sum_row += std::accumulate(m(i, _).begin(), m(i, _).end(), 0.0) / p;
  }

  for (int j = 0; j < p; j++) {
    // Sum over each column
    sum_col += std::accumulate(m(_, j).begin(), m(_, j).end(), 0.0) / n;
  }

  return (sum_col + sum_row)/n;
}')


Rcpp::cppFunction('IntegerVector deux(IntegerVector vec) {
  if (vec.size() == 0) {
    return IntegerVector();  // Return an empty vector if input is empty
  }

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
  IntegerVector out(10);  // Vector to store counts for numbers 1 to 10
  for (int i = 0; i < vec.size(); i++) {
    if (vec[i] >= 1 && vec[i] <= 10) {  // Check if the number is within 1-10
      out[vec[i] - 1]++;
    }
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
bench::system_time(un_ccp_new(m))
#> process    real 
#>       0  2.29ms
v <- sample(1:10, bigM, replace=TRUE)
bench::system_time(deux(v))
#> process    real 
#>   656ms   708ms
vv <- sample(1:10, bigM, replace=TRUE, prob=sample(seq(0.1,0.9,by=0.1), 10, replace = TRUE))
bench::system_time(trois(vv))
#> process    real 
#> 15.62ms  3.22ms
```

And here are the runtimes for 50 evaluations of these functions.

``` r
bench::mark(un_ccp_new(m), iterations = 10)
#> # A tibble: 1 × 6
#>   expression         min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>    <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 un_ccp_new(m)   1.89ms    1.9ms      515.    18.2KB        0
bench::mark(deux(v), iterations = 10)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 deux(v)       702ms    794ms      1.26    6.62KB     24.5
bench::mark(trois(vv), iterations = 10)
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 trois(vv)    3.06ms   3.07ms      325.    6.62KB        0
```
