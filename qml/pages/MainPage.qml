import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                objectName: "pageHeader"
                title: qsTr("FractalsBuilder")
                extraContent.children: [
                    IconButton {
                        objectName: "aboutButton"
                        icon.source: "image://theme/icon-m-about"
                        anchors.verticalCenter: parent.verticalCenter

                        onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
//                        onClicked: pageStack.push(Qt.resolvedUrl("fractals/Mandelbrot.qml"))
                    }
                ]
            }

            Button {
                text: "Фрактал Мандельброта"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.push(Qt.resolvedUrl("fractals/Mandelbrot.qml"))
            }

            SectionHeader {
                text: "Выберите фрактал"
            }

            // Кнопки меню
            BackgroundItem {
                id: mandelbrotItem
                width: parent.width
                height: Theme.itemSizeLarge
                onClicked: pageStack.push(Qt.resolvedUrl("fractals/Mandelbrot.qml"))

                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Фрактал Мандельброта"
                    color: mandelbrotItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                }
            }

            BackgroundItem {
                id: juliaItem
                width: parent.width
                height: Theme.itemSizeLarge
                onClicked: pageStack.push(Qt.resolvedUrl("fractals/Julia.qml"))

                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Фрактал Жулиа"
                    color: juliaItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                }
            }

            BackgroundItem {
                id: sierpinskiItem
                width: parent.width
                height: Theme.itemSizeLarge
                onClicked: pageStack.push(Qt.resolvedUrl("fractals/Sierpinski.qml"))

                Label {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                    text: "Треугольник Серпинского"
                    color: sierpinskiItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                }
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
        }
    }
}
