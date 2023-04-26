<?php
    require_once 'header.php';
    if(!isset($_SESSION))
    {
        session_start();
    }
?>

<div class="page_title">
    <h3>Select Packet:</h3>
</div>
<div class="page_style">
        <?php
            require_once 'connection_start.php';
            include 'dropdown_query.php'
        ?>
</div>

<?php
    require_once 'footer.php';
?>



