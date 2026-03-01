TARGET = ru.fractals.FractalsBuilder

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    qml/pages/BasePage.qml \
    qml/pages/Mandelbrot.qml \
    qml/pages/fractals/Julia.qml \
    qml/pages/fractals/js/db.js \
    rpm/ru.fractals.FractalsBuilder.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.fractals.FractalsBuilder.ts \
    translations/ru.fractals.FractalsBuilder-ru.ts \
