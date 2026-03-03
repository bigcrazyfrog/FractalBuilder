import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: infoPage
    allowedOrientations: Orientation.Portrait

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: "О фрактале Мандельброта"
            }

            Label {
                width: parent.width - 2*Theme.horizontalPageMargin
                anchors.horizontalCenter: parent.horizontalCenter
                text: "<style>
                    body { color: " + Theme.primaryColor + "; font-family: " + Theme.fontFamily + "; }
                    h3 { color: " + Theme.highlightColor + "; font-size: large; margin-top: 16px; margin-bottom: 8px; }
                    b { color: " + Theme.highlightColor + "; }
                    i { color: " + Theme.secondaryColor + "; }
                </style>
                <body>
                    <h3>Что такое фрактал Мандельброта?</h3>
                    <p><b>Фрактал Мандельброта</b> — это множество точек на комплексной плоскости, для которого итеративная последовательность <i>z<sub>n+1</sub> = z<sub>n</sub><sup>2</sup> + c</i> остаётся ограниченной.</p>

                    <h3>Математическое определение</h3>
                    <p>Для каждого комплексного числа <i>c</i> строится последовательность:</p>
                    <p style='text-align: center;'><b>z<sub>0</sub> = 0</b><br>
                    <b>z<sub>n+1</sub> = z<sub>n</sub><sup>2</sup> + c</b></p>
                    <p>Если |z<sub>n</sub>| < 2 для всех n, то точка <i>c</i> принадлежит множеству Мандельброта.</p>

                    <p>Изображение, полученное таким способом, является лишь приближением к реальному множеству Мандельброта. Более качественные результаты можно получать, увеличивая максимальное количество итераций, однако при этом пропорционально вырастает и время расчётов.</p>
                </body>"

                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                linkColor: Theme.highlightColor
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }

            Button {
                text: "Построить фрактал"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pageStack.pop()
            }
        }
    }
}
