import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: basePage

    default property alias content: contentArea.children

    Item {
        id: contentArea
        anchors {
            fill: parent
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
            topMargin: Theme.paddingLarge
            bottomMargin: Theme.paddingLarge
        }
    }

    property string pageTitle: ""
    PageHeader {
        title: basePage.pageTitle
        visible: pageTitle !== ""
    }
}
