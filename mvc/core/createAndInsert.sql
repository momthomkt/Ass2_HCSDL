-- 1. Company
CREATE TABLE Company(
	Cnumber		CHAR(4)	PRIMARY KEY,
    name		VARCHAR(40)	NOT NULL,
    address		VARCHAR(60),
    phone		VARCHAR(15)	NOT NULL	UNIQUE,
    Edate		DATE,
    CONSTRAINT  check_Cnumber   
        CHECK   (Cnumber like '____'),
    CONSTRAINT  check_Cnumber2   
        CHECK   (SUBSTRING(Cnumber, 1, 1) = 'C'),
    CONSTRAINT  check_Cnumber3   
        CHECK   (CAST(SUBSTRING(Cnumber,2,3) as SIGNED) >= 0 and CAST(SUBSTRING(Cnumber,2,3) as SIGNED) <= 999)
);

-- 2. Person
CREATE TABLE Person(
	SSN			CHAR(12)	PRIMARY KEY,
    Fname		VARCHAR(30),
    Lname		VARCHAR(10), 
    address		VARCHAR(60),
    phone		VARCHAR(15)	NOT NULL	UNIQUE
);

-- 3. Trainee
CREATE TABLE Trainee(
	SSN			CHAR(12)	PRIMARY KEY,
    DoB			DATE,
    Photo		VARCHAR(512),
    Company_ID	CHAR(4),
    CONSTRAINT 	fk_trainee_person_SSN	FOREIGN KEY	(SSN)
    			REFERENCES Person(SSN)
    			ON DELETE CASCADE,
    CONSTRAINT 	fk_trainee_company_comid	FOREIGN KEY	(Company_ID)
    			REFERENCES Company(Cnumber)
    			ON DELETE CASCADE
);

-- 4. MC
CREATE TABLE MC(
	SSN		CHAR(12)	PRIMARY KEY,
    CONSTRAINT 	fk_mc_person_SSN	FOREIGN KEY	(SSN)
    			REFERENCES Person(SSN)
    			ON DELETE CASCADE
);

-- 5. Mentor
CREATE TABLE Mentor(
	SSN		CHAR(12)	PRIMARY KEY,
    CONSTRAINT 	fk_mentor_person_SSN	FOREIGN KEY	(SSN)
    			REFERENCES Person(SSN)
    			ON DELETE CASCADE
);

-- 6. Song
CREATE TABLE Song(
    number          VARCHAR(5)      PRIMARY KEY,
    released_year   YEAR(4),
    name            VARCHAR(40),
    singer_SSN_fist_performed   CHAR(12)
);

-- Rang buoc cho number của bang Song
CREATE TABLE S(
    _no INT AUTO_INCREMENT PRIMARY KEY
);

DELIMITER $$
CREATE TRIGGER before_Song_insert
BEFORE INSERT
ON Song FOR EACH ROW
BEGIN
	declare maxi int;
	insert into S value (NULL);
	select max(_no) from S into maxi;
	SET NEW.number = CONCAT("S",maxi);
END $$
DELIMITER ;
-- -------------------------------------------

-- 7. ThemeSong (Bai hat chu de)
CREATE TABLE ThemeSong(
    song_ID     VARCHAR(5)     PRIMARY KEY,
    CONSTRAINT 	fk_tsong_song_songid	FOREIGN KEY	(song_ID)
    			REFERENCES Song(number)
    			ON DELETE CASCADE
);

-- 8. SongComposedBy
CREATE TABLE SongComposedBy(
    song_ID         VARCHAR(5),
    composer_SSN    CHAR(12),
    PRIMARY KEY     (song_ID, composer_SSN),
    CONSTRAINT 	fk_SCB_song_songid	FOREIGN KEY	(song_ID)
    			REFERENCES Song(number)
    			ON DELETE CASCADE
);

-- 9. Singer
CREATE TABLE Singer(
    SSN         CHAR(12)   PRIMARY KEY,
    Guest_ID    INT        UNIQUE,
    CONSTRAINT 	fk_Singer_Mentor_SSN	FOREIGN KEY	(SSN)
    			REFERENCES Mentor(SSN)
    			ON DELETE CASCADE
);
-- Bo sung cho bang 6. Song
ALTER TABLE Song
ADD CONSTRAINT  fk_song_singer_ssn FOREIGN KEY(singer_SSN_fist_performed)
                REFERENCES  Singer(SSN)
                ON  DELETE SET NULL;

-- 10. SingerSignatureSong
CREATE TABLE SingerSignatureSong(
    SSN         CHAR(12),
    song_name    VARCHAR(40),
    PRIMARY KEY (SSN, song_name),
    CONSTRAINT 	fk_SSS_Singer_SSN	FOREIGN KEY	(SSN)
    			REFERENCES Singer(SSN)
    			ON DELETE CASCADE
);

-- 11. Producer
CREATE TABLE Producer(
     SSN    CHAR(12)    PRIMARY KEY,
     CONSTRAINT 	fk_Pro_Mentor_SSN	FOREIGN KEY	(SSN)
    			    REFERENCES Mentor(SSN)
    			    ON DELETE CASCADE
);

-- 12. ProducerProgram
CREATE TABLE ProducerProgram(
    SSN             CHAR(12),
    Program_name    VARCHAR(40),
    PRIMARY KEY     (SSN, Program_name),
    CONSTRAINT 	    fk_ProPro_Pro_SSN	FOREIGN KEY	(SSN)
    			    REFERENCES Producer(SSN)
    			    ON DELETE CASCADE
);

-- 13. SongWriter
create TABLE SongWriter(
	SSN         char(12)    PRIMARY KEY,
    CONSTRAINT  fk_SongWriter_mentor_ssn FOREIGN KEY(ssn) 
                REFERENCES mentor(ssn) 
                ON DELETE CASCADE
);

-- Bo sung cho bang 8. SongComposedBy
ALTER TABLE SongComposedBy
ADD CONSTRAINT  fk_SCB_songwriter_ssn     FOREIGN KEY(composer_SSN)
                REFERENCES  SongWriter(SSN)
                ON DELETE CASCADE;

-- 14. Season
create TABLE Season(
	year YEAR(4)    PRIMARY KEY,
    location        varchar(60),
    themesong_ID    VARCHAR(5)      UNIQUE,
    MC_SSN char(12),
    CONSTRAINT fk_Season_themesong_Themesong_ID FOREIGN KEY(Themesong_ID) REFERENCES themesong(song_ID) ON DELETE SET NULL,
    CONSTRAINT fk_Season_MC_MC_SSN FOREIGN KEY(MC_SSN) REFERENCES MC(SSN) ON DELETE SET NULL
);

-- 15. SeasonMentor
create TABLE SeasonMentor(
	year YEAR(4) ,
    SSN_mentor char(12),
    PRIMARY KEY(year, SSN_mentor),
    CONSTRAINT fk_SeasonMentor_Season_year FOREIGN KEY(year) REFERENCES Season(year) ON DELETE CASCADE,
    CONSTRAINT fk_SeasonMentor_mentor_SSN_mentor FOREIGN KEY(SSN_mentor) REFERENCES mentor(SSN) ON DELETE CASCADE
);

-- 16. SeasonTrainee
create TABLE SeasonTrainee(
	year YEAR(4) ,
    SSN_trainee char(12),
    PRIMARY KEY(year, ssn_trainee),
    CONSTRAINT fk_SeasonTrainee_Season_year FOREIGN KEY(year) REFERENCES Season(year) ON DELETE CASCADE,
    CONSTRAINT fk_SeasonTrainee_trainee_SSN_trainee FOREIGN KEY(SSN_trainee) REFERENCES Trainee(SSN)  ON DELETE CASCADE
);

-- 17. MentorValuateTrainee
create TABLE MentorValuateTrainee(
	year YEAR(4) ,
    SSN_trainee char(12)  ,
    SSN_mentor char(12) ,
    score int  CHECK (score >=0 and score <= 100),
    PRIMARY KEY(year, ssn_trainee, SSN_mentor),
    CONSTRAINT fk_MentorValuateTrainee_Season_year FOREIGN KEY(year) REFERENCES Season(year) ON DELETE CASCADE,
    CONSTRAINT fk_MentorValuateTrainee_trainee_SSN_trainee FOREIGN KEY(SSN_trainee) REFERENCES Trainee(SSN) ON DELETE CASCADE,
    CONSTRAINT fk_MentorValuateTrainee_mentor_SSN_mentor FOREIGN KEY(SSN_mentor) REFERENCES Mentor(SSN) ON DELETE CASCADE
);

-- 18. Episode
create TABLE Episode(
	year YEAR(4) ,
    No int CHECK (No >=1 and No <= 5),
    name    VARCHAR(20),
    datetime DATETIME,
    duration int, 
    PRIMARY KEY(year, No),
    CONSTRAINT fk_Episode_Season_year FOREIGN KEY(year) REFERENCES Season(year) ON DELETE CASCADE
);

-- 19. Stage
create TABLE Stage(
	year YEAR(4) ,
    ep_No int ,
    stage_No int, 
    is_group boolean,	
    skill int DEFAULT 4 CHECK (skill >=1 and skill <= 4),
    total_vote int,
    song_ID VARCHAR(5),
    PRIMARY KEY(year, ep_No, stage_No),
    CONSTRAINT fk_Stage_Episode_year_ep_No FOREIGN KEY(year, ep_No) REFERENCES Episode(year, No) ON DELETE CASCADE,
    CONSTRAINT fk_Stage_Song_song_ID FOREIGN KEY(song_ID) REFERENCES Song(number) ON DELETE SET NULL
);

