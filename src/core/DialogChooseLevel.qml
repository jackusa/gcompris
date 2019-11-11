/* GCompris - DialogChooseLevel.qml
 *
 * Copyright (C) 2018 Johnny Jazeix <jazeix@gmail.com>
 *
 * Authors:
 *   Johnny Jazeix <jazeix@gmail.com>
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
import QtQuick.Controls 1.5
import GCompris 1.0

/**
 * todo
 * @ingroup components
 *
 * todo
 *
 * @sa ApplicationSettings
 * @inherit QtQuick.Item
 */
Rectangle {
    id: dialogChooseLevel
    visible: false

    /* Public interface: */

    /**
     * type:string
     * The name of the activity in case of per-activity config.
     *
     * Will be autogenerated unless set by the caller.
     */
    property string activityName: currentActivity.name.split('/')[0]

    /// @cond INTERNAL_DOCS

    property bool isDialog: true

    /**
     * type:string
     * Title of the configuration dialog.
    */
    readonly property string title: currentActivity ? qsTr("%1 settings").arg(currentActivity.title) : ""

    property var difficultiesModel: []
    property QtObject currentActivity

    property var chosenLevels: []

    property var activityData
    onActivityDataChanged: loadData()
    /// @endcond

    /**
     * By default, we display configuration (this avoids to add code in each 
     * activity to set it by default).
     */
    property bool displayDatasetAtStart: !hasConfig

    /**
     * Emitted when the config dialog has been closed.
     */
    signal close

    /**
     * Emitted when the config dialog has been started.
     */
    signal start

    onStart: initialize()

    signal stop

    /**
     * Emitted when the settings are to be saved.
     *
     * The actual persisting of the settings in the settings file is done by
     * DialogActivityConfig. The activity has to take care to update its
     * internal state.
     */
    signal saveData

    signal startActivity

    /**
     * Emitted when the config settings have been loaded.
     */
    signal loadData

    property bool hasConfigOrDataset: hasConfig || hasDataset
    property bool hasConfig: activityConfigFile.exists("qrc:/gcompris/src/activities/"+activityName+"/ActivityConfig.qml")
    property bool hasDataset: currentActivity && currentActivity.levels.length !== 0

    color: "#696da3"
    border.color: "black"
    border.width: 1

    property bool inMenu: false

    onVisibleChanged: {
        if(visible) {
            configLoader.initializePanel()
        }
    }

    function initialize() {
        // dataset information
        chosenLevels = currentActivity.currentLevels
        difficultiesModel = []
        if(currentActivity.levels.length == 0) {
            print("no levels to load for", activityName)
        }
        else {
            for(var level in currentActivity.levels) {
                objectiveLoader.dataFiles.push({"level": currentActivity.levels[level], "file": "qrc:/gcompris/src/activities/"+activityName+"/resource/"+currentActivity.levels[level]+"/Data.qml"})
            }
            objectiveLoader.start()
        }

        // Defaults to config if in an activity else to dataset if in menu
        if(displayDatasetAtStart) {
            datasetVisibleButton.clicked()
        }
        else {
             optionsVisibleButton.clicked()
        }
    }

    Loader {
        id: objectiveLoader
        property var dataFiles: []
        property var currentFile
        signal start
        signal stop

        onStart: {
            var file = dataFiles.shift()
            currentFile = file
            source = file.file.toString()
        }

        onLoaded: {
            difficultiesModel.push({"level": currentFile.level, "objective": item.objective, "difficulty": item.difficulty, "selectedInConfig": chosenLevels.includes(currentFile.level)})
            if(dataFiles.length != 0) {
                start()
            }
            else {
                stop()
            }
        }
        onStop: {
            difficultiesRepeater.model = difficultiesModel
        }
    }

    Row {
        visible: true
        spacing: 2
        Item { width: 10; height: 1 }

        Column {
            spacing: 10
            anchors.top: parent.top
            Item { width: 1; height: 10 }
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogChooseLevel.width - 30
                height: title.height * 1.2
                border.color: "black"
                border.width: 2

                Row {
                    spacing: 2
                    padding: 8
                    Image {
                        id: titleIcon
                        anchors {
                            left: parent.left
                            top: parent.top
                            margins: 4 * ApplicationInfo.ratio
                        }
                    }

                    GCText {
                        id: title
                        text: dialogChooseLevel.title
                        width: dialogChooseLevel.width - (30 + cancel.width)
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "black"
                        fontSize: 20
                        font.weight: Font.DemiBold
                        wrapMode: Text.WordWrap
                    }
                }
            }

            // Header buttons
            Row {
                id: datasetOptionsRow
                height: dialogChooseLevel.height / 12
                width: parent.width
                spacing: parent.width / 4
                anchors.leftMargin: parent.width / 8
                Button {
                    id: datasetVisibleButton
                    text: qsTr("Dataset")
                    enabled: hasDataset
                    height: parent.height
                    opacity: enabled ? 1 : 0
                    width: parent.width / 3
                    property bool selected: true
                    style: GCButtonStyle {
                        selected: datasetVisibleButton.selected
                    }
                    onClicked: { selected = true; }
                }
                Button {
                    id: optionsVisibleButton
                    text: qsTr("Options")
                    enabled: hasConfig
                    height: parent.height
                    opacity: enabled ? 1 : 0
                    width: parent.width / 3
                    style: GCButtonStyle {
                        selected: !datasetVisibleButton.selected
                    }
                    onClicked: { datasetVisibleButton.selected = false; } //showOptions()
                }
            }

            // "Dataset"/"Options" content
            Rectangle {
                color: "#e6e6e6"
                radius: 6.0
                width: dialogChooseLevel.width - 30
                height: dialogChooseLevel.height - (30 + title.height * 1.2) - saveAndPlayRow.height - datasetOptionsRow.height - 3 * parent.spacing
                border.color: "black"
                border.width: 2

                Flickable {
                    id: flick
                    anchors.margins: 8
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    flickableDirection: Flickable.VerticalFlick
                    clip: true
                    contentHeight: contentItem.childrenRect.height + 40 * ApplicationInfo.ratio

                    Loader {
                        id: configLoader
                        visible: !datasetVisibleButton.selected
                        active: optionsVisibleButton.enabled
                        source: active ? "qrc:/gcompris/src/activities/"+activityName+"/ActivityConfig.qml" : ""

                        // Load configuration at start of activity
                        // in the menu, it's done when the visibility property
                        // of the dialog changes
                        onItemChanged: if(!inMenu) { initializePanel(); }

                        function initializePanel() {
                            if(item) {
                                // only connect once the signal to save data
                                if(item.background !== dialogChooseLevel) {
                                    item.background = dialogChooseLevel
                                    dialogChooseLevel.saveData.connect(save)
                                }
                                getInitialConfiguration()
                            }
                        }

                        function getInitialConfiguration() {
                            activityData = Qt.binding(function() { return item.dataToSave })
                            if(item) {
                                item.dataToSave = ApplicationSettings.loadActivityConfiguration(activityName)
                                item.setDefaultValues()
                            }
                        }
                        function save() {
                            item.saveValues()
                            ApplicationSettings.saveActivityConfiguration(activityName, item.dataToSave)
                        }
                    }

                    Column {
                        visible: datasetVisibleButton.selected
                        spacing: 10

                        Repeater {
                            id: difficultiesRepeater
                            delegate: Row {
                                height: objective.height
                                Image {
                                    id: difficultyIcon
                                    source: "qrc:/gcompris/src/core/resource/difficulty" +
                                    modelData.difficulty + ".svg";
                                    sourceSize.height: objective.indicatorImageHeight
                                    anchors.verticalCenter: objective.verticalCenter
                                }
                                GCDialogCheckBox {
                                    id: objective
                                    width: dialogChooseLevel.width - 30 - difficultyIcon.width - 2 * flick.anchors.margins
                                    text: modelData.objective
                                    // to be fixed by all last used levels
                                    checked: modelData.selectedInConfig
                                    onClicked: {
                                        if(checked) {
                                            chosenLevels.push(modelData.level)
                                        }
                                        else if(chosenLevels.length > 1) {
                                            chosenLevels.splice(chosenLevels.indexOf(modelData.level), 1)
                                        }
                                        else {
                                            // At least one must be selected
                                            checked = true;
                                        }
                                    }
                                }                            
                            }
                        }
                    }
                }

                // The scroll buttons
                GCButtonScroll {
                    anchors.right: parent.right
                    anchors.rightMargin: 5 * ApplicationInfo.ratio
                    anchors.bottom: flick.bottom
                    anchors.bottomMargin: 5 * ApplicationInfo.ratio
                    onUp: flick.flick(0, 1400)
                    onDown: flick.flick(0, -1400)
                    upVisible: flick.visibleArea.yPosition <= 0 ? false : true
                    downVisible: flick.visibleArea.yPosition + flick.visibleArea.heightRatio >= 1 ? false : true
                }
            }
            // Footer buttons
            Row {
                id: saveAndPlayRow
                height: dialogChooseLevel.height / 12
                width: parent.width
                spacing: parent.width / 16
                Button {
                    id: cancelButton
                    text: qsTr("Cancel")
                    height: parent.height
                    width: parent.width / 4
                    property bool selected: true
                    style: GCButtonStyle {}
                    onClicked: dialogChooseLevel.close()
                }
                Button {
                    id: saveButton
                    text: qsTr("Save")
                    height: parent.height
                    width: parent.width / 4
                    property bool selected: true
                    style: GCButtonStyle { }
                    onClicked: {
                        saveData();
                        close();
                    }
                }
                Button {
                    id: saveAndStartButton
                    text: qsTr("Save and start")
                    height: parent.height
                    width: parent.width / 3
                    visible: inMenu === true
                    style: GCButtonStyle { }
                    onClicked: {
                        saveData();
                        startActivity();
                    }
                }
            }

            Item { width: 1; height: 10 }
        }
    }

    // The cancel button
    GCButtonCancel {
        id: cancel
        onClose: {
            parent.close()
        }
    }

    File {
        id: activityConfigFile
    }
}
