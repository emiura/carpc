import QtQuick.LocalStorage 2.0
import QtQuick 2.1

Item 
{
    id: db
    property var db: null

    // init
    function openDataBase()
    {
        return  LocalStorage.openDatabaseSync("carpc", "1.0", "StorageDatabase", 100000);
    }

    function initialize()
    {
        var db = openDataBase();
        db.transaction(function(tx)
        {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value TEXT)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS playlist(path TEXT, name TEXT)");
        });
        console.log("Database started!");
    }

    // insert settings
    function setSetting(setting, value) 
    {
        var db = openDataBase();
        db.transaction(function(tx)
        { 
            tx.executeSql('INSERT OR REPLACE INTO settings VALUES(?, ?)', [setting, value]);
        });
    }

    // select settings
    function getSetting(setting) 
    {
        var db = openDataBase();
        var res = "";
        db.transaction(function(tx) 
        {
            var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
            res = rs.rows.item(0).value;
        });
        return res;
    }

    // insert playlist
    function setPlaylist(playlist)
    {
        var db = openDataBase();
        var res = "";
        var count = 0;
        playlist.currentIndex = 0;
        db.transaction(function(tx)
        {
            var rs = tx.executeSql("DELETE FROM playlist;")
            for (var i = 0; i < playlist.count; i++)
            {
                rs = tx.executeSql("INSERT INTO playlist VALUES (?,?);", [playlist.currentItem.data.path, playlist.currentItem.data.name]);
                playlist.currentIndex += 1;
                count += rs.rowsAffected;
            }
            if (count > 0)
            {
                res = "OK";
            }
            else
            {
                res = "Error";
            }
        })
        return res
    }

    // select playlist
    function getPlaylist(playlist)
    {
        var db = openDataBase();
        var res = "";
        try
        {
            db.transaction(function(tx)
            {
                var rs = tx.executeSql("SELECT * FROM playlist;");
                if (rs.rows.length > 0)
                {
                    for (var i = 0; i < rs.rows.length; i++)
                    {
                        controller.add(rs.rows.item(i).path, rs.rows.item(i).name)
                    }
                    res = "OK";
                }
                else
                {
                    res = "Unknown";
                }
            })
        }   
        catch(e)
        {
            console.error("Error" + e);
        }
        return res
    }
}