-- 20. StageIncludeTrainee
create TABLE StageIncludeTrainee(
	year YEAR(4),
    ep_No int,
    stage_No int, 
    SSN_trainee char(12), 
    role int DEFAULT 1 CHECK (role >=1 and role <= 3) ,
    no_of_votes int CHECK (no_of_votes >=0 and no_of_votes <= 500),
    PRIMARY KEY(year, ep_No, stage_No, SSN_trainee),
    CONSTRAINT fk_StageIncludeTrainee_Stage_year_ep_No_stage_No 
                    FOREIGN KEY(year, ep_No, stage_No) 
                    REFERENCES Stage(year, ep_No, stage_No)
                    ON DELETE CASCADE
);

-- 21. InvitedGuest
create TABLE InvitedGuest(
	guest_ID int AUTO_INCREMENT PRIMARY KEY
);

-- Bo sung cho bang 9. Singer
ALTER TABLE Singer
ADD CONSTRAINT  fk_singer_IGuest_ID     FOREIGN KEY(Guest_ID)
                REFERENCES  InvitedGuest(Guest_ID)
                ON DELETE CASCADE;

-- 22. Group_mems
create TABLE Group_mems(
	Gname varchar(12) PRIMARY KEY,
    no_of_member int not null CHECK (no_of_member >=1 and no_of_member <= 20),
    guest_ID int,
    CONSTRAINT fk_Group_mems_InvitedGuest_guest_ID FOREIGN KEY(guest_ID) REFERENCES InvitedGuest(guest_ID) ON DELETE SET NULL
);

-- 23. GroupSignatureSong
create TABLE GroupSignatureSong(
	Gname varchar(12),
    song_name VARCHAR(40),
    PRIMARY KEY(Gname, song_name),
    CONSTRAINT fk_GroupSignatureSong_Group_mems_Gname FOREIGN KEY(Gname) REFERENCES Group_mems(Gname) ON DELETE CASCADE
);

-- 24. GuestSupportStage
create TABLE GuestSupportStage(
	guest_ID int,
    year YEAR(4) ,
    ep_No int,
    stage_No int,
    PRIMARY KEY(year, ep_No, stage_No),
    CONSTRAINT fk_GuestSupportStage_InvitedGuest_guest_ID FOREIGN KEY(guest_ID) REFERENCES InvitedGuest(guest_ID) ON DELETE SET NULL, 
    CONSTRAINT fk_GuestSupportStage_Stage_Gname_year_ep_No_stage_No 
                                FOREIGN KEY(year, ep_No, stage_No) 
                                REFERENCES Stage(year, ep_No, stage_No) 
                                ON DELETE CASCADE
);

-- INSERT ---------------------------

-- 1. Company
INSERT INTO Company VALUES ('C002', 'Công ty TNHH 4 thành viên', 'Phòng 513 AG4, Ký túc xá khu A Đại học Quốc gia TP.HCM', '0373805673', '2022-11-18');
INSERT INTO Company VALUES ('C001', 'Thế giới di động', 'Thành phố Thủ Đức, Thành phố Hồ Chí Minh', '0123456789', '2000-03-26');
INSERT INTO Company VALUES ('C003', 'Tập đoàn Vingroup', 'Quận Long Biên, Hà Nội', '0988888888', '1993-08-08');
INSERT INTO Company VALUES ('C004', 'Ngân hàng Đầu tư và Phát triển Việt Nam', 'Quận Long Biên, Hà Nội', '01648785758', '1957-06-25');
INSERT INTO Company VALUES ('C005', 'Tập đoàn Hoàng Anh Gia Lai', 'Thành phố Pleiku, tỉnh Gia Lai', '0606276368', '1993-02-14');
INSERT INTO Company VALUES ('C006', 'Hãng hàng không Quốc gia Việt Nam', ',  Sân bay quốc tế Nội Bài, huyện Sóc Sơn, Hà Nội', '0973448575', '1956-01-15');

-- 2. Person
INSERT INTO Person VALUES ('000000000000', 'Huỳnh Trấn', 'Thành', 'phường 2, Quận 1, TP.HCM', '0684390607');
INSERT INTO Person VALUES ('000000000001', 'Bùi Quốc', 'Huy', 'Vũ Hòa, Kiến Xương, Thái Bình', '0936847954');
INSERT INTO Person VALUES ('000000000002', 'Huỳnh Thanh', 'Thống', 'Phòng 513 AG4, Ký túc xá khu A Đại học Quốc gia TP.HCM', '0268765734');
INSERT INTO Person VALUES ('000000000003', 'Nguyễn Văn', 'Tân', 'Phòng 513 AG4, Ký túc xá khu A Đại học Quốc gia TP.HCM', '0903824765');
INSERT INTO Person VALUES ('000000000004', 'Trương Huy', 'Thái', 'phường 2, quận 3, TP.HCM', '0985297655');
INSERT INTO Person VALUES ('000000000005', 'Nguyễn Khánh Đan', 'Linh', '101 Mai Hắc Đế, Bùi Thị Xuân, Hai Bà Trưng, Hà Nội', '0387297655');

INSERT INTO Person VALUES ('000000000006', 'Nguyễn Văn', 'Anh', '40 Lý Thường Kiệt, Buôn Mê Thuột, Đắk Lắk', '0367834627');
INSERT INTO Person VALUES ('000000000007', 'Nguyễn Văn', 'Bình', '40 Lý Thường Kiệt, Buôn Mê Thuột, Đắk Lắk', '0237823728');
INSERT INTO Person VALUES ('000000000008', 'Nguyễn Văn', 'Cường', '64 Nguyễn Tất Thành, Pleiku, Gia Lai', '0478463287');
INSERT INTO Person VALUES ('000000000009', 'Nguyễn Thị', 'Dung', 'Đông Hòa, Dĩ An, Bình Dương', '0952455895');
INSERT INTO Person VALUES ('000000000010', 'Nguyễn Thị', 'Em', '513 Phan Đình Phùng, phường Quang Trung, Kon Tum, Kon Tum', '0994885734');
INSERT INTO Person VALUES ('000000000011', 'Lê Văn', 'Phúc', 'phường 13, quận 2, thành phố Hồ Chí Minh', '0345896255');
INSERT INTO Person VALUES ('000000000012', 'Lê Văn', 'Giang', '16 Lý Thái Tổ, phường Quang Trung, thành phố Đà Nẵng', '0345996255');
INSERT INTO Person VALUES ('000000000013', 'Lê Văn', 'Hà', '18 Lý Thái Tổ, phường Quang Trung, thành phố Đà Nẵng', '0323896255');
INSERT INTO Person VALUES ('000000000014', 'Lê Thị', 'Minh', 'thôn 3, xã Vũ Thư, huyện Kiến Xương, tỉnh Thái Bình', '0163857439');
INSERT INTO Person VALUES ('000000000015', 'Lê Thị', 'Du', '45 Quang Trung, Đăk Hà, Kon Tum', '0473895261');
INSERT INTO Person VALUES ('000000000016', 'Vũ Văn', 'An', '45 Quang Trung, Đăk Hà, Kon Tum', '3223242434');
INSERT INTO Person VALUES ('000000000017', 'Vũ Văn', 'Bính', '46 Quang Trung, Đăk Hà, Kon Tum', '2323242366');
INSERT INTO Person VALUES ('000000000018', 'Vũ Văn', 'Công', '47 Quang Trung, Đăk Hà, Kon Tum', '0998063452');
INSERT INTO Person VALUES ('000000000019', 'Vũ Thị', 'Dung', '48 Quang Trung, Đăk Hà, Kon Tum', '0423246345');
INSERT INTO Person VALUES ('000000000020', 'Vũ Thị', 'Lan', '49 Quang Trung, Đăk Hà, Kon Tum', '0324645734');
INSERT INTO Person VALUES ('000000000021', 'Vũ Thị', 'Phương', '50 Quang Trung, Đăk Hà, Kon Tum', '0343476352');
INSERT INTO Person VALUES ('000000000022', 'Trần Văn', 'Ánh', '51 Quang Trung, Đăk Hà, Kon Tum', '0454624554');
INSERT INTO Person VALUES ('000000000023', 'Trần Văn', 'Bang', '52 Quang Trung, Đăk Hà, Kon Tum', '0897857134');
INSERT INTO Person VALUES ('000000000024', 'Trần Văn', 'Chung', '53 Quang Trung, Đăk Hà, Kon Tum', '0474564545');
INSERT INTO Person VALUES ('000000000025', 'Trần Thị', 'Duyên', '54 Quang Trung, Đăk Hà, Kon Tum', '0342364663');
INSERT INTO Person VALUES ('000000000026', 'Trần Thị', 'Em', '55 Quang Trung, Đăk Hà, Kon Tum', '0786678786');
INSERT INTO Person VALUES ('000000000027', 'Trần Thị', 'Phê', '56 Quang Trung, Đăk Hà, Kon Tum', '0726854573');
INSERT INTO Person VALUES ('000000000028', 'Phạm Văn', 'Luyến', '57 Quang Trung, Đăk Hà, Kon Tum', '0564534354');
INSERT INTO Person VALUES ('000000000029', 'Phạm Văn', 'Minh', '58 Quang Trung, Đăk Hà, Kon Tum', '0534325474');
INSERT INTO Person VALUES ('000000000030', 'Phạm Văn', 'Nguyên', '59 Quang Trung, Đăk Hà, Kon Tum', '0124354432');
INSERT INTO Person VALUES ('000000000031', 'Phạm Thị', 'Mai', '60 Quang Trung, Đăk Hà, Kon Tum', '0454733542');
INSERT INTO Person VALUES ('000000000032', 'Phạm Thị', 'Phong', '61 Quang Trung, Đăk Hà, Kon Tum', '0365354643');
INSERT INTO Person VALUES ('000000000033', 'Phạm Thị', 'Quý', '62 Quang Trung, Đăk Hà, Kon Tum', '0475353435');
INSERT INTO Person VALUES ('000000000034', 'Đặng Văn', 'Hiếu', '63 Quang Trung, Đăk Hà, Kon Tum', '0454634534');
INSERT INTO Person VALUES ('000000000035', 'Đặng Thị', 'Sơn', '64 Quang Trung, Đăk Hà, Kon Tum', '0435475254');

