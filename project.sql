-- CREATE SCHEMA human_resource;

CREATE TABLE institution ( 
	institutionNo        int  NOT NULL    PRIMARY KEY,
	institutionName      text  NOT NULL    ,
	instTellNo           text  NOT NULL    ,
	instFaxNo            text      ,
	instWebAddress       text      ,
	contactName          text  NOT NULL    ,
	contactTellNo        text  NOT NULL    ,
	contactFaxNo         text      ,
	contactEmailAddress  text      
 );

CREATE TABLE positiontype ( 
	positionTypeNo       int  NOT NULL    PRIMARY KEY,
	positionTypeDescription text  NOT NULL    
 );

CREATE TABLE prevcompany ( 
	prevCompanyNo        int  NOT NULL    PRIMARY KEY,
	pCompanyName         text  NOT NULL    ,
	pCompanyStreet       text  NOT NULL    ,
	pCompanyCity         text  NOT NULL    ,
	pCompanyState        text  NOT NULL    ,
	pCompanyZipCode      text  NOT NULL    ,
	pCompanyTellNo       text  NOT NULL    ,
	pCompanyFaxNo        text      ,
	pCompanyWebAddress   text      ,
	contactName          text  NOT NULL    ,
	contactTellNo        text  NOT NULL    ,
	contactFaxNo         text      ,
	contactEmailAddress  text      
 );

