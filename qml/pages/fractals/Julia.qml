import QtQuick 2.2
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
ApplicationWindow {
 initialPage: Component {
 Page {
 id: page
 property string directoryPath
 SilicaFlickable {
 contentHeight: column.height + Theme.paddingLarge*2
 anchors.fill: parent
 VerticalScrollDecorator {}
 Column {
 id: column
 width: parent.width
 PageHeader {
 title: "Пример выбора каталога"
 }
 ValueButton {
 anchors.horizontalCenter: parent.horizontalCenter
 label: "Каталог"
 value: directoryPath ? directoryPath : "None"
 onClicked: pageStack.push(folderPickerDialog)
 }
 }
 }
 Component {
 id: folderPickerDialog
 FolderPickerDialog {
 title: "Скачать в"
 onAccepted: directoryPath = selectedPath
 onRejected: directoryPath = ""
 }
 }
 }
 }
}
