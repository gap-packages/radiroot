gap> START_TEST("Test handling of easy polynomials by RadiRoot");
gap> # special case f = x, does output work
gap> f := UnivariatePolynomial( Rationals, [0,1] );;
gap> RootsOfPolynomialAsRadicals(f, "off");;
gap> RootsAsMatrices(f);
[ [ [ 0 ] ] ]
gap> SplittingField(f);
Rationals
gap> GaloisGroupOnRoots(f);
Group(())
gap> # f = x - 1
gap> f := UnivariatePolynomial( Rationals, [-1,1] );;
gap> RootsAsMatrices(f);
[ [ [ 1 ] ] ]
gap> SplittingField(f);
Rationals
gap> GaloisGroupOnRoots(f);
Group(())
gap> # f = x^2 + x + 2
gap> f := UnivariatePolynomial( Rationals, [2,1,1] );;
gap> GaloisGroupOnRoots(f);
Group([ (1,2) ])
gap> SplittingField(f);
<algebraic extension over the Rationals of degree 2>
gap> RootsAsMatrices(f);
[ [ [ 0, 1 ], [ -2, -1 ] ], [ [ -1, -1 ], [ 2, 0 ] ] ]
gap> RootsOfPolynomialAsRadicals(f,"latex");;
gap> # f = x^3 - 3*x^2 + 3*x -3
gap> f := UnivariatePolynomial( Rationals, [-3,3,-3,1] );;
gap> RootsOfPolynomialAsRadicals(f,"maple");;
gap> GaloisGroupOnRoots(f);
Group([ (2,3), (1,2) ])
gap> SplittingField(f);
<algebraic extension over the Rationals of degree 6>
gap> STOP_TEST( "docexmpl.tst", 100000);   
