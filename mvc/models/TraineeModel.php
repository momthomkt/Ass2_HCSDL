<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once "./mvc/core/Model.php";

class TraineeModel extends Model {
    private $query_inf_trainee = "(SELECT trainee.SSN, CONCAT(fname, ' ',lname) as name, phone, address , Photo FROM person, trainee WHERE person.SSN = trainee.SSN) as inf_trainee";
    private $query_ac_trainee = "(SELECT SSN_trainee as SSN, MAX(ep_NO) as BestAC, count(DISTINCT year) as NoS FROM `stageincludetrainee` GROUP BY SSN_trainee) as ac_trainee";
    
    private $db_table = "trainee";

    public function readList() {
        $query ="SELECT P.SSN, P.Fname, P.Lname, T.DoB, P.address, P.phone, C.name 
                FROM person P, trainee T, company C 
                WHERE P.SSN = T.SSN AND T.Company_ID = C.Cnumber 
                ORDER BY P.Lname, P.Fname;";
        $stmt = mysqli_query($this->conn, $query);
        $result = array(); 

        while($row = mysqli_fetch_assoc($stmt))
        {
            $result[] = $row;
        }
        return  $result;
    }

    public function addTrainee($SSN, $Fname, $Lname, $address, $phone, $DoB, $photo, $Cnumber, $Cname, $Caddress, $Cphone, $Edate){
        $table_person = "person";
        $table_trainee = "trainee";
        $table_company = "company";
        if($SSN == "" or $Fname == "" or $Lname == "" or $phone == "" or $Cnumber == "" or $Cphone == ""){
            throw new Exception("Vui lòng điền đầy đủ thông tin có dấu *");
        }
        $query = "SELECT SSN FROM $table_person WHERE SSN = $SSN;";
        $stmt = mysqli_query($this->conn, $query);
        if (mysqli_num_rows($stmt) > 0){
            throw new Exception("Mã định danh SSN đã tồn tại");
        }
        $query = "SELECT phone FROM $table_person WHERE phone = $phone;";
        $stmt = mysqli_query($this->conn, $query);
        if (mysqli_num_rows($stmt) > 0){
            throw new Exception("Số điện thoại cá nhân đã tồn tại");
        }
        $query = "SELECT Cnumber FROM $table_company WHERE Cnumber = '$Cnumber';";
        $stmt = mysqli_query($this->conn, $query);
        // Kiểm tra xem có công ty trong bảng đã tạo chưa
        if (mysqli_num_rows($stmt) == 0){
            $query = "SELECT phone FROM $table_company WHERE phone = $phone;";
            $stmt = mysqli_query($this->conn, $query);
                if (mysqli_num_rows($stmt) > 0)
                {
                    throw new Exception("Số điện thoại công ty đang làm việc đã tồn tại");
                }
                else
                {
                    $query3 = "INSERT INTO $table_company values ('$Cnumber', '$Cname', '$Caddress', '$Cphone', '$Edate');";
                    $stmt3 = mysqli_query($this->conn, $query3);
                    if(!$stmt3) 
                    {
                        throw new Exception("Lỗi insert bảng company");
                    }
                }
        }
        $query1 = "INSERT INTO $table_person values ('$SSN', '$Fname', '$Lname', '$address', '$phone');";
        $stmt1 = mysqli_query($this->conn, $query1);
        if(!$stmt1) 
        {
            throw new Exception("Lỗi insert bảng person");
        }

        $query2 = "INSERT INTO $table_trainee values ('$SSN', '$DoB', '$photo', '$Cnumber');";
        $stmt2 = mysqli_query($this->conn, $query2);
        if(!$stmt2) 
        {
            throw new Exception("Lỗi insert bảng trainee");
        }
        return "Add successfully";
    }

    public function readSSN($ssn) {
        $query = "SELECT * FROM $this->db_table WHERE SSN=$ssn;";
        // $query = "SELECT * FROM $this->db_table WHERE SSN LIKE '$ssn';";
        $stmt = mysqli_query($this->conn, $query);

        if (mysqli_num_rows($stmt) > 0) return mysqli_fetch_assoc($stmt);
        else throw new Exception("User SSN does not exist");
    }

    public function readName($name) {
       // $query = "SELECT * FROM $this->query_inf_trainee WHERE name like LOWER('$name');";
        $query = "SELECT * FROM $this->query_inf_trainee WHERE name LIKE '%$name%';";
        $stmt = mysqli_query($this->conn, $query);

        if (mysqli_num_rows($stmt) == 0) throw new Exception("User Name does not exist");
        $result = array(); 
        while($row = mysqli_fetch_assoc($stmt))
        {
            $result[] = $row;
        }
        return  $result;
    }

    public function readFullInf($ssn) {
        $tb_full_trainee = "(SELECT * FROM $this->query_ac_trainee JOIN $this->query_inf_trainee USING (SSN)) as full_trainee";
        $query = "SELECT * FROM $tb_full_trainee WHERE SSN=$ssn;";
        $stmt = mysqli_query($this->conn, $query);
        if (mysqli_num_rows($stmt) > 0) return mysqli_fetch_assoc($stmt);
        else throw new Exception("User SSN does not exist");
    }

    public function ResultOfTrainee($SSN, $year)
    {
        if($SSN == "" or  $year == "") throw new Exception("Please fill all information");
        $query = "CALL GetResultOfTrainee('$SSN', $year);";
        $stmt = mysqli_query($this->conn, $query);
        if (mysqli_num_rows($stmt) == 0) throw new Exception("Result does not exist");
        $result = array();
        while($row = mysqli_fetch_assoc($stmt))
        {
            $result[] = $row;
        }
        return $result;
    }
}
    
?>
