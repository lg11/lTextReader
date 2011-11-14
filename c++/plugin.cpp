#include "plugin.h"
#include "model.h"

#include <QtDeclarative/qdeclarative.h>

void Plugin::registerTypes( const char *uri ) {
    qmlRegisterType<TextViewModel>(uri, 1, 0, "TextViewModel");
}

Q_EXPORT_PLUGIN2( plugin, Plugin )

