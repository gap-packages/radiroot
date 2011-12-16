#############################################################################
####
##
#W  Radicals.gi               RADIROOT package                Andreas Distler
##
##  Installation file for the main function of the RADIROOT package
##
#H  @(#)$Id: Radicals.gi,v 1.0 2004/08/21 14:38:01 gap Exp $
##
#Y  2004
##


#############################################################################
##
#F  RR_RootOfUnity( <erw>, <ord> )
##
##  Computes a <ord>-th root of unity built up on the roots of unity
##  that already exists in the field of the record <erw>
##
InstallGlobalFunction( RR_RootOfUnity, function( erw, ord )
    local i, unity, cond, faktor, m;

    unity := One( erw.K );
    cond := 1;
    m := 1;
    for i in DuplicateFreeList( Factors( ord ) ) do
        # first factor of the i-th cyclotomic polynomial in H
        faktor := FactorsPolynomialKant( CyclotomicPolynomial( Rationals, i ),
                                         erw.H )[ 1 ];
        Info( InfoRadiroot, 3,"        Cyclotomic polynomial factor: ",
                              faktor );

        if Degree( faktor ) = i-1 then
	    cond := cond * i; #unity := unity * E( i );
            Info( InfoRadiroot, 4, "            Adjoining ", i,
                                   "-th root of unity" );
	elif Degree( faktor ) = 1 then
            erw.B := Basis( erw.K, RR_CanonicalBasis( PrimitiveElement(erw.K),
                                              DegreeOverPrimeField(erw.K)));
	    unity := unity * LinearCombination( erw.B, 
                                        ExtRepOfObj( -Value( faktor, 0 ) ));
            Info( InfoRadiroot, 4, "            Calculate ", i,
                                   "-th root of unity" );
        else
            m := i * m; 
	fi;
    od;

    if  m = 1 then
        return E( cond ) * unity;
    else
        return m * Order( unity );
    fi;
end );


#############################################################################
##
#M  IsSolvablePolynomial( <f> )
#M  IsSolvable( <f> )
##
##  Determines wether the polynomial <f> is solvable, e. g. wether its
##  Galois-group is solvable
##
InstallMethod( IsSolvablePolynomial, "rational polynomials", 
[ IsUnivariatePolynomial ],
function( f )

    if ForAny( CoefficientsOfUnivariatePolynomial(f),
               c -> not c in Rationals ) then TryNextMethod( ); fi;

    return ForAll( Filtered( List( Factors(f), RR_SimplifiedPolynomial ),
                             ff -> Degree(ff) <> 1 ),
                   ff -> IsSolvableGroup( TransitiveGroup( Degree(ff),
                                          GaloisType(ff) ) ) );
end );

InstallMethod( IsSolvable, "rational polynomials", [ IsPolynomial ],
               IsSolvablePolynomial );

#############################################################################
##
#F  RootsOfPolynomialAsRadicals( <f> )
##
##  For the irreducible, rational polynomial <f> a representation of the
##  roots as radicals is computed if this is possible, e. g. if the
##  Galoisgroup of <f> is solvable. The function stores the result as a
##  Tex-readable string in a file.
##
InstallGlobalFunction( RootsOfPolynomialAsRadicals, function( f )

    # irreducibility test
    if not IsIrreducible( f ) then
        Error( "f must be irreducible" );
    fi;

    # solvibility test
    if not IsSolvable( f ) then
        Info( InfoRadiroot, 1, "Polynomial is not solvable." );
        Info( InfoRadiroot, 3, "        GaloisType is ", GaloisType( f ) );
        return fail;
    fi; 
    
    Info( InfoRadiroot, 3, "        GaloisType is ", GaloisType( f ) );
    Info( InfoRadiroot, 1, "Galoisgroup is ",
                           TransitiveGroup( Degree( f ), GaloisType( f ) ) );

    return RootsOfPolynomialAsRadicalsNC( f, true );
end );

#############################################################################
##
#F  RR_Roots( <roots>, <erw> )
##
##  The elements in the list <roots> are in various forms. They are transfered
##  in a matrix representation and returned as one duplicate free list.
##
InstallGlobalFunction( RR_Roots, function( roots, erw )
    local i, root;    

    # Test whether there are already enough roots as matrices
    if Length(roots[1]) + Length(roots[2]) >= Length(roots[3])
    then
        return roots[2];
    fi;

    erw.B := Basis( erw.K, RR_CanonicalBasis( PrimitiveElement(erw.K),
                                              DegreeOverPrimeField(erw.K)));

    # kick out known symbolic roots
    for root in Concatenation(roots[1], roots[2]) do
        root := LinearCombination( Basis( erw.H ),
                                   Coefficients( erw.B, root ) );
        roots[3] := Difference( roots[3], [ root ] );
    od;

    # compute the other roots
    if roots[1] = [ ] then Unbind(roots[3][Length(roots[3])]); fi; 
    for root in roots[3] do
        Info(InfoRadiroot,3,"        Constructing ",Length(roots[2]),". root");
        Add( roots[2], LinearCombination( erw.B, ExtRepOfObj( root )));
    od;
 
    return roots[2];
end );


