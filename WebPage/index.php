<?php
    require_once 'header.php';
?>

<div class="empty"></div>
<div class="page_style">
    <form action="packets_list.php">
        <input type="submit" class="button" value="Display all packets">
    </form>
    <form action="client_reservations.php">
        <input type="submit" class="button" value="View reservations">
    </form>
    <form action="client_fees.php">
        <input type="submit" class="button" value="Search by email">
    </form>
</div>

<?php
    require_once 'footer.php';
?>
