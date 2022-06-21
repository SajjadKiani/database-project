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

INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 0, 'Abel', '308-845-2517', '117-670-9189', 'http://ext.netf/thgut/wnb.aspx', 'Patrice', '327-606-7759', '738-318-8675', 'pfuo60@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 1, 'Erick', '329-637-1526', null, 'http://ovomk.net5/ziivj/mikqb.aspx', 'Oliver', '071-722-2174', '556-686-3581', 'fuyy.oinz@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 2, 'Janice', '660-705-7187', '915-443-4885', 'http://blagb.web64/qmxrg/rvcr.html', 'Harry', '414-331-3665', '484-815-5670', 'uvbf283@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 3, 'Gretchen', '701-353-3725', '331-434-1224', 'http://vlh.net4/cffnj/afb.aspx', 'Stacie', '551-157-0358', '333-128-1294', 'tbynq.dweggb@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 4, 'Lawanda', '854-774-2282', '554-380-7520', 'http://ise.local76/eawyg/hot.htm', 'Eugene', '986-747-6301', '713-337-1347', 'edwcy1@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 5, 'Robbie', '368-277-6644', '822-453-2221', 'http://iyg.net/ycpvn/dido.php', 'Joel', '126-431-4431', '745-844-7131', 'aupyg3@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 6, 'Carla', '596-590-8479', '671-410-8379', 'http://gyzne.web8/urszn/pff.htm', 'George', '424-142-5064', null, 'gqyd.ermwl@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 7, 'Heath', '884-908-8137', null, null, 'Lesley', '782-456-6992', '570-463-7448', 'gdgp6@example.com');
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 8, 'Kendra', '459-893-7727', '688-181-4204', 'http://xtt.nets2/rbgmd/yqp.aspx', 'Don', '280-811-2632', '167-247-7223', null);
INSERT INTO institution( institutionNo, institutionName, instTellNo, instFaxNo, instWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 9, 'Brandie', '601-244-5989', '612-723-8711', 'http://mkt.net/ghrfp/ycje.aspx', 'Dallas', '525-961-2743', '905-255-7242', 'fjij@example.com');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 0, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 1, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 2, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 3, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 4, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 5, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 6, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 7, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 8, 'null');
INSERT INTO positiontype( positionTypeNo, positionTypeDescription ) VALUES ( 9, 'null');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 0, 'Rapzapin Direct Company', '308 East White Second Drive', 'Fort Wayne', 'Illinois', '26974', '327-606-7759', '738-318-8675', 'http://lxgwi.web81/qbubg/ecr.php', 'Trenton', '446-368-3081', '460-046-8162', 'hmxb@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 1, 'Klibanollover WorldWide Company', '77 South Green Clarendon Freeway', 'Fort Wayne', 'Arizona', '73847', '071-722-2174', '556-686-3581', null, 'Rickey', '622-916-2623', '066-633-7178', 'ziuv5@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 2, 'Klierplar WorldWide Group', '33 South White Cowley Drive', 'Seattle', 'Arkansas', '33036', '414-331-3665', '484-815-5670', 'http://uvb.net/rngbl/aoi.php', 'Jeanne', '157-965-7154', '242-497-4736', null);
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 3, 'Unkiledax Holdings ', '48 North White New Street', 'Colorado', 'Florida', '62614', '551-157-0358', '333-128-1294', null, 'Daniel', '310-941-6982', '322-405-4506', 'fymm.fjev@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 4, 'Frozapanor Holdings Corp.', '124 East Rocky Nobel St.', 'Tulsa', 'Louisiana', '45384', '986-747-6301', '713-337-1347', 'http://din.net3/ixdhy/edw.php', 'Danielle', '018-820-0429', '560-864-4279', 'zjbose@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 5, 'Zeerobedor WorldWide Corp.', '371 South Green Fabien Way', 'St. Petersburg', 'Colorado', '74156', '126-431-4431', '745-844-7131', 'http://vmy.nety/imkve/feua.htm', 'Gerardo', '875-594-2336', '251-423-3858', 'vaef@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 6, 'Parvenepicator Holdings Inc', '381 North Green First Avenue', 'Omaha', 'Idaho', '73193', '424-142-5064', null, 'http://mqgl.net1/srzig/gpq.aspx', 'Tracie', '241-694-2558', null, 'ucfx2@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 7, 'Endglibamentor Holdings Company', '80 East Green Second Drive', 'Nashville', 'Washington', '98773', '782-456-6992', '570-463-7448', 'http://rpgk.neta06/drxdu/wdl.html', 'Gerardo', '781-024-4866', '132-122-7435', 'qyyymx6@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 8, 'Inhupimentor WorldWide Company', '485 North Green Hague Freeway', 'Baton Rouge', 'Illinois', '74717', '280-811-2632', '167-247-7223', 'http://dso.net/suzdu/vbp.htm', 'Katrina', '111-938-5645', '722-620-1445', 'fmju@example.com');
INSERT INTO prevcompany( prevCompanyNo, pCompanyName, pCompanyStreet, pCompanyCity, pCompanyState, pCompanyZipCode, pCompanyTellNo, pCompanyFaxNo, pCompanyWebAddress, contactName, contactTellNo, contactFaxNo, contactEmailAddress ) VALUES ( 9, 'Klinipentor WorldWide ', '67 South Green Second St.', 'Fort Worth', 'Nevada', '73805', '525-961-2743', '905-255-7242', 'http://ext.netf8/hauyb/rmq.html', 'Paul', '431-778-8586', '178-168-8759', 'gywv022@example.com');
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 0, '2014-08-14', '2014-08-16', 'null', 1568971868, 1568779461, 7);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 1, '2002-01-03', '2005-11-13', 'null', 1972923321, 189533491, 3);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 2, '2008-03-14', '2018-01-11', 'null', 1972693766, 1049914526, 5);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 3, '2008-02-24', '2000-01-31', 'null', 1459337896, 991787866, 2);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 4, '2004-02-26', '2009-12-08', 'null', 168336464, 963357709, 7);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 5, '2000-09-21', '2017-02-03', 'null', 53286715, 1498325847, 7);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 6, '2006-08-27', '2019-09-19', 'null', 1501631577, 596500747, 1);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 7, '2013-03-06', '2000-08-31', 'null', 1728588968, 1632003450, 2);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 8, '2019-05-10', '2017-02-21', 'null', 324768466, 470823983, 3);
INSERT INTO grade( gradeNo, validFromDate, validToDate, gradeDescription, gradeSalary, noDayLeave, positionTypeNo ) VALUES ( 9, '2014-03-19', '2018-06-18', 'null', 1985522669, 1976574038, 6);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 0, 'Abel', '308 East White Second Drive', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 1, 'Erick', '77 South Green Clarendon Freeway', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 2, 'Janice', '33 South White Cowley Drive', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 3, 'Gretchen', '48 North White New Street', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 4, 'Lawanda', '124 East Rocky Nobel St.', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 5, 'Robbie', '371 South Green Fabien Way', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 6, 'Carla', '381 North Green First Avenue', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 7, 'Heath', '80 East Green Second Drive', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 8, 'Kendra', '485 North Green Hague Freeway', null);
INSERT INTO department( departmentNo, departmentName, depLocation, mangeEmployeeNo ) VALUES ( 9, 'Brandie', '67 South Green Second St.', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 0, 'Dr', 'Latoya', 'Cisneros', '87 South White Milton Way', '269-473-4733', '571-658-8554', 'tjwsj@example.com', '901-24-5161', '2014-08-08', 0, 1568394742, 7, '2014-08-06', '2014-08-08', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 1, 'Miss', 'Casey', 'Blackburn', '814 South Rocky Second Road', '036-261-4538', null, 'vryhp.catwtl@example.com', '608-75-8279', '2005-01-20', 1, 917721094, 0, '2006-07-30', '2010-06-08', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 2, 'Dr.', 'Lakeisha', 'Byrd', '83 North Rocky Hague Parkway', '474-567-1939', '652-354-2364', 'tjgj.kfsv@example.com', '925-59-8330', '2015-04-30', 1, 1351839628, 2, '2008-11-21', '2018-09-20', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 3, 'Miss', 'Colleen', 'Miles', '43 North Rocky Second Drive', '877-747-7738', '423-133-6555', 'lnmxl43@example.com', '393-85-3479', '2016-04-28', 1, 56687741, 2, '2000-05-30', '2012-05-06', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 4, 'Dr', 'Alice', 'Ingram', '84 South Rocky First Freeway', '056-374-6440', '585-894-6265', 'kzvy@example.com', '420-13-2912', '2015-05-27', 0, 405916585, 4, '2001-01-09', '2006-10-22', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 5, 'Miss.', 'Bernard', 'Neal', '848 South Rocky Cowley Way', '813-571-3331', '374-263-1126', 'eybo.fonmsglfku@example.com', '865-87-9562', '2017-01-27', 1, 93436818, 0, '2015-04-01', '2011-08-14', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 6, 'Miss', 'Howard', 'White', '610 North Green Clarendon Freeway', '444-356-3977', '982-250-4599', 'ncqo.pcmweu@example.com', '182-20-5514', '2011-10-26', 0, 933722798, 9, '2014-05-27', '2007-06-19', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 7, 'Miss', 'Hector', 'Daniels', '475 North Green Nobel Avenue', '748-153-4170', '142-506-7825', 'rwbruy@example.com', '602-89-7858', '2019-11-16', 0, 1438832383, 6, '2003-03-23', '2010-09-17', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 8, 'Mr', 'Vernon', 'Barrera', '620 North Green New Blvd.', '173-658-9112', '879-332-6669', 'gwub.wbij@example.com', '748-23-8076', '2018-08-03', 1, 762934983, 0, '2008-03-16', '2005-12-28', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 9, 'Miss', 'Mike', 'Middleton', '47 South White Oak Avenue', '475-591-0816', '114-632-2519', null, '849-07-9234', '2002-11-20', 0, 1958676714, 9, '2017-03-23', '2001-06-21', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 10, 'Mr', 'Marissa', 'Haynes', '326 North White Hague Drive', '547-545-7728', '263-622-2560', 'qrhmagq33@example.com', '482-21-0683', '2007-10-14', 1, 280239121, 4, '2001-08-14', '2001-03-30', 9);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 11, 'Dr', 'Ruby', 'Garrett', '882 West White Milton Street', '586-554-9218', '343-817-1326', 'winf@example.com', '724-16-1646', '2007-01-18', 1, 1415714396, 0, '2019-01-17', '2005-01-17', 1);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 12, 'Miss.', 'Joni', 'Rodgers', '42 North Rocky Fabien Road', '594-727-3536', '655-118-2332', 'sjql7@example.com', '242-84-0669', '2011-11-02', 1, 383947147, 3, '2018-02-12', '2003-05-29', 1);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 13, 'Dr', 'Duane', 'Moreno', '232 East White Fabien Street', '661-085-8647', '967-315-1820', 'ikoe.ukbs@example.com', '321-56-6303', '2010-08-21', 0, 871785121, 1, '2014-05-12', '2001-07-27', 3);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 14, 'Ms', 'Harry', 'Ellison', '667 South Green Second Freeway', '200-333-3721', '963-696-6843', 'iibp79@example.com', '702-33-5233', '2011-08-08', 0, 1141024854, 4, '2008-01-02', '2010-09-13', 6);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 15, 'Miss.', 'Luz', 'Ryan', '62 East White First Road', '135-133-1118', '133-714-6256', 'qqkx.eqmj@example.com', '347-00-4067', '2002-06-25', 0, 1303157622, 8, '2008-03-07', '2013-11-27', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 16, 'Dr', 'Salvatore', 'Matthews', '30 West Green Hague Drive', '480-537-7725', '947-105-2813', 'lqxt@example.com', '522-34-2649', '2009-10-28', 1, 2130958456, 6, '2015-04-08', '2011-03-09', 9);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 17, 'Miss', 'Byron', 'Newman', '85 West Green Fabien Parkway', '745-417-8565', '354-895-4582', null, '155-37-8165', '2000-04-11', 0, 743780883, 6, '2011-04-23', '2018-01-13', 4);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 18, 'Miss.', 'Sammy', 'George', '786 North Rocky Fabien Parkway', '515-870-5144', '914-189-8365', null, '404-77-9172', '2018-01-27', 1, 392210057, 8, '2017-09-28', '2017-12-28', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 19, 'Dr', 'Anthony', 'Hoffman', '52 North Green First Boulevard', '226-381-9219', '132-307-8924', 'limrh@example.com', '705-27-5552', '2019-07-09', 0, 688193481, 9, '2004-05-29', '2005-09-28', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 20, 'Dr.', 'Sarah', 'Hayes', '79 West White Oak Avenue', '454-864-1616', '925-522-3168', 'zhbv.qssa@example.com', '742-18-5278', '2007-07-01', 1, 1976327424, 7, '2017-04-11', '2009-12-10', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 21, 'Dr', 'Gavin', 'Combs', '726 South Green Milton Avenue', '476-676-3361', '256-399-6347', 'wwktt895@example.com', '280-07-1564', '2014-06-11', 1, 1531579738, 5, '2002-07-11', '2006-06-19', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 22, 'Miss', 'Candice', 'Hess', '175 West Rocky Milton Road', '677-789-1260', '466-196-7357', null, '617-62-3423', '2001-12-05', 1, 1197711394, 7, '2019-06-02', '2006-04-20', 2);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 23, 'Dr.', 'Terrell', 'Morrison', '61 South Rocky Hague Parkway', '852-652-4103', '134-733-4783', 'tjjgy@example.com', '827-62-3346', '2009-10-21', 1, 564860760, 8, '2013-02-10', '2005-08-19', 4);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 24, 'Mr', 'Travis', 'Mack', '86 North Rocky New Way', '560-059-1751', '136-135-1153', 'huicn5@example.com', '288-89-8796', '2009-06-22', 1, 653068827, 9, '2001-04-09', '2012-06-03', 4);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 25, 'Miss.', 'Derek', 'Patterson', '947 South Green Second Drive', '698-942-7628', '587-715-1186', 'fdjyg@example.com', '567-65-0854', '2013-08-04', 0, 2063338478, 6, '2006-09-12', '2006-11-13', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 26, 'Mrs', 'Guy', 'Huffman', '64 South Rocky Milton Boulevard', '434-297-3082', null, 'bowy@example.com', '145-18-0314', '2007-06-13', 1, 455055205, 8, '2006-02-09', '2017-02-10', 5);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 27, 'Miss.', 'Kelley', 'Dunlap', '74 North Green Old Freeway', '726-857-7487', '820-256-2228', 'ulrvl.oedrbm@example.com', '490-37-1036', '2015-05-20', 0, 893081803, 3, '2004-06-05', '2012-08-22', 1);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 28, 'Mr', 'Cara', 'Hutchinson', '315 South Green New Drive', '785-465-3847', '883-633-1692', 'xxgn158@example.com', '923-37-6454', '2013-05-24', 0, 506940909, 3, '2018-12-07', '2004-10-11', 9);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 29, 'Miss.', 'Charles', 'Beltran', '173 North Green Cowley St.', '254-970-4356', '849-156-7128', null, '191-12-5394', '2015-08-04', 0, 2010088665, 3, '2017-12-29', '2006-03-11', 1);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 30, 'Miss.', 'Chris', 'Newton', '67 South Rocky Old Drive', '150-874-6531', '717-422-3470', 'uvrot7@example.com', '539-72-9524', '2004-05-18', 0, 1056778159, 6, '2008-11-11', '2000-07-01', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 31, 'Miss', 'Freddie', 'Mejia', '82 South Green Hague Road', '502-274-5888', null, null, '312-21-3982', '2014-12-06', 1, 2059022366, 8, '2016-07-25', '2015-05-04', 5);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 32, 'Dr.', 'Jennifer', 'Park', '86 South Rocky Old Boulevard', '676-811-6967', '577-915-4243', 'afvw@example.com', '271-45-3954', '2002-01-23', 1, 1684925964, 7, '2006-06-30', '2013-03-03', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 33, 'Dr.', 'Monte', 'Larson', '936 West Green Milton Drive', '833-177-6388', '417-827-9855', 'olnc.bgtbsx@example.com', '195-40-4813', '2007-02-25', 1, 575484648, 7, '2010-04-22', '2002-12-10', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 34, 'Dr.', 'Jeremiah', 'O''Neal', '73 North Green Hague Avenue', '771-581-8418', '041-666-2763', 'qlio@example.com', '118-64-0691', '2008-03-10', 0, 1006390200, 0, '2010-09-20', '2018-10-28', 2);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 35, 'Dr.', 'Cynthia', 'Sanford', '395 South Green Hague Drive', '174-739-2443', '415-347-4554', 'cpby8@example.com', '546-44-4521', '2011-05-11', 1, 1623209660, 9, '2009-06-02', '2000-11-14', 6);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 36, 'Dr.', 'Gilbert', 'Fletcher', '862 South Green Milton Parkway', '334-228-5318', '639-011-6427', 'ucwu@example.com', '367-39-8734', '2002-05-08', 1, 832897688, 0, '2019-09-28', '2001-09-11', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 37, 'Dr.', 'Bethany', 'Hicks', '364 North Rocky Clarendon St.', '243-786-3874', '264-190-8682', null, '265-55-5431', '2009-12-04', 0, 1347469937, 3, '2018-08-26', '2002-02-08', 7);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 38, 'Mrs.', 'Lonnie', 'Lara', '68 South Green First Freeway', '555-228-2975', '149-417-4115', 'hcvmtz.izxm@example.com', '352-21-8538', '2000-12-12', 0, 1565576552, 1, '2010-01-09', '2008-03-20', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 39, 'Dr.', 'Terri', 'Mcfarland', '366 East Rocky Cowley Road', '817-765-5592', '883-446-0285', 'qglgq.ithm@example.com', '545-54-6465', '2001-12-29', 1, 788288776, 8, '2014-03-14', '2000-01-18', 4);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 40, 'Miss', 'Candice', 'Flowers', '657 North Green Second Freeway', '465-723-5615', '987-528-4683', 'etqgm666@example.com', '869-37-8861', '2006-07-29', 0, 418257158, 4, '2002-11-29', '2000-08-28', 5);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 41, 'Dr', 'Ashley', 'Gates', '144 South Green Old Boulevard', '554-645-7178', '336-937-5469', 'hnxwx173@example.com', '767-55-4143', '2010-12-03', 1, 939771566, 8, '2011-11-18', '2006-02-28', 8);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 42, 'Mr', 'Darrick', 'Mcgrath', '81 East Green Old Way', '754-565-3406', '928-624-8818', 'jmte5@example.com', '927-77-2337', '2006-12-25', 1, 1189436654, 3, '2012-06-03', '2013-05-05', 5);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 43, 'Miss', 'Mindy', 'Carlson', '31 South Rocky Nobel St.', '568-418-2893', '517-628-1904', 'mwov51@example.com', '772-76-7371', '2002-01-16', 1, 417385569, 5, '2013-01-07', '2004-10-14', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 44, 'Dr', 'Jerome', 'Vincent', '343 South Green Cowley Blvd.', '515-688-1495', '387-241-2886', 'rqus@example.com', '773-28-2662', '2001-07-04', 1, 1806532593, 8, '2002-03-17', '2006-09-06', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 45, 'Miss.', 'Craig', 'Newman', '66 East Rocky Old Freeway', '032-144-5237', null, 'ihdu.pqnu@example.com', '353-77-9664', '2016-06-15', 0, 986322627, 4, '2006-02-27', '2013-11-17', 2);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 46, 'Ms', 'Chanda', 'Thompson', '534 North Green Fabien Freeway', '840-677-3574', '511-818-3248', 'kwdg@example.com', '223-06-4550', '2016-11-10', 0, 1676824622, 2, '2000-01-22', '2012-08-28', 6);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 47, 'Dr', 'Mickey', 'Hatfield', '243 North Rocky Oak Avenue', '714-415-8871', '737-531-2601', 'pqlzgl@example.com', '626-70-4288', '2013-01-03', 1, 888153875, 0, '2009-04-12', '2002-01-28', 6);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 48, 'Mr', 'Brad', 'Glenn', '76 East Green Milton Parkway', '765-757-0024', '856-930-4695', 'hkyt7@example.com', '827-10-5446', '2003-02-24', 1, 563460641, 9, '2017-04-14', '2001-09-06', 8);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 49, 'Ms', 'Lillian', 'Mills', '853 North Green Nobel Freeway', '292-374-8540', '313-553-9432', 'xvnq.wnix@example.com', '622-26-6187', '2004-11-07', 0, 367301367, 3, '2000-03-24', '2018-09-12', 7);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 50, 'Dr.', 'Alexander', 'Jordan', '602 North Rocky Clarendon Avenue', '063-441-5461', '685-432-1856', 'ssxno.qtmfs@example.com', '642-74-5634', '2011-05-05', 1, 762644840, 4, '2015-08-05', '2017-05-27', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 51, 'Dr', 'Betsy', 'Walters', '845 South White Second Avenue', '871-987-7665', '091-326-6868', 'pfaa8@example.com', '729-76-3758', '2003-07-20', 0, 1170150040, 7, '2012-07-29', '2000-10-21', 9);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 52, 'Miss', 'Ann', 'Bowman', '39 South Green Old Drive', '024-153-4735', '384-466-9617', 'qpev@example.com', '161-27-7687', '2002-06-09', 1, 1424366029, 9, '2018-11-03', '2001-07-16', 5);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 53, 'Dr', 'Jeanette', 'Ponce', '329 South Green Old Avenue', '704-243-3834', '666-323-4538', 'irnp1@example.com', '005-99-5446', '2017-06-12', 0, 36655637, 9, '2005-05-31', '2004-06-09', 1);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 54, 'Miss.', 'Tracie', 'Mc Guire', '57 North Green New Drive', '148-284-8559', '791-785-5531', 'llch@example.com', '500-31-3121', '2014-02-15', 1, 351602548, 6, '2005-09-28', '2007-01-11', null);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 55, 'Dr', 'Esther', 'Mckee', '652 North Rocky Fabien Drive', '759-544-8958', '342-128-1737', 'lxqp11@example.com', '501-48-3461', '2012-05-11', 0, 1868570729, 4, '2002-06-07', '2004-11-16', 8);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 56, 'Dr', 'Joann', 'Mooney', '74 West Green Hague Avenue', '782-664-3642', '235-721-1872', 'reew021@example.com', '213-30-6410', '2002-06-13', 0, 1495892907, 4, '2017-11-25', '2011-04-24', 8);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 57, 'Ms', 'Jesse', 'Stone', '266 West Green Milton Parkway', '204-331-8634', '513-028-8543', 'dlwc198@example.com', '787-80-2866', '2004-07-04', 1, 872429231, 4, '2017-03-18', '2012-09-06', 0);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 58, 'Mr', 'Marcos', 'Vargas', '93 West Green New Road', '899-881-6552', '454-122-8880', 'sxgdi35@example.com', '760-37-5622', '2003-08-05', 0, 547593247, 5, '2013-05-05', '2006-01-11', 7);
INSERT INTO employee( employeeNo, Title, firstName, lastName, address, workTelExt, homeTellNo, emplyeeEmailAddress, socialSecurityNumber, DOB, sex, salary, departmentNo, dateStarted, dateLeft, supervisorEmployeeNo ) VALUES ( 59, 'Miss', 'Kellie', 'Hart', '43 South Rocky Second Avenue', '848-355-1467', '531-568-2651', null, '142-23-6734', '2019-07-29', 1, 898527134, 2, '2006-08-15', '2001-05-02', 3);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 0, '2014-08-14', '2014-08-16', 'null', 0, 0, 0, 0, 7);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 1, '2002-01-03', '2005-11-13', 'null', 0, 1, 0, 0, 9);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 2, '2008-03-14', '2018-01-11', 'null', 0, 1, 0, 1, 5);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 3, '2008-02-24', '2000-01-31', 'null', 0, 1, 1, 0, 0);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 4, '2004-02-26', '2009-12-08', 'null', 1, 1, 1, 0, 1);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 5, '2000-09-21', '2017-02-03', 'null', 1, 0, 0, 1, 1);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 6, '2006-08-27', '2019-09-19', 'null', 0, 1, 0, 1, 8);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 7, '2013-03-06', '2000-08-31', 'null', 0, 0, 0, 0, 4);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 8, '2019-05-10', '2017-02-21', 'null', 1, 1, 1, 1, 5);
INSERT INTO post( postNo, availableFromDate, availableToDate, postDescription, salariedHourly, fullPartTime, temporaryPermanet, treeLaborStandardsActExempt, departmentNo ) VALUES ( 9, '2014-03-19', '2018-06-18', 'null', 0, 0, 0, 0, 2);
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 1, '2013-03-06', 0, '2011-07-03');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 6, '2008-02-24', 0, '2016-02-08');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 8, '2002-01-03', 2, '2011-04-01');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 6, '2004-02-26', 4, '2001-05-05');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 7, '2014-08-14', 7, '2014-08-15');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 3, '2000-09-21', 8, '2011-08-21');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 5, '2019-05-10', 8, '2004-07-18');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 2, '2008-03-14', 9, '2001-06-02');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 5, '2006-08-27', 9, '2015-05-13');
INSERT INTO gradepost( gradeNo, validFromDate, postNo, availableFromDate ) VALUES ( 7, '2014-03-19', 9, '2017-01-17');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 0, 7, '2014-08-16', '2014-08-15');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 0, 7, '2018-06-18', '2017-01-17');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 2, 0, '2017-02-03', '2011-08-21');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 4, 3, '2019-09-19', '2015-05-13');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 4, 9, '2017-02-21', '2004-07-18');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 5, 6, '2000-08-31', '2011-07-03');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 6, 1, '2005-11-13', '2011-04-01');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 7, 2, '2009-12-08', '2001-05-05');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 7, 4, '2000-01-31', '2016-02-08');
INSERT INTO position ( employeeNo, postNo, startDate, endDate ) VALUES ( 8, 4, '2018-01-11', '2001-06-02');
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 0, 'Abel', 1570126089, '2014-08-15', '2014-08-12', 7.3052003E11, 7);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 1, 'Colby', 1206768426, '2002-09-14', '2011-06-29', 2.83149009E11, 7);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 2, 'Robbie', 2120470094, '2011-08-21', '2004-05-09', 6.9771198E11, 7);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 3, 'Kristen', 573006458, '2008-11-12', '2005-08-10', 5.8317701E11, 3);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 4, 'Carla', 489965424, '2015-05-13', '2013-08-04', 2.77766996E11, 1);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 5, 'Heath', 160618523, '2011-07-03', '2005-09-08', 7.5996103E11, 2);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 6, 'Erick', 1935844031, '2011-04-01', '2018-02-24', 8.8258396E10, 3);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 7, 'Lawanda', 1840659869, '2001-05-05', '2018-05-16', 4.48598016E11, 7);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 8, 'Janice', 1066918395, '2001-06-02', '2018-05-17', 4.88905015E11, 5);
INSERT INTO qualification( employeeNo, qualificationName, gradeObtained, startQualDate, endQualDate, gpa, institutionNo ) VALUES ( 9, 'Keri', 876785566, '2000-08-05', '2016-02-06', 3.92875999E11, 8);
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 0, 2, '2007-07-20', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 1, 4, '2001-02-18', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 1, 4, '2018-12-25', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 1, 6, '2005-07-03', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 1, 9, '2004-12-11', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 2, 1, '2017-02-03', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 2, 1, '2019-10-01', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 2, 5, '2015-09-15', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 2, 9, '2002-03-20', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 2, 9, '2004-07-24', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 4, 2, '2019-09-19', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 4, 5, '2008-03-01', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 4, 9, '2017-02-21', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 5, 2, '2013-10-31', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 5, 3, '2011-01-28', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 5, 7, '2000-08-31', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 5, 8, '2017-01-12', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 6, 5, '2005-11-13', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 6, 9, '2014-11-11', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 7, 3, '2000-01-31', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 7, 5, '2010-05-26', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 7, 8, '2009-12-08', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 8, 2, '2000-08-10', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 8, 3, '2018-01-11', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 8, 5, '2009-01-21', 'null');
INSERT INTO review( reviewedEmployeeNo, reviewerEmployeeNo, reviewDate, comments ) VALUES ( 9, 4, '2016-10-21', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 7, ' labor ', 4, 931887446, '763 North Rocky Milton Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 9, 'recruiting manager', 1, 744779428, '555 North Green Second Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 10, 'recruiting manager ', 7, 215421193, '983 West Green Fabien St.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 12, ' labor ', 9, 609522754, '85 South Green Hague Boulevard', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 13, ' researcher ', 8, 2068491577, '755 East Rocky First Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 19, ' admin ', 1, 744779428, '555 North Green Second Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 32, ' admin ', 4, 210034349, '117 East Green Milton Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 33, 'recruiting manager ', 3, 1453298028, '913 East Green Oak Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 40, ' admin ', 7, 1211828256, '274 East White Old Street', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 43, 'recruiting manager ', 5, 1780390841, '863 North Green Hague Street', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 44, 'recruiting manager ', 1, 720234895, '470 North White Milton Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 52, ' labor ', 1, 1373173900, '28 North White Oak Blvd.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 54, ' researcher ', 4, 1790854556, '211 South Green Milton Blvd.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 55, 'recruiting manager ', 5, 346071680, '817 North White Second Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 0, 59, 'recruiting manager ', 9, 162785424, '468 South Green Fabien Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 2, 'recruiting manager ', 1, 1735123306, '846 South Green Old Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 4, ' labor ', 9, 1863032905, '529 South Rocky Hague Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 7, 'labor', 5, 7260017, '84 South Green Milton Blvd.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 8, ' labor ', 3, 433525975, '623 South Green Clarendon Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 17, ' admin ', 6, 581144195, '61 East Green New Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 20, ' labor ', 5, 1266429491, '85 North White Nobel Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 21, ' researcher ', 8, 1225068593, '673 East Green Hague Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 29, ' admin ', 0, 1646299576, '23 West Rocky New St.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 1, 37, 'recruiting manager ', 9, 971355902, '55 South Green Fabien Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 2, ' researcher ', 3, 1613937925, '851 North Green Oak Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 3, 'researcher', 0, 610849826, '644 North Green Old Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 8, ' labor ', 4, null, '46 East White Milton Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 14, 'recruiting manager ', 0, null, '23 North Green Second Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 18, ' admin ', 8, 1082593066, '36 East Green New Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 21, ' labor ', 0, 1576521936, '261 South White Nobel Street', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 25, 'recruiting manager ', 8, 1852914687, '62 North Rocky First Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 40, 'recruiting manager ', 1, 1804305905, '24 North Green Milton Street', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 45, ' labor ', 0, 610849826, '644 North Green Old Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 2, 47, 'recruiting manager ', 2, 143064377, '393 East White Old Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 1, 'admin', 5, 324768466, '92 South Green New Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 2, 'recruiting manager ', 5, 318109936, '718 North Green First Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 6, 'recruiting manager ', 9, 189367377, '89 South Green First Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 8, ' labor ', 5, 324768466, '92 South Green New Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 19, 'recruiting manager ', 7, 1927677104, '71 East Rocky New Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 21, 'recruiting manager ', 2, 370032389, '22 East Green Hague Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 27, 'recruiting manager ', 4, 1829503477, '88 North Green Old St.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 29, 'recruiting manager ', 3, null, '18 North Green Nobel Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 40, 'recruiting manager ', 2, 604869432, '16 East Green Hague Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 43, 'recruiting manager ', 2, 644189511, '36 South White First St.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 46, ' admin ', 4, 2013003626, '350 East Green Second Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 3, 48, 'recruiting manager ', 8, 968749031, '40 East White Milton Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 4, 2, 'admin', 4, 1844398615, '227 South Green Hague Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 4, 3, ' labor ', 7, 1031313272, '200 North Rocky Cowley Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 4, 14, 'recruiting manager ', 4, 1844398615, '227 South Green Hague Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 4, 29, 'recruiting manager ', 5, 964389720, '24 South Rocky Fabien Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 4, 31, ' labor ', 1, 2094808833, '352 North White Hague Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 2, 'recruiting manager', 7, 902843160, '647 North Rocky Old Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 5, 'recruiting manager ', 1, 806239115, '86 North Green Hague Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 25, ' labor ', 5, 967088503, '291 South Green Old Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 47, 'recruiting manager ', 9, 889421171, '218 North Green Hague Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 48, ' admin ', 1, 2104357929, '958 North White New Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 49, 'recruiting manager ', 7, 902843160, '647 North Rocky Old Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 52, ' labor ', 2, 774137726, '548 North Rocky New Boulevard', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 5, 58, 'recruiting manager ', 5, 2139161008, '137 South White New Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 1, ' researcher ', 3, 1158526307, '403 South Green New Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 2, 'recruiting manager ', 0, 1734358423, '35 North Green Hague Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 8, 'researcher', 0, 1716279577, '69 West Green Second Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 9, ' labor ', 3, 741448024, '95 South White Milton Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 11, ' researcher ', 1, 1887453251, '877 North Rocky Hague Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 13, 'recruiting manager ', 2, 625805014, '437 South Green Nobel Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 20, ' researcher ', 7, 1759693936, '45 East White Clarendon Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 28, ' researcher ', 1, 1655657808, '66 South Rocky Milton Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 41, ' labor ', 3, 1251995926, '70 East Green Nobel Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 45, 'recruiting manager ', 8, 53286715, '774 East Green Second Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 46, ' researcher ', 0, 757621159, '236 South Green New St.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 56, 'recruiting manager ', 9, null, '42 East White Milton Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 6, 59, 'recruiting manager ', 0, 1716279577, '69 West Green Second Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 0, 'labor', 7, 1948991452, '269 North White Nobel Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 1, 'recruiting manager ', 4, 196029808, '243 North Green Fabien Street', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 14, 'recruiting manager ', 0, 1206401873, '854 North White Milton Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 33, ' labor ', 8, 1768772963, '31 North White New Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 34, 'recruiting manager ', 3, 530692573, '384 West Rocky New Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 35, ' admin ', 5, null, '527 South Green Second Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 37, 'recruiting manager ', 2, 242962476, '57 East White Milton Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 38, ' labor ', 4, 1017195237, '74 North Green Milton Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 46, ' admin ', 2, 529101544, '73 North Green Hague Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 51, ' admin ', 7, 1948991452, '269 North White Nobel Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 53, ' researcher ', 5, 2010256746, '662 South Green Hague Street', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 56, 'recruiting manager ', 1, null, '437 South White First Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 58, ' labor ', 9, 1696866454, '66 East Green Nobel Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 7, 59, 'recruiting manager ', 2, 1476452632, '746 West Rocky Second Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 1, ' researcher ', 7, 1797931491, '41 West White Oak Parkway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 5, 'admin', 5, 1972693766, '673 North Green New Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 7, ' admin ', 2, null, '238 West White Hague St.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 12, 'recruiting manager ', 5, 819377368, '28 North Green Second Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 15, 'recruiting manager ', 8, 881441175, '268 North Rocky Nobel Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 20, ' researcher ', 0, 567143928, '627 North Green First Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 35, 'recruiting manager ', 8, 1678515937, '53 East White First Avenue', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 38, ' researcher ', 5, 1694318720, '71 East Green Clarendon Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 47, 'recruiting manager ', 5, 1972693766, '673 North Green New Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 53, 'recruiting manager ', 7, 1747945137, '785 East Green Oak Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 8, 59, ' labor ', 4, 583585742, '925 East White Hague Blvd.', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 4, 'recruiting manager ', 5, 696909558, '563 North Green Nobel Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 6, 'recruiting manager ', 0, 1412873037, '65 North White Milton Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 16, 'recruiting manager ', 4, 1917884299, '77 West White Clarendon Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 23, 'recruiting manager ', 1, null, '31 North Green Oak Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 30, 'recruiting manager ', 3, 318304442, '673 North Green Oak Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 32, ' admin ', 2, 1345876718, '35 East Rocky Second Way', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 35, 'recruiting manager ', 0, 894156697, '52 East White Milton Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 44, ' labor ', 1, 653546486, '634 West Green Hague Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 45, 'recruiting manager ', 4, 1065924815, '29 South Green Second Drive', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 48, 'recruiting manager ', 9, 1551391347, '39 East Green Clarendon Road', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 50, 'recruiting manager ', 5, 1487734309, '381 South Rocky Old Freeway', 'null');
INSERT INTO workhistory( prevCompanyNo, employeeNo, prevPostition, prevGrade, prevSalary, prevLocation, prevResponsibilities ) VALUES ( 9, 54, ' admin ', 3, 2000389839, '43 South Green Milton Street', 'null');
