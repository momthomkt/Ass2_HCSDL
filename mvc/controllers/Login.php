<?php

class Login extends Controller{

    public function __construct(){
        // Model
        $acc = $this->model("AccountModel");
        // $acc->test();
        //changeProfile($username, $name, $phoneNum, $email, $address)
        $result = $acc->changeProfile("tan29072001", "Huỳnh Thanh Thống", "1234567890","thanhthong@gmail.com","giường tầng 2");
        if($result){
            echo "Thêm thành công";
        }
        else{
            echo "Thêm thất bại";
        }
    }
    // function login(){
    //     $data = array("page"=>"login");
    //     $this->view("Home", $data);
    // }
}

?>