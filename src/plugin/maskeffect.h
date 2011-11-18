#ifndef MASKEFFECT_H
#define MASKEFFECT_H

#include <QGraphicsEffect>

class MaskEffectPrivate ;

class QDeclarativeItem ;
class QPainter ;

class MaskEffect : public QGraphicsEffect {
    Q_OBJECT
public :
    explicit MaskEffect( QObject* parent = 0 ) ;
    ~MaskEffect() ;
    void setMask( QDeclarativeItem* mask ) ;
protected :
    void draw( QPainter* painter ) ;
private :
    Q_DISABLE_COPY( MaskEffect ) ;
    Q_DECLARE_PRIVATE( MaskEffect ) ;
    MaskEffectPrivate* d_ptr ;
} ;

#endif // MASKEFFECT_H
