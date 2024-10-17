
<!-- README.md is generated from README.Rmd. Please edit that file -->

# runningEmu

<!-- badges: start -->
<!-- badges: end -->

``` r
library(Rcpp)
```

``` r
Rcpp::cppFunction('double un(NumericMatrix m) {
  int n = m.nrow();  // Number of rows
  int p = m.ncol();  // Number of columns
  NumericVector row_means(n);
  NumericVector col_means(p);
  
  // Calculate row means
  for (int i = 0; i < n; i++) {
    double row_sum = 0;
    for (int j = 0; j < p; j++) {
      row_sum += m(i, j);
    }
    row_means[i] = row_sum / p;
  }

  // Calculate column means
  for (int j = 0; j < p; j++) {
    double col_sum = 0;
    for (int i = 0; i < n; i++) {
      col_sum += m(i, j);
    }
    col_means[j] = col_sum / n;
  }

  // Calculate the mean of row means + column means
  double overall_mean = mean(row_means + col_means);
  
  return overall_mean;
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
bench::system_time(un(m))
#> process    real 
#>       0  4.04ms
v <- sample(1:10, bigM, replace=TRUE)
bench::system_time(deux(v))
#>  process     real 
#> 703.12ms    1.06s
vv <- sample(1:10, bigM, replace=TRUE, prob=sample(seq(0.1,0.9,by=0.1), 10, replace = TRUE))
bench::system_time(trois(vv))
#> process    real 
#>       0  7.75ms
```

And here are the runtimes for 50 evaluations of these functions.

``` r
bench::mark(un(m), iterations = 10)
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 un(m)         4.5ms   5.58ms      181.    41.8KB        0
bench::mark(deux(v), iterations = 10)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 deux(v)       883ms    1.06s     0.944    6.62KB     11.0
bench::mark(trois(vv), iterations = 10)
#> # A tibble: 1 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 trois(vv)    5.38ms   5.74ms      146.    6.62KB        0
```
