## syncthing-status plasmoid for Plasma 6

This is a plasmoid for KDE Plasma 6 written in QML without external dependencies. It displays an icon based on Syncthing's current sync status.

**Note:** This plasmoid just shows whether a sync operation is in progress or not. If you're looking for a full-featured tray application, please have a look at the excellent https://github.com/Martchus/syncthingtray.

## Install & uninstall

Install: 
```sh
$ git clone https://github.com/dwu/syncthing-status
$ kpackagetool6 -t Plasma/Applet -i package
```

Uninstall:

```sh
$ kpackagetool6 -t Plasma/Applet -r io.github.dwu.syncthing-status
``` 

## Configuration properties

- **Syncthing API Base URL:** The base URL for Syncthing's REST API, typically `http://localhost:8384/rest`.
- **Syncthing API Key:** The API key. Can be found either in the "General" tab of the Web GUI's settings or in Syncthing's `config.xml` at xpath `/configuration/gui/apikey`.
    - On Unix-like operating systems you can get the apikey e.g. via xmlstarlet: `xmlstarlet sel -t -v /configuration/gui/apikey ~/.local/state/syncthing/config.xml`.
- **Shared folders**: The folder IDs of the shared folders to monitor separated by comma. Can be found either in the "Folders" view of the Syncthing Web Gui or in Syncthing's `config.xml` at xpath `/configuration/folder/@id`.
    - On Unix-like operating systems you can get the shared folders e.g. via xmlstarlet: `xmlstarlet sel -t -v /configuration/folder/@id ~/.local/state/syncthing/config.xml`

## Status display logic

- Information gathering
    - Gets a list of connected devices via Syncthing's REST API
    - Gets a the sync status of each connected device via Syncthing's REST API
    - Gets a the sync status of each shared folder via Syncthing's REST API
- Icon display
    - no connected devices: offline icon
    - only synced connected devices: paused icons
    - unsynced devices and unsynced folders: sync icon
    - unsynced devices and only synced folders: upload icon
    - only synced devices and unsynced folders: donwload icon
