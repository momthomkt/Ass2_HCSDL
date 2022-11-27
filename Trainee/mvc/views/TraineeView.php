<?php

header('Content-Type: application/json');

class TraineeView {
    public function readRespond($result) {
        echo json_encode($result);
    } 
}

?>