import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
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
    property string savePath: ""  // Добавьте эту строку


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

            Button {
                text: "Построить фрактал"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: canvas.requestPaint()
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
                text: "Сохранить как фото"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.FileSaveDialog", {
                        title: "Сохранить фрактал",
                        folder: StandardPaths.pictures,
                        name: "Mandelbrot_" + new Date().toISOString().replace(/[:.]/g, "-") + ".png"
                    })

                    dialog.accepted.connect(function() {
                        canvas.grabToImage(function(result) {
                            if (result.saveToFile(dialog.path)) {
                                pageStack.push(Qt.resolvedUrl("../Notification.qml"), {
                                    message: "Сохранено!"
                                })
                            } else {
                                pageStack.push(Qt.resolvedUrl("../Notification.qml"), {
                                    message: "Ошибка сохранения"
                                })
                            }
                        })
                    })
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
