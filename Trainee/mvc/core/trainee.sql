drop database if exists trainee;
create database trainee;
use trainee;

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

-- 14. Season
create TABLE Season(
	year YEAR(4)    PRIMARY KEY,
    location        varchar(60),
    themesong_ID    VARCHAR(5)      UNIQUE,
    MC_SSN char(12)
);


-- 16. SeasonTrainee
create TABLE SeasonTrainee(
	year YEAR(4) ,
    SSN_trainee char(12),
    PRIMARY KEY(year, ssn_trainee)
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
    CONSTRAINT fk_Stage_Episode_year_ep_No FOREIGN KEY(year, ep_No) REFERENCES Episode(year, No) ON DELETE CASCADE
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

INSERT INTO Person VALUES ('000000000006', 'Nguyễn Văn', 'A', '40 Lý Thường Kiệt, Buôn Mê Thuột, Đắk Lắk', '0367834627');
INSERT INTO Person VALUES ('000000000007', 'Nguyễn Văn', 'B', '40 Lý Thường Kiệt, Buôn Mê Thuột, Đắk Lắk', '0237823728');
INSERT INTO Person VALUES ('000000000008', 'Nguyễn Văn', 'C', '64 Nguyễn Tất Thành, Pleiku, Gia Lai', '0478463287');
INSERT INTO Person VALUES ('000000000009', 'Nguyễn Thị', 'D', 'Đông Hòa, Dĩ An, Bình Dương', '0952455895');
INSERT INTO Person VALUES ('000000000010', 'Nguyễn Thị', 'E', '513 Phan Đình Phùng, phường Quang Trung, Kon Tum, Kon Tum', '0994885734');
INSERT INTO Person VALUES ('000000000011', 'Lê Văn', 'F', 'phường 13, quận 2, thành phố Hồ Chí Minh', '0345896255');
INSERT INTO Person VALUES ('000000000012', 'Lê Văn', 'G', '16 Lý Thái Tổ, phường Quang Trung, thành phố Đà Nẵng', '0345996255');
INSERT INTO Person VALUES ('000000000013', 'Lê Văn', 'H', '18 Lý Thái Tổ, phường Quang Trung, thành phố Đà Nẵng', '0323896255');
INSERT INTO Person VALUES ('000000000014', 'Lê Thị', 'I', 'thôn 3, xã Vũ Thư, huyện Kiến Xương, tỉnh Thái Bình', '0163857439');
INSERT INTO Person VALUES ('000000000015', 'Lê Thị', 'J', '45 Quang Trung, Đăk Hà, Kon Tum', '0473895261');
INSERT INTO Person VALUES ('000000000016', 'Vũ Văn', 'A', '45 Quang Trung, Đăk Hà, Kon Tum', '3223242434');
INSERT INTO Person VALUES ('000000000017', 'Vũ Văn', 'B', '46 Quang Trung, Đăk Hà, Kon Tum', '2323242366');
INSERT INTO Person VALUES ('000000000018', 'Vũ Văn', 'C', '47 Quang Trung, Đăk Hà, Kon Tum', '0998063452');
INSERT INTO Person VALUES ('000000000019', 'Vũ Thị', 'D', '48 Quang Trung, Đăk Hà, Kon Tum', '0423246345');
INSERT INTO Person VALUES ('000000000020', 'Vũ Thị', 'E', '49 Quang Trung, Đăk Hà, Kon Tum', '0324645734');
INSERT INTO Person VALUES ('000000000021', 'Vũ Thị', 'F', '50 Quang Trung, Đăk Hà, Kon Tum', '0343476352');
INSERT INTO Person VALUES ('000000000022', 'Trần Văn', 'A', '51 Quang Trung, Đăk Hà, Kon Tum', '0454624554');
INSERT INTO Person VALUES ('000000000023', 'Trần Văn', 'B', '52 Quang Trung, Đăk Hà, Kon Tum', '0897857134');
INSERT INTO Person VALUES ('000000000024', 'Trần Văn', 'C', '53 Quang Trung, Đăk Hà, Kon Tum', '0474564545');
INSERT INTO Person VALUES ('000000000025', 'Trần Thị', 'D', '54 Quang Trung, Đăk Hà, Kon Tum', '0342364663');
INSERT INTO Person VALUES ('000000000026', 'Trần Thị', 'E', '55 Quang Trung, Đăk Hà, Kon Tum', '0786678786');
INSERT INTO Person VALUES ('000000000027', 'Trần Thị', 'F', '56 Quang Trung, Đăk Hà, Kon Tum', '0726854573');
INSERT INTO Person VALUES ('000000000028', 'Phạm Văn', 'L', '57 Quang Trung, Đăk Hà, Kon Tum', '0564534354');
INSERT INTO Person VALUES ('000000000029', 'Phạm Văn', 'M', '58 Quang Trung, Đăk Hà, Kon Tum', '0534325474');
INSERT INTO Person VALUES ('000000000030', 'Phạm Văn', 'N', '59 Quang Trung, Đăk Hà, Kon Tum', '0124354432');
INSERT INTO Person VALUES ('000000000031', 'Phạm Thị', 'O', '60 Quang Trung, Đăk Hà, Kon Tum', '0454733542');
INSERT INTO Person VALUES ('000000000032', 'Phạm Thị', 'P', '61 Quang Trung, Đăk Hà, Kon Tum', '0365354643');
INSERT INTO Person VALUES ('000000000033', 'Phạm Thị', 'Q', '62 Quang Trung, Đăk Hà, Kon Tum', '0475353435');
INSERT INTO Person VALUES ('000000000034', 'Đặng Văn', 'R', '63 Quang Trung, Đăk Hà, Kon Tum', '0454634534');
INSERT INTO Person VALUES ('000000000035', 'Đặng Thị', 'S', '64 Quang Trung, Đăk Hà, Kon Tum', '0435475254');

INSERT INTO Person VALUES ('000000000036', 'Lê Đình', 'Thuận', '64 Quang Trung, Pleiku, Gia Lai', '0432375254');
INSERT INTO Person VALUES ('000000000037', 'Lê Đình', 'Huy', '65 Quang Trung, Pleiku, Gia Lai', '0527462537');
INSERT INTO Person VALUES ('000000000038', 'Lê Đình', 'Trí', '66 Quang Trung, Pleiku, Gia Lai', '0263674536');
INSERT INTO Person VALUES ('000000000039', 'Lê Đình', 'Minh', '67 Quang Trung, Pleiku, Gia Lai', '0437453846');
INSERT INTO Person VALUES ('000000000040', 'Lê Đình', 'Cường', '68 Quang Trung, Pleiku, Gia Lai', '0246463463');

INSERT INTO Person VALUES ('000000000041', 'Mạc Văn', 'A', '69 Quang Trung, Pleiku, Gia Lai', '0246467463');
INSERT INTO Person VALUES ('000000000042', 'Mạc Văn', 'B', '70 Quang Trung, Pleiku, Gia Lai', '0346679245');
INSERT INTO Person VALUES ('000000000043', 'Mạc Văn', 'C', '71 Quang Trung, Pleiku, Gia Lai', '0966564535');
INSERT INTO Person VALUES ('000000000044', 'Mạc Văn', 'D', '72 Quang Trung, Pleiku, Gia Lai', '0357534545');
INSERT INTO Person VALUES ('000000000045', 'Mạc Văn', 'E', '73 Quang Trung, Pleiku, Gia Lai', '0216793564');
INSERT INTO Person VALUES ('000000000046', 'Mạc Văn', 'F', '74 Quang Trung, Pleiku, Gia Lai', '0345683589');
INSERT INTO Person VALUES ('000000000047', 'Mạc Văn', 'G', '75 Quang Trung, Pleiku, Gia Lai', '0978546546');
INSERT INTO Person VALUES ('000000000048', 'Mạc Văn', 'H', '76 Quang Trung, Pleiku, Gia Lai', '0975316754');
INSERT INTO Person VALUES ('000000000049', 'Mạc Văn', 'I', '77 Quang Trung, Pleiku, Gia Lai', '0912365874');
INSERT INTO Person VALUES ('000000000050', 'Mạc Văn', 'J', '78 Quang Trung, Pleiku, Gia Lai', '0978434564');
INSERT INTO Person VALUES ('000000000051', 'Mạc Văn', 'K', '79 Quang Trung, Pleiku, Gia Lai', '0754675543');
INSERT INTO Person VALUES ('000000000052', 'Mạc Văn', 'L', '80 Quang Trung, Pleiku, Gia Lai', '0743544576');
INSERT INTO Person VALUES ('000000000053', 'Mạc Văn', 'M', '81 Quang Trung, Pleiku, Gia Lai', '0135467684');
INSERT INTO Person VALUES ('000000000054', 'Mạc Văn', 'N', '82 Quang Trung, Pleiku, Gia Lai', '0454531356');
INSERT INTO Person VALUES ('000000000055', 'Mạc Văn', 'O', '83 Quang Trung, Pleiku, Gia Lai', '0127557923');
INSERT INTO Person VALUES ('000000000056', 'Mạc Văn', 'P', '84 Quang Trung, Pleiku, Gia Lai', '0123451245');
INSERT INTO Person VALUES ('000000000057', 'Mạc Văn', 'Q', '85 Quang Trung, Pleiku, Gia Lai', '0124638876');
INSERT INTO Person VALUES ('000000000058', 'Mạc Văn', 'R', '86 Quang Trung, Pleiku, Gia Lai', '0125687854');
INSERT INTO Person VALUES ('000000000059', 'Mạc Văn', 'S', '87 Quang Trung, Pleiku, Gia Lai', '0135687564');
INSERT INTO Person VALUES ('000000000060', 'Mạc Văn', 'T', '88 Quang Trung, Pleiku, Gia Lai', '0797344543');

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

-- 14. Season
INSERT INTO Season VALUES (2020, 'Hà Nội', 'S1', '000000000000');
INSERT INTO Season VALUES (2021, 'Đà Nẵng', 'S2', '000000000000');
INSERT INTO Season VALUES (2022, 'TP.HCM', 'S3', '000000000001');
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
INSERT INTO Episode VALUE (2022, 5, 'Chung kết', '28-05-2022 19:00:00', 150);-- 19. Stage
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
