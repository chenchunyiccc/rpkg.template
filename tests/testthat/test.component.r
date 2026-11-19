test_that("RemoveSeasonal computes seasonal mean and anomaly", {
  y <- c(30, 10, 40, 20)
  t <- c(102, 101, 102, 101)
  out <- RemoveSeasonal(y, t)

  expect_equal(out$mu, c(15, 35))
  expect_equal(out$anomaly, c(-5, -5, 5, 5))
})

test_that("RemoveSeasonal handles NA via na.rm", {
  y <- c(10, NA, 30, 40)
  t <- c(101, 101, 102, 102)
  out <- RemoveSeasonal(y, t)

  expect_equal(out$mu, c(10, 35))
  expect_true(is.na(out$anomaly[2]))
})

test_that("LS_OneBreak matches lm with a breakpoint", {
  n <- 20
  X <- seq_len(n)
  Ic <- 10
  ind <- c(rep(0, Ic), rep(1, n - Ic))
  Y <- 2 + 0.5 * X + 3 * ind

  out <- LS_OneBreak(Y, X, Ic)
  m <- lm(Y ~ X + ind)

  expect_equal(as.vector(out$coef), unname(coef(m)))
  expect_equal(out$fitted, unname(fitted(m)))
  expect_equal(out$SSE, sum(resid(m)^2))
})

test_that("LS_OneBreak reduces to lm when Ic = NA", {
  n <- 20
  X <- seq_len(n)
  Y <- 1 + 2 * X

  out <- LS_OneBreak(Y, X, NA)
  m <- lm(Y ~ X)

  expect_equal(as.vector(out$coef), unname(coef(m)))
})

test_that("LS_MultiBreaks matches lm with centred X", {
  n <- 30
  X <- seq_len(n)
  Ips <- c(10, 20, 30)
  seg2 <- c(rep(0, 10), rep(1, 10), rep(0, 10))
  seg3 <- c(rep(0, 20), rep(1, 10))
  Y <- 2 + 0.5 * (X - mean(X)) + 3 * seg2 - 2 * seg3

  out <- LS_MultiBreaks(Y, X, Ips)
  m <- lm(Y ~ I(X - mean(X)) + seg2 + seg3)

  expect_equal(as.vector(out$coef), unname(coef(m)))
  expect_equal(out$fitted, unname(fitted(m)))
})

test_that("lm_solve returns coef, fitted, resi and SSE", {
  X <- seq_len(4)
  design <- cbind(1, X)
  Y <- 2 * X

  out <- lm_solve(design, Y)

  expect_equal(as.vector(out$coef), c(0, 2))
  expect_equal(out$fitted, Y)
  expect_equal(out$resi, rep(0, 4))
  expect_equal(out$SSE, 0)
})

test_that("lm_solve with only.SSE returns just SSE", {
  design <- cbind(1, seq_len(4))
  Y <- 2 * seq_len(4)

  out <- lm_solve(design, Y, only.SSE = TRUE)

  expect_equal(out, list(SSE = 0))
})
