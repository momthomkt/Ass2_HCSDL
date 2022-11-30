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
            // Cau a
            if ($arr[1] == "add"){
                $data = json_decode(file_get_contents("php://input"));
                $SSN = isset($data->SSN) ? $data->SSN : "";
                $Fname = isset($data->Fname) ? $data->Fname : "";
                $Lname = isset($data->Lname) ? $data->Lname : "";
                $address = isset($data->address) ? $data->address : "";
                $phone = isset($data->phone) ? $data->phone : "";
                $DoB = isset($data->DoB) ? $data->DoB : "";
                $photo = isset($data->photo) ? $data->photo : "";
                $Cnumber = isset($data->Cnumber) ? $data->Cnumber : "";
                $Cname = isset($data->Cname) ? $data->Cname : "";
                $Caddress = isset($data->Caddress) ? $data->Caddress : "";
                $Cphone = isset($data->Cphone) ? $data->Cphone : "";
                $Edate = isset($data->Edate) ? $data->Edate : "";

                $result = $this->model->addTrainee($SSN, $Fname, $Lname, $address, $phone, $DoB, $photo, $Cnumber, $Cname, $Caddress, $Cphone, $Edate);
                $this->view->addRespond($result);
                // if (isset($arr[2]) && is_numeric($arr[2]) && (int)$arr[2]>0 && strlen($arr[2]) == 12){
                //     $result = $this->model->addTrainee($arr[2]);
                //     $this->view->addRespond($result);
                // }
                // else throw new Exception("Wrong Trainee SSN");
            }

            // Cau b
            elseif ($arr[1]=="search"){
                $data = json_decode(file_get_contents("php://input"));
                $name = isset($data->name) ? $data->name : "";
                $result = $this->model->readName($name);
                $this->view->searchRespond($result);
            }
            // Cau c
            elseif ($arr[1]=="detail"){
                if (isset($arr[2]) && is_numeric($arr[2]) && (int)$arr[2]>0) {
                    $result = $this->model->readFullInf((int)$arr[2]);
                    $this->view->readRespond($result);
                }
            }
            else if($arr[1] == "getResult")
            {
                $data = json_decode(file_get_contents("php://input"));
                $SSN = isset($data->SSN) ? $data->SSN : "";
                $year = isset($data->year) ? $data->year : "";
                $result = $this->model->ResultOfTrainee($SSN, $year);
                $this->view->getResultRespond($result);
            }
            else throw new Exception("Wrong URL");
        }
        else throw new Exception("Wrong URL");
    }

}
?>
