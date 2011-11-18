#include "maskableitem.h"
#include "maskeffect.h"

class MaskableItemPrivate {
public :
    QDeclarativeItem* mask ;
    MaskEffect* effect ;
    MaskableItemPrivate() : 
        mask( 0 ) ,
        effect( new MaskEffect )
    {
    }
    ~MaskableItemPrivate() {
    }
} ;

MaskableItem::MaskableItem( QDeclarativeItem* parent ) : \
        QDeclarativeItem( parent ), \
        d_ptr( new MaskableItemPrivate )
{
    this->setFlag( QGraphicsItem::ItemHasNoContents, false) ;
    this->setFlag( QGraphicsItem::ItemClipsChildrenToShape ) ;
    
    Q_D( MaskableItem ) ;
    this->setGraphicsEffect( d->effect ) ;
}

MaskableItem::~MaskableItem() {
    delete this->d_ptr ;
}

QDeclarativeItem* MaskableItem::getMask() const {
    Q_D( const MaskableItem ) ;
    return d->mask ;
}

void MaskableItem::setMask( QDeclarativeItem* mask ) {
    Q_D( MaskableItem ) ;
    if ( d->mask != mask ) {
        d->mask = mask ;
        emit this->maskChanged( d->mask ) ;
        if ( d->mask )
            d->effect->setMask( d->mask ) ;
        else
            d->effect->setMask( 0 ) ;
    }
}

