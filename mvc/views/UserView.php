<?php

header('Content-Type: application/json');

class UserView {
    public function readRespond($result) {
        echo json_encode($result);
    } 
}

?>