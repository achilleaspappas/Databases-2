<?php
    if(!isset($_SESSION))
    {
        session_start();
    }

$email = $_SESSION['email'];

$sql = "SELECT destination FROM packets AS p
JOIN chosen_packet AS cp ON p.packet_num = cp.packet_num
JOIN customers AS c ON c.customer_num = cp.customer_num
WHERE c.email = '$email'";

$result = mysqli_query($conn, $sql);

$sql1 = "SELECT SUM(cost) FROM packets AS p
JOIN chosen_packet AS cp ON p.packet_num = cp.packet_num
JOIN customers AS c ON c.customer_num = cp.customer_num
WHERE c.email = '$email'";

$result1 = mysqli_query($conn, $sql1);

if (mysqli_num_rows($result) > 0) {
    echo "<table style='border:1px solid black'>";
    echo "<tr>".
        "<th>Destination</th>".
        "</tr>";
    while($row = mysqli_fetch_assoc($result)) {
        echo "<tr>".
            "<td>".$row['destination']."</td>".
            "</tr>".
            "</td>";
    }
    echo "</table>";
    echo "<table style='border:1px solid black'>";
    echo "<tr>".
        "<th>Cost</th>".
        "</tr>";
    while($row = mysqli_fetch_assoc($result1)) {
        echo "<tr>".
            "<td>".$row['SUM(cost)']."</td>".
            "</tr>".
            "</td>";
    }
    echo "</table>";

}
else {
    echo "No available packets found.";
}
?>