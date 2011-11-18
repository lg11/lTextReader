#include "maskableitem.h"
#include "maskeffect.h"

class MaskableItemPrivate {
public :
    MaskEffect* effect ;
    MaskableItemPrivate() : effect( new MaskEffect ) {}
    ~MaskableItemPrivate() { delete this->effect ; }
} ;

MaskableItem::MaskableItem( QDeclarativeItem* parent ) : \
        QDeclarativeItem( parent ), \
        d_ptr( new MaskableItemPrivate )
{
    this->setFlag( QGraphicsItem::ItemHasNoContents, false) ;
    this->setFlag( QGraphicsItem::ItemClipsChildrenToShape ) ;
    
    Q_D( MaskableItem ) ;
    this->setGraphicsEffect( d->effect ) ;
    d->effect->setTarget( this ) ;
}

MaskableItem::~MaskableItem() {
    delete this->d_ptr ;
}

void MaskableItem::activeEffect() {
    Q_D( MaskableItem ) ;
    d->effect->setTarget( this ) ;
}

