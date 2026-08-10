gap> START_TEST("Test reuse of an already computed splitting field");

# The result must not depend on whether the splitting field of a polynomial
# has been computed before, see issue #8

# f = x^4 + 1; more than one root of f lies in the basis of the splitting field
gap> f := UnivariatePolynomial( Rationals, [1,0,0,0,1] );;
gap> GaloisGroupOnRoots( f );
Group([ (1,2)(3,4), (1,3)(2,4) ])
gap> f := UnivariatePolynomial( Rationals, [1,0,0,0,1] );;
gap> SplittingField( f );
<algebraic extension over the Rationals of degree 4>
gap> GaloisGroupOnRoots( f );
Group([ (1,2)(3,4), (1,3)(2,4) ])

# f = x^4 + x^3 + x^2 + x + 1; all roots are powers of one of them
gap> f := UnivariatePolynomial( Rationals, [1,1,1,1,1] );;
gap> GaloisGroupOnRoots( f );
Group([ (1,2)(3,4), (1,3,2,4) ])
gap> f := UnivariatePolynomial( Rationals, [1,1,1,1,1] );;
gap> SplittingField( f );
<algebraic extension over the Rationals of degree 4>
gap> GaloisGroupOnRoots( f );
Group([ (1,2)(3,4), (1,3,2,4) ])

# f = x^4 - 1; the rational root 1 lies in the basis of the splitting field
gap> f := UnivariatePolynomial( Rationals, [-1,0,0,0,1] );;
gap> GaloisGroupOnRoots( f );
Group([ (1,4) ])
gap> f := UnivariatePolynomial( Rationals, [-1,0,0,0,1] );;
gap> SplittingField( f );
<algebraic extension over the Rationals of degree 2>
gap> GaloisGroupOnRoots( f );
Group([ (1,4) ])

# the Galois group computed via 'RootsOfPolynomialAsRadicals' as well
gap> f := UnivariatePolynomial( Rationals, [-1,0,0,0,1] );;
gap> SplittingField( f );;
gap> RootsOfPolynomialAsRadicals( f, "off" );
gap> GaloisGroupOnRoots( f );
Group([ (1,4) ])

# f = (x - 2) * (x - 3); no root lies in the basis of the splitting field
gap> f := UnivariatePolynomial( Rationals, [6,-5,1] );;
gap> GaloisGroupOnRoots( f );
Group(())
gap> f := UnivariatePolynomial( Rationals, [6,-5,1] );;
gap> SplittingField( f );
Rationals
gap> GaloisGroupOnRoots( f );
Group(())

# the data describing the splitting field is reproduced exactly
gap> new := function( )
>        return rec( roots := [ ], degs := [ ], coeffs := [ ],
>                    K := FieldByMatrices([ [[ 1 ]] ]), H := Rationals );
>    end;;
gap> f := UnivariatePolynomial( Rationals, [-2,0,0,0,1] );;
gap> erw := RR_Zerfaellungskoerper( f, new( ) );;
gap> erw.degs;
[ 4, 2 ]
gap> new_erw := RR_Zerfaellungskoerper( f, new( ) );;
gap> [ new_erw.degs = erw.degs, new_erw.coeffs = erw.coeffs,
>      new_erw.roots = erw.roots, new_erw.H = erw.H,
>      IsIdenticalObj( new_erw.K, erw.K ) ];
[ true, true, true, true, true ]

# roots and Galois group refer to the same ordering of the roots, no matter
# whether the splitting field was known in advance
gap> f := UnivariatePolynomial( Rationals, [-2,0,0,0,1] );;
gap> roots := RootsAsMatrices( f );;
gap> galgrp := GaloisGroupOnRoots( f );;
gap> g := UnivariatePolynomial( Rationals, [-2,0,0,0,1] );;
gap> SplittingField( g );;
gap> RootsAsMatrices( g ) = roots;
true
gap> GaloisGroupOnRoots( g ) = galgrp;
true

#
gap> STOP_TEST( "splittingfield.tst", 100000);
