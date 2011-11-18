#include "plugin.h"
#include "textviewmodel.h"
#include "maskableitem.h"
//#include "mdeclarativemaskeditem.h"

#include <QtDeclarative/qdeclarative.h>

void Plugin::registerTypes( const char *uri ) {
    qmlRegisterType<TextViewModel>( uri, 1, 0, "TextViewModel" ) ;
    qmlRegisterType<MaskableItem>( uri, 1, 0, "MaskableItem" ) ;
    //qmlRegisterType<MDeclarativeMaskedItem>( uri, 1, 0, "MaskedItem" ) ;
}

Q_EXPORT_PLUGIN2( plugin, Plugin )

