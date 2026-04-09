import QtQuick
import Quickshell
import Quickshell.Io

FloatingWindow {
    id: root
    title: "qs-volume"
    objectName: "quickshellWidget"
    color: "transparent"
    visible: true

    implicitWidth: 480
    implicitHeight: volumePopup.implicitHeight

    VolumePopup {
        id: volumePopup
        anchors.fill: parent
    }

    Shortcut {
        sequence: "Escape"
        onActivated: Qt.quit()
    }
}