INSERT INTO Person VALUES ('000000000036', 'Lê Đình', 'Thuận', '64 Quang Trung, Pleiku, Gia Lai', '0432375254');
INSERT INTO Person VALUES ('000000000037', 'Lê Đình', 'Huy', '65 Quang Trung, Pleiku, Gia Lai', '0527462537');
INSERT INTO Person VALUES ('000000000038', 'Lê Đình', 'Trí', '66 Quang Trung, Pleiku, Gia Lai', '0263674536');
INSERT INTO Person VALUES ('000000000039', 'Lê Đình', 'Minh', '67 Quang Trung, Pleiku, Gia Lai', '0437453846');
INSERT INTO Person VALUES ('000000000040', 'Lê Đình', 'Cường', '68 Quang Trung, Pleiku, Gia Lai', '0246463463');

INSERT INTO Person VALUES ('000000000041', 'Mạc Văn', 'Anh', '69 Quang Trung, Pleiku, Gia Lai', '0246467463');
INSERT INTO Person VALUES ('000000000042', 'Mạc Văn', 'Boong', '70 Quang Trung, Pleiku, Gia Lai', '0346679245');
INSERT INTO Person VALUES ('000000000043', 'Mạc Văn', 'Can', '71 Quang Trung, Pleiku, Gia Lai', '0966564535');
INSERT INTO Person VALUES ('000000000044', 'Mạc Văn', 'Đan', '72 Quang Trung, Pleiku, Gia Lai', '0357534545');
INSERT INTO Person VALUES ('000000000045', 'Mạc Văn', 'Tuấn', '73 Quang Trung, Pleiku, Gia Lai', '0216793564');
INSERT INTO Person VALUES ('000000000046', 'Mạc Văn', 'Phước', '74 Quang Trung, Pleiku, Gia Lai', '0345683589');
INSERT INTO Person VALUES ('000000000047', 'Mạc Văn', 'Giang', '75 Quang Trung, Pleiku, Gia Lai', '0978546546');
INSERT INTO Person VALUES ('000000000048', 'Mạc Văn', 'Hùng', '76 Quang Trung, Pleiku, Gia Lai', '0975316754');
INSERT INTO Person VALUES ('000000000049', 'Mạc Văn', 'Thống', '77 Quang Trung, Pleiku, Gia Lai', '0912365874');
INSERT INTO Person VALUES ('000000000050', 'Mạc Văn', 'Thắng', '78 Quang Trung, Pleiku, Gia Lai', '0978434564');
INSERT INTO Person VALUES ('000000000051', 'Mạc Văn', 'Khải', '79 Quang Trung, Pleiku, Gia Lai', '0754675543');
INSERT INTO Person VALUES ('000000000052', 'Mạc Văn', 'Luân', '80 Quang Trung, Pleiku, Gia Lai', '0743544576');
INSERT INTO Person VALUES ('000000000053', 'Mạc Văn', 'Minh', '81 Quang Trung, Pleiku, Gia Lai', '0135467684');
INSERT INTO Person VALUES ('000000000054', 'Mạc Văn', 'Nhân', '82 Quang Trung, Pleiku, Gia Lai', '0454531356');
INSERT INTO Person VALUES ('000000000055', 'Mạc Văn', 'Thái', '83 Quang Trung, Pleiku, Gia Lai', '0127557923');
INSERT INTO Person VALUES ('000000000056', 'Mạc Văn', 'Phương', '84 Quang Trung, Pleiku, Gia Lai', '0123451245');
INSERT INTO Person VALUES ('000000000057', 'Mạc Văn', 'Quốc', '85 Quang Trung, Pleiku, Gia Lai', '0124638876');
INSERT INTO Person VALUES ('000000000058', 'Mạc Văn', 'Hòa', '86 Quang Trung, Pleiku, Gia Lai', '0125687854');
INSERT INTO Person VALUES ('000000000059', 'Mạc Văn', 'Tùng', '87 Quang Trung, Pleiku, Gia Lai', '0135687564');
INSERT INTO Person VALUES ('000000000060', 'Mạc Văn', 'Thanh', '88 Quang Trung, Pleiku, Gia Lai', '0797344543');

