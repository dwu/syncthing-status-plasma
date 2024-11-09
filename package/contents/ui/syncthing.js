class Syncthing {

    constructor(baseUrl, apiKey, folders) {
        this.baseUrl = baseUrl;
        this.apiKey = apiKey;
        this.sharedFolders = folders.split(",");
    }

    sendRequest(url, callback) {
        let request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                let response = {
                    status : request.status,
                    headers : request.getAllResponseHeaders(),
                    contentType : request.responseType,
                    content : request.response
                };

                callback(response);
            }
        };

        request.open("GET", url);
        request.setRequestHeader("X-API-Key", this.apiKey);
        request.send();
    }

    getStatus() {
        return new Promise((resolve, reject) => {
            this.getConnectedDevices()
                .then(result => {
                    const connectedDevices = result.connections;
                    if (connectedDevices.length == 0) {
                        // no connected devices
                        resolve({ status: "IDLE" });
                    } else {
                        const devices = connectedDevices.map((device) => this.getDeviceSyncStatus(device));
                        Promise.all(devices).then(results => {
                            const unsyncedDevices = results.filter((e) => e.status != 100);
                            const folders = this.sharedFolders.map((folder) => this.getFolderSyncStatus(folder));
                            Promise.all(folders).then(results => {
                                const unsyncedFolders = results.filter((e) => e.status != 100);
                                if (unsyncedDevices.length > 0 && unsyncedFolders.length > 0) {
                                    // bi-directional sync
                                    resolve({status: "SYNC"});
                                } else if (unsyncedDevices.length == 0 && unsyncedFolders.length > 0) {
                                    // downloading
                                    resolve({status: "SYNC_DOWNLOAD"});
                                } else if (unsyncedDevices.length > 0 && unsyncedFolders.length == 0) {
                                    // uploading
                                    resolve({status: "SYNC_UPLOAD"});
                                } else {
                                    resolve({status: "IDLE"});
                                }
                            }, err => reject({status: "ERROR", error: err}));
                        }, err => reject({status: "ERROR", error: err}));
                    }
                }, err => reject({status: "ERROR", error: err}))
                .catch((err) => {
                    reject({status: "ERROR", error: err});
                });
        });
    }

    getConnectedDevices() {
        return new Promise((resolve, reject) => {
            this.sendRequest(this.baseUrl + "/system/connections", (response) => {
                if (response.status !== 200) {
                    reject({ status: response.status, content: response.content });
                }

                try {
                    const connections = [];
                    const json = JSON.parse(response.content);
                    for (const [name, connection] of Object.entries(json.connections)) {
                        if (connection.connected) {
                            connections.push(name)
                        }
                    }
                    resolve({ status: response.status, content: response.content, connections: connections });
                } catch (error) {
                    reject({ error })
                }
            });
        });
    }

    getDeviceSyncStatus(device) {
        return new Promise((resolve, reject) => {
            this.sendRequest(this.baseUrl + `/db/completion?device=${device}`, (response) => {
                if (response.status !== 200) {
                    reject({ status: response.status, content: response.content });
                }

                try {
                    const json = JSON.parse(response.content);
                    resolve({ status: response.status, content: response.content, status: json.completion });
                } catch (error) {
                    reject({ error })
                }
            });
        });
    }

    getFolderSyncStatus(folder) {
        return new Promise((resolve, reject) => {
            this.sendRequest(this.baseUrl + `/db/completion?folder=${folder}`, (response) => {
                if (response.status !== 200) {
                    reject({ status: response.status, content: response.content });
                }

                try {
                    const json = JSON.parse(response.content);
                    resolve({ status: response.status, content: response.content, status: json.completion });
                } catch (error) {
                    reject({ error })
                }
            });
        });
    }

}


