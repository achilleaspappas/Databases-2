<?php

// SQL query
$sql = "SELECT * FROM packets";

// Execute query
$result = mysqli_query($conn, $sql);

// Check if results returned
if (mysqli_num_rows($result) > 0) {
    echo "<table style='border:1px solid black'>";
    echo "<tr>".
        "<th>Packet Number</th>".
        "<th>Destination</th>".
        "<th>Start Date</th>".
        "<th>End Date</th>".
        "<th>Transport</th>".
        "<th>Cost</th>".
        "</tr>";
    while($row = mysqli_fetch_assoc($result)) {
        echo "<tr>".
            "<td>".$row['packet_num']."</td>".
            "<td>".$row['destination']."</td>".
            "<td>".$row['start_date']."</td>".
            "<td>".$row['end_date']."</td>".
            "<td>".$row['transport']."</td>".
            "<td>".$row['cost']."</td>".
            "</tr>".
            "</td>";
    }
    echo "</table>";
}
else {
    echo "No available packets found";
}

?>
