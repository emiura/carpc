// return db
function getDatabase() 
{
     return LocalStorage.openDatabaseSync("carpc", "1.0", "StorageDatabase", 1000000);
}

// init db
function initialize() 
{
    var db = getDatabase();
    db.transaction(
        function(tx) 
        {
            tx.executeSql("CREATE TABLE IF NOT EXISTS settings(setting TEXT, value TEXT)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS playlist(path TEXT, name TEXT)");
        })
}

// insert settings
function setSetting(setting, value) 
{
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) 
    {
        var rs = tx.executeSql("INSERT OR REPLACE INTO settings VALUES (?,?);", [setting,value]);
        //console.log(rs.rowsAffected)
        if (rs.rowsAffected > 0) 
        {
            res = "OK";
        } 
        else 
        {
           res = "Error";
        }
    });
    return res;
}

// insert playlist
function setPlaylist(playlist) 
{
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) 
    {
        var rs = tx.executeSql("DELETE FROM playlist;")
        var count = 0
        for (var i = 0; i < playlist.count; i++) 
        {
            rs = tx.executeSql("INSERT INTO playlist VALUES (?,?);", [playlist.path(i).path, playlist.name(i).name]);
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

// select settings
function getSetting(setting) 
{
    var db = getDatabase();
    var res="";

    try 
    {
        db.transaction(function(tx) 
        {
            var rs = tx.executeSql('SELECT value FROM settings WHERE setting=?;', [setting]);
            if (rs.rows.length > 0) 
            {
                res = rs.rows.item(0).value;
            } 
            else 
            {
                res = "Unknown";
            }
        })
    } 
    catch(e) 
    {
        return "";
    }
    return res
}

// select playlist
function getPlaylist(playlist) 
{
    var db = getDatabase();
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
                    playlist.append(
                    { 
                        "source": rs.rows.item(i).source, "title": rs.rows.item(i).title
                    })
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
        return "";
    }
    return res
}
