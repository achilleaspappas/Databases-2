<?php
if(!isset($_SESSION))
{
    session_start();
}

$selected_destination = $_SESSION['destinations'];

// SQL query
$sql = "SELECT first_name, last_name, address, phone, email FROM customers AS c
JOIN chosen_packet AS cp ON c.customer_num = cp.customer_num 
JOIN packets AS p ON p.packet_num = cp.packet_num 
WHERE p.destination = '$selected_destination'";

// Execute query
$result = mysqli_query($conn, $sql);

// Check if results returned
if (mysqli_num_rows($result) > 0) {
    echo "<table style='border:1px solid black'>";
    echo "<tr>".
    "<th>First Name</th>".
    "<th>Last Name</th>".
    "<th>Address</th>".
    "<th>Phone</th>".
    "<th>Email</th>".
    "</tr>";
    while($row = mysqli_fetch_assoc($result)) {
        echo "<tr>".
        "<td>".$row['first_name']."</td>".
        "<td>".$row['last_name']."</td>".
        "<td>".$row['address']."</td>".
        "<td>".$row['phone']."</td>".
        "<td>".$row['email']."</td>".
        "</tr>".
        "</td>";
    }
    echo "</table>";
}
else {
    echo "No results";
}

?>
