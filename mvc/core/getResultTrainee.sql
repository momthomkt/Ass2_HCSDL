DROP PROCEDURE GetResultOfTrainee ; 
DELIMITER $$
CREATE PROCEDURE GetResultOfTrainee(
IN SSN_input CHAR(12),
IN Year_input YEAR
)
BEGIN
	DECLARE done INT DEFAULT FALSE;

	DECLARE a,b,c,d INT ; 
    
	DEClARE cur_Result1  CURSOR FOR SELECT year, SSN_trainee, score FROM MentorValuateTrainee;
	DEClARE cur_Result2  CURSOR FOR SELECT year,SSN_trainee, ep_no, no_of_votes FROM StageIncludeTrainee;

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

		CREATE TABLE Result (
				Episode 	INT,
				Vote 		INT
		);
        -- get value of ep 1
		OPEN cur_Result1 ; 
		get_Value: LOOP
			FETCH cur_Result1 INTO a , b,c ;
			-- end loop
            IF done THEN 
					LEAVE get_Value;
			END IF;
            -- to do 
            IF (a = Year_input and b = SSN_input) THEN 
				INSERT INTO Result VALUES (1, c);
            END IF;
		END LOOP get_Value;
        
        -- get value of ep 2,3,4,5
        SET done = FALSE ; 
        OPEN cur_Result2 ; 
        get_Value2: LOOP
			FETCH cur_Result2 INTO a , b ,c, d  ;
			-- end loop
            IF done THEN 
					LEAVE get_Value2;
			END IF;
            -- to do 
            IF (a = Year_input and b = SSN_input) THEN 
				INSERT INTO Result VALUES (c, d);
            END IF;
		END LOOP get_Value2;
		CLOSE cur_Result2 ; 	
        
        -- get all result
		SELECT Episode, SUM(Vote) AS 'vote'
        FROM Result 
        GROUP BY Episode ; 
        DROP TABLE Result;
END; $$
DELIMITER ;
