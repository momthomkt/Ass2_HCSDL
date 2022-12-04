<?php
    header('Access-Control-Allow-Methods: POST');
    header('Access-Control-Allow-Methods: PUT');
    header('Access-Control-Allow-Methods: DELETE');
    
    require_once "./mvc/models/UserModel.php";
    require_once "./mvc/views/UserView.php";

class User {
    private $model;
    private $view;

    function __construct() {
        $this->model = new UserModel();
        $this->view = new UserView();
    }

    function execute($arr) {
        if (isset($arr[1])) {
            // if ($arr[1]=="read") {
            //     if (isset($arr[2]) && is_numeric($arr[2]) && (int)$arr[2]>0) {
            //         $result = $this->model->readID((int)$arr[2]);
            //         $this->view->readRespond($result);
            //     }
            //     else {
            //         $result = $this->model->readList();
            //         $this->view->readRespond($result);
            //     }
            // }
            // else 
            if ($arr[1]=="login") {
                $data = json_decode(file_get_contents("php://input"));
                $username = $data->username;
                $password = $data->password;
                $result = $this->model->login($username, $password);
                $this->view->readRespond($result);
            }
            else throw new Exception("Wrong URL");
        }
        else throw new Exception("Wrong URL");
    }

}
?>
