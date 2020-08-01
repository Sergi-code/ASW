var baseURI = "http://localhost:8080/waslab03";
var tweetsURI = baseURI+"/tweets";

var req;
var tweetBlock = "	<div id='tweet_{0}' class='wallitem'>\n\
	<div class='likes'>\n\
	<span class='numlikes'>{1}</span><br /> <span\n\
	class='plt'>people like this</span><br /> <br />\n\
	<button onclick='{5}Handler(\"{0}\")'>{5}</button>\n\
	<br />\n\
	</div>\n\
	<div class='item'>\n\
	<h4>\n\
	<em>{2}</em> on {4}\n\
	</h4>\n\
	<p>{3}</p>\n\
	</div>\n\
	</div>\n";

String.prototype.format = function() {
	var args = arguments;
	return this.replace(/{(\d+)}/g, function(match, number) { 
		return typeof args[number] != 'undefined'
			? args[number]
		: match
		;
	});
};

function likeHandler(tweetID) {
	var target = 'tweet_' + tweetID;
	var uri = tweetsURI+ "/" + tweetID +"/likes";
	// e.g. to like tweet #6 we call http://localhost:8080/waslab03/tweets/6/like

	req = new XMLHttpRequest();
	req.open('POST', uri, /*async*/true);
	req.onload = function() { 
		if (req.status == 200) { // 200 OK
			document.getElementById(target).getElementsByClassName("numlikes")[0].innerHTML = req.responseText;
		}
	};
	req.send(/*no params*/null);
}

function deleteHandler(tweetID) {
	/*

	 * TASK #4 

	 */	
	req = new XMLHttpRequest();
	req.open('DELETE', tweetsURI+ "/" + tweetID, /*async*/true);
	req.onload = function() { 
		if (req.status == 200) { // 200 OK
			t = document.getElementById("tweet_"+tweetID);
			t.remove();
		}
	};
	
	token = localStorage.getItem(tweetID); 
	json_req = JSON.stringify({ token: token});
	req.send(json_req);

}

function getTweetHTML(tweet, action) {  // action :== "like" xor "delete"
	var dat = new Date(tweet.date);
	var dd = dat.toDateString()+" @ "+dat.toLocaleTimeString();
	return tweetBlock.format(tweet.id, tweet.likes, tweet.author, tweet.text, dd, action);

}

function getTweets() {
	req = new XMLHttpRequest(); 
	req.open("GET", tweetsURI, true); 
	req.onload = function() {
		if (req.status == 200) { // 200 OK
			var tweet_list = req.responseText;
			/*
			 * TASK #2 -->
			 */
			var tt_list = JSON.parse(tweet_list);
			var num;
			for(i = 0; i<tt_list.length; i++) {
				console.log(localStorage.getItem(tt_list[i]['id']));
				test = localStorage.getItem(tt_list[i]['id']);
				if (test != null){
					num += getTweetHTML(tt_list[i], "delete");
				}
				else {
					num += getTweetHTML(tt_list[i], "like");	
				}
			}
			document.getElementById("tweet_list").innerHTML = num;
		}
	};
	req.send(null); 
};


function tweetHandler() {
	var author = document.getElementById("tweet_author").value;
	var text = document.getElementById("tweet_text").value;
	/*
	 * TASK #3 -->
	 */
	
	req = new XMLHttpRequest();
	req.open('POST', tweetsURI, /*async*/true);
	req.onload = function() { 
		if (req.status == 200) { // 200 OK
			nt = JSON.parse(req.responseText);
			list = document.getElementById("tweet_list").innerHTML;
			document.getElementById("tweet_list").innerHTML = getTweetHTML(nt, "delete") + list;
			
			if (typeof(Storage) !== "undefined") {
				  // Code for localStorage/sessionStorage.
				localStorage.setItem(nt.id, nt.token);
			} else {
				  // Sorry! No Web Storage support..
			}
		}
	};
	req.setRequestHeader("Content-Type","application/json");
	req.send(JSON.stringify({ author: author, text: text }));
	
	
	/*var mes1 = "Someone ({0}) wants to insert a new tweet ('{1}'),\n but this feature is not implemented yet!";
	alert(mes1.format(author, text));*/

	// clear form fields
	document.getElementById("tweet_author").value = "";
	document.getElementById("tweet_text").value = "";

};

//main
function main() {
	document.getElementById("tweet_submit").onclick = tweetHandler;
	getTweets();
};