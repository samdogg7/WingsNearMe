<?php
// Create connection to database

<?php
$servername = "localhost";
$username = "samdogg7";
$password = "fpKb7N#U4R9N7qcN2DtH";
$dbname = "u137892925_wings_near_me";

// Create connection
$con=mysqli_connect($servername,$username,$password, $dbname);
// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$sql = "INSERT INTO Reviews (Name, Rating, Review, PlaceID)
VALUES ('John Doe', '3.3', 'I like wings', 'ChIJvbz9ZW4X44kRALfuwtz07OI')";

if ($conn->query($sql) === TRUE) {
  echo "New record created successfully";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
