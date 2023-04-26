<?php
    require_once 'header.php';
?>

<div class="page_title">
    <h3>Available Packets:</h3>
</div>
<div class="empty"></div>
<div class="page_style">
    <?php
        require_once 'connection_start.php';
        include 'packets_list_query.php';
        require_once 'connection_stop.php';
    ?>
</div>

<?php
    require_once 'footer.php';
?>

