/* GCompris - NoteNames.qml
 *
 * Copyright (C) 2018 Aman Kumar Gupta <gupta2140@gmail.com>
 *
 * Authors:
 *   Aman Kumar Gupta <gupta2140@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.6
import QtQuick.Controls 1.0
import GCompris 1.0

import "../../core"
import "../piano_composition"
import "note_names.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    property bool horizontalLayout: width > height

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ABCDEF"

        signal start
        signal stop

        Component.onCompleted: {
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        Keys.onPressed: {
            if(!introMessage.visible && !iAmReady.visible && !messageBox.visible && multipleStaff.musicElementModel.count - 1) {
                // If the key pressed matches the note, pass the correct answer as parameter, else pass a wrong answer.
                if(event.key === Qt.Key_1) {
                    isCorrectKey('C')
                }
                else if(event.key === Qt.Key_2) {
                    isCorrectKey('D')
                }
                else if(event.key === Qt.Key_3) {
                    isCorrectKey('E')
                }
                else if(event.key === Qt.Key_4) {
                    isCorrectKey('F')
                }
                else if(event.key === Qt.Key_5) {
                    isCorrectKey('G')
                }
                else if(event.key === Qt.Key_6) {
                    isCorrectKey('A')
                }
                else if(event.key === Qt.Key_7) {
                    isCorrectKey('B')
                }
                else if(event.key === Qt.Key_Left && shiftKeyboardLeft.visible) {
                    doubleOctave.currentOctaveNb--
                }
                else if(event.key === Qt.Key_Right && shiftKeyboardRight.visible) {
                    doubleOctave.currentOctaveNb++
                }
            }
        }

        function isCorrectKey(key) {
            if(Activity.newNotesSequence[Activity.currentNoteIndex][0] === key)
                Activity.correctAnswer()
            else
                items.displayNoteNameTimer.start()
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property GCSfx audioEffects: activity.audioEffects
            property alias bar: bar
            property alias multipleStaff: multipleStaff
            property alias doubleOctave: doubleOctave
            property alias bonus: bonus
            property alias iAmReady: iAmReady
            property alias messageBox: messageBox
            property alias addNoteTimer: addNoteTimer
            property alias dataset: dataset
            property alias progressBar: progressBar
            property alias introMessage: introMessage
            property bool isTutorialMode: true
            property alias displayNoteNameTimer: displayNoteNameTimer
        }

        Loader {
            id: dataset
            asynchronous: false
            source: "qrc:/gcompris/src/activities/note_names/resource/dataset_01.qml"
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property string clefType: "Treble"

        Timer {
            id: displayNoteNameTimer
            interval: 2000
            onRunningChanged: {
                if(running) {
                    multipleStaff.pauseNoteAnimation()
                    addNoteTimer.pause()
                    messageBox.visible = true
                }
                else {
                    messageBox.visible = false
                    if(progressBar.percentage != 100 && Activity.newNotesSequence.length) {
                        Activity.wrongAnswer()
                        addNoteTimer.resume()
                    }
                }
            }
        }

        Rectangle {
            id: messageBox
            width: label.width + 20
            height: label.height + 20
            border.width: 5
            border.color: "black"
            anchors.centerIn: multipleStaff
            radius: 10
            z: 11
            visible: false
            onVisibleChanged: text = Activity.targetNotes[0] == undefined ? ""
                                                                       : items.isTutorialMode ? qsTr("New note: %1").arg(Activity.targetNotes[0])
                                                                       : Activity.newNotesSequence[Activity.currentNoteIndex]
            property string text

            GCText {
                id: label
                anchors.centerIn: parent
                fontSize: mediumSize
                text: parent.text
            }

            MouseArea {
                anchors.fill: parent
                enabled: items.isTutorialMode
                onClicked: {
                    items.multipleStaff.pauseNoteAnimation()
                    items.multipleStaff.musicElementModel.remove(1)
                    Activity.showTutorial()
                }
            }
        }

        Rectangle {
            id: colorLayer
            anchors.fill: parent
            color: "black"
            opacity: 0.3
            visible: iAmReady.visible
            z: 10
            MouseArea {
                anchors.fill: parent
            }
        }

        ReadyButton {
            id: iAmReady
            focus: true
            z: 10
            visible: !introMessage.visible
            onVisibleChanged: {
                messageBox.visible = false
            }
            onClicked: {
                Activity.initLevel()
            }
        }

        IntroMessage {
            id: introMessage
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 5
                left: parent.left
                leftMargin: 5
            }
            z: 10
        }

        AdvancedTimer {
            id: addNoteTimer
            onTriggered: {
                Activity.noteIndexToDisplay = (Activity.noteIndexToDisplay + 1) % Activity.newNotesSequence.length
                Activity.displayNote(Activity.newNotesSequence[Activity.noteIndexToDisplay])
            }
        }

        ProgressBar {
            id: progressBar
            height: 20 * ApplicationInfo.ratio
            width: parent.width / 4

            property int percentage: 0

            value: percentage
            maximumValue: 100
            visible: !items.isTutorialMode
            anchors {
                top: parent.top
                topMargin: 10
                right: parent.right
                rightMargin: 10
            }

            GCText {
                anchors.centerIn: parent
                fontSize: mediumSize
                font.bold: true
                color: "black"
                text: parent.value + '%'
                z: 2
            }
        }

        MultipleStaff {
            id: multipleStaff
            width: horizontalLayout ? parent.width * 0.5 : parent.width * 0.8
            height: horizontalLayout ? parent.height * 0.9 : parent.height * 0.7
            nbStaves: 1
            clef: clefType
            notesColor: "red"
            isFlickable: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: progressBar.height + 20
            flickableTopMargin: multipleStaff.height / 14 + distanceBetweenStaff / 2.7
            noteAnimationEnabled: true
            onNoteAnimationFinished: {
                if(!items.isTutorialMode)
                    displayNoteNameTimer.start()
            }
        }

        // We present a pair of two joint piano keyboard octaves.
        Item {
            id: doubleOctave
            width: horizontalLayout ? parent.width * 0.8 : parent.width * 0.72
            height: horizontalLayout ? parent.height * 0.22 : 2 * parent.height * 0.18
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: bar.top
            anchors.bottomMargin: 30

            readonly property int nbJointKeyboards: 2
            readonly property int maxNbOctaves: (background.clefType === "Bass") ? 2 : 3
            property int currentOctaveNb: 0
            property var coloredKeyLabels: []

            Repeater {
                id: octaveRepeater
                anchors.fill: parent
                model: doubleOctave.nbJointKeyboards
                Piano {
                    id: pianoKeyboard
                    width: horizontalLayout ? octaveRepeater.width / 2 : octaveRepeater.width
                    height: horizontalLayout ? octaveRepeater.height : octaveRepeater.height / 2
                    blackLabelsVisible: false
                    blackKeysEnabled: blackLabelsVisible
                    whiteKeysEnabled: !messageBox.visible && multipleStaff.musicElementModel.count > 1
                    onNoteClicked: Activity.checkAnswer(note)
                    currentOctaveNb: doubleOctave.currentOctaveNb
                    anchors.top: (index === 1) ? octaveRepeater.top : undefined
                    anchors.topMargin: horizontalLayout ? 0 : -15
                    anchors.bottom: (index === 0) ? octaveRepeater.bottom : undefined
                    anchors.right: (index === 1) ? octaveRepeater.right : undefined
                    coloredKeyLabels: doubleOctave.coloredKeyLabels
                    labelsColor: "red"
                    // The octaves sets corresponding to respective clef types are in pairs for piano and piano2 at a time when displaying.
                    whiteNotesBass: {
                        if(index === 0) {
                            return [
                                whiteKeyNotes.slice(0, 4),    // F1 to B1
                                whiteKeyNotes.slice(11, 18)   // C3 to B3
                            ]
                        }
                        else {
                            return [
                                whiteKeyNotes.slice(4, 11),   // C2 to B2
                                whiteKeyNotes.slice(18, 25)   // C4 to B4
                            ]
                        }
                    }
                    whiteNotesTreble: {
                        if(index === 0) {
                            return [
                                [],                           // No keys to show for this piano keyboard in the lowest octave.
                                whiteKeyNotes.slice(18, 25),  // C4 to B4
                                whiteKeyNotes.slice(32, 34),  // C6 to D6
                            ]
                        }
                        else {
                            return [
                                whiteKeyNotes.slice(11, 18),  // C3 to B3
                                whiteKeyNotes.slice(25, 32),  // C5 to B5
                                [],                           // No keys to show for this piano keyboard in the highest octave.
                            ]
                        }
                    }
                }
            }
        }

        Image {
            id: shiftKeyboardLeft
            source: "qrc:/gcompris/src/core/resource/bar_previous.svg"
            sourceSize.width: horizontalLayout ? doubleOctave.width / 14 : doubleOctave.width / 7
            width: sourceSize.width
            height: width
            fillMode: Image.PreserveAspectFit
            visible: (doubleOctave.currentOctaveNb > 0) && doubleOctave.visible
            anchors {
                verticalCenter: doubleOctave.verticalCenter
                right: doubleOctave.left
            }
            MouseArea {
                enabled: !messageBox.visible
                anchors.fill: parent
                onClicked: {
                    doubleOctave.currentOctaveNb--
                }
            }
        }

        Image {
            id: shiftKeyboardRight
            source: "qrc:/gcompris/src/core/resource/bar_next.svg"
            sourceSize.width: horizontalLayout ? doubleOctave.width / 14 : doubleOctave.width / 7
            width: sourceSize.width
            height: width
            fillMode: Image.PreserveAspectFit
            visible: (doubleOctave.currentOctaveNb < doubleOctave.maxNbOctaves - 1) && doubleOctave.visible
            anchors {
                verticalCenter: doubleOctave.verticalCenter
                left: doubleOctave.right
            }
            MouseArea {
                enabled: !messageBox.visible
                anchors.fill: parent
                onClicked: {
                    doubleOctave.currentOctaveNb++
                }
            }
        }

        OptionsRow {
            id: optionsRow
            visible: false
        }

        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload }
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: {
                multipleStaff.eraseAllNotes()
                iAmReady.visible = true
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: win.connect(Activity.nextLevel)
        }
    }
}