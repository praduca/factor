! Copyright (C) 2011 John Benediktsson
! See https://factorcode.org/license.txt for BSD license

USING: accessors ascii assocs checksums checksums.md5
classes.tuple formatting http.client images.http json kernel
math.parser sequences strings ;

IN: gravatar

TUPLE: info aboutMe accounts currentLocation displayName emails
hash id ims name phoneNumbers photos preferredUsername
profileBackground profileUrl requestHash thumbnailUrl urls ;

: gravatar-id ( email -- gravatar-id )
    [ blank? ] trim >lower md5 checksum-bytes bytes>hex-string ;

: gravatar-info ( gravatar-id -- info )
    "https://gravatar.com/%s.json" sprintf http-get nip
    >string json> "entry" of first info from-slots ;

: gravatar. ( gravatar-id -- )
    gravatar-info thumbnailUrl>> http-image. ;
