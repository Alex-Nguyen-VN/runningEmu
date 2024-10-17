#' @title First function
#' @description
#' Given a square matrix, calculates the average over the sum of row averages and column averages
#' 
#' @param m a square matrix with no missing values
#' @return Single numerical value
#' @examples
#' m <- matrix(seq(16),nrow=4)
#' un(m)
#' @export

un <- Rcpp::cppFunction('double un_ccp(NumericMatrix m) {
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


#' @title Second
#' @description
#' Given a vector gives the longest continuous increasing subset
#' 
#' @param vec Numerical vector with no missing values
#' @return A numerical vector containing the longest continuous increasing subset
#' @export
deux <-  Rcpp::cppFunction('IntegerVector deux_ccp(IntegerVector vec) {
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

#' @title Third
#' @description
#' Given a vector return the count of each unique element
#' 
#' Hint: Try looking into `tabulate`, `fastmatch::fastmatch`
#' @param vec Numerical vector
#' @return A single numerical vector with counts of each unique element
#'
#' @export
trois <-  Rcpp::cppFunction('IntegerVector trois_ccp(IntegerVector vec) {
  IntegerVector out(10);
  for (int i = 0; i < vec.size(); i++) {
    out[vec[i] - 1]++;
  }
  return out;
}')