<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<?php
$conn = @mysql_connect("192.168.241.89", "root", "Vega2010##") or die("X Connect failed");
mysql_select_db("chacha_cloud", $conn);
mysql_query("set names 'UTF-8'"); 

  $sql="select username,password,phone from user limit 12500000,500000";
  $query=mysql_query($sql);
  while($row=mysql_fetch_array($query)){
    $fp = fopen('t4/14.csv', 'a'); 
	fwrite($fp,'"'.@$row[username].'","'.@$row[password].'"'.'","'.@$row[phone].'"'."\n"); 
	fclose($fp); 
  }  
echo 'finished';
  ?>

  log_app
  device_name,imei,phone
  
  user
  username,password,phone,fullname
  username,password,phone,address
  username,password,phone,email