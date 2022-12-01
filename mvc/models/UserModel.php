<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once "./mvc/core/Model.php";

class UserModel extends Model {
    private $db_table2 = "user";

    public function login($username, $password) {
        require_once "user-auth/VmtHandler.php";
        try{
            // check if username valid
            if (strlen($username) < 5 || strlen($username) > 50 || is_numeric($username[0])) 
                throw new Exception("Invalid username");

            $query = "SELECT * FROM $this->db_table2 WHERE User ='$username';";
            $query_stmt = mysqli_query($this->conn2, $query);
            // IF THE USER IS FOUNDED BY EMAIL
            if(mysqli_num_rows($query_stmt)>0):
                $row = mysqli_fetch_assoc($query_stmt);
                $data = $row;
                $check_password = false;
                if ($data["Password"] == $password) $check_password = true;

                // VERIFYING THE PASSWORD (IS CORRECT OR NOT?)
                // IF PASSWORD IS CORRECT THEN SEND THE LOGIN TOKEN
                if($check_password):

                    $vmt = new VmtHandler();
                    $token = $vmt->VmtEncode(json_encode($data));
                    $returnData = [
                        'message' => 'successful',
                        'token' => $token
                    ];

                // IF INVALID PASSWORD
                else:
                    $returnData = array("message" => "Invalid password");
                endif;

            // IF THE USER IS NOT FOUNDED BY EMAIL THEN SHOW THE FOLLOWING ERROR
            else:
                $returnData = array("message" => "Invalid username");
            endif;
        }
        catch(PDOException $e){
            return array("message" => $e->getMessage());
        }
        catch (Exception $e) {
            return array("message" => $e->getMessage());
        }
        return $returnData;
    }
}
    
?>
