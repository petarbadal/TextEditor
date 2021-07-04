import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: appWindow

    width: 800
    height: 600
    visible: true
    title: qsTr("Simple Text Editor")

    property int numberOfCharacters: 0

    function highlightTextPositions(start, end) {
        console.log("Start", start, "End:", end)
        mainTextArea.select(start, end)
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action { text: qsTr("&New...") }
            Action { text: qsTr("&Open...") }
            Action { text: qsTr("&Save") }
            Action { text: qsTr("Save &As...") }
            MenuSeparator { }
            Action { text: qsTr("&Quit") }
        }
        Menu {
            title: qsTr("&Edit")
            Action { text: qsTr("Undo") }
            Action { text: qsTr("Redo") }
            MenuSeparator { }
            Action { text: qsTr("Cu&t") }
            Action { text: qsTr("&Copy") }
            Action { text: qsTr("&Paste") }
        }
        Menu {
            title: qsTr("Tools")
            Action {
                text: qsTr("Highlight Text")

                onTriggered: {
                    console.log("Hightlight Text Action is Clicked!")
                    hightlightTextPopup.visible = true
                }
            }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("&About") }
        }
    }

    footer: Rectangle {
        height: 30
        color: "lightgray"

        Text {
            anchors.verticalCenter: parent.verticalCenter
            height: 30
            text: " # Characters entered: " + appWindow.numberOfCharacters
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        height: 2
        width: parent.width
        color: "lightgray"
    }

    TextArea {
        id: mainTextArea

        anchors.fill: parent
        anchors.topMargin: 2
        width: parent.width
        height: parent.header - 2
        font.pixelSize: 14
        font.letterSpacing: 2
        selectionColor: "yellow"

        onTextChanged: {
            var trimString = text.replace(/\s+/g, '')
            appWindow.numberOfCharacters = trimString.length
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: hightlightTextPopup.visible
        color: "gray"
        opacity: 0.5

        MouseArea {
            anchors.fill: parent

            onClicked: {
                hightlightTextPopup.visible = false
            }
        }
    }

    Rectangle {
        id: hightlightTextPopup

        anchors.centerIn: parent
        width: 300
        height: 200
        radius: 5
        border.color: "gray"
        visible: false

        MouseArea {
            anchors.fill: parent
        }

        Text {
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Enter text positions to highlight:"
        }

        ColumnLayout {
            width: parent.width
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.top: parent.top
            anchors.topMargin: 50
            spacing: 30

            ColumnLayout {
                spacing: 10
                RowLayout {
                    width: parent.width
                    Text {
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10
                        text: "Start Position:"
                    }

                    TextField {
                        id: controlStart

                        Layout.alignment: Qt.AlignRight
                        placeholderText: qsTr("Start")
                        maximumLength: 4

                        background: Rectangle {
                            implicitWidth: 70
                            implicitHeight: 30
                            color: controlStart.enabled ? "transparent" : "lightgray"
                            border.color: controlStart.enabled ? "gray" : "transparent"

                        }
                    }
                }

                RowLayout {
                    width: parent.width
                    Text {
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 10
                        text: "End Position:  "
                    }

                    TextField {
                        id: controlEnd

                        Layout.alignment: Qt.AlignRight
                        placeholderText: qsTr("End")
                        maximumLength: 4

                        background: Rectangle {
                            implicitWidth: 70
                            implicitHeight: 30
                            color: controlEnd.enabled ? "transparent" : "lightgray"
                            border.color: controlEnd.enabled ? "gray" : "transparent"

                        }
                    }
                }
            }

            Rectangle {
                width: parent.width / 2
                height: 40
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: -20
                color: (controlStart.text.length > 0 && controlEnd.text.length > 0) ? "gray" : "lightgray"
                radius: 3

                Text {
                    anchors.centerIn:  parent
                    text: "Apply"
                    font.pixelSize: 16
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        console.log("Apply Button clicked!")
                        var startValue = parseInt(controlStart.text)
                        var endValue = parseInt(controlEnd.text)

                        if(startValue < 0)
                            startValue = 0

                        if(endValue > mainTextArea.text.length)
                            endValue = mainTextArea.text.length

                        highlightTextPositions(startValue, endValue)
                        hightlightTextPopup.visible = false
                    }
                }
            }
        }
    }
}
