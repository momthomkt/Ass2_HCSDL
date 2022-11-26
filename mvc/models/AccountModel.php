<?php

class AccountModel extends Database{
    function checkAccount($username)
    {
        $sql = "SELECT * FROM account WHERE username ='$username'";
        return $this->get_one($sql);
    }
    function addAccount($username, $password, $name)
    {
        $sql = "INSERT INTO account (username,password,name,level) values ('$username','$password','$name','2')";
        $this->query($sql);
    }
    function changePass($username, $newPass)
    {
        $sql = "UPDATE account SET password='$newPass' WHERE username = '$username'";
        $this->query($sql);
    }
    function changeProfile($username, $name, $phoneNum, $email, $address)
    {
        $sql = "UPDATE account SET name='$name',phoneNumber='$phoneNum',email='$email',address='$address' WHERE username = '$username'";
        $this->query($sql);
    }
}

?>