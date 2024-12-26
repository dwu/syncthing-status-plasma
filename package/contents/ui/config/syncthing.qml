import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: configConnection

    property alias cfg_syncthingApiBaseUrl: apiBaseUrl.text
    property alias cfg_syncthingApiKey: apiKey.text
    property alias cfg_syncthingWebUrl: webUrl.text
    property alias cfg_sharedFolders: sharedFolders.text
    property alias cfg_pollingInterval: pollingInterval.value

    GridLayout {
        id: configConnectionGrid
        Layout.margins: 10
        Layout.fillWidth: true
        rowSpacing: 10
        columnSpacing: 10
        columns: 2

        Text {
            text: "Syncthing Web URL"
        }
        TextField {
            id: webUrl
            Layout.minimumWidth: 300
            placeholderText: "http://localhost:8384"
        }

        Text {
            text: "Syncthing API Base URL"
        }
        TextField {
            id: apiBaseUrl
            Layout.minimumWidth: 300
            placeholderText: "http://localhost:8384/rest"
        }

        Text {
            text: "Syncthing API Key"
        }
        TextField {
            id: apiKey
            Layout.minimumWidth: 300
            placeholderText: ""
        }

        Text {
            text: "Synced Folders (separated by \",\")"
        }
        TextField {
            id: sharedFolders
            Layout.minimumWidth: 300
            placeholderText: ""
        }

        Text {
            text: "Polling interval (s)"
        }
        SpinBox {
            id: pollingInterval
            stepSize: 1
            from: 1
            to: 60
        }
    }
}
