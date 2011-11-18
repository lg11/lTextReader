#ifndef MASKABLEITEM_H
#define MASKABLEITEM_H

#include <QDeclarativeItem>

class MaskableItemPrivate ;

class MaskableItem : public QDeclarativeItem {
    Q_OBJECT

public :
    explicit MaskableItem( QDeclarativeItem* parent = 0 ) ;
    ~MaskableItem() ;

public slots :
    void activeEffect() ;

private :
    Q_DISABLE_COPY( MaskableItem ) ;
    Q_DECLARE_PRIVATE( MaskableItem ) ;
    MaskableItemPrivate* d_ptr ;
} ;

#endif // MASKABLEITEM_H
