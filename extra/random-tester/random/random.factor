USING: kernel math sequences namespaces hashtables words math.functions
arrays parser compiler syntax io random prettyprint optimizer layouts 
inference math.constants random-tester.utils ;
IN: random-tester

! Tweak me
: max-length 15 ; inline
: max-value 1000000000 ; inline

! varying bit-length random number
: random-bits ( n -- int )
    random 2 swap ^ random ;

: random-seq ( -- seq )
    { [ ] { } V{ } "" } random
    [ max-length random [ max-value random , ] times ] swap make ;

: random-string
    [ max-length random [ max-value random , ] times ] "" make ;

: special-integers ( -- seq ) \ special-integers get ;
[ { -1 0 1 } % most-negative-fixnum , most-positive-fixnum , first-bignum , ] 
{ } make \ special-integers set-global
: special-floats ( -- seq ) \ special-floats get ;
[ { 0.0 -0.0 } % e , pi , 1./0. , -1./0. , 0./0. , epsilon , epsilon neg , ]
{ } make \ special-floats set-global
: special-complexes ( -- seq ) \ special-complexes get ;
[ 
    { -1 0 1 } % -1 sqrt dup , neg ,
    e , e neg , pi , pi neg ,
    0 pi rect> , 0 pi neg rect> , pi neg 0 rect> , pi pi rect> ,
    pi pi neg rect> , pi neg pi rect> , pi neg pi neg rect> ,
    e neg e neg rect> , e e rect> ,
] { } make \ special-complexes set-global

: random-fixnum ( -- fixnum )
    most-positive-fixnum random 1+ coin-flip [ neg 1- ] when >fixnum ;

: random-bignum ( -- bignum )
     400 random-bits first-bignum + coin-flip [ neg ] when ;
    
: random-integer ( -- n )
    coin-flip [
        random-fixnum
    ] [
        coin-flip [ random-bignum ] [ special-integers random ] if
    ] if ;

: random-positive-integer ( -- int )
    random-integer dup 0 < [
            neg
        ] [
            dup 0 = [ 1 + ] when
    ] if ;

: random-ratio ( -- ratio )
    1000000000 dup [ random ] 2apply 1+ / coin-flip [ neg ] when dup [ drop random-ratio ] unless 10% [ drop 0 ] when ;

: random-float ( -- float )
    coin-flip [ random-ratio ] [ special-floats random ] if
    coin-flip 
    [ .0000000000000000001 /f ] [ coin-flip [ .00000000000000001 * ] when ] if
    >float ;

: random-number ( -- number )
    {
        [ random-integer ]
        [ random-ratio ]
        [ random-float ]
    } do-one ;

: random-complex ( -- C )
    random-number random-number rect> ;

