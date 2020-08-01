<?php

$URI = 'http://localhost:8080/waslab02/wall.php';
$resp = file_get_contents($URI);

echo $http_response_header[0], "\n"; // Print the first HTTP response header

$tweets = new SimpleXMLElement($resp);

foreach($tweets->tweet as $n) {
    echo "[tweet #", $n['id'], "] ", $n->author, ": ", $n->text, " [", $n->time, "]\n"; 
}

$posdata = new SimpleXMLElement("<tweet></tweet>");
$posdata->addAttribute('version', '1.0');
$posdata->author = 'Pedro';
$posdata->text = 'Bon dia';

$opciones = array(
  'http'=>array(
    'method'=>"PUT",
    'header'=>"Content-type: text/xml",
    'content' => $posdata->asXml()
    )
);

$contexto = stream_context_create($opciones);

$resultat = file_get_contents($URI, false, $contexto);

echo $resultat;

$opciones_delete = array(
  'http'=>array(
    'method'=>"DELETE",
    )
);

$deletedata = new SimpleXMLElement($resultat);

$contexto_delete = stream_context_create($opciones_delete);

$resultat_delete = file_get_contents($URI."?twid=".$deletedata->tweetid, false, $contexto_delete);

echo $resultat_delete;






//echo $resp;  // Print HTTP response body

?>
