import QtQuick
import Quickshell
import Quickshell.Io

FloatingWindow {
    id: root
    title: "qs-network"
    objectName: "quickshellWidget"
    color: "transparent"
    visible: true

    implicitWidth: 900
    implicitHeight: 700

    NetworkPopup {
        anchors.fill: parent
    }

    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }
}
