#ifndef PLUGIN_H
#define PLUGIN_H

#include <QtDeclarative/QDeclarativeExtensionPlugin>

class Plugin : public QDeclarativeExtensionPlugin
{
    Q_OBJECT
public:
    void registerTypes(const char *uri);
};

#endif // PLUGIN_H

