! Copyright (C) 2008 Doug Coleman.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors combinators io.files.types kernel math.parser
sequences splitting ;
IN: ftp.client.listing-parser

: ch>file-type ( ch -- type )
    {
        { char: b [ +block-device+ ] }
        { char: c [ +character-device+ ] }
        { char: d [ +directory+ ] }
        { char: l [ +symbolic-link+ ] }
        { char: s [ +socket+ ] }
        { char: p [ +fifo+ ] }
        { char: - [ +regular-file+ ] }
        [ drop +unknown+ ]
    } case ;

: file-type>ch ( type -- string )
    {
        { +block-device+ [ char: b ] }
        { +character-device+ [ char: c ] }
        { +directory+ [ char: d ] }
        { +symbolic-link+ [ char: l ] }
        { +socket+ [ char: s ] }
        { +fifo+ [ char: p ] }
        { +regular-file+ [ char: - ] }
        [ drop char: - ]
    } case ;

: parse-permissions ( remote-file str -- remote-file )
    [ first ch>file-type >>type ] [ rest >>permissions ] bi ;

TUPLE: remote-file
type permissions links owner group size month day time year
name target ;

: <remote-file> ( -- remote-file ) remote-file new ;

: parse-list-11 ( lines -- seq )
    [
        11 f pad-tail
        <remote-file> swap {
            [ 0 swap nth parse-permissions ]
            [ 1 swap nth string>number >>links ]
            [ 2 swap nth >>owner ]
            [ 3 swap nth >>group ]
            [ 4 swap nth string>number >>size ]
            [ 5 swap nth >>month ]
            [ 6 swap nth >>day ]
            [ 7 swap nth >>time ]
            [ 8 swap nth >>name ]
            [ 10 swap nth >>target ]
        } cleave
    ] map ;

: parse-list-8 ( lines -- seq )
    [
        <remote-file> swap {
            [ 0 swap nth parse-permissions ]
            [ 1 swap nth string>number >>links ]
            [ 2 swap nth >>owner ]
            [ 3 swap nth >>size ]
            [ 4 swap nth >>month ]
            [ 5 swap nth >>day ]
            [ 6 swap nth >>time ]
            [ 7 swap nth >>name ]
        } cleave
    ] map ;

: parse-list-3 ( lines -- seq )
    [
        <remote-file> swap {
            [ 0 swap nth parse-permissions ]
            [ 1 swap nth string>number >>links ]
            [ 2 swap nth >>name ]
        } cleave
    ] map ;

: parse-list ( ftp-response -- ftp-response )
    dup strings>>
    [ " " split harvest ] map
    dup length {
        { 11 [ parse-list-11 ] }
        { 9 [ parse-list-11 ] }
        { 8 [ parse-list-8 ] }
        { 3 [ parse-list-3 ] }
        [ drop ]
    } case >>parsed ;
