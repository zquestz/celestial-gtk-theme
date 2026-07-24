import QtQuick 2.15

Rectangle {
    id: root
    color: "#141a1b"

    property int stage

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true;
        }
    }

    Column {
        id: content
        anchors.centerIn: parent
        spacing: 36
        opacity: 0

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Celestial"
            color: "#c6cdcb"
            font.pixelSize: 44
            font.weight: Font.Light
            font.letterSpacing: 8
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 2
            color: "#414747"
            height: 4
            width: 220

            Rectangle {
                radius: 2
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                width: (parent.width / 6) * (root.stage - 1)
                color: "#2eb398"
                Behavior on width {
                    PropertyAnimation {
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: introAnimation
        running: false

        PropertyAnimation {
            target: content
            property: "opacity"
            to: 1
            duration: 700
            easing.type: Easing.InOutQuad
        }
    }
}
