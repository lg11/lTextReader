#include "maskeffect.h"

#include <QDeclarativeItem>
#include <QPainter>
#include <QScopedPointer>
#include <QPixmap>

//#include <QDebug>

class MaskEffectPrivate {
public :
    QPixmap buffer ;
    QScopedPointer<QDeclarativeItem> mask ;
    MaskEffectPrivate() : mask( 0 ) {}
} ;

MaskEffect::MaskEffect( QObject* parent ) :
    QGraphicsEffect( parent ) ,
    d_ptr( new MaskEffectPrivate )
{
}

MaskEffect::~MaskEffect() {
    delete this->d_ptr ;
}

void MaskEffect::setMask( QDeclarativeItem* mask ) {
    Q_D( MaskEffect ) ;
    
    if ( !d->mask.isNull() ) {
        disconnect( d->mask.data(), SIGNAL(widthChanged()), this, SLOT(update()) ) ;
        disconnect( d->mask.data(), SIGNAL(heightChanged()), this, SLOT(update()) ) ;
    }

    d->mask.reset( mask ) ;
    this->update() ;
    
    if ( !d->mask.isNull() ) {
        connect( d->mask.data(), SIGNAL(widthChanged()), this, SLOT(update()) ) ;
        connect( d->mask.data(), SIGNAL(heightChanged()), this, SLOT(update()) ) ;
    }

}

void MaskEffect::draw( QPainter* painter ) {
    Q_D( MaskEffect ) ;

    if ( d->mask.isNull() ) {
        this->drawSource( painter ) ;
        return ;
    }

    QPoint offset ;
    const QPixmap &pixmap = this->sourcePixmap( Qt::LogicalCoordinates, &offset, QGraphicsEffect::NoPad ) ;

    if ( pixmap.isNull() )
        return ;

    if ( pixmap.size() != d->buffer.size() )
        d->buffer = pixmap ;
    //qDebug() << "mask" << d->mask->x() << d->mask->y() << d->mask->width() << d->mask->height() << pixmap.size() << d->buffer.size() ;

    QPainter p( &d->buffer ) ;

    p.setCompositionMode( QPainter::CompositionMode_Source ) ;
    p.fillRect( 0, 0, d->buffer.width(), d->buffer.height(), Qt::transparent ) ;
    p.fillRect( d->mask->x(), d->mask->y(), d->mask->width(), d->mask->height(), Qt::white ) ;
    //d->mask->paint( &p, 0, 0 ) ;

    p.setCompositionMode( QPainter::CompositionMode_SourceIn ) ;
    p.drawPixmap( 0, 0, pixmap ) ;

    //painter->drawPixmap( offset, d->buffer ) ;
    painter->drawPixmap( offset, d->buffer ) ;
}

