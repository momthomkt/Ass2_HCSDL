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
        $query = "SELECT * FROM $this->db_table;";
        $stmt = mysqli_query($this->conn, $query);
        $result = array(); 

        while($row = mysqli_fetch_assoc($stmt))
        {
            $result[] = $row;
        }
        return  $result;
    }

    public function readSSN($ssn) {
        $query = "SELECT * FROM $this->db_table WHERE SSN=$ssn;";
        $stmt = mysqli_query($this->conn, $query);

        if (mysqli_num_rows($stmt) > 0) return mysqli_fetch_assoc($stmt);
        else throw new Exception("User SSN does not exist");
    }

    public function readName($name) {
        $query = "SELECT * FROM $this->query_inf_trainee WHERE name=LOWER('$name');";
        $stmt = mysqli_query($this->conn, $query);

        if (mysqli_num_rows($stmt) == 0) throw new Exception("User SSN does not exist");
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
}
    
?>
