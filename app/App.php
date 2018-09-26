<?php

require_once(__DIR__.'/vendor/autoload.php');
use SDK\Client;
use SDK\Util;

class App {
  public $client;

  function __construct() {
    $this->client = new Client;
    $this->loadState();
  }

  function createPost($title, $content) {
    $curl = curl_init();

    $payload = (object)[];
    $payload->title = $title;
    $payload->content= $content;
    $payload->status = 'publish';
    // TODO: replace with block timestamp
    $payload->date = '2018-08-01 00:00:00';
    $jsonstr = json_encode($payload);

    curl_setopt_array($curl, array(
      CURLOPT_PORT => "8080",
      CURLOPT_URL => "http://localhost:8080/wp-json/wp/v2/posts",
      CURLOPT_RETURNTRANSFER => true,
      CURLOPT_ENCODING => "",
      CURLOPT_MAXREDIRS => 10,
      CURLOPT_TIMEOUT => 30,
      CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
      CURLOPT_CUSTOMREQUEST => "POST",
      CURLOPT_POSTFIELDS => $jsonstr,
      CURLOPT_HTTPHEADER => array(
        "authorization: Basic ". base64_encode("admin:password"),
        "cache-control: no-cache",
        "content-type: application/json"
      ),
    ));

    $response = curl_exec($curl);
    $err = curl_error($curl);

    curl_close($curl);

    if ($err) {
      echo "cURL Error #:" . $err;
    } else {
      echo $response;
    }

    $this->setState();
  }

  function loadState() {
    echo "loading state...\n";
    $result = $this->client->state()->get(Util::string2ByteArray('posts'));
    $query = trim(Util::byteArray2String($result->value));

    if ($query == "") {
      echo "query empty; returning.\n";
      return;
    }

    $command = "mysql wordpress -e 'DROP TABLE wp_posts;';";
    echo "wp_posts dropped\n";
    shell_exec($command);

    $fp = fopen('query.sql', 'w');
    fwrite($fp, $query);
    fclose($fp);
    echo "query.sql wrote\n";

    $command = 'mysql wordpress < query.sql';
    shell_exec($command);
    echo "sql imported\n";
  }

  function setState() {
    $command = "/usr/bin/mysqldump wordpress wp_posts --compact";
    $output = shell_exec($command);

    echo "setting state: \n".$output."\n";
    $this->client->state()->set(Util::string2ByteArray('posts'), Util::string2ByteArray($output));
    echo "set state finished\n";
  }
}

$app = new App;
$app->client->registerMethod('createPost', [], array($app, 'createPost'));
$app->client->serve();

?>
