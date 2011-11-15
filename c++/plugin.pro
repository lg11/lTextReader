TEMPLATE = lib
TARGET = textview
QT += declarative
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = me.utils.textmodel

# Input
SOURCES += \
    plugin.cpp \
    textviewmodel.cpp \
    fileviewmodel.cpp

HEADERS += \
    plugin.h \
    textviewmodel.h \
    fileviewmodel.h

OTHER_FILES = 

OBJECTS_DIR = tmp
MOC_DIR = tmp

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qml/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = 

symbian {
    TARGET.EPOCALLOWDLLDATA = 1
} else:unix {
    installPath = /usr/lib/qt4/imports/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}
