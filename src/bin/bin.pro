TEMPLATE = app
QT += declarative
CONFIG += meegotouch
TARGET = "ltextreader"
DEPENDPATH += .
INCLUDEPATH += .

# Input
HEADERS += mainwindow.h
SOURCES += main.cpp mainwindow.cpp
#FORMS#

  unix {
    #VARIABLES
    isEmpty(PREFIX) {
        PREFIX = /usr
  }
BINDIR = $$PREFIX/bin
DATADIR =$$PREFIX/share

DEFINES += DATADIR=\\\"$$DATADIR\\\" PKGDATADIR=\\\"$$PKGDATADIR\\\"

#MAKE INSTALL

INSTALLS += target qmlgui desktop service iconxpm icon26 icon48 icon64

  target.path =$$BINDIR

  qmlgui.path = $$DATADIR/ltextreader
  qmlgui.files += \
  	../qml/DocumentView.qml \
  	../qml/DocumentViewPage.qml \
  	../qml/TextView.qml \
  	../qml/TextViewPage.qml \
  	../qml/TextViewSlider.qml \
  	../qml/main.qml \
  	../qml/qmldir \
  	../plugin/libltextreaderplugin.so \

  desktop.path = $$DATADIR/applications
  desktop.files += $${TARGET}.desktop

  service.path = $$DATADIR/dbus-1/services/
  service.files += com.meego.$${TARGET}.service

  iconxpm.path = $$DATADIR/pixmap
  iconxpm.files += ../../data/maemo/$${TARGET}.xpm

  icon26.path = $$DATADIR/icons/hicolor/26x26/apps
  icon26.files += ../../data/26x26/$${TARGET}.png

  icon48.path = $$DATADIR/icons/hicolor/48x48/apps
  icon48.files += ../../data/48x48/$${TARGET}.png

  icon64.path = $$DATADIR/icons/hicolor/64x64/apps
  icon64.files += ../../data/64x64/$${TARGET}.png
}