-- 3. Trainee
INSERT INTO Trainee VALUES ('000000000006', '1998-01-30', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000007', '1999-06-20', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C005');
INSERT INTO Trainee VALUES ('000000000008', '2003-11-11', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000009', '2000-11-12', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000010', '2001-01-01', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C004');
INSERT INTO Trainee VALUES ('000000000011', '2002-05-01', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000012', '2000-09-30', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C006');
INSERT INTO Trainee VALUES ('000000000013', '1999-08-27', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000014', '1998-07-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000015', '2002-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C005');
INSERT INTO Trainee VALUES ('000000000016', '2002-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C005');
INSERT INTO Trainee VALUES ('000000000017', '2002-05-18', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C006');
INSERT INTO Trainee VALUES ('000000000018', '2002-04-29', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000019', '2002-03-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000020', '2002-04-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000021', '2002-04-26', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C004');
INSERT INTO Trainee VALUES ('000000000022', '2001-11-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C004');
INSERT INTO Trainee VALUES ('000000000023', '2003-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000024', '2002-07-09', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000025', '2002-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000026', '2002-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000027', '1999-12-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C006');
INSERT INTO Trainee VALUES ('000000000028', '2002-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C004');
INSERT INTO Trainee VALUES ('000000000029', '2002-04-06', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000030', '1997-04-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000031', '2002-10-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000032', '2002-04-20', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000033', '1998-06-28', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000034', '2002-04-11', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000035', '2003-05-22', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000036', '2003-05-06', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000037', '2002-07-02', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C006');
INSERT INTO Trainee VALUES ('000000000038', '2000-05-12', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000039', '2001-12-24', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C005');
INSERT INTO Trainee VALUES ('000000000040', '1998-05-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C006');

INSERT INTO Trainee VALUES ('000000000041', '2001-05-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000042', '2000-06-20', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000043', '1998-07-22', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000044', '2001-08-23', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C004');
INSERT INTO Trainee VALUES ('000000000045', '1998-09-24', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000046', '2002-10-25', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C005');
INSERT INTO Trainee VALUES ('000000000047', '2001-11-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000048', '1999-12-27', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000049', '1998-01-11', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000050', '2000-02-12', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000051', '1998-03-13', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000052', '2000-04-14', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C004');
INSERT INTO Trainee VALUES ('000000000053', '1998-05-19', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000054', '2000-06-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000055', '2001-07-27', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C001');
INSERT INTO Trainee VALUES ('000000000056', '1998-08-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C005');
INSERT INTO Trainee VALUES ('000000000057', '2003-09-21', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C003');
INSERT INTO Trainee VALUES ('000000000058', '2000-10-31', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C006');
INSERT INTO Trainee VALUES ('000000000059', '1999-11-30', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
INSERT INTO Trainee VALUES ('000000000060', '2001-12-01', 'https://drive.google.com/file/d/1HHTjCVZC3rLFZrO1Ex040Zp6OkNOhksj/view?usp=sharing', 'C002');
-- 4. MC
INSERT INTO MC VALUES ('000000000001');
INSERT INTO MC VALUES ('000000000000');

-- 5. Mentor
INSERT INTO Mentor VALUES ('000000000002');
INSERT INTO Mentor VALUES ('000000000003');
INSERT INTO Mentor VALUES ('000000000004');
INSERT INTO Mentor VALUES ('000000000005');

-- 21. InvitedGuest

INSERT INTO InvitedGuest VALUES(); -- S1
INSERT INTO InvitedGuest VALUES(); -- S2
INSERT INTO InvitedGuest VALUES(); -- S3
INSERT INTO InvitedGuest VALUES(); -- S4
INSERT INTO InvitedGuest VALUES(); -- S5
INSERT INTO InvitedGuest VALUES(); -- S6
INSERT INTO InvitedGuest VALUES(); -- S7

-- 9. Singer
INSERT INTO Singer VALUES('000000000002', 2);
INSERT INTO Singer VALUES('000000000003', 3);
INSERT INTO Singer VALUES('000000000004', 4);

-- 6. Song
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2012, 'Em của ngày hôm qua', '000000000002');
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2016, 'Mình là gì của nhau', '000000000003');
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2016, 'Phía sau một cô gái', '000000000004');
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2017, 'Anh đã quen với cô đơn', '000000000004');
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2017, 'Lạc trôi', '000000000002');
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2019, 'Là bạn không thể yêu', '000000000003');

INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2017, 'Nơi ta chờ em', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2019, 'Bông hoa chẳng thuộc về ta', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2020, 'Nàng thơ', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2017, 'Mặt trời của em', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2017, 'Legend never die', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2017, 'Yêu 5', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2019, 'Simple love', NULL);
INSERT INTO Song(released_year, name, singer_SSN_fist_performed) VALUES (2020, 'Không thể cùng nhau suốt kiếp', NULL);


-- 7. ThemeSong
INSERT INTO ThemeSong VALUES('S1');
INSERT INTO ThemeSong VALUES('S2');
INSERT INTO ThemeSong VALUES('S3');

-- 13. SongWriter
INSERT INTO SongWriter VALUES('000000000002');
INSERT INTO SongWriter VALUES('000000000003');
INSERT INTO SongWriter VALUES('000000000004');
INSERT INTO SongWriter VALUES('000000000005');

-- 8. SongComposedBy
INSERT INTO SongComposedBy VALUES('S1', '000000000002');
INSERT INTO SongComposedBy VALUES('S2', '000000000003');
INSERT INTO SongComposedBy VALUES('S3', '000000000004');
INSERT INTO SongComposedBy VALUES('S4', '000000000004');
INSERT INTO SongComposedBy VALUES('S5', '000000000002');
INSERT INTO SongComposedBy VALUES('S6', '000000000003');
INSERT INTO SongComposedBy VALUES('S6', '000000000005');

-- 10. SingerSignatureSong
INSERT INTO SingerSignatureSong VALUES('000000000002', 'Em của ngày hôm qua');
INSERT INTO SingerSignatureSong VALUES('000000000002', 'Lạc trôi');
INSERT INTO SingerSignatureSong VALUES('000000000002', 'Nơi này có anh');
INSERT INTO SingerSignatureSong VALUES('000000000002', 'Không phải dạng vừa đâu');

INSERT INTO SingerSignatureSong VALUES('000000000003', 'Mình là gì của nhau');
INSERT INTO SingerSignatureSong VALUES('000000000003', 'Là bạn không thể yêu');
INSERT INTO SingerSignatureSong VALUES('000000000003', 'Yêu em dại khờ');
INSERT INTO SingerSignatureSong VALUES('000000000003', 'Yêu một người có lẽ');

INSERT INTO SingerSignatureSong VALUES('000000000004', 'Phía sau một cô gái');
INSERT INTO SingerSignatureSong VALUES('000000000004', 'Anh đã quen với cô đơn');
INSERT INTO SingerSignatureSong VALUES('000000000004', 'Vài lần đón đưa');
INSERT INTO SingerSignatureSong VALUES('000000000004', 'Nếu ngày ấy');

-- 11. Producer
INSERT INTO Producer VALUES ('000000000002');
INSERT INTO Producer VALUES ('000000000005');

-- 12. ProducerProgram
INSERT INTO ProducerProgram VALUES ('000000000002', 'Idol giới trẻ');
INSERT INTO ProducerProgram VALUES ('000000000005', 'Hãy chọn giá đúng');

-- 14. Season
INSERT INTO Season VALUES (2020, 'Hà Nội', 'S1', '000000000000');
INSERT INTO Season VALUES (2021, 'Đà Nẵng', 'S2', '000000000000');
INSERT INTO Season VALUES (2022, 'TP.HCM', 'S3', '000000000001');

-- 15. SeasonMentor
INSERT INTO SeasonMentor VALUES (2020, '000000000002');
INSERT INTO SeasonMentor VALUES (2020, '000000000003');
INSERT INTO SeasonMentor VALUES (2020, '000000000004');
INSERT INTO SeasonMentor VALUES (2020, '000000000005');

INSERT INTO SeasonMentor VALUES (2021, '000000000002');
INSERT INTO SeasonMentor VALUES (2021, '000000000003');
INSERT INTO SeasonMentor VALUES (2021, '000000000004');
INSERT INTO SeasonMentor VALUES (2021, '000000000005');

INSERT INTO SeasonMentor VALUES (2022, '000000000002');
INSERT INTO SeasonMentor VALUES (2022, '000000000003');
INSERT INTO SeasonMentor VALUES (2022, '000000000004');
INSERT INTO SeasonMentor VALUES (2022, '000000000005');

-- 16. SeasonTrainee
INSERT INTO SeasonTrainee VALUES (2020, '000000000006');
INSERT INTO SeasonTrainee VALUES (2020, '000000000007');
INSERT INTO SeasonTrainee VALUES (2020, '000000000008');
INSERT INTO SeasonTrainee VALUES (2020, '000000000009');
INSERT INTO SeasonTrainee VALUES (2020, '000000000010');
INSERT INTO SeasonTrainee VALUES (2020, '000000000011');
INSERT INTO SeasonTrainee VALUES (2020, '000000000012');
INSERT INTO SeasonTrainee VALUES (2020, '000000000013');
INSERT INTO SeasonTrainee VALUES (2020, '000000000014');
INSERT INTO SeasonTrainee VALUES (2020, '000000000015');
INSERT INTO SeasonTrainee VALUES (2020, '000000000016');
INSERT INTO SeasonTrainee VALUES (2020, '000000000017');
INSERT INTO SeasonTrainee VALUES (2020, '000000000018');
INSERT INTO SeasonTrainee VALUES (2020, '000000000019');
INSERT INTO SeasonTrainee VALUES (2020, '000000000020');
INSERT INTO SeasonTrainee VALUES (2020, '000000000021');
INSERT INTO SeasonTrainee VALUES (2020, '000000000022');
INSERT INTO SeasonTrainee VALUES (2020, '000000000023');
INSERT INTO SeasonTrainee VALUES (2020, '000000000024');
INSERT INTO SeasonTrainee VALUES (2020, '000000000025');
INSERT INTO SeasonTrainee VALUES (2020, '000000000026');
INSERT INTO SeasonTrainee VALUES (2020, '000000000027');
INSERT INTO SeasonTrainee VALUES (2020, '000000000028');
INSERT INTO SeasonTrainee VALUES (2020, '000000000029');
INSERT INTO SeasonTrainee VALUES (2020, '000000000030');
INSERT INTO SeasonTrainee VALUES (2020, '000000000031');
INSERT INTO SeasonTrainee VALUES (2020, '000000000032');
INSERT INTO SeasonTrainee VALUES (2020, '000000000033');
INSERT INTO SeasonTrainee VALUES (2020, '000000000034');
INSERT INTO SeasonTrainee VALUES (2020, '000000000035');
INSERT INTO SeasonTrainee VALUES (2020, '000000000036');
INSERT INTO SeasonTrainee VALUES (2020, '000000000037');
INSERT INTO SeasonTrainee VALUES (2020, '000000000038');
INSERT INTO SeasonTrainee VALUES (2020, '000000000039');
INSERT INTO SeasonTrainee VALUES (2020, '000000000040');
INSERT INTO SeasonTrainee VALUES (2020, '000000000041');
INSERT INTO SeasonTrainee VALUES (2020, '000000000042');
INSERT INTO SeasonTrainee VALUES (2020, '000000000043');
INSERT INTO SeasonTrainee VALUES (2020, '000000000044');
INSERT INTO SeasonTrainee VALUES (2020, '000000000045');
INSERT INTO SeasonTrainee VALUES (2020, '000000000046');
INSERT INTO SeasonTrainee VALUES (2020, '000000000047');
INSERT INTO SeasonTrainee VALUES (2020, '000000000048');
INSERT INTO SeasonTrainee VALUES (2020, '000000000049');
INSERT INTO SeasonTrainee VALUES (2020, '000000000050');
INSERT INTO SeasonTrainee VALUES (2020, '000000000051');
INSERT INTO SeasonTrainee VALUES (2020, '000000000052');
INSERT INTO SeasonTrainee VALUES (2020, '000000000053');
INSERT INTO SeasonTrainee VALUES (2020, '000000000054');
INSERT INTO SeasonTrainee VALUES (2020, '000000000055');
INSERT INTO SeasonTrainee VALUES (2020, '000000000056');
INSERT INTO SeasonTrainee VALUES (2020, '000000000057');
INSERT INTO SeasonTrainee VALUES (2020, '000000000058');
INSERT INTO SeasonTrainee VALUES (2020, '000000000059');
INSERT INTO SeasonTrainee VALUES (2020, '000000000060');

INSERT INTO SeasonTrainee VALUES (2021, '000000000006');
INSERT INTO SeasonTrainee VALUES (2021, '000000000007');
INSERT INTO SeasonTrainee VALUES (2021, '000000000008');
INSERT INTO SeasonTrainee VALUES (2021, '000000000009');
INSERT INTO SeasonTrainee VALUES (2021, '000000000010');
INSERT INTO SeasonTrainee VALUES (2021, '000000000011');
INSERT INTO SeasonTrainee VALUES (2021, '000000000012');
INSERT INTO SeasonTrainee VALUES (2021, '000000000013');
INSERT INTO SeasonTrainee VALUES (2021, '000000000014');
INSERT INTO SeasonTrainee VALUES (2021, '000000000015');
INSERT INTO SeasonTrainee VALUES (2021, '000000000016');
INSERT INTO SeasonTrainee VALUES (2021, '000000000017');
INSERT INTO SeasonTrainee VALUES (2021, '000000000018');
INSERT INTO SeasonTrainee VALUES (2021, '000000000019');
INSERT INTO SeasonTrainee VALUES (2021, '000000000020');
INSERT INTO SeasonTrainee VALUES (2021, '000000000021');
INSERT INTO SeasonTrainee VALUES (2021, '000000000022');
INSERT INTO SeasonTrainee VALUES (2021, '000000000023');
INSERT INTO SeasonTrainee VALUES (2021, '000000000024');
INSERT INTO SeasonTrainee VALUES (2021, '000000000025');
INSERT INTO SeasonTrainee VALUES (2021, '000000000026');
INSERT INTO SeasonTrainee VALUES (2021, '000000000027');
INSERT INTO SeasonTrainee VALUES (2021, '000000000028');
INSERT INTO SeasonTrainee VALUES (2021, '000000000029');
INSERT INTO SeasonTrainee VALUES (2021, '000000000030');
INSERT INTO SeasonTrainee VALUES (2021, '000000000031');
INSERT INTO SeasonTrainee VALUES (2021, '000000000032');
INSERT INTO SeasonTrainee VALUES (2021, '000000000033');
INSERT INTO SeasonTrainee VALUES (2021, '000000000034');
INSERT INTO SeasonTrainee VALUES (2021, '000000000035');
INSERT INTO SeasonTrainee VALUES (2021, '000000000036');
INSERT INTO SeasonTrainee VALUES (2021, '000000000037');
INSERT INTO SeasonTrainee VALUES (2021, '000000000038');
INSERT INTO SeasonTrainee VALUES (2021, '000000000039');
INSERT INTO SeasonTrainee VALUES (2021, '000000000040');
INSERT INTO SeasonTrainee VALUES (2021, '000000000041');
INSERT INTO SeasonTrainee VALUES (2021, '000000000042');
INSERT INTO SeasonTrainee VALUES (2021, '000000000043');
INSERT INTO SeasonTrainee VALUES (2021, '000000000044');
INSERT INTO SeasonTrainee VALUES (2021, '000000000045');
INSERT INTO SeasonTrainee VALUES (2021, '000000000046');
INSERT INTO SeasonTrainee VALUES (2021, '000000000047');
INSERT INTO SeasonTrainee VALUES (2021, '000000000048');
INSERT INTO SeasonTrainee VALUES (2021, '000000000049');
INSERT INTO SeasonTrainee VALUES (2021, '000000000050');

INSERT INTO SeasonTrainee VALUES (2022, '000000000006');
INSERT INTO SeasonTrainee VALUES (2022, '000000000007');
INSERT INTO SeasonTrainee VALUES (2022, '000000000008');
INSERT INTO SeasonTrainee VALUES (2022, '000000000009');
INSERT INTO SeasonTrainee VALUES (2022, '000000000010');
INSERT INTO SeasonTrainee VALUES (2022, '000000000011');
INSERT INTO SeasonTrainee VALUES (2022, '000000000012');
INSERT INTO SeasonTrainee VALUES (2022, '000000000013');
INSERT INTO SeasonTrainee VALUES (2022, '000000000014');
INSERT INTO SeasonTrainee VALUES (2022, '000000000015');
INSERT INTO SeasonTrainee VALUES (2022, '000000000016');
INSERT INTO SeasonTrainee VALUES (2022, '000000000017');
INSERT INTO SeasonTrainee VALUES (2022, '000000000018');
INSERT INTO SeasonTrainee VALUES (2022, '000000000019');
INSERT INTO SeasonTrainee VALUES (2022, '000000000020');
INSERT INTO SeasonTrainee VALUES (2022, '000000000021');
INSERT INTO SeasonTrainee VALUES (2022, '000000000022');
INSERT INTO SeasonTrainee VALUES (2022, '000000000023');
INSERT INTO SeasonTrainee VALUES (2022, '000000000024');
INSERT INTO SeasonTrainee VALUES (2022, '000000000025');
INSERT INTO SeasonTrainee VALUES (2022, '000000000026');
INSERT INTO SeasonTrainee VALUES (2022, '000000000027');
INSERT INTO SeasonTrainee VALUES (2022, '000000000028');
INSERT INTO SeasonTrainee VALUES (2022, '000000000029');
INSERT INTO SeasonTrainee VALUES (2022, '000000000030');
INSERT INTO SeasonTrainee VALUES (2022, '000000000031');
INSERT INTO SeasonTrainee VALUES (2022, '000000000032');
INSERT INTO SeasonTrainee VALUES (2022, '000000000033');
INSERT INTO SeasonTrainee VALUES (2022, '000000000034');
INSERT INTO SeasonTrainee VALUES (2022, '000000000035');
INSERT INTO SeasonTrainee VALUES (2022, '000000000036');
INSERT INTO SeasonTrainee VALUES (2022, '000000000037');
INSERT INTO SeasonTrainee VALUES (2022, '000000000038');
INSERT INTO SeasonTrainee VALUES (2022, '000000000039');
INSERT INTO SeasonTrainee VALUES (2022, '000000000040');

-- 17. MentorValuateTrainee
-- 2020 ---------------------------------------------------------------------------
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000006', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000007', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000008', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000009', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000010', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000011', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000012', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000013', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000014', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000015', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000016', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000017', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000018', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000019', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000020', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000021', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000022', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000023', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000024', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000025', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000026', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000027', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000028', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000029', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000030', '000000000002', 70);

INSERT INTO MentorValuateTrainee VALUES (2020, '000000000031', '000000000002', 80); -- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000032', '000000000002', 81);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000033', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000034', '000000000002', 84);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000035', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000036', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000037', '000000000002', 85);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000038', '000000000002', 83);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000039', '000000000002', 87);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000040', '000000000002', 89);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000041', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000042', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000043', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000044', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000045', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000046', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000047', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000048', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000049', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000050', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000051', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000052', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000053', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000054', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000055', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000056', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000057', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000058', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000059', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000060', '000000000002', 100);


INSERT INTO MentorValuateTrainee VALUES (2020, '000000000006', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000007', '000000000003', 20);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000008', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000009', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000010', '000000000003', 30);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000011', '000000000003', 35);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000012', '000000000003', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000013', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000014', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000015', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000016', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000017', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000018', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000019', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000020', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000021', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000022', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000023', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000024', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000025', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000026', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000027', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000028', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000029', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000030', '000000000003', 70);

