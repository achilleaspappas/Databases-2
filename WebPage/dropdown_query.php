<?php
if(!isset($_SESSION))
{
    session_start();
}

// SQL query
$sql = "SELECT destination FROM packets";

// Execute query
$result = mysqli_query($conn, $sql);
?>

<form method="post" action="<?php echo $_SERVER['PHP_SELF'];?>">
<select name="destinations">
    <?php
        if (mysqli_num_rows($result) > 0) {
            while($rows = $result->fetch_assoc())
            {
                $destination = $rows['destination'];
                echo "<option value='$destination'>$destination</option>";
            }
        }
        else {
            echo "No available packets.";
        }
    ?>
</select>
    <input type="submit" value="submit">
</form>

<?php
    if($_SERVER["REQUEST_METHOD"] == "POST") {
        $_SESSION['destinations'] = $_POST['destinations'];
        include 'reservations_list_query.php';
    }
?>