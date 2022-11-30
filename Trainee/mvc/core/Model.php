<?php 

class Model {
    protected $servername = "localhost";
    protected $username = "root";
    protected $password = "";
    protected $db_name = "assignment2";
    protected $db_name2 = "user";
    protected $conn;
    protected $conn2;
    public function __construct()
    {
        $this->conn = mysqli_connect($this->servername, $this->username, $this->password, $this->db_name);
        $this->conn2 = mysqli_connect($this->servername, $this->username, $this->password, $this->db_name2);
        // Check connection
        if (!$this->conn or !$this->conn2) {
            echo "null";
            die("Connection failed: " . mysqli_connect_error());
        }
    }

    public function dbConnection() {
        $conn = mysqli_connect($this->servername, $this->username, $this->password, $this->db_name);
        
        // Check connection
        if (!$conn) {
            echo "null";
            die("Connection failed: " . mysqli_connect_error());
        }
        return $conn;
    }
}

?>
