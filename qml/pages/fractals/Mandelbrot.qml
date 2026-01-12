import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: fractalPage
    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "Fractal"
            }

            Button {
                text: "Построить фрактал"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: canvas.requestPaint()
            }

            Canvas {
                id: canvas

                width: 800
                height: 600
                anchors.horizontalCenter: parent.horizontalCenter

                onPaint: {
                    console.log("Начало")
                    console.log("Размер:", width, height)

                    var ctx = canvas.getContext('2d')
                    ctx.clearRect(0, 0, width, height)

                    var maxIter = 50

                    for (var px = 0; px < width; px++) {
                        for (var py = 0; py < height; py++) {
                            var x0 = (px / width) * 3.5 - 2.5
                            var y0 = (py / height) * 2.0 - 1.0

                            var x = 0
                            var y = 0
                            var iter = 0

                            while (x*x + y*y <= 4 && iter < maxIter) {
                                var xtemp = x*x - y*y + x0
                                y = 2*x*y + y0
                                x = xtemp
                                iter++
                            }

                            if (iter === maxIter) {
                                ctx.fillStyle = "black"
                            } else {
                                var brightness = Math.floor(255 * iter / maxIter)
                                ctx.fillStyle = "rgb(" + brightness + ", " + brightness + ", " + brightness + ")"
                            }

                            ctx.fillRect(px, py, 1, 1)
                        }
                    }

                    console.log("Отрисовка завершена")
                }
            }
        }
    }
}