INSERT INTO MentorValuateTrainee VALUES (2020, '000000000031', '000000000003', 80);-- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000032', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000033', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000034', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000035', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000036', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000037', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000038', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000039', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000040', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000041', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000042', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000043', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000044', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000045', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000046', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000047', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000048', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000049', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000050', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000051', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000052', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000053', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000054', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000055', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000056', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000057', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000058', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000059', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000060', '000000000003', 100);


INSERT INTO MentorValuateTrainee VALUES (2020, '000000000006', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000007', '000000000004', 20);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000008', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000009', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000010', '000000000004', 30);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000011', '000000000004', 35);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000012', '000000000004', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000013', '000000000004', 45);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000014', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000015', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000016', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000017', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000018', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000019', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000020', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000021', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000022', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000023', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000024', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000025', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000026', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000027', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000028', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000029', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000030', '000000000004', 50);

INSERT INTO MentorValuateTrainee VALUES (2020, '000000000031', '000000000004', 75);-- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000032', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000033', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000034', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000035', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000036', '000000000004', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000037', '000000000004', 85);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000038', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000039', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000040', '000000000004', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000041', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000042', '000000000004', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000043', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000044', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000045', '000000000004', 60);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000046', '000000000004', 60);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000047', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000048', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000049', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000050', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000051', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000052', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000053', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000054', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000055', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000056', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000057', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000058', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000059', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000060', '000000000004', 100);


INSERT INTO MentorValuateTrainee VALUES (2020, '000000000006', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000007', '000000000005', 20);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000008', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000009', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000010', '000000000005', 30);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000011', '000000000005', 35);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000012', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000013', '000000000005', 45);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000014', '000000000005', 50);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000015', '000000000005', 45);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000016', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000017', '000000000005', 46);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000018', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000019', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000020', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000021', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000022', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000023', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000024', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000025', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000026', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000027', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000028', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000029', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000030', '000000000005', 40);

INSERT INTO MentorValuateTrainee VALUES (2020, '000000000031', '000000000005', 75);-- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000032', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000033', '000000000005', 55);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000034', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000035', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000036', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000037', '000000000005', 85);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000038', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000039', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000040', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000041', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000042', '000000000005', 70);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000043', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000044', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000045', '000000000005', 60);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000046', '000000000005', 60);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000047', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000048', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000049', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000050', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000051', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000052', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000053', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000054', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000055', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000056', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000057', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000058', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000059', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2020, '000000000060', '000000000005', 100);

-- 2021 ---------------------------------------------------------------------------
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000006', '000000000002', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000007', '000000000002', 20);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000008', '000000000002', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000009', '000000000002', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000010', '000000000002', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000011', '000000000002', 20);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000012', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000013', '000000000002', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000014', '000000000002', 35);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000015', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000016', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000017', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000018', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000019', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000020', '000000000002', 40);

INSERT INTO MentorValuateTrainee VALUES (2021, '000000000021', '000000000002', 80);-- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000022', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000023', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000024', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000025', '000000000002', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000026', '000000000002', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000027', '000000000002', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000028', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000029', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000030', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000031', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000032', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000033', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000034', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000035', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000036', '000000000002', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000037', '000000000002', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000038', '000000000002', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000039', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000040', '000000000002', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000041', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000042', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000043', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000044', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000045', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000046', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000047', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000048', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000049', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000050', '000000000002', 100);


INSERT INTO MentorValuateTrainee VALUES (2021, '000000000006', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000007', '000000000003', 20);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000008', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000009', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000010', '000000000003', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000011', '000000000003', 35);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000012', '000000000003', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000013', '000000000003', 45);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000014', '000000000003', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000015', '000000000003', 45);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000016', '000000000003', 35);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000017', '000000000003', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000018', '000000000003', 25);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000019', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000020', '000000000003', 40);

INSERT INTO MentorValuateTrainee VALUES (2021, '000000000021', '000000000003', 80);-- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000022', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000023', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000024', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000025', '000000000003', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000026', '000000000003', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000027', '000000000003', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000028', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000029', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000030', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000031', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000032', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000033', '000000000003', 55);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000034', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000035', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000036', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000037', '000000000003', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000038', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000039', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000040', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000041', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000042', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000043', '000000000003', 86);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000044', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000045', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000046', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000047', '000000000003', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000048', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000049', '000000000003', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000050', '000000000003', 100);


