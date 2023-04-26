<?php
    require_once 'header.php';
    if(!isset($_SESSION))
    {
        session_start();
    }
?>

<div class="page_title">
    <h3>Search Packets:</h3>
</div>
<div class="page_style">
    <form method="post" action="<?php $_SERVER['PHP_SELF'] ?>">
        Category: <input type="text" name="name">
        <br><br>
        E-mail: <input type="text" name="email">
        <br><br>
        <input type="submit" value="submit">
    </form>
    <?php
        if($_SERVER["REQUEST_METHOD"] == "POST") {
            $_SESSION['email'] = $_POST['email'];
            require_once 'connection_start.php';
            include 'client_fees_query.php';
            require_once 'connection_stop.php';
        }
    ?>
</div>

<?php
    require_once 'footer.php';
?>

