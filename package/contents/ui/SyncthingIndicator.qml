import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "syncthing.js" as St

Item {
    id: syncthingIndicator
    anchors.fill: parent

    readonly property var syncthingApiBaseUrl: plasmoid.configuration.syncthingApiBaseUrl
    readonly property var syncthingApiKey: plasmoid.configuration.syncthingApiKey
    readonly property var sharedFolders: plasmoid.configuration.sharedFolders
    readonly property var pollingInterval: plasmoid.configuration.pollingInterval
    property var syncthing: new St.Syncthing(plasmoid.configuration.syncthingApiBaseUrl,
                                             plasmoid.configuration.syncthingApiKey,
                                             plasmoid.configuration.sharedFolders)

    property var statusText: "Status: OK"

    property var icons: ({
        "syncon": "state-sync-symbolic",
        "syncoff": "state-offline-symbolic",
        "syncpaused": "state-pause-symbolic",
        "syncalert": "state-error-symbolic",
        "syncdownload": "state-download-symbolic",
        "syncupload": "state-upload-symbolic",
    })

    Kirigami.Icon {
        id: statusIcon
        anchors.fill: parent
        source: icons.syncoff
    }

    Timer {
        id: refreshTimer
        interval: pollingInterval * 1000
        running: true
        repeat: true
        onTriggered: updateStatus()
    }

    Component.onCompleted: {
        updateStatus();
    }

    function validateConfig() {
        if (syncthingApiBaseUrl.length == 0) {
            return false;
        }
        if (syncthingApiKey.length == 0) {
            return false;s
        }
        if (sharedFolders.length == 0) {
            return false;
        }
        return true;
    }

    function updateStatus() {
        if (!validateConfig()) {
            statusIcon.source = icons.syncalert
            root.toolTipSubText = "Error: Invalid config settings";
            return;
        }

        syncthing.getStatus().then(
            result => {
                switch (result.status) {
                    case "IDLE":
                        statusIcon.source = icons.syncpaused;
                        break;
                    case "SYNC":
                        statusIcon.source = icons.syncon;
                        break;
                    case "SYNC_DOWNLOAD":
                        statusIcon.source = icons.syncdownload;
                        break;
                    case "SYNC_UPLOAD":
                        statusIcon.source = icons.syncupload;
                        break;
                }
                root.toolTipSubText = `Status: ${result.status}`;
            },
            err => {
                statusIcon.source = icons.syncalert
                root.toolTipSubText = "Error: " + JSON.stringify(err.error);
            });
    }
}
