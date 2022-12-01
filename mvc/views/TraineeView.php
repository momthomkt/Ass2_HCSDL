<?php

header('Content-Type: application/json');

class TraineeView {
    public function readRespond($result) {
        echo json_encode($result);
    }

    public function addRespond($success){
        echo json_encode(array("message" => $success));
    }

    public function searchRespond($result) {
        echo json_encode($result);
    }

    public function detailRespond($result){
        echo json_encode($result);
    }

    public function getResultRespond($result){
        echo json_encode($result);
    }
}

?>