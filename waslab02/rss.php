<?php


    require_once("DbHandler.php");
    $dbhandler = new DbHandler();

    
	$res = $dbhandler->getTweets();
	
    $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8" ?><rss version="2.0"/>'); 	
    $item = $xml->addchild('channel');
	$item->addChild('title', "Wall of Tweets 2 - RSS Version");
	$item->addChild('link', "http://localhost:8080/waslab02/wall.php");
	$item->addChild('description', "RSS 2.0 feed that retrieves the tweets posted to the web app 'Wall of Tweets 2'");
    foreach($res as $tweet) {
    
        $twid = $tweet['id'];
        $description = "This is WoT tweet #" . $twid . "posted by <b>" . $tweet['author'] . "</b>. It has been liked by <b>" . $tweet['likes'] . "</b> people";
        $link = "http://localhost:8080/waslab02/wall.php#item_" . $twid;    
        
        $inner_elem = $item->addChild('item');
 		$inner_elem->title = $tweet['text'];
 		$inner_elem->link = $link;
 		$inner_elem->description = $description;
 		$inner_elem->pubDate = date('r', $tweet['time']);

    }    
    
    echo $xml->asXml();

?>



?>
