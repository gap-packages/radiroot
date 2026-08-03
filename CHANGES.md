This file describes changes in the RadiRoot package, beginning with version 2.1.

## 2.9 (2022-03-01)

  - Clarify that the license is GPL 2 *or later*

## 2.8 (2018-04-23)

  - Add the GAP Team as package maintainer
  - Move the package homepage to GitHub
  - Use `TestDirectory` to run the tests, and fix whitespace in the `.tst`
    files
  - Require GAP >= 4.7 and Alnuth >= 3.0

## 2.7 (2014-04-09)

  - Fix a bug in the output regarding the powers of the root of unity,
    reported by Daniel Blazewicz on 2014-03-31
  - Reduce the coefficients in the representations of cyclic elements in the
    output, following a suggestion by Daniel Blazewicz

## 2.6 (2011-11-04)

  - Replace the archive that mistakenly became public as 2.5

## 2.5 (2011-10-28)

  - Adjust the package to GAP 4.5 and the new homepage location
  - Fix a method selection bug reported by Max Horn, by adding
    `TryNextMethod` to the various methods that are for rational polynomials,
    so that other polynomials are delegated to appropriate methods

## 2.4 (2008-01-22)

  - Correct the documentation, as reported by David Sevilla
  - Fix a bug for linear polynomials in `RR_RootOfUnity`, reported by David
    Sevilla (introduced with the fix in 2.3)
  - Fix wrong results from subsequent calls to the main functions for
    polynomials whose cyclotomic polynomial splits into non-linear factors
    over the splitting field
  - Add a method for `IsomorphismMatrixField` for the Rationals
  - Correct the output for the polynomial `x`

## 2.3 (2007-06-15)

  - Add a test file with the examples from the documentation
  - Fix a bug in `RR_RootOfUnity`, reported by David Sevilla, by using
    `IsomorphismMatrixField` instead of `EquationOrderBasis`

## 2.2 (2007-05-09)

  - Add this file to document the changes between versions
  - Introduce a copyright
  - Improve the documentation, following the final report of the referee
  - Change the status of the package to 'accepted'. :)
