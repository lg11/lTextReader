#include "plugin.h"
#include "textviewmodel.h"
#include "fileviewmodel.h"

#include <QtDeclarative/qdeclarative.h>

void Plugin::registerTypes( const char *uri ) {
    qmlRegisterType<TextViewModel>(uri, 1, 0, "TextViewModel");
    qmlRegisterType<FileViewModel>(uri, 1, 0, "FileViewModel");
}

Q_EXPORT_PLUGIN2( plugin, Plugin )

