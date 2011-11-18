#ifndef MASKABLEITEM_H
#define MASKABLEITEM_H

#include <QDeclarativeItem>

class MaskableItemPrivate ;

class QPainter ;
class QPainterPath ;
class QStyleOptionGraphicsItem ;

class MaskableItem : public QDeclarativeItem {
    Q_OBJECT
    Q_PROPERTY( QDeclarativeItem* mask READ getMask WRITE setMask NOTIFY maskChanged )

signals :
    void maskChanged( QDeclarativeItem* mask ) ;

public :
    explicit MaskableItem( QDeclarativeItem* parent = 0 ) ;
    ~MaskableItem() ;

    QDeclarativeItem* getMask() const ;
    void setMask( QDeclarativeItem* mask ) ;

private :
    Q_DISABLE_COPY( MaskableItem ) ;
    Q_DECLARE_PRIVATE( MaskableItem ) ;
    MaskableItemPrivate* d_ptr ;
} ;

#endif // MASKABLEITEM_H
