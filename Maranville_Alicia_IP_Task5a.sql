-- TASK 5A: Statements for all queries

IF OBJECT_ID('EnterTeam', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterTeam; -- Drop the procedure
END;
GO

IF OBJECT_ID('EnterClient', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterClient; -- Drop the procedure
END;
GO

IF OBJECT_ID('EnterVolunteer', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterVolunteer; -- Drop the procedure
END;
GO

IF OBJECT_ID('EnterVolunteerHours', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterVolunteerHours; -- Drop the procedure
END;
GO

IF OBJECT_ID('EnterEmployee', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterEmployee; -- Drop the procedure
END;
GO

IF OBJECT_ID('EnterEmployeeExpense', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterEmployeeExpense; -- Drop the procedure
END;
GO

IF OBJECT_ID('EnterDonorWithDonations', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE EnterDonorWithDonations; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetDoctorInfoByClient', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetDoctorInfoByClient; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetExpensesByTime', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetExpensesByTime; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetVolunteersByClient', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetVolunteersByClient; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetTeamsByDate', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetTeamsByDate; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetPeople', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetPeople; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetDonorEmployees', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetDonorEmployees; -- Drop the procedure
END;
GO

IF OBJECT_ID('IncreaseSalary', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE IncreaseSalary; -- Drop the procedure
END;
GO

IF OBJECT_ID('DeleteClients', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE DeleteClients; -- Drop the procedure
END;
GO

IF OBJECT_ID('GetMailingList', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE GetMailingList; -- Drop the procedure
END;
GO

-- QUERY 1: Enter a new team into the database
CREATE PROCEDURE EnterTeam
@team_name VARCHAR(100),
@team_type VARCHAR(50),
@date_formed DATE
AS
BEGIN
    INSERT INTO team (team_name, team_type, date_formed)
    VALUES (@team_name, @team_type, @date_formed);
END;
GO


-- QUERY 2: Enter a new client into the database and associate him or her with one or more teamsEnter a new client into the database and associate him or her with one or more teams
CREATE PROCEDURE EnterClient
@person_name VARCHAR(100),
@SSN CHAR(11),
@gender VARCHAR(6),
@profession VARCHAR(100),
@mailing_address VARCHAR(250),
@email_address VARCHAR(100),
@phone_number CHAR(10),
@inMailingList BIT,
@doctor_name VARCHAR(100),
@doctor_phone_number CHAR(10),
@date_assigned DATE,
@needs NVARCHAR(MAX), -- List of clients need in form need:value,...
@insurances NVARCHAR(MAX), -- List of insurance in form policyID,name,address,type|...
@teams NVARCHAR(MAX) -- List of team names to associate client with
AS
BEGIN
    -- Insert into person table
    IF NOT EXISTS (SELECT 1 FROM person WHERE SSN = @SSN)
    BEGIN
        INSERT INTO person (person_name, SSN, gender, profession, mailing_address, email_address, phone_number, inMailingList)
        VALUES (@person_name, @SSN, @gender, @profession, @mailing_address, @email_address, @phone_number, @inMailingList);
    END

    -- Insert into client table
    IF NOT EXISTS (SELECT 1 FROM client WHERE SSN = @SSN)
    BEGIN
        INSERT INTO client (SSN, doctor_name, doctor_phone_number, date_assigned)
        VALUES (@SSN, @doctor_name, @doctor_phone_number, @date_assigned);

        -- Insert clients needs to need table
        DECLARE @need NVARCHAR(200);
        DECLARE @need_name NVARCHAR(100);
        DECLARE @importance_value NVARCHAR(20);
        WHILE CHARINDEX(',', @needs) > 0 -- Iterate over list of needs need:value
        BEGIN
            SET @need = LEFT(@needs, CHARINDEX(',', @needs) - 1);
            SET @needs = SUBSTRING(@needs, CHARINDEX(',', @needs) + 1, LEN(@needs));
            SET @need_name = LEFT(@need, CHARINDEX(':', @need) - 1); 
            SET @importance_value = SUBSTRING(@need, CHARINDEX(':', @need) + 1, LEN(@need) - CHARINDEX(':', @need)); 
            
            -- Insert into need table
            INSERT INTO need (SSN, need_name, importance_value)
            VALUES (@SSN, @need_name, @importance_value);
        END;  

        IF LEN(@needs) > 0 -- May be one entry left without comma at end
        BEGIN
            SET @need = @needs;
            SET @need_name = LEFT(@need, CHARINDEX(':', @need) - 1);
            SET @importance_value = SUBSTRING(@need, CHARINDEX(':', @need) + 1, LEN(@need) - CHARINDEX(':', @need));

            -- Insert into need table
            INSERT INTO need (SSN, need_name, importance_value)
            VALUES (@SSN, @need_name, @importance_value);
        END;

        -- Insert clients insurance to insurance table
        DECLARE @insurance NVARCHAR(500);
        DECLARE @pos INT;
        DECLARE @delim CHAR(1) = '|';

        WHILE LEN(@insurances) > 0
        BEGIN
            SET @pos = CHARINDEX(@delim, @insurances);
            IF @pos > 0
            BEGIN
                SET @insurance = LEFT(@insurances, @pos - 1);
                SET @insurances = SUBSTRING(@insurances, @pos + 1, LEN(@insurances));
            END
            ELSE
            BEGIN
                SET @insurance = @insurances;
                SET @insurances = '';
            END
            DECLARE @policy_ID VARCHAR(20),
                    @provider_name VARCHAR(50),
                    @provider_address VARCHAR(250),
                    @insurance_type VARCHAR(6)
            SET @policy_ID = SUBSTRING(@insurance, 1, CHARINDEX(',', @insurance) - 1);  
            SET @insurance = SUBSTRING(@insurance, CHARINDEX(',', @insurance) + 1, LEN(@insurance));

            SET @provider_name = SUBSTRING(@insurance, 1, CHARINDEX(',', @insurance) - 1); 
            SET @insurance = SUBSTRING(@insurance, CHARINDEX(',', @insurance) + 1, LEN(@insurance)); 

            SET @provider_address = SUBSTRING(@insurance, 1, CHARINDEX(',', @insurance) - 1);
            SET @insurance = SUBSTRING(@insurance, CHARINDEX(',', @insurance) + 1, LEN(@insurance)); 

            SET @insurance_type = @insurance; 

            INSERT INTO insurance (policy_ID, provider_name, provider_address, insurance_type, SSN)
            VALUES (@policy_ID, @provider_name, @provider_address, @insurance_type, @SSN)
        END

        -- Associate client with teams through 'cares' table
        DECLARE @team_name NVARCHAR(100);
        WHILE CHARINDEX(',', @teams) > 0 -- Iterate over list of teams
        BEGIN
            SET @team_name = LEFT(@teams, CHARINDEX(',', @teams) - 1); -- Extracts first team name
            SET @teams = SUBSTRING(@teams, CHARINDEX(',', @teams) + 1, LEN(@teams)); -- Removes processed team from list

            INSERT INTO cares (client_SSN, team_name, isActive)
            VALUES (@SSN, @team_name, 1);
        END;

        -- Associate with last team
        IF LEN(@teams) > 0 -- May be one left without comma at end
        BEGIN
            INSERT INTO cares (client_SSN, team_name, isActive)
            VALUES (@SSN, @teams, 1);
        END;
    END
    ELSE
    BEGIN
        PRINT 'Client already exists'
    END
END;
GO


-- QUERY 3: Enter a new volunteer into the database and associate him or her with one or more teams
CREATE PROCEDURE EnterVolunteer
@person_name VARCHAR(100),
@SSN CHAR(11),
@gender VARCHAR(6),
@profession VARCHAR(100),
@mailing_address VARCHAR(250),
@email_address VARCHAR(100),
@phone_number CHAR(10),
@inMailingList BIT,
@date_joined DATE,
@last_training_date DATE,
@last_training_location VARCHAR(250),
@teams_roles NVARCHAR(MAX) -- List of team names and roles to associate volunteer with (format name1:role1,name2:role2,...)
AS
BEGIN
    -- Insert into person table
    IF NOT EXISTS (SELECT 1 FROM person WHERE SSN = @SSN)
    BEGIN
        INSERT INTO person (person_name, SSN, gender, profession, mailing_address, email_address, phone_number, inMailingList)
        VALUES (@person_name, @SSN, @gender, @profession, @mailing_address, @email_address, @phone_number, @inMailingList);
    END

    -- Insert into volunteer table
    IF NOT EXISTS (SELECT 1 FROM volunteer WHERE SSN = @SSN)
    BEGIN
        INSERT INTO volunteer (SSN, date_joined, last_training_date, last_training_location)
        VALUES (@SSN, @date_joined, @last_training_date, @last_training_location);

        -- Associate volunteer with teams through either 'serves' or 'leads' tables
        DECLARE @team_role NVARCHAR(200);
        DECLARE @team_name NVARCHAR(100);
        DECLARE @role NVARCHAR(20);
        WHILE CHARINDEX(',', @teams_roles) > 0 -- Iterate over list of teams:roles
        BEGIN
            SET @team_role = LEFT(@teams_roles, CHARINDEX(',', @teams_roles) - 1); -- Extracts first pair team:role
            SET @teams_roles = SUBSTRING(@teams_roles, CHARINDEX(',', @teams_roles) + 1, LEN(@teams_roles));
            SET @team_name = LEFT(@team_role, CHARINDEX(':', @team_role) - 1); -- Extracts team name from team:role
            SET @role = SUBSTRING(@team_role, CHARINDEX(':', @team_role) + 1, LEN(@team_role) - CHARINDEX(':', @team_role)); -- Extracts role from team:role
            
            -- Insert into table based on role
            IF @role = 'leads'
            BEGIN
                INSERT INTO leads (volunteer_SSN, team_name, leads_hours, isActive)
                VALUES (@SSN, @team_name, 0, 1); -- Inital 0 hours
            END
            ELSE IF @role = 'serves'
            BEGIN
                INSERT INTO serves (volunteer_SSN, team_name, serves_hours, isActive)
                VALUES (@SSN, @team_name, 0, 1); -- Initial 0 hours
            END
        END;

        -- Associate with last team
        IF LEN(@teams_roles) > 0 -- May be one entry left without comma at end
        BEGIN
            SET @team_role = @teams_roles;
            SET @team_name = LEFT(@team_role, CHARINDEX(':', @team_role) - 1);
            SET @role = SUBSTRING(@team_role, CHARINDEX(':', @team_role) + 1, LEN(@team_role) - CHARINDEX(':', @team_role));

            -- Insert into table based on role
            IF @role = 'leads'
            BEGIN
                INSERT INTO leads (volunteer_SSN, team_name, leads_hours, isActive)
                VALUES (@SSN, @team_name, 0, 1); -- Initial 0 hours
            END
            ELSE IF @role = 'serves'
            BEGIN
                INSERT INTO serves (volunteer_SSN, team_name, serves_hours, isActive)
                VALUES (@SSN, @team_name, 0, 1); -- Initial 0 hours
            END
        END;
    END;
END;
GO


-- QUERY 4: Enter the number of hours a volunteer worked this month for a particular team
CREATE PROCEDURE EnterVolunteerHours
@volunteer_SSN CHAR(11),
@team_name VARCHAR(100),
@hours INT
AS
BEGIN
    -- Try to insert into the 'leads' table first
    IF EXISTS (SELECT 1 FROM leads WHERE volunteer_SSN = @volunteer_SSN AND team_name = @team_name)
    BEGIN
        -- Insert into the 'leads' table (volunteer is leading on this team)
        UPDATE leads
        SET leads_hours = leads_hours + @hours -- Add to existing hours if applicable
        WHERE volunteer_SSN = @volunteer_SSN AND team_name = @team_name;
    END
    ELSE IF EXISTS (SELECT 1 FROM serves WHERE volunteer_SSN = @volunteer_SSN AND team_name = @team_name)
    BEGIN
        -- Insert into the 'serves' table (volunteer is serving on this team)
        UPDATE serves
        SET serves_hours = serves_hours + @hours -- Add to existing hours if applicable
        WHERE volunteer_SSN = @volunteer_SSN AND team_name = @team_name;
    END
    ELSE
    BEGIN
        PRINT 'Volunteer is not currently assigned to the given team. Please ensure they are properly assigned first.';
    END
END;
GO


-- QUERY 5: Enter a new employee into the database and associate him or her with one or more teams
CREATE PROCEDURE EnterEmployee
@person_name VARCHAR(100),
@SSN CHAR(11),
@gender VARCHAR(6),
@profession VARCHAR(100),
@mailing_address VARCHAR(250),
@email_address VARCHAR(100),
@phone_number CHAR(10),
@inMailingList BIT,
@salary DECIMAL(10, 2),
@marital_status VARCHAR(10),
@hire_date DATE,
@teams NVARCHAR(MAX) -- List of team names to associate employee with
AS
BEGIN
    -- Insert into person table
    IF NOT EXISTS (SELECT 1 FROM person WHERE SSN = @SSN)
    BEGIN
        INSERT INTO person (person_name, SSN, gender, profession, mailing_address, email_address, phone_number, inMailingList)
        VALUES (@person_name, @SSN, @gender, @profession, @mailing_address, @email_address, @phone_number, @inMailingList);
    END

    -- Insert into employee table
    IF NOT EXISTS (SELECT 1 FROM employee WHERE SSN = @SSN)
    BEGIN
        INSERT INTO employee (SSN, salary, marital_status, hire_date)
        VALUES (@SSN, @salary, @marital_status, @hire_date);

    -- Associate employee with teams through 'reports' table
    DECLARE @team_name NVARCHAR(100);
    WHILE CHARINDEX(',', @teams) > 0 -- Iterate over list of teams
    BEGIN
        SET @team_name = LEFT(@teams, CHARINDEX(',', @teams) - 1); -- Extracts first team name
        SET @teams = SUBSTRING(@teams, CHARINDEX(',', @teams) + 1, LEN(@teams)); -- Removes processed team from list

        INSERT INTO reports (employee_SSN, team_name)
        VALUES (@SSN, @team_name);
    END;

    -- Associate with last team
    IF LEN(@teams) > 0 -- May be one left without comma at end
    BEGIN
        INSERT INTO reports (employee_SSN, team_name)
        VALUES (@SSN, @teams);
    END;
    END;
END;
GO


-- QUERY 6: Enter an expense charged by an employee
CREATE PROCEDURE EnterEmployeeExpense
@SSN CHAR(11),
@amount DECIMAL(10, 2),
@expense_description VARCHAR(250),
@expense_date DATE
AS
BEGIN
    INSERT INTO expense (SSN, amount, expense_description, expense_date)
    VALUES (@SSN, @amount, @expense_description, @expense_date);
END;
GO


-- QUERY 7: Enter a new donor and associate with donations
CREATE PROCEDURE EnterDonorWithDonations
@person_name NVARCHAR(100),
@SSN CHAR(11),
@gender NVARCHAR(6),
@profession NVARCHAR(100),
@mailing_address NVARCHAR(250),
@email_address NVARCHAR(100),
@phone_number CHAR(10),
@inMailingList BIT,
@isAnon BIT,
@donations NVARCHAR(MAX)
AS
BEGIN
    -- Insert into Person table if doesn't exist
    IF NOT EXISTS (SELECT 1 FROM person WHERE SSN = @SSN)
    BEGIN
        INSERT INTO person (SSN, person_name, gender, profession, mailing_address, email_address, phone_number, inMailingList)
        VALUES (@SSN, @person_name, @gender, @profession, @mailing_address, @email_address, @phone_number, @inMailingList);
    END

    -- Insert into Donor table
    IF NOT EXISTS (SELECT 1 FROM donor WHERE SSN = @SSN)
    BEGIN
        INSERT INTO donor (SSN, isAnon)
        VALUES (@SSN, @isAnon);

    -- Associate donor with donations (check or card)
    DECLARE @donation NVARCHAR(500);
    DECLARE @pos INT;
    DECLARE @delim CHAR(1) = '|';

    WHILE LEN(@donations) > 0
    BEGIN
        SET @pos = CHARINDEX(@delim, @donations);
        IF @pos > 0
        BEGIN
            SET @donation = LEFT(@donations, @pos - 1);
            SET @donations = SUBSTRING(@donations, @pos + 1, LEN(@donations));
        END
        ELSE
        BEGIN
            SET @donation = @donations;
            SET @donations = '';
        END

        DECLARE @donation_date DATE,
                @amount DECIMAL(10, 2),
                @donation_type NVARCHAR(50),
                @campaign NVARCHAR(100),
                @check_number NVARCHAR(50) = NULL,
                @card_number CHAR(16) = NULL,
                @card_type NVARCHAR(20) = NULL,
                @card_expiration_date DATE = NULL;
        SET @donation_date = CONVERT(DATE, SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1));  -- First part: donation_date
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove donation_date part

        SET @amount = CONVERT(DECIMAL(10, 2), SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1)); -- Second part: amount
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove amount part

        SET @donation_type = SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1); -- Third part: donation_type
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove donation_type part

        SET @campaign = SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1); -- Fourth part: campaign
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove campaign part

        SET @check_number = SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1); -- Fifth part: check_number (could be NULL)
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove check_number part

        SET @card_number = SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1); -- Sixth part: card_number (could be NULL)
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove card_number part

        SET @card_type = SUBSTRING(@donation, 1, CHARINDEX(',', @donation) - 1); -- Seventh part: card_type (could be NULL)
        SET @donation = SUBSTRING(@donation, CHARINDEX(',', @donation) + 1, LEN(@donation)); -- Remove card_type part

        SET @card_expiration_date = CONVERT(DATE, @donation); -- Eighth part: card_expiration_date

        IF @donation_type = 'Check'
        BEGIN
            INSERT INTO check_donation (SSN, donation_date, amount, donation_type, campaign, check_number)
            VALUES (@SSN, @donation_date, @amount, @donation_type, @campaign, @check_number);
        END
        ELSE
        BEGIN
            INSERT INTO card_donation (SSN, donation_date, amount, donation_type, campaign, card_number, card_type, card_expiration_date)
            VALUES (@SSN, @donation_date, @amount, @donation_type, @campaign, @card_number, @card_type, @card_expiration_date);
        END
    END;
    END;
END;
GO


-- QUERY 8: Retrieve the name and phone number of the doctor of a particular client 
CREATE PROCEDURE GetDoctorInfoByClient
@SSN CHAR(11)
AS
BEGIN
    -- Retrieve the doctor's name and phone number for the specified client
    SELECT doctor_name, doctor_phone_number
    FROM client
    WHERE SSN = @SSN;
END;
GO


-- QUERY 9: Retrieve the total amount of expenses charged by each employee for a particular period of time
CREATE PROCEDURE GetExpensesByTime
@start_date DATE,
@end_date DATE
AS
BEGIN
    SELECT e.SSN, SUM(amount) AS total_expenses
    FROM expense e
    WHERE expense_date BETWEEN @start_date AND @end_date
    GROUP BY e.SSN
    ORDER BY total_expenses DESC;
END;
GO

-- QUERY 10: Retrieve the list of volunteers that are members of teams that support a particular client
CREATE PROCEDURE GetVolunteersByClient
@SSN CHAR(11)
AS
BEGIN
    SELECT v.SSN, v.date_joined
    FROM serves s
    JOIN cares c ON s.team_name = c.team_name
    JOIN volunteer v ON s.volunteer_SSN = v.SSN
    WHERE c.client_SSN = @SSN

    UNION

    -- Select volunteers from 'leads' table
    SELECT v.SSN, v.date_joined
    FROM leads l
    JOIN cares c ON l.team_name = c.team_name
    JOIN volunteer v ON l.volunteer_SSN = v.SSN
    WHERE c.client_SSN = @SSN;
END;
GO

-- QUERY 11: Retrieve the names of all teams that were founded after a particular date
CREATE PROCEDURE GetTeamsByDate
@date DATE
AS
BEGIN
    SELECT team_name
    FROM team
    WHERE date_formed > @date;
END;
GO


-- QUERY 12: Retrieve the names, social security numbers, contact information, and emergency contact information of all people in the database
CREATE PROCEDURE GetPeople
AS
BEGIN
    SELECT p.person_name, p.SSN, p.email_address, p.phone_number
    FROM person p;
END;
GO


-- QUERY 13: Retrieve the name and total amount donated by donors that are also employees
CREATE PROCEDURE GetDonorEmployees
AS
BEGIN
    SELECT p.person_name, 
        d.SSN, 
        SUM(ISNULL(cd.amount, 0) + ISNULL(chd.amount, 0)) AS total_donations, 
        d.isAnon
    FROM donor d
    JOIN person p ON d.SSN = p.SSN
    LEFT JOIN card_donation cd ON d.SSN = cd.SSN
    LEFT JOIN check_donation chd ON d.SSN = chd.SSN
    WHERE d.SSN IN (SELECT SSN FROM employee)
    GROUP BY p.person_name, d.SSN, d.isAnon
    ORDER BY total_donations DESC;
END;
GO



-- QUERY 14: Increase the salary by 10% of all employees to whom more than one team must report
CREATE PROCEDURE IncreaseSalary
AS
BEGIN
    UPDATE employee
    SET salary = salary * 1.10
    WHERE SSN IN (
        SELECT employee_SSN
        FROM reports
        GROUP BY employee_SSN
        HAVING COUNT(DISTINCT team_name) > 1
    );
END;
GO


-- QUERY 15: Delete all clients who do not have health insurance and whose value of importance for transportation is less than 5
CREATE PROCEDURE DeleteClients
AS
BEGIN
    DELETE FROM client
    WHERE SSN NOT IN (
            SELECT SSN 
            FROM insurance 
            WHERE insurance_type = 'Health'
        ) 
    AND SSN IN (
        SELECT SSN
        FROM need
        WHERE need_name = 'transportation' AND importance_value < 5
    );
END;
GO

-- QUERY 17: Retrieve names and mailing addresses of people in mailing list
CREATE PROCEDURE GetMailingList
AS
BEGIN
    SELECT person_name, mailing_address
    FROM person
    WHERE inMailingList = 1;
END;
GO