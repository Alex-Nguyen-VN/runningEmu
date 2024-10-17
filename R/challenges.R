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

un <- Rcpp::cppFunction('double un(NumericMatrix m) {
  int n = m.nrow();
  int p = m.ncol();  // Number of columns
  double sum = 0;
  for (int i = 0; i < n; i++) {
    double row_mean = 0;
    for (int j = 0; j < p; j++) {
      row_mean += m(i, j);
    }
    sum += row_mean / p;  // Divide by number of columns
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

#' @title Third
#' @description
#' Given a vector return the count of each unique element
#' 
#' Hint: Try looking into `tabulate`, `fastmatch::fastmatch`
#' @param vec Numerical vector
#' @return A single numerical vector with counts of each unique element
#'
#' @export
Rcpp::cppFunction('IntegerVector trois(IntegerVector vec) {
  IntegerVector out(10);  // Vector to store counts for numbers 1 to 10
  for (int i = 0; i < vec.size(); i++) {
    if (vec[i] >= 1 && vec[i] <= 10) {  // Check if the number is within 1-10
      out[vec[i] - 1]++;
    }
  }
  return out;
}')