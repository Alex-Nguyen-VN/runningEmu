describe("new_un_cpp",{
  it("should calculate the average of the sum of row averages and column averages in a square matrix", {
    m <- matrix(seq(9),nrow=3)
    expect_equal(10, new_un_cpp(m))
    m <- matrix(seq(16),nrow=4)
    expect_equal(17, new_un_cpp(m))
  })
})

describe("deux", {
  it("should return the longest continuous increasing subsequence", {
    vec <- c(3, 10, 2, 1, 20, 4, 5, 6, 7, 8)
    expect_equal(c(4,5,6,7,8), deux(vec))
    vec <- c(10, 9, 2, 5, 3, 7, 101, 18)
    expect_equal(c(3, 7, 101), deux(vec))
  })
})

describe("trois", {
  it("should return the table of unique values", {
    vec <- as.integer(c(1, 2, 2, 3, 1, 2, 3, 4, 5))
    expect_equal(trois(vec), table(vec))
    vec <- as.integer(c(3, 3, 4, 3, 4, 4, 5, 5, 5))
    expect_equal(trois(vec), table(vec))
  })
})

m <- matrix(seq(9),nrow=3)
old_un <- function(m) {
  mean(apply(m,1,mean) + apply(m,2,mean))
}

old_un(m)

un_cpp_corrected <- 