CREATE TABLE grade ( 
	gradeNo              int  NOT NULL    ,
	validFromDate        date  NOT NULL    ,
	validToDate          date  NOT NULL    ,
	gradeDescription     text  NOT NULL    ,
	gradeSalary          int  NOT NULL    ,
	noDayLeave           int  NOT NULL    ,
	positionTypeNo       int  NOT NULL    ,
	CONSTRAINT pk_grade PRIMARY KEY ( gradeNo, validFromDate, validToDate ),
	CONSTRAINT unq_grade_gradeno UNIQUE ( gradeNo ) ,
	CONSTRAINT fk_grade_positiontype FOREIGN KEY ( positionTypeNo ) REFERENCES positiontype( positionTypeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT
 );

CREATE INDEX fk_grade_positiontype ON grade ( positionTypeNo );

CREATE TABLE department ( 
	departmentNo         int  NOT NULL    PRIMARY KEY,
	departmentName       text  NOT NULL    ,
	depLocation          text  NOT NULL    ,
	mangeEmployeeNo      int      
 );

CREATE INDEX mangeEmployeeNo ON department ( mangeEmployeeNo );

CREATE TABLE employee ( 
	employeeNo           int  NOT NULL    PRIMARY KEY,
	Title                text  NOT NULL    ,
	firstName            text  NOT NULL    ,
	lastName             text  NOT NULL    ,
	address              text  NOT NULL    ,
	workTelExt           text  NOT NULL    ,
	homeTellNo           text      ,
	emplyeeEmailAddress  text      ,
	socialSecurityNumber text  NOT NULL    ,
	DOB                  date  NOT NULL    ,
	sex                  boolean  NOT NULL    ,
	salary               int  NOT NULL    ,
	departmentNo         int  NOT NULL    ,
	dateStarted          date  NOT NULL    ,
	dateLeft             date  NOT NULL    ,
	supervisorEmployeeNo int      
 );

CREATE INDEX departmentNo ON employee ( departmentNo );

CREATE INDEX fk_employee_employee ON employee ( supervisorEmployeeNo );

CREATE TABLE gradepost ( 
	gradeNo              int  NOT NULL    ,
	validFromDate        date  NOT NULL    ,
	postNo               int  NOT NULL    ,
	availableFromDate    date  NOT NULL    ,
	CONSTRAINT pk_gradepost PRIMARY KEY ( gradeNo, validFromDate, postNo, availableFromDate )
 );

CREATE INDEX fk_gradepost_post ON gradepost ( postNo );

CREATE TABLE position ( 
	employeeNo           int  NOT NULL    ,
	postNo               int  NOT NULL    ,
	startDate            date  NOT NULL    ,
	endDate              date  NOT NULL    ,
	CONSTRAINT pk_position PRIMARY KEY ( employeeNo, postNo, startDate )
 );

CREATE INDEX employeeNo ON position ( employeeNo, postNo );

CREATE INDEX postNo ON position ( postNo );

CREATE TABLE post ( 
	postNo               int  NOT NULL    ,
	availableFromDate    date  NOT NULL    ,
	availableToDate      date  NOT NULL    ,
	postDescription      text  NOT NULL    ,
	salariedHourly       boolean  NOT NULL    ,
	fullPartTime         boolean  NOT NULL    ,
	temporaryPermanet    boolean  NOT NULL    ,
	treeLaborStandardsActExempt boolean  NOT NULL    ,
	departmentNo         int  NOT NULL    ,
	CONSTRAINT pk_post PRIMARY KEY ( postNo, availableFromDate ),
	CONSTRAINT postNo UNIQUE ( postNo ) 
 );

CREATE INDEX departmentNo ON post ( departmentNo );

CREATE TABLE qualification ( 
	employeeNo           int  NOT NULL    PRIMARY KEY,
	qualificationName    text  NOT NULL    ,
	gradeObtained        int  NOT NULL    ,
	startQualDate        date  NOT NULL    ,
	endQualDate          date  NOT NULL    ,
	gpa                  float(12,0)  NOT NULL    ,
	institutionNo        int  NOT NULL    
 );

CREATE INDEX institutionNo ON qualification ( institutionNo );

CREATE TABLE review ( 
	reviewedEmployeeNo   int  NOT NULL    ,
	reviewerEmployeeNo   int  NOT NULL    ,
	reviewDate           date  NOT NULL    ,
	comments             text  NOT NULL    ,
	CONSTRAINT pk_review PRIMARY KEY ( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate )
 );

CREATE INDEX reviewedEmployeeNo ON review ( reviewedEmployeeNo, reviewerEmployeeNo );

CREATE INDEX reviewerEmployeeNo ON review ( reviewerEmployeeNo );

CREATE TABLE workhistory ( 
	prevCompanyNo        int  NOT NULL    ,
	employeeNo           int  NOT NULL    ,
	prevPostition        text  NOT NULL    ,
	prevGrade            int  NOT NULL    ,
	prevSalary           int      ,
	prevLocation         text  NOT NULL    ,
	prevResponsibilities text  NOT NULL    ,
	CONSTRAINT pk_workhistory PRIMARY KEY ( prevCompanyNo, employeeNo )
 );

CREATE INDEX fk_workhistory_employee ON workhistory ( employeeNo );

CREATE INDEX fk_workhistory_grade ON workhistory ( prevGrade );

ALTER TABLE department ADD CONSTRAINT Department_ibfk_1 FOREIGN KEY ( mangeEmployeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE employee ADD CONSTRAINT Employee_ibfk_2 FOREIGN KEY ( departmentNo ) REFERENCES department( departmentNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE employee ADD CONSTRAINT fk_employee_employee FOREIGN KEY ( supervisorEmployeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE gradepost ADD CONSTRAINT fk_gradepost_grade FOREIGN KEY ( gradeNo ) REFERENCES grade( gradeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE gradepost ADD CONSTRAINT fk_gradepost_post FOREIGN KEY ( postNo ) REFERENCES post( postNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE position ADD CONSTRAINT Position_ibfk_1 FOREIGN KEY ( employeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE position ADD CONSTRAINT Position_ibfk_2 FOREIGN KEY ( postNo ) REFERENCES post( postNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE post ADD CONSTRAINT Post_ibfk_1 FOREIGN KEY ( departmentNo ) REFERENCES department( departmentNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE qualification ADD CONSTRAINT Qualification_ibfk_1 FOREIGN KEY ( employeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE qualification ADD CONSTRAINT Qualification_ibfk_2 FOREIGN KEY ( institutionNo ) REFERENCES institution( institutionNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE review ADD CONSTRAINT Review_ibfk_1 FOREIGN KEY ( reviewedEmployeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE review ADD CONSTRAINT Review_ibfk_2 FOREIGN KEY ( reviewerEmployeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE workhistory ADD CONSTRAINT fk_workhistory_employee FOREIGN KEY ( employeeNo ) REFERENCES employee( employeeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE workhistory ADD CONSTRAINT fk_workhistory_grade FOREIGN KEY ( prevGrade ) REFERENCES grade( gradeNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE workhistory ADD CONSTRAINT fk_workhistory_prevcompany FOREIGN KEY ( prevCompanyNo ) REFERENCES prevcompany( prevCompanyNo ) ON DELETE RESTRICT ON UPDATE RESTRICT;