#ifndef ICU_UCSD_H
#define ICU_UCSD_H

#include <unicode/ucsdet.h> 
#include <QString>

QString detectCodec( char* buffer, int length ) {
    UErrorCode status = U_ZERO_ERROR ;
    UCharsetDetector* ucsd ;
    const UCharsetMatch* ucsm ;

    ucsd = ucsdet_open( &status ) ;

    ucsdet_setText( ucsd, buffer, length, &status ) ;
    ucsm = ucsdet_detect( ucsd, &status ) ;

    const char* name = ucsdet_getName( ucsm, &status ) ;

    QString str( name ) ;

    ucsdet_close( ucsd )  ;
    
    return str ;
}

#endif // ICU_UCSD_H
