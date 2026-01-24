import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import QtQuick.Layouts 1.1
import "js/mandelbrot.js" as Mandelbrot

Page {
    id: fractalPage
    allowedOrientations: Orientation.All

    property int maxIter: 50
    property string colorScheme: "Черно-белая"
    property real centerX: -0.5
    property real centerY: 0
    property real zoom: 1.0
    property int renderTime: 0
    property bool autoUpdate: true
    property string savePath: ""


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "Mandelbrot Fractal"
            }

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 2*Theme.horizontalPageMargin
                spacing: Theme.paddingMedium

                Button {
                    text: "-"
                    Layout.preferredWidth: Theme.itemSizeSmall
                    onClicked: {
                        zoom = Math.max(0.2, zoom / 1.3)
                        zoomField.text = zoom.toFixed(2)

                        if (autoUpdate) canvas.requestPaint()
                    }
                }

                Button {
                    text: "Построить фрактал"
                    Layout.fillWidth: true
                    onClicked: canvas.requestPaint()
                }

                Button {
                    text: "+"
                    Layout.preferredWidth: Theme.itemSizeSmall
                    onClicked: {
                        zoom = zoom * 1.3
                        zoomField.text = zoom.toFixed(2)
                        if (autoUpdate) canvas.requestPaint()
                    }
                }
            }

            Canvas {
                id: canvas

                width: parent.width - 2*Theme.horizontalPageMargin
                height: width * 0.75
                anchors.horizontalCenter: parent.horizontalCenter

                PinchArea {
                    anchors.fill: parent
                    onPinchUpdated: {
                        zoom = Math.min(10, Math.max(0.5, zoom * pinch.scale))
                        zoomField.text = zoom.toFixed(2)
                        if (autoUpdate) canvas.requestPaint()
                    }
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    drag.target: dragProxy
                    drag.minimumX: 0
                    drag.maximumX: parent.width
                    drag.minimumY: 0
                    drag.maximumY: parent.height

                    Item { id: dragProxy }

                    onPressed: {
                        dragProxy.x = mouse.x
                        dragProxy.y = mouse.y
                    }

                    onPositionChanged: {
                        if (drag.active) {
                            var dx = dragProxy.x - mouse.x
                            var dy = dragProxy.y - mouse.y

                            var planeWidth = 3.5 / zoom
                            var planeHeight = 2.0 / zoom

                            var dxPlane = (dx / width) * planeWidth
                            var dyPlane = (dy / height) * planeHeight

                            centerX += dxPlane
                            centerY += dyPlane

                            xCenterField.text = centerX.toFixed(4)
                            yCenterField.text = centerY.toFixed(4)

                            dragProxy.x = mouse.x
                            dragProxy.y = mouse.y

                            if (autoUpdate) canvas.requestPaint()
                        }
                    }
                }

                onPaint: {
                    var startTime = new Date().getTime()
                    Mandelbrot.drawMandelbrot(canvas, width, height, maxIter,
                                             colorScheme, centerX, centerY, zoom)
                    renderTime = new Date().getTime() - startTime
                }
            }

            Label {
                text: "Время рендера: " + renderTime + " мс"
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
            }

            Slider {
                id: depthSlider
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Число итераций"
                minimumValue: 10
                maximumValue: 500
                value: maxIter
                stepSize: 10
                valueText: value
                onValueChanged: {
                    maxIter = value
                    if (autoUpdate) canvas.requestPaint()
                }
            }

            ComboBox {
                id: colorSchemeCombo
                label: "Тема"
                currentIndex: 0
                menu: ContextMenu {
                    MenuItem { text: "Черно-белая" }
                    MenuItem { text: "Огонь" }
                    MenuItem { text: "Океан" }
                }
                onCurrentIndexChanged: {
                    colorScheme = colorSchemeCombo.currentItem.text
                    if (autoUpdate) canvas.requestPaint()
                }
            }

            TextField {
                id: xCenterField
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Центр X"
                text: centerX
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.onClicked: {
                    centerX = parseFloat(text)
                    if (autoUpdate) canvas.requestPaint()
                }
                onTextChanged: {
                    if (focus === false) {
                        centerX = parseFloat(text)
                        if (autoUpdate) canvas.requestPaint()
                    }
                }
            }

            TextField {
                id: yCenterField
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Центр Y"
                text: centerY
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.onClicked: {
                    centerY = parseFloat(text)
                    if (autoUpdate) canvas.requestPaint()
                }
                onTextChanged: {
                    if (focus === false) {
                        centerY = parseFloat(text)
                        if (autoUpdate) canvas.requestPaint()
                    }
                }
            }

            TextField {
                id: zoomField
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                label: "Масштаб"
                text: zoom
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                EnterKey.onClicked: {
                    zoom = parseFloat(text)
                    if (autoUpdate) canvas.requestPaint()
                }
                onTextChanged: {
                    if (focus === false) {
                        zoom = parseFloat(text)
                        if (autoUpdate) canvas.requestPaint()
                    }
                }
            }

            Button {
                text: "Сбросить настройки"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    maxIter = 50
                    depthSlider.value = 50
                    colorScheme = "Черно-белая"
                    colorSchemeCombo.currentIndex = 0
                    centerX = -0.5
                    centerY = 0
                    zoom = 1.0
                    xCenterField.text = "-0.5"
                    yCenterField.text = "0"
                    zoomField.text = "1.0"
                    if (autoUpdate) canvas.requestPaint()
                }
            }

            Button {
                text: "Случайный фрактал"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    centerX = (Math.random() * 2 - 1.5).toFixed(2)
                    centerY = (Math.random() * 1.5 - 0.75).toFixed(2)
                    zoom = (Math.random() * 3 + 0.5).toFixed(2)
                    xCenterField.text = centerX
                    yCenterField.text = centerY
                    zoomField.text = zoom
                    if (autoUpdate) canvas.requestPaint()
                }
            }

            ComboBox {
                id: aspectCombo
                label: "Соотношение сторон"
                currentIndex: 0
                menu: ContextMenu {
                    MenuItem { text: "4:3" }
                    MenuItem { text: "16:9" }
                    MenuItem { text: "1:1" }
                }
                onCurrentIndexChanged: {
                    var ratios = [0.75, 0.5625, 1.0]
                    canvas.height = canvas.width * ratios[currentIndex]
                }
            }

            TextSwitch {
                id: autoUpdateSwitch
                text: "Автообновление"
                checked: true
                onCheckedChanged: {
                    autoUpdate = checked
                    if (autoUpdate) canvas.requestPaint()
                }
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

            Component {
                id: folderPickerDialog
                FolderPickerDialog {
                    onAccepted: {
                        savePath = selectedPath

                        var filename = "Mandelbrot_" + new Date().toISOString().replace(/[:.]/g, "-") + ".png"
                        var fullPath = savePath + "/" + filename

                        console.log("Сохраняем в:", fullPath)

                        canvas.grabToImage(function(result) {
                            if (result.saveToFile(fullPath)) {
                                console.log("Успешно сохранено:", fullPath)
                            } else {
                                console.log("Ошибка сохранения в:", fullPath)
                            }
                        })
                    }
                }
            }

            Button {
                text: "Сохранить как фото"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pageStack.push(folderPickerDialog)
                }
            }
        }
    }
}