INSERT INTO MentorValuateTrainee VALUES (2021, '000000000006', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000007', '000000000004', 20);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000008', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000009', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000010', '000000000004', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000011', '000000000004', 35);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000012', '000000000004', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000013', '000000000004', 35);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000014', '000000000004', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000015', '000000000004', 45);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000016', '000000000004', 20);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000017', '000000000004', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000018', '000000000004', 25);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000019', '000000000004', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000020', '000000000004', 40);

INSERT INTO MentorValuateTrainee VALUES (2021, '000000000021', '000000000004', 80);-- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000022', '000000000004', 70);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000023', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000024', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000025', '000000000004', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000026', '000000000004', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000027', '000000000004', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000028', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000029', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000030', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000031', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000032', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000033', '000000000004', 55);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000034', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000035', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000036', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000037', '000000000004', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000038', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000039', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000040', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000041', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000042', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000043', '000000000004', 55);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000044', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000045', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000046', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000047', '000000000004', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000048', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000049', '000000000004', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000050', '000000000004', 100);


INSERT INTO MentorValuateTrainee VALUES (2021, '000000000006', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000007', '000000000005', 20);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000008', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000009', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000010', '000000000005', 30);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000011', '000000000005', 35);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000012', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000013', '000000000005', 45);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000014', '000000000005', 50);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000015', '000000000005', 45);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000016', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000017', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000018', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000019', '000000000005', 50);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000020', '000000000005', 40);

INSERT INTO MentorValuateTrainee VALUES (2021, '000000000021', '000000000005', 80); -- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000022', '000000000005', 70);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000023', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000024', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000025', '000000000005', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000026', '000000000005', 60);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000027', '000000000005', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000028', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000029', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000030', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000031', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000032', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000033', '000000000005', 55);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000034', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000035', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000036', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000037', '000000000005', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000038', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000039', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000040', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000041', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000042', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000043', '000000000005', 55);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000044', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000045', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000046', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000047', '000000000005', 85);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000048', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000049', '000000000005', 95);
INSERT INTO MentorValuateTrainee VALUES (2021, '000000000050', '000000000005', 85);

-- 2022 ---------------------------------------------------------------------------
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000006', '000000000002', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000007', '000000000002', 20);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000008', '000000000002', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000009', '000000000002', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000010', '000000000002', 30);

INSERT INTO MentorValuateTrainee VALUES (2022, '000000000011', '000000000002', 45); -- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000012', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000013', '000000000002', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000014', '000000000002', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000015', '000000000002', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000016', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000017', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000018', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000019', '000000000002', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000020', '000000000002', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000021', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000022', '000000000002', 70);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000023', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000024', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000025', '000000000002', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000026', '000000000002', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000027', '000000000002', 95);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000028', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000029', '000000000002', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000030', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000031', '000000000002', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000032', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000033', '000000000002', 55);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000034', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000035', '000000000002', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000036', '000000000002', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000037', '000000000002', 85);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000038', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000039', '000000000002', 100);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000040', '000000000002', 100);


INSERT INTO MentorValuateTrainee VALUES (2022, '000000000006', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000007', '000000000003', 20);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000008', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000009', '000000000003', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000010', '000000000003', 30);

INSERT INTO MentorValuateTrainee VALUES (2022, '000000000011', '000000000003', 35); -- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000012', '000000000003', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000013', '000000000003', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000014', '000000000003', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000015', '000000000003', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000016', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000017', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000018', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000019', '000000000003', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000020', '000000000003', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000021', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000022', '000000000003', 70);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000023', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000024', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000025', '000000000003', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000026', '000000000003', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000027', '000000000003', 95);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000028', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000029', '000000000003', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000030', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000031', '000000000003', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000032', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000033', '000000000003', 55);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000034', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000035', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000036', '000000000003', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000037', '000000000003', 85);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000038', '000000000003', 95);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000039', '000000000003', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000040', '000000000003', 80);


INSERT INTO MentorValuateTrainee VALUES (2022, '000000000006', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000007', '000000000004', 20);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000008', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000009', '000000000004', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000010', '000000000004', 30);

INSERT INTO MentorValuateTrainee VALUES (2022, '000000000011', '000000000004', 35); -- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000012', '000000000004', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000013', '000000000004', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000014', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000015', '000000000004', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000016', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000017', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000018', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000019', '000000000004', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000020', '000000000004', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000021', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000022', '000000000004', 70);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000023', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000024', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000025', '000000000004', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000026', '000000000004', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000027', '000000000004', 95);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000028', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000029', '000000000004', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000030', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000031', '000000000004', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000032', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000033', '000000000004', 55);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000034', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000035', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000036', '000000000004', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000037', '000000000004', 85);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000038', '000000000004', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000039', '000000000004', 95);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000040', '000000000004', 100);


INSERT INTO MentorValuateTrainee VALUES (2022, '000000000006', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000007', '000000000005', 20);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000008', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000009', '000000000005', 15);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000010', '000000000005', 30);

INSERT INTO MentorValuateTrainee VALUES (2022, '000000000011', '000000000005', 35); -- Vao vong 2
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000012', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000013', '000000000005', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000014', '000000000005', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000015', '000000000005', 45);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000016', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000017', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000018', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000019', '000000000005', 50);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000020', '000000000005', 40);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000021', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000022', '000000000005', 70);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000023', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000024', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000025', '000000000005', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000026', '000000000005', 60);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000027', '000000000005', 95);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000028', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000029', '000000000005', 80);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000030', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000031', '000000000005', 75);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000032', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000033', '000000000005', 55);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000034', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000035', '000000000005', 90);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000036', '000000000005', 65);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000037', '000000000005', 85);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000038', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000039', '000000000005', 100);
INSERT INTO MentorValuateTrainee VALUES (2022, '000000000040', '000000000005', 95);

-- 18. Episode
INSERT INTO Episode VALUE (2020, 1, 'Bài hát chủ đề', '30-01-2020 19:00:00', 120);
INSERT INTO Episode VALUE (2020, 2, 'Đánh giá kỹ năng', '28-02-2020 19:00:00', 120);
INSERT INTO Episode VALUE (2020, 3, 'Thi đấu nhóm', '29-03-2020 19:00:00', 120);
INSERT INTO Episode VALUE (2020, 4, 'Khách mời', '27-04-2020 19:00:00', 120);
INSERT INTO Episode VALUE (2020, 5, 'Chung kết', '28-05-2020 19:00:00', 150);

INSERT INTO Episode VALUE (2021, 1, 'Bài hát chủ đề', '30-01-2021 19:00:00', 120);
INSERT INTO Episode VALUE (2021, 2, 'Đánh giá kỹ năng', '28-02-2021 19:00:00', 120);
INSERT INTO Episode VALUE (2021, 3, 'Thi đấu nhóm', '29-03-2021 19:00:00', 120);
INSERT INTO Episode VALUE (2021, 4, 'Khách mời', '27-04-2021 19:00:00', 120);
INSERT INTO Episode VALUE (2021, 5, 'Chung kết', '28-05-2021 19:00:00', 150);

INSERT INTO Episode VALUE (2022, 1, 'Bài hát chủ đề', '30-01-2022 19:00:00', 120);
INSERT INTO Episode VALUE (2022, 2, 'Đánh giá kỹ năng', '28-02-2022 19:00:00', 120);
INSERT INTO Episode VALUE (2022, 3, 'Thi đấu nhóm', '29-03-2022 19:00:00', 120);
INSERT INTO Episode VALUE (2022, 4, 'Khách mời', '27-04-2022 19:00:00', 120);
INSERT INTO Episode VALUE (2022, 5, 'Chung kết', '28-05-2022 19:00:00', 150);
-- ---------------------

