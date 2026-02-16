<?php
require_once('database.php');

if ($_SERVER['REQUEST_METHOD'] == 'POST')  {
    $selectedRow = $_POST['selectedRow'];
    $list = execPythonScript($selectedRow);
}

?>
