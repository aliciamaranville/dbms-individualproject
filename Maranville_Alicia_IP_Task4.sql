-- TASK 4: Creating tables and indices

-- DROP EXISTING TABLES

DROP TABLE IF EXISTS card_donation;
DROP TABLE IF EXISTS check_donation;
DROP TABLE IF EXISTS donor;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS serves;
DROP TABLE IF EXISTS leads;
DROP TABLE IF EXISTS cares;
DROP TABLE IF EXISTS team;
DROP TABLE IF EXISTS expense;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS volunteer;
DROP TABLE IF EXISTS insurance;
DROP TABLE IF EXISTS need;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS emergency_contact;
DROP TABLE IF EXISTS person;


-- CREATE TABLES / INDICES

CREATE TABLE person(
    person_name VARCHAR(100),
    SSN CHAR(11),
    gender VARCHAR(6) CHECK (gender = 'Male' OR gender = 'Female'),
    profession VARCHAR(100),
    mailing_address VARCHAR(250),
    email_address VARCHAR(100),
    phone_number CHAR(10),
    inMailingList BIT, -- 1 is in, 0 is not in
    PRIMARY KEY (SSN)
);


CREATE TABLE emergency_contact(
    SSN CHAR(11),
    contact_name VARCHAR(100),
    phone_number CHAR(10),
    relation VARCHAR(50),
    PRIMARY KEY (SSN, contact_name),
    FOREIGN KEY (SSN) REFERENCES person ON DELETE CASCADE
);


CREATE TABLE client(
    SSN CHAR(11) PRIMARY KEY,
    doctor_name VARCHAR(100),
    doctor_phone_number CHAR(10),
    date_assigned DATE -- yyyy-MM-dd
    FOREIGN KEY (SSN) REFERENCES person ON DELETE CASCADE
);
CREATE INDEX idx_client_SSN ON client(SSN);


CREATE TABLE need(
    SSN CHAR(11),
    need_name VARCHAR(50),
    importance_value INT CHECK (importance_value > -1 AND importance_value < 11),
    PRIMARY KEY (SSN, need_name),
    FOREIGN KEY (SSN) REFERENCES client ON DELETE CASCADE
);
CREATE INDEX idx_need_name ON need(need_name);
CREATE INDEX idx_importance_value ON need(importance_value);


CREATE TABLE insurance(
    policy_ID VARCHAR(20) PRIMARY KEY,
    provider_name VARCHAR(50),
    provider_address VARCHAR(250),
    insurance_type VARCHAR(6) CHECK (insurance_type = 'Life' OR insurance_type = 'Health' OR insurance_type = 'Home' OR insurance_type = 'Auto'),
    SSN CHAR(11),
    FOREIGN KEY (SSN) REFERENCES client ON DELETE CASCADE
);
CREATE INDEX idx_insurance_type on insurance(insurance_type);


CREATE TABLE volunteer(
    SSN CHAR(11) PRIMARY KEY,
    date_joined DATE,
    last_training_date DATE,
    last_training_location VARCHAR(250),
    FOREIGN KEY (SSN) REFERENCES person ON DELETE CASCADE
);
CREATE INDEX idx_volunteer_SSN ON volunteer(SSN);


CREATE TABLE employee(
    SSN CHAR(11) PRIMARY KEY,
    salary DECIMAL(10, 2),
    marital_status VARCHAR(10),
    hire_date DATE,
    FOREIGN KEY (SSN) REFERENCES person ON DELETE CASCADE
);
CREATE INDEX idx_employee_SSN on employee(SSN);


CREATE TABLE expense(
    SSN CHAR(11),
    amount DECIMAL(10,2),
    expense_description VARCHAR(250),
    expense_date DATE,
    PRIMARY KEY (SSN, expense_date),
    FOREIGN KEY (SSN) REFERENCES employee ON DELETE CASCADE
);
CREATE INDEX idx_expense_date ON expense(expense_date);


CREATE TABLE team(
    team_name VARCHAR(100) PRIMARY KEY,
    team_type VARCHAR(50),
    date_formed DATE
);
CREATE INDEX idx_team_date_formed ON team(date_formed);


CREATE TABLE cares(
    client_SSN CHAR(11),
    team_name VARCHAR(100),
    isActive BIT, -- 1 is active, 0 is inactive
    PRIMARY KEY (client_SSN, team_name),
    FOREIGN KEY (client_SSN) REFERENCES client(SSN) ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name) ON DELETE CASCADE
);
CREATE INDEX idx_cares_client_team ON cares(client_SSN, team_name);


CREATE TABLE leads (
    volunteer_SSN CHAR(11),
    team_name VARCHAR(100),
    leads_hours INT,
    isActive BIT, -- 1 is active, 0 is inactive
    PRIMARY KEY (volunteer_SSN, team_name),
    FOREIGN KEY (volunteer_SSN) REFERENCES volunteer(SSN) ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name) ON DELETE CASCADE
);
CREATE INDEX idx_leads_volunteer_team ON leads (volunteer_SSN, team_name);


CREATE TABLE serves (
    volunteer_SSN CHAR(11),
    team_name VARCHAR(100),
    serves_hours INT,
    isActive BIT, -- 1 is active, 0 is inactive
    PRIMARY KEY (volunteer_SSN, team_name),
    FOREIGN KEY (volunteer_SSN) REFERENCES volunteer(SSN) ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name) ON DELETE CASCADE
);
CREATE INDEX idx_serves_volunteer_team ON serves (volunteer_SSN, team_name);


CREATE TABLE reports (
    employee_SSN CHAR(11),
    team_name VARCHAR(100),
    report_date DATE,
    report_description VARCHAR(250),
    PRIMARY KEY (employee_SSN, team_name),
    FOREIGN KEY (employee_SSN) REFERENCES employee(SSN) ON DELETE CASCADE,
    FOREIGN KEY (team_name) REFERENCES team(team_name) ON DELETE CASCADE
);
CREATE INDEX idx_reports_employee_team ON reports(employee_SSN, team_name);


CREATE TABLE donor (
    SSN CHAR(11) PRIMARY KEY,
    isAnon BIT, -- 1 for anon, 0 for not
    FOREIGN KEY (SSN) REFERENCES person(SSN) ON DELETE CASCADE
);
CREATE INDEX idx_donor_SSN ON donor (SSN);


CREATE TABLE check_donation (
    SSN CHAR(11),
    donation_date DATE,
    amount DECIMAL(10, 2),
    donation_type VARCHAR(50),
    campaign VARCHAR(100),
    check_number VARCHAR(50),
    PRIMARY KEY (SSN, donation_date),
    FOREIGN KEY (SSN) REFERENCES donor ON DELETE CASCADE
);
CREATE INDEX idx_check_donation_date ON check_donation(SSN, donation_date);


CREATE TABLE card_donation (
    SSN CHAR(11),
    donation_date DATE,
    amount DECIMAL(10, 2),
    donation_type VARCHAR(50),
    campaign VARCHAR(100),
    card_number CHAR(16),
    card_type VARCHAR(20),
    card_expiration_date DATE,
    PRIMARY KEY (SSN, donation_date),
    FOREIGN KEY (SSN) REFERENCES donor(SSN) ON DELETE CASCADE
);
CREATE INDEX idx_card_donation_date ON card_donation(SSN, donation_date);

