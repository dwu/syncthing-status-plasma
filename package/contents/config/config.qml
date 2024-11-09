import QtQuick

import org.kde.plasma.plasmoid
import org.kde.plasma.configuration

ConfigModel {
    id: configModel

    ConfigCategory {
         name: "Syncthing"
         icon: "applications-network-symbolic"
         source: "config/syncthing.qml"
    }
}