#############################################################################
##
#F  RR_SimplifiedPolynomial( <f> )
##
##  return the polynomial g(x) with g(x^n) = f(x-a) with greatest possible n
##  for the polynomial <f>
##
InstallGlobalFunction( RR_SimplifiedPolynomial, function( f )
    local deg, coeff, gcd, poly;

    deg := Degree( f );

    poly := f / LeadingCoefficient( f );
    poly := Value( poly, UnivariatePolynomial( Rationals,
        [-CoefficientsOfUnivariatePolynomial(poly)[deg] / deg, 1] ) );
    coeff := CoefficientsOfUnivariatePolynomial( poly );
    gcd := Gcd(Filtered( [0..Degree(f)], i -> not coeff[i+1] = 0));
    if gcd = 1 then
        return f / LeadingCoefficient(f);
    fi;

    return UnivariatePolynomial(Rationals,
                                List([0..deg/gcd], i -> coeff[i*gcd+1]));
end );


#############################################################################
##
#F  RootsOfPolynomialAsRadicalsNC( <f>, <display> )
##
##  For the irreducible, rational polynomial <f> a representation
##  of the roots as radicals is computed if this is possible, e. g. if
##  the Galois-group of <f> is solvable. The function stores the
##  result as a Tex-readable string in a file and diplays it if the boolean
##  <display> is 'true'
##
InstallGlobalFunction( RootsOfPolynomialAsRadicalsNC, function( f, display )
    local erw,elements,lcm,conj,bas,file,tmpdir,poly,B,fix,compser;

    # normed, simplified polynomial
    poly := RR_SimplifiedPolynomial( f );
    Info( InfoRadiroot, 2, "    Normed, simplified Polynomial: ", poly );
   
    Info( InfoRadiroot, 1, "Construction of the splitting field" );
    erw := RR_Zerfaellungskoerper( poly, rec( roots := [ ],
                                              degs := [ ],
                                              coeffs := [ ],
                                              K:=FieldByMatrices([ [[ 1 ]] ]),
                                              H:=Rationals ));;

    erw.unity := RR_RootOfUnity( erw, DegreeOverPrimeField(erw.K) );
    if IsInt(erw.unity) then 
        erw := RR_SplittField(poly, erw.unity );
    fi;

    # get all roots, set a basis of the primitive element
    erw.roots := RR_Roots( [ [], erw.roots[1], erw.roots[2] ], erw );;
    Add( erw.roots, 
         -CoefficientsOfUnivariatePolynomial(poly)[Degree(poly)]*One(erw.K)
         -Sum( erw.roots ) );

    Info( InfoRadiroot, 1, "Construction of the Galoisgroup" );
    erw.coeffs := Filtered(Coefficients(Basis(erw.K),PrimitiveElement(erw.K)),
                           i -> i <> 0 ); 
    erw.galgrp := RR_ConstructGaloisGroup( erw );
    Info( InfoRadiroot, 1, "Galoisgroup as PermGrp is ", erw.galgrp );
    if not IsSolvable( erw.galgrp ) then
        Info( InfoRadiroot, 1, "Polynomial is not solvable." );
        return fail;
    fi; 

    Info( InfoRadiroot, 3, "        h := Lcm( Order( Galoisgroup ) ) = ",
                           Product(Unique(Factors(Order(erw.galgrp)))) );
    if IsDiagonalMat( erw.unity ) then
        Info( InfoRadiroot, 2, "    no root of unity in the splitting field"); 
        compser := CompositionSeries( erw.galgrp );
    elif Length( erw.degs ) <> Length( erw.coeffs ) then
        compser := CompositionSeries( erw.galgrp );
    else
        fix := Filtered(AsList(erw.galgrp), 
                        p -> RR_Produkt(erw, erw.unity, p) = erw.unity);
        compser := RR_CompositionSeries( erw.galgrp, AsGroup( fix ));
    fi; 
    erw.K!.cyclics := RR_CyclicElements( erw, compser );;
    Info( InfoRadiroot, 1, "computed cyclic elements" );

    tmpdir := DirectoryTemporary( );
    file := RR_TexFile( f, erw, erw.K!.cyclics, tmpdir );
    if display then RR_Display( file, tmpdir ); fi;

    # prepare the output
    erw.galgrp!.roots := erw.roots; Unbind( erw.roots );
    erw.K!.unity := erw.unity; Unbind( erw.unity );
    Unbind( erw.degs ); Unbind( erw.coeffs ); Unbind( erw.B );

    return erw;
end );


#############################################################################
##
#E









