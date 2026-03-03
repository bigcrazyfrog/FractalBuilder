.pragma library
.import QtQuick.LocalStorage 2.0 as Sql

var db = null

function initDatabase() {
    try {
        db = Sql.LocalStorage.openDatabaseSync("FractalsBuilder", "", "Settings for fractals", 1000000)
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS fractal_settings (id INTEGER PRIMARY KEY, setting_name TEXT UNIQUE, setting_value TEXT, last_updated DATETIME DEFAULT CURRENT_TIMESTAMP)')
            console.log("Database initialized")
        })
        return true
    } catch (err) {
        console.log("Database error: " + err)
        return false
    }
}

function saveSetting(name, value) {
    if (!db) {
        if (!initDatabase()) return false
    }

    try {
        db.transaction(function(tx) {
            tx.executeSql('INSERT OR REPLACE INTO fractal_settings (setting_name, setting_value, last_updated) VALUES (?, ?, CURRENT_TIMESTAMP)',
                         [name, value.toString()])
        })
        console.log("Setting saved:", name, value)
        return true
    } catch (err) {
        console.log("Error saving setting:", err)
        return false
    }
}

function loadSetting(name, defaultValue) {
    if (!db) {
        if (!initDatabase()) return defaultValue
    }

    try {
        var result = defaultValue
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT setting_value FROM fractal_settings WHERE setting_name = ?', [name])
            if (rs.rows.length > 0) {
                result = rs.rows.item(0).setting_value
            }
        })
        return result
    } catch (err) {
        console.log("Error loading setting:", err)
        return defaultValue
    }
}