-- Lam cac bang chua xong: 19, 20
-- 19. Stage
INSERT INTO Stage VALUE (2020, 1, 1, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 2, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 3, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 4, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 5, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 6, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 7, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 8, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 9, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 10, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 11, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 12, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 13, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 14, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 15, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 16, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 17, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 18, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 19, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 20, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 21, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 22, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 23, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 24, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 25, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 26, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 27, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 28, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 29, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 30, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 31, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 32, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 33, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 34, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 35, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 36, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 37, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 38, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 39, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 40, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 41, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 42, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 43, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 44, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 45, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 46, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 47, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 48, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 49, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 50, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 51, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 52, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 53, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 54, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 1, 55, 0, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 2, 1, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 2, 2, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 2, 3, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 2, 4, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 2, 5, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 2, 6, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 3, 1, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 3, 2, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 3, 3, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 3, 4, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 4, 1, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 4, 2, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 4, 3, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 4, 4, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 5, 1, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 5, 2, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 5, 3, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 5, 4, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 5, 5, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 5, 6, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 5, 7, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 5, 8, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 5, 9, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2020, 5, 10, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2020, 5, 11, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2020, 5, 12, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 1, 1, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 2, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 3, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 4, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 5, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 6, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 7, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 8, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 9, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 10, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 11, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 12, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 13, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 14, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 15, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 16, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 17, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 18, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 19, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 20, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 21, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 22, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 23, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 24, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 25, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 26, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 27, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 28, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 29, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 30, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 31, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 32, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 33, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 34, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 35, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 36, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 37, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 38, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 39, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 40, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 41, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 42, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 43, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 44, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 1, 45, 0, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 2, 1, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 2, 2, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 2, 3, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 2, 4, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 2, 5, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 2, 6, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 3, 1, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 3, 2, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 3, 3, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 3, 4, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 4, 1, 1, 2, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 4, 2, 1, 2, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 4, 3, 1, 2, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 4, 4, 1, 2, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 5, 1, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2021, 5, 2, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 5, 3, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 5, 4, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 5, 5, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 5, 6, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 5, 7, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 5, 8, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 5, 9, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2021, 5, 10, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 5, 11, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2021, 5, 12, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 1, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 2, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 3, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 4, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 5, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 6, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 7, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 8, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 9, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 10, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 11, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 12, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 13, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 14, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 15, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 16, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 17, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 18, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 19, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 20, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 21, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 22, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 23, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 24, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 25, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 26, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 27, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 28, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 29, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 30, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 31, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 32, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 33, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 34, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 1, 35, 0, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 2, 1, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2022, 2, 2, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2022, 2, 3, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 2, 4, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 2, 5, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 2, 6, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 3, 1, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 3, 2, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 3, 3, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 3, 4, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 4, 1, 1, 3, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 4, 2, 1, 3, NULL, 'S1');
INSERT INTO Stage VALUE (2022, 4, 3, 1, 3, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 4, 4, 1, 3, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 5, 1, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 5, 2, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 5, 3, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 5, 4, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 5, 5, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2022, 5, 6, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2022, 5, 7, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 5, 8, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 5, 9, 1, 4, NULL, 'S1');
INSERT INTO Stage VALUE (2022, 5, 10, 1, 4, NULL, 'S3');
INSERT INTO Stage VALUE (2022, 5, 11, 1, 4, NULL, 'S2');
INSERT INTO Stage VALUE (2022, 5, 12, 1, 4, NULL, 'S1');
-- 20. StageIncludeTrainee
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 1, '000000000006', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 2, '000000000007', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 3, '000000000008', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 4, '000000000009', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 5, '000000000010', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 6, '000000000011', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 7, '000000000012', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 8, '000000000013', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 9, '000000000014', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 10, '000000000015', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 11, '000000000016', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 12, '000000000017', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 13, '000000000018', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 14, '000000000019', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 15, '000000000020', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 16, '000000000021', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 17, '000000000022', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 18, '000000000023', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 19, '000000000024', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 20, '000000000025', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 21, '000000000026', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 22, '000000000027', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 23, '000000000028', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 24, '000000000029', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 25, '000000000030', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 26, '000000000031', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 27, '000000000032', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 28, '000000000033', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 29, '000000000034', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 30, '000000000035', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 31, '000000000036', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 32, '000000000037', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 33, '000000000038', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 34, '000000000039', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 35, '000000000040', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 36, '000000000041', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 37, '000000000042', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 38, '000000000043', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 39, '000000000044', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 40, '000000000045', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 41, '000000000046', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 42, '000000000047', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 43, '000000000048', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 44, '000000000049', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 45, '000000000050', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 46, '000000000051', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 47, '000000000052', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 48, '000000000053', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 49, '000000000054', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 50, '000000000055', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 51, '000000000056', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 52, '000000000057', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 53, '000000000058', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 54, '000000000059', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 1, 55, '000000000060', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 1, '000000000035', 3, 20);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 1, '000000000058', 1, 12);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 1, '000000000047', 1, 24);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 1, '000000000055', 1, 36);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 1, '000000000057', 2, 1);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 2, '000000000044', 2, 38);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 2, '000000000052', 1, 11);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 2, '000000000040', 3, 17);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 2, '000000000036', 1, 11);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 2, '000000000060', 1, 29);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 3, '000000000038', 3, 40);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 3, '000000000032', 1, 38);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 3, '000000000043', 2, 7);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 3, '000000000037', 1, 30);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 3, '000000000048', 1, 19);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 4, '000000000046', 3, 1);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 4, '000000000039', 1, 6);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 4, '000000000042', 1, 3);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 4, '000000000041', 2, 38);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 4, '000000000033', 1, 3);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 5, '000000000053', 3, 48);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 5, '000000000031', 1, 47);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 5, '000000000059', 2, 44);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 5, '000000000045', 1, 20);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 5, '000000000034', 1, 5);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 6, '000000000056', 3, 41);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 6, '000000000050', 1, 24);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 6, '000000000054', 1, 24);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 6, '000000000051', 1, 26);
INSERT INTO StageIncludeTrainee VALUE (2020, 2, 6, '000000000049', 2, 33);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 1, '000000000046', 3, 29);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 1, '000000000050', 2, 43);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 1, '000000000054', 1, 20);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 1, '000000000060', 1, 4);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 1, '000000000048', 1, 18);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 2, '000000000045', 3, 48);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 2, '000000000043', 1, 48);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 2, '000000000051', 1, 45);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 2, '000000000057', 2, 13);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 2, '000000000058', 1, 47);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 3, '000000000053', 3, 40);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 3, '000000000041', 1, 47);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 3, '000000000049', 2, 49);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 3, '000000000047', 1, 18);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 3, '000000000055', 1, 29);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 4, '000000000052', 3, 4);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 4, '000000000044', 1, 8);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 4, '000000000042', 2, 41);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 4, '000000000059', 1, 26);
INSERT INTO StageIncludeTrainee VALUE (2020, 3, 4, '000000000056', 1, 15);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 1, '000000000059', 3, 36);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 1, '000000000052', 1, 21);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 1, '000000000056', 1, 35);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 1, '000000000060', 2, 20);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 2, '000000000053', 2, 32);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 2, '000000000055', 1, 9);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 2, '000000000048', 1, 28);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 2, '000000000051', 3, 6);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 3, '000000000054', 3, 31);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 3, '000000000057', 1, 40);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 3, '000000000058', 1, 36);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 3, '000000000049', 2, 48);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 4, '000000000047', 3, 19);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 4, '000000000045', 1, 0);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 4, '000000000046', 1, 28);
INSERT INTO StageIncludeTrainee VALUE (2020, 4, 4, '000000000050', 2, 22);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 1, '000000000059', 3, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 1, '000000000055', 2, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 1, '000000000054', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 1, '000000000060', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 1, '000000000056', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 2, '000000000059', 1, 74);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 3, '000000000055', 1, 64);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 4, '000000000054', 1, 63);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 5, '000000000060', 1, 7);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 6, '000000000056', 1, 84);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 7, '000000000057', 3, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 7, '000000000052', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 7, '000000000058', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 7, '000000000053', 2, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 7, '000000000051', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 8, '000000000057', 1, 52);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 9, '000000000052', 1, 68);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 10, '000000000058', 1, 71);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 11, '000000000053', 1, 52);
INSERT INTO StageIncludeTrainee VALUE (2020, 5, 12, '000000000051', 1, 75);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 1, '000000000006', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 2, '000000000007', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 3, '000000000008', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 4, '000000000009', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 5, '000000000010', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 6, '000000000011', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 7, '000000000012', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 8, '000000000013', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 9, '000000000014', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 10, '000000000015', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 11, '000000000016', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 12, '000000000017', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 13, '000000000018', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 14, '000000000019', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 15, '000000000020', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 16, '000000000021', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 17, '000000000022', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 18, '000000000023', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 19, '000000000024', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 20, '000000000025', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 21, '000000000026', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 22, '000000000027', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 23, '000000000028', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 24, '000000000029', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 25, '000000000030', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 26, '000000000031', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 27, '000000000032', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 28, '000000000033', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 29, '000000000034', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 30, '000000000035', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 31, '000000000036', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 32, '000000000037', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 33, '000000000038', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 34, '000000000039', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 35, '000000000040', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 36, '000000000041', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 37, '000000000042', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 38, '000000000043', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 39, '000000000044', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 40, '000000000045', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 41, '000000000046', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 42, '000000000047', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 43, '000000000048', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 44, '000000000049', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 1, 45, '000000000050', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 1, '000000000037', 3, 46);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 1, '000000000024', 1, 36);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 1, '000000000046', 2, 10);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 1, '000000000039', 1, 48);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 1, '000000000040', 1, 45);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 2, '000000000034', 2, 39);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 2, '000000000047', 1, 5);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 2, '000000000026', 1, 5);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 2, '000000000021', 3, 45);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 2, '000000000031', 1, 13);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 3, '000000000049', 3, 38);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 3, '000000000022', 1, 45);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 3, '000000000023', 2, 19);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 3, '000000000032', 1, 17);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 3, '000000000029', 1, 34);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 4, '000000000025', 3, 12);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 4, '000000000027', 1, 24);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 4, '000000000036', 2, 17);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 4, '000000000030', 1, 19);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 4, '000000000035', 1, 46);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 5, '000000000044', 3, 46);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 5, '000000000033', 2, 35);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 5, '000000000045', 1, 35);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 5, '000000000028', 1, 30);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 5, '000000000043', 1, 11);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 6, '000000000050', 2, 32);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 6, '000000000041', 1, 6);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 6, '000000000042', 3, 44);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 6, '000000000038', 1, 8);
INSERT INTO StageIncludeTrainee VALUE (2021, 2, 6, '000000000048', 1, 37);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 1, '000000000031', 2, 0);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 1, '000000000044', 1, 20);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 1, '000000000037', 1, 30);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 1, '000000000039', 3, 22);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 1, '000000000046', 1, 21);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 2, '000000000047', 2, 22);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 2, '000000000043', 1, 5);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 2, '000000000042', 3, 21);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 2, '000000000040', 1, 33);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 2, '000000000050', 1, 31);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 3, '000000000034', 3, 44);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 3, '000000000035', 1, 17);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 3, '000000000045', 1, 8);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 3, '000000000048', 2, 14);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 3, '000000000049', 1, 21);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 4, '000000000033', 3, 36);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 4, '000000000032', 2, 10);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 4, '000000000036', 1, 49);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 4, '000000000038', 1, 2);
INSERT INTO StageIncludeTrainee VALUE (2021, 3, 4, '000000000041', 1, 45);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 1, '000000000049', 3, 43);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 1, '000000000047', 1, 28);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 1, '000000000038', 2, 21);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 1, '000000000046', 1, 35);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 2, '000000000045', 2, 8);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 2, '000000000040', 1, 10);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 2, '000000000044', 3, 5);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 2, '000000000042', 1, 48);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 3, '000000000037', 3, 34);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 3, '000000000043', 1, 2);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 3, '000000000036', 2, 18);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 3, '000000000041', 1, 33);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 4, '000000000035', 3, 4);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 4, '000000000050', 1, 39);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 4, '000000000048', 1, 37);
INSERT INTO StageIncludeTrainee VALUE (2021, 4, 4, '000000000039', 2, 24);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 1, '000000000044', 2, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 1, '000000000046', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 1, '000000000050', 3, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 1, '000000000048', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 1, '000000000043', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 2, '000000000044', 1, 54);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 3, '000000000046', 1, 58);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 4, '000000000050', 1, 41);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 5, '000000000048', 1, 59);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 6, '000000000043', 1, 67);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 7, '000000000047', 3, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 7, '000000000042', 2, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 7, '000000000041', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 7, '000000000049', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 7, '000000000045', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 8, '000000000047', 1, 78);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 9, '000000000042', 1, 58);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 10, '000000000041', 1, 85);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 11, '000000000049', 1, 87);
INSERT INTO StageIncludeTrainee VALUE (2021, 5, 12, '000000000045', 1, 88);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 1, '000000000006', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 2, '000000000007', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 3, '000000000008', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 4, '000000000009', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 5, '000000000010', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 6, '000000000011', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 7, '000000000012', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 8, '000000000013', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 9, '000000000014', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 10, '000000000015', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 11, '000000000016', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 12, '000000000017', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 13, '000000000018', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 14, '000000000019', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 15, '000000000020', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 16, '000000000021', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 17, '000000000022', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 18, '000000000023', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 19, '000000000024', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 20, '000000000025', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 21, '000000000026', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 22, '000000000027', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 23, '000000000028', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 24, '000000000029', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 25, '000000000030', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 26, '000000000031', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 27, '000000000032', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 28, '000000000033', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 29, '000000000034', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 30, '000000000035', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 31, '000000000036', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 32, '000000000037', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 33, '000000000038', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 34, '000000000039', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 1, 35, '000000000040', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 1, '000000000036', 3, 8);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 1, '000000000040', 2, 31);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 1, '000000000022', 1, 8);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 1, '000000000038', 1, 28);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 1, '000000000016', 1, 34);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 2, '000000000039', 3, 29);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 2, '000000000025', 1, 21);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 2, '000000000030', 1, 31);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 2, '000000000014', 2, 9);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 2, '000000000018', 1, 47);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 3, '000000000026', 3, 46);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 3, '000000000012', 2, 10);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 3, '000000000037', 1, 27);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 3, '000000000027', 1, 48);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 3, '000000000020', 1, 27);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 4, '000000000021', 3, 16);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 4, '000000000023', 1, 41);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 4, '000000000034', 2, 14);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 4, '000000000035', 1, 11);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 4, '000000000015', 1, 36);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 5, '000000000032', 3, 10);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 5, '000000000024', 1, 9);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 5, '000000000019', 1, 48);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 5, '000000000017', 2, 35);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 5, '000000000029', 1, 16);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 6, '000000000028', 3, 8);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 6, '000000000011', 1, 36);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 6, '000000000033', 2, 48);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 6, '000000000031', 1, 15);
INSERT INTO StageIncludeTrainee VALUE (2022, 2, 6, '000000000013', 1, 28);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 1, '000000000040', 3, 42);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 1, '000000000026', 1, 25);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 1, '000000000023', 1, 13);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 1, '000000000035', 1, 8);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 1, '000000000039', 2, 1);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 2, '000000000036', 3, 6);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 2, '000000000037', 1, 47);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 2, '000000000032', 1, 33);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 2, '000000000021', 2, 27);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 2, '000000000034', 1, 25);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 3, '000000000031', 3, 11);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 3, '000000000027', 2, 30);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 3, '000000000033', 1, 29);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 3, '000000000038', 1, 2);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 3, '000000000029', 1, 47);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 4, '000000000030', 3, 31);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 4, '000000000025', 2, 9);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 4, '000000000028', 1, 38);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 4, '000000000022', 1, 25);
INSERT INTO StageIncludeTrainee VALUE (2022, 3, 4, '000000000024', 1, 35);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 1, '000000000027', 3, 35);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 1, '000000000036', 1, 2);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 1, '000000000025', 1, 45);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 1, '000000000031', 2, 17);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 2, '000000000028', 2, 21);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 2, '000000000040', 1, 1);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 2, '000000000034', 3, 18);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 2, '000000000033', 1, 26);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 3, '000000000032', 3, 18);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 3, '000000000039', 2, 19);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 3, '000000000030', 1, 32);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 3, '000000000035', 1, 4);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 4, '000000000037', 3, 33);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 4, '000000000038', 1, 45);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 4, '000000000026', 2, 4);
INSERT INTO StageIncludeTrainee VALUE (2022, 4, 4, '000000000029', 1, 48);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 1, '000000000034', 3, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 1, '000000000037', 2, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 1, '000000000033', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 1, '000000000032', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 1, '000000000038', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 2, '000000000034', 1, 62);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 3, '000000000037', 1, 80);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 4, '000000000033', 1, 56);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 5, '000000000032', 1, 79);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 6, '000000000038', 1, 77);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 7, '000000000036', 3, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 7, '000000000035', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 7, '000000000039', 2, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 7, '000000000040', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 7, '000000000031', 1, NULL);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 8, '000000000036', 1, 63);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 9, '000000000035', 1, 66);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 10, '000000000039', 1, 83);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 11, '000000000040', 1, 15);
INSERT INTO StageIncludeTrainee VALUE (2022, 5, 12, '000000000031', 1, 81);



