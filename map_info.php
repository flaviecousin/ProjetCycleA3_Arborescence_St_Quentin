<?php

require_once('database.php');

$db=dbConnect();

if($db==false)
{
    header('HTTP/1.1 503 Service Unavailable'); // si on change une constante dans le fichier database.php on obtient ce message d'erreur
    exit;
}
$result=false;


function dbGetTab($db){
    //exécuter la requête
    try{
    $request = 'SELECT * FROM Arbre';
    $statement = $db->prepare($request);//requête préparée
    $statement->execute();
    $result = $statement->fetchAll(PDO::FETCH_ASSOC);
    }
    catch (PDOException $exception) {
        error_log('Request error: '.$exception->getMessage());
        return false;
    }
    return $result;
}

$result = dbGetTrees($db);

if($_GET['request']=='tableau'){
    $result=dbGetTab($db);
}



if (($result==false))
    header('HTTP/1.1 400 Bad Request');
else {
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-control: no-store, no-cache, must-revalidate');
    header('Pragma: no-cache');
    header('HTTP/1.1 200 OK');
    echo json_encode($result);    
}



?>
