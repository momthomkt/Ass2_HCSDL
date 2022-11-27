<?php
    header('Access-Control-Allow-Methods: POST');
    header('Access-Control-Allow-Methods: PUT');
    header('Access-Control-Allow-Methods: DELETE');
    
    require_once "./mvc/models/TraineeModel.php";
    require_once "./mvc/views/TraineeView.php";

class Trainee {
    private $model;
    private $view;

    function __construct() {
        $this->model = new TraineeModel();
        $this->view = new TraineeView();
    }

    function execute($arr) {
        if (isset($arr[1])) {
            if ($arr[1]=="read") {
                if (isset($arr[2]) && is_numeric($arr[2]) && (int)$arr[2]>0) {
                    $result = $this->model->readSSN((int)$arr[2]);
                    $this->view->readRespond($result);
                }
                else {
                    $result = $this->model->readList();
                    $this->view->readRespond($result);
                }
            }
            elseif ($arr[1]=="caub"){
                if (isset($arr[2])) {
                    $result = $this->model->readName($arr[2]);
                    $this->view->readRespond($result);
                }
                else {
                    $result = $this->model->readList();
                    $this->view->readRespond($result);
                }
            }
            elseif ($arr[1]=="cauc"){
                if (isset($arr[2]) && is_numeric($arr[2]) && (int)$arr[2]>0) {
                    $result = $this->model->readFullInf((int)$arr[2]);
                    $this->view->readRespond($result);
                }
                else {
                    $result = $this->model->readList();
                    $this->view->readRespond($result);
                }
            }
            else throw new Exception("Wrong URL");
        }
        else throw new Exception("Wrong URL");
    }

}
?>