-- ---------------------

-- 22. Group_mems
INSERT INTO Group_mems VALUE ('2020-4-A', 4, 1);
INSERT INTO Group_mems VALUE ('2020-4-B', 4, 2);
INSERT INTO Group_mems VALUE ('2020-4-C', 4, 3);
INSERT INTO Group_mems VALUE ('2020-4-D', 4, 4);

INSERT INTO Group_mems VALUE ('2021-4-A', 4, 5);
INSERT INTO Group_mems VALUE ('2021-4-B', 4, 6);
INSERT INTO Group_mems VALUE ('2021-4-C', 4, 7);
INSERT INTO Group_mems VALUE ('2021-4-D', 4, 1);

INSERT INTO Group_mems VALUE ('2022-4-A', 4, 2);
INSERT INTO Group_mems VALUE ('2022-4-B', 4, 5);
INSERT INTO Group_mems VALUE ('2022-4-C', 4, 1);
INSERT INTO Group_mems VALUE ('2022-4-D', 4, 7);

-- 23. GroupSignatureSong 
INSERT INTO GroupSignatureSong VALUE ('2020-4-A', 'Không thể cùng nhau suốt kiếp');
INSERT INTO GroupSignatureSong VALUE ('2020-4-B', 'Yêu 5');
INSERT INTO GroupSignatureSong VALUE ('2020-4-C', 'Simple love');
INSERT INTO GroupSignatureSong VALUE ('2020-4-D', 'Mặt trời của em');

INSERT INTO GroupSignatureSong VALUE ('2021-4-A', 'Legend never die');
INSERT INTO GroupSignatureSong VALUE ('2021-4-B', 'Nàng thơ');
INSERT INTO GroupSignatureSong VALUE ('2021-4-C', 'Bông hoa chẳng thuộc về ta');
INSERT INTO GroupSignatureSong VALUE ('2021-4-D', 'Nơi ta chờ em');

INSERT INTO GroupSignatureSong VALUE ('2022-4-A', 'Là bạn không thể yêu');
INSERT INTO GroupSignatureSong VALUE ('2022-4-B', 'Lạc trôi');
INSERT INTO GroupSignatureSong VALUE ('2022-4-C', 'Anh đã quen với cô đơn');
INSERT INTO GroupSignatureSong VALUE ('2022-4-D', 'Phía sau một cô gái');

-- 24. GuestSupportStage
INSERT INTO GuestSupportStage VALUE ('4', 2020, 4, 1);
INSERT INTO GuestSupportStage VALUE ('4', 2020, 4, 2);
INSERT INTO GuestSupportStage VALUE ('3', 2020, 4, 3);
INSERT INTO GuestSupportStage VALUE ('2', 2020, 4, 4);
INSERT INTO GuestSupportStage VALUE ('7', 2021, 4, 1);
INSERT INTO GuestSupportStage VALUE ('1', 2021, 4, 2);
INSERT INTO GuestSupportStage VALUE ('1', 2021, 4, 3);
INSERT INTO GuestSupportStage VALUE ('2', 2021, 4, 4);
INSERT INTO GuestSupportStage VALUE ('4', 2022, 4, 1);
INSERT INTO GuestSupportStage VALUE ('3', 2022, 4, 2);
INSERT INTO GuestSupportStage VALUE ('6', 2022, 4, 3);
INSERT INTO GuestSupportStage VALUE ('2', 2022, 4, 4);
