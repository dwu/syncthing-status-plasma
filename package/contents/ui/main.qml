import QtQuick 2.15

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.onActivated: {} // disable activation

    preferredRepresentation: compactRepresentation
    compactRepresentation: SyncthingIndicator{}
    fullRepresentation: SyncthingIndicator{}
}
