<?php

// Lien avec le fichier comportant les infos du serveur
require_once('database.php');


// Connexion à la base de données
$db=dbConnect();
if($db==false)
{
    header('HTTP/1.1 503 Service Unavailable'); // si on change une constante dans le fichier database.php on obtient ce message d'erreur
    exit;
}

// Affichage des salons en JSON
$result=false;
if($_GET['request']=='etat_de_l_arbre')
    $result=dbGetEtat($db);

if($_GET['request']=='stat_dev')
    $result=dbGetStade($db);

if($_GET['request']=='Especes')
    $result=dbGetEspece($db);

if($_GET['request']=='remarquable')
    $result=dbGetEspece($db);

if($_GET['request']=='feuillage')
    $result=dbGetEspece($db);

if($_GET['request']=='Port')
    $result=dbGetPort($db);

if($_GET['request']=='pied')
    $result=dbGetPied($db);

if($_GET['request']=='send_arbre'){
    $result=dbAddarbre(
        $db,
        (float) $_POST['longitude'],
        (float) $_POST['latitude'],
        (int) $_POST['etat_de_l_arbre'],
        $_POST['espece'],
        $_POST['remarquable'],
        $_POST['feuillage'],
        (float) $_POST['h_tot'],
        (float) $_POST['h_tronc'],
        (float) $_POST['d_tronc'],
        (int) $_POST['port'],
        (int) $_POST['pied'],
        (int) $_POST['stade_dev_arbre']
    );
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
