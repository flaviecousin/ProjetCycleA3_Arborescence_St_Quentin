<?php
define ('DB_USER', "etu0502");
define ('DB_PASSWORD', "ibjrfobv");
define ('DB_NAME', "etu0502");
define ('DB_SERVER', "127.0.0.1");

function dbConnect()
{
    try 
    {
        $db = new PDO('mysql:host='.DB_SERVER.';dbname='.DB_NAME.';'.'charset=utf8', DB_USER, DB_PASSWORD);
        $db->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
        }
        catch (PDOException $exception) {
        error_log('Connection error: '.$exception->getMessage());
        return false;
        }
        return $db; // variable symbolisée avec un $ avant le nom de la variable
}

function dbGetEtat($db)
{
    try {
        $statement = $db->query('SELECT * FROM etat_de_l_arbre');
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    }
        catch (PDOException $exception) {
            error_log('Request error: '.$exception->getMessage());
            return false;
        }
        return $result;
}

function dbGetStade($db)
{
    try {
        $statement = $db->query('SELECT * FROM stat_dev');
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    }
        catch (PDOException $exception) {
            error_log('Request error: '.$exception->getMessage());
            return false;
        }
        return $result;
}
function dbGetEspece($db)
{
    try {
        $statement = $db->query('SELECT * FROM Arbre');
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    }
        catch (PDOException $exception) {
            error_log('Request error: '.$exception->getMessage());
            return false;
        }
        return $result;
}

function dbGetPort($db)
{
    try {
        $statement = $db->query('SELECT * FROM Port');
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    }
        catch (PDOException $exception) {
            error_log('Request error: '.$exception->getMessage());
            return false;
        }
        return $result;
}

function dbGetPied($db)
{
    try {
        $statement = $db->query('SELECT * FROM pied');
        $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    }
        catch (PDOException $exception) {
            error_log('Request error: '.$exception->getMessage());
            return false;
        }   
        return $result;
}

function dbAddarbre($db,$longitude,$latitude,$etat_de_l_arbre,$espece,$remarquable,$feuillage,$hauteur_arbre,$hauteur_tronc,$diametre_tronc,$port,$pied,$stade_dev_arbre){
    
    //var_dump($longitude,$latitude,$etat_de_l_arbre,$espece,$remarquable,$feuillage,$hauteur_arbre,$hauteur_tronc,$diametre_tronc,$port,$pied,$stade_dev_arbre);

    //on envoie un message
    try{
        $request = 'INSERT INTO Arbre (longitude, latitude, id_etat_de_l_arbre, Especes, remarquable, feuillage, hauteur_totale, hauteur_tronc, diametre_tronc, id_port, id_pied, id_stat_dev)  VALUES (:longitude, :latitude, :etat_de_l_arbre, :espece, :remarquable, :feuillage, :h_tot, :h_tronc, :d_tronc, :port, :pied, :stat_dev_arbre)';
        $statement = $db->prepare($request);//requête préparée
        $statement->bindParam(':longitude', $longitude, PDO::PARAM_STR,256);//vérification si les paramètres de la variable cid soient bien comme voulu
        $statement->bindParam(':latitude', $latitude, PDO::PARAM_STR,256);
        $statement->bindParam(':etat_de_l_arbre', $etat_de_l_arbre, PDO::PARAM_STR,256);
        $statement->bindParam(':espece', $espece, PDO::PARAM_STR,256);
        $statement->bindParam(':remarquable', $remarquable, PDO::PARAM_STR,256);
        $statement->bindParam(':feuillage', $feuillage, PDO::PARAM_STR,256);
        $statement->bindParam(':h_tot', $hauteur_arbre, PDO::PARAM_STR,256);
        $statement->bindParam(':h_tronc', $hauteur_tronc, PDO::PARAM_STR,256);
        $statement->bindParam(':d_tronc', $diametre_tronc, PDO::PARAM_STR,256);
        $statement->bindParam(':port', $port, PDO::PARAM_STR,256);
        $statement->bindParam(':pied', $pied, PDO::PARAM_STR,256);
        $statement->bindParam(':stat_dev_arbre', $stade_dev_arbre, PDO::PARAM_STR,256);
        $result = $statement->execute();

    }

    catch(PDOException $exception) {
        echo("AH");
        error_log('Request error: '.$exception->getMessage());
        return false;
        }
    return true;
    

}

function dbGetTrees($db)
    {
        try {
            $statement = $db->query('SELECT a.latitude, a.longitude,a.Especes,a.hauteur_totale,a.hauteur_tronc,
            a.diametre_tronc, a.remarquable, e.etat_arbre, s.dev_arbre FROM Arbre a JOIN etat_de_l_arbre e 
            ON e.id_etat_de_l_arbre=a.id_etat_de_l_arbre LEFT JOIN stat_dev s ON s.id_stat_dev');
            $result = $statement->fetchAll(PDO::FETCH_ASSOC);
        }
        catch (PDOException $exception){
            error_log('Request error: '.$exception->getMessage());
            return false;
        }
        return $result;
    }

function execPythonScript($selectedRow) {
    $command = escapeshellcmd("python age.py --model svm");
    $output = shell_exec($command);
    return ['result' => $output];
}

?>
