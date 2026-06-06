import QtQuick
import Quickshell
import Quickshell.Wayland
import "."

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            // ✅ FULL SCREEN (correct Quickshell way)
            anchors { top: true; bottom: true; left: true; right: true }

            exclusionMode: ExclusionMode.Ignore

            // ✅ FORCE ABOVE EVERYTHING (Waybar included)
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            WlrLayershell.exclusiveZone: -1

            color: "transparent"

            // ─── SETTINGS ───
            property real dimOpacity: 0.65
            property int fadeInDuration: 900
            property int fadeOutDuration: 250
            property bool isQuitting: false

            function fadeAndQuit() {
    Qt.quit()
}
            Timer {
                id: quitTimer
                interval: win.fadeOutDuration
                repeat: false
                onTriggered: Qt.quit()
            }

            // ─── BACKDROP ───
            Image {
    id: dimLayer
    anchors.fill: parent
    source: "file:///tmp/idle-blur.png"
    fillMode: Image.PreserveAspectCrop
}

Rectangle {
    anchors.fill: parent
    color: "#000000"
    opacity: 0.20
}

Rectangle {
    anchors.fill: parent
    color: Colors.md3.surface
    opacity: 0.08
}
            // ─── CONTENT ───
            Item {
                id: content
                anchors.fill: parent
                opacity: 0.0

                Column {
    anchors.centerIn: parent
    spacing: 10

    width: parent.width

                    // ─── CAT ANIMATION ───
Text {
    id: catText

    width: parent.width
    height: 280
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    color: Colors.md3.on_surface
    font.family: "JetBrains Mono Nerd Font"
    font.pixelSize: 28
property string cat1:
"\n" +
" \n" +
"  |\\      _,,,---,,_\n" +
"      /,`.-'`'    -.  ;-;;,_\n" +
"       |,4-  ) )-,_. ,\\ (  `'-'\n" +
" '---''(_/--'  `-'\\_)\n"

property string cat2:
" \n" +
"  z    \n" +
"  |\\      _,,,---,,_\n" +
"      /,`.-'`'    -.  ;-;;,_\n" +
"       |,4-  ) )-,_. ,\\ (  `'-'\n" +
" '---''(_/--'  `-'\\_)\n"

property string cat3:
" Z      \n" +
"  z    \n" +
"  |\\      _,,,---,,_\n" +
"      /,`.-'`'    -.  ;-;;,_\n" +
"       |,4-  ) )-,_. ,\\ (  `'-'\n" +
" '---''(_/--'  `-'\\_)\n"
                        property int frame: 0
                        text: frame === 0 ? cat1 : frame === 1 ? cat2 : cat3

Timer {
    id: frameTimer
    interval: 800
    repeat: true
    running: false
    onTriggered: catText.frame = (catText.frame + 1) % 3
}
                    }

// ─── TITLE ───
Text {
    width: parent.width

    text:
"██╗   ██╗██╗      ██████╗ ██████╗ ██╗   ██╗████████╗██╗  ██╗\n" +
"╚██╗ ██╔╝██║     ██╔═══██╗██╔══██╗╚██╗ ██╔╝╚══██╔══╝██║  ██║\n" +
" ╚████╔╝ ██║     ██║   ██║██████╔╝ ╚████╔╝    ██║   ███████║\n" +
"  ╚██╔╝  ██║     ██║   ██║██╔══██╗  ╚██╔╝     ██║   ██╔══██║\n" +
"   ██║   ███████╗╚██████╔╝██║  ██║   ██║      ██║   ██║  ██║\n" +
"   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝"

    color: Colors.md3.primary
    font.family: "JetBrains Mono Nerd Font"
    font.pixelSize: 14
    horizontalAlignment: Text.AlignHCenter
}
                    // ─── HINT ───
                    Text {
                        width: parent.width 
                        text: "move mouse / press key to exit idle screen"
                        color: Colors.md3.on_surface_variant
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: win.fadeInDuration
                        easing.type: Easing.InOutQuad
                    }
                }
            }

            // ─── INPUT TO EXIT ───
            Item {
                anchors.fill: parent
                focus: true

                Keys.onPressed: win.fadeAndQuit()

                MouseArea {
                    anchors.fill: parent
                    onPressed: win.fadeAndQuit()
                    onPositionChanged: win.fadeAndQuit()
                }
            }

            // ─── START ───
            Component.onCompleted: {
    content.opacity = 1.0
    frameTimer.start()
}
        }
    }
}
