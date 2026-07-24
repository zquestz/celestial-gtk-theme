import QtQuick 2.15

Rectangle {
    id: root
    color: "#1a1a1a"

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
            color: "#d0c8c8"
            font.pixelSize: 44
            font.weight: Font.Light
            font.letterSpacing: 8
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 2
            color: "#484646"
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
                color: "#f0544c"
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
