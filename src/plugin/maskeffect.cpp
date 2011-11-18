#include "maskeffect.h"

#include <QDeclarativeItem>
#include <QPainter>
#include <QWeakPointer>
#include <QPixmap>

//#include <QDebug>

class MaskEffectPrivate {
public :
    QPixmap buffer ;
    QWeakPointer<QDeclarativeItem> target ;
    int propertyIndex[2] ;
    MaskEffectPrivate() {}
} ;

MaskEffect::MaskEffect( QObject* parent ) :
    QGraphicsEffect( parent ) ,
    d_ptr( new MaskEffectPrivate )
{
}

MaskEffect::~MaskEffect() {
    delete this->d_ptr ;
}

void MaskEffect::setTarget( QDeclarativeItem* target ) {
    Q_D( MaskEffect ) ;
    if ( !d->target.isNull() ) {
        disconnect( d->target.data(), SIGNAL(maskTopChanged()), this, SLOT(update()) ) ;
        disconnect( d->target.data(), SIGNAL(maskBottomChanged()), this, SLOT(update()) ) ;
    }

    d->target.clear() ;
    this->update() ;

    const QMetaObject* metaObject = target->metaObject() ;

    d->propertyIndex[0] = metaObject->indexOfProperty( "maskTop" ) ;
    if ( d->propertyIndex[0] > -1 ) {
        d->propertyIndex[1] = metaObject->indexOfProperty( "maskBottom" ) ;
        if ( d->propertyIndex[0] > -1 )  {
            d->target = target ;
            connect( d->target.data(), SIGNAL(maskTopChanged()), this, SLOT(update()) ) ;
            connect( d->target.data(), SIGNAL(maskBottomChanged()), this, SLOT(update()) ) ;
        }
    }
}

void MaskEffect::draw( QPainter* painter ) {
    Q_D( MaskEffect ) ;

    if ( d->target.isNull() ) {
        this->drawSource( painter ) ;
        return ;
    }

    const QMetaObject* metaObject = d->target.data()->metaObject() ;
    qreal maskTop = metaObject->property( d->propertyIndex[0] ).read( d->target.data() ).toReal() ;
    qreal maskBottom = metaObject->property( d->propertyIndex[1]).read( d->target.data() ).toReal() ;

    //qDebug() << maskTop << maskBottom ;

    QPoint offset ;
    const QPixmap &pixmap = this->sourcePixmap( Qt::LogicalCoordinates, &offset, QGraphicsEffect::NoPad ) ;

    if ( pixmap.isNull() )
        return ;

    if ( pixmap.size() != d->buffer.size() )
        d->buffer = pixmap ;

    QPainter p( &d->buffer ) ;

    p.setCompositionMode( QPainter::CompositionMode_Source ) ;
    p.fillRect( 0, 0, d->buffer.width(), d->buffer.height(), Qt::transparent ) ;
    p.fillRect( 0, maskTop, d->buffer.width(), maskBottom - maskTop, Qt::white ) ;
    //d->mask->paint( &p, 0, 0 ) ;

    p.setCompositionMode( QPainter::CompositionMode_SourceIn ) ;
    p.drawPixmap( 0, 0, pixmap ) ;

    //painter->drawPixmap( offset, d->buffer ) ;
    painter->drawPixmap( offset, d->buffer ) ;
}

