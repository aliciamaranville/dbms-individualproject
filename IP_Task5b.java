package org.dbms.group54;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import java.util.Scanner;
import java.util.logging.Logger;
import java.io.*;

public class IP_Task5b {
    private static final Logger log; // Logger for the application

    static {
        System.setProperty("java.util.logging.SimpleFormatter.format", "[%4$-7s] %5$s %n"); // Set log format
        log = Logger.getLogger(IP_Task5b.class.getName()); // Initialize the logger
    }

    public static void main(String[] args) throws Exception {
        log.info("Starting the application"); // Log application start
        log.info("Loading application properties"); // Log loading properties

        Properties properties = new Properties(); // Load database properties
        properties.load(IP_Task5b.class.getClassLoader().getResourceAsStream("application.properties")); // Load properties file

        log.info("Connecting to the database"); // Log database connection attempt
        Connection connection = DriverManager.getConnection(properties.getProperty("url"), properties); // Establish connection
        log.info("Database connection test: " + connection.getCatalog()); // Test the connection

        Scanner keyboard = new Scanner(System.in); // Initialize scanner for user input
        int query = 0; // Initialize query input variable
        
        System.out.println("WELCOME TO THE PATIENT ASSISTANT NETWORK DATABASE SYSTEM\n\nChoose an option:\n"); // Prompt user
        System.out.println("(1) Enter a new team into the database\n(2) Enter a new client into the database and associate him or her with one or more teams\n(3) Enter a new volunteer into the database and associate him or her with one or more teams");
        System.out.println("(4) Enter the number of hours a volunteer worked this month for a particular team\n(5) Enter a new employee into the database and associate him or her with one or more teams\n(6) Enter an expense charged by an employee");
        System.out.println("(7) Enter a new donor and associate him or her with several donations\n(8) Retrieve the name and phone number of the doctor of a particular client\n(9) Retrieve the total amount of expenses charged by each employee for a particular period of\n"
        		+ "time\n(10) Retrieve the list of volunteers that are members of teams that support a particular client\n(11) Retrieve the names of all teams that were founded after a particular date\n(12) Retrieve the names, social security numbers, contact information, and emergency contact\n"
        		+ "information of all people in the database \n(13) Retrieve the name and total amount donated by donors that are also employees.\n(14) Increase the salary by 10% of all employees to whom more than one team must report\n(15) Delete all clients who do not have health insurance and whose value of importance for\n"
        		+ "transportation is less than 5\n(16) Import: enter new teams from a data file until the file is empty\n(17) Export: Retrieve names and mailing addresses of all people on the mailing list and\n"
        		+ "output them to a data file \n(18) Quit.\n");

        while (query != 18) { // Loop until user selects option 18
        	System.out.println("Choose an option (1-18): ");
            query = keyboard.nextInt(); // Get user input

            switch (query) { // Handle different query options
                case 1:
                    executeQuery1(connection, keyboard); // Execute query 1
                    break;
                case 2:
                	executeQuery2(connection, keyboard); // Execute query 2
                    break;
                case 3:
                    executeQuery3(connection, keyboard); // Execute query 3
                    break;
                case 4:
                    executeQuery4(connection, keyboard); // Execute query 4
                    break;
                case 5:
                    executeQuery5(connection, keyboard); // Execute query 5
                    break;
                case 6:
                    executeQuery6(connection, keyboard); // Execute query 6
                    break;
                case 7:
                    executeQuery7(connection, keyboard); // Execute query 7
                    break;
                case 8:
                    executeQuery8(connection, keyboard); // Execute query 8
                    break;
                case 9:
                    executeQuery9(connection, keyboard); // Execute query 9
                    break;
                case 10:
                    executeQuery10(connection, keyboard); // Execute query 10
                    break;
                case 11:
                    executeQuery11(connection, keyboard); // Execute query 11
                    break;
                case 12:
                    executeQuery12(connection); // Execute query 12
                    break;
                case 13:
                    executeQuery13(connection); // Execute query 13
                    break;
                case 14:
                    executeQuery14(connection); // Execute query 14
                    break;
                case 15:
                    executeQuery15(connection); // Execute query 15
                    break;
                case 16:
                    executeImportTeams(connection, keyboard); // Execute query 15
                    break;
                case 17:
                    executeExportMailing(connection, keyboard); // Execute query 15
                    break;
                case 18:
                    System.out.println("Terminating program."); // Exit program
                    break;
                default:
                    System.out.println("Invalid option. Please select a valid option (1-18)."); // Handle invalid input
            }
        }

        connection.close(); // Close database connection
    }

    private static void executeQuery1(Connection connection, Scanner keyboard) { 
    	keyboard.nextLine();
    	System.out.println("Enter team name: "); // Getting team name
        String teamName = keyboard.nextLine(); 

        System.out.println("Enter team type: "); // Getting team type
        String teamType = keyboard.next(); 

        System.out.println("Enter date formed in format yyyy-MM-dd: "); // Getting date formed
        String dateFormed = keyboard.next();
        
        
	    String sql = "{call EnterTeam(?, ?, ?)}"; // Prepare the SQL call for the procedure
	    try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, teamName); 
	        stmt.setString(2, teamType);
	        stmt.setString(3, dateFormed); 
	
	        stmt.execute(); // Execute the stored procedure
	        
	        System.out.println("Team inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
	    } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }

    private static void executeQuery2(Connection connection, Scanner keyboard) { 

    	keyboard.nextLine();
    	System.out.println("Enter client's name: "); // Getting name
        String personName = keyboard.nextLine(); 

        System.out.println("Enter client's SSN: "); // Getting SSN
        String SSN = keyboard.next(); 

        System.out.println("Enter client's gender: "); // Getting gender
        String gender = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter client's profession: "); // Getting profession
        String profession = keyboard.nextLine();
        
        keyboard.nextLine();
        System.out.println("Enter client's mailing address: "); // Getting mail address
        String mailingAddress = keyboard.nextLine();
        
        System.out.println("Enter client's email address: "); // Getting email address
        String emailAddress = keyboard.next();
        
        System.out.println("Enter client's phone number: "); // Getting phone number
        String phoneNumber = keyboard.next();
        
        System.out.println("Is client in mailing list? 1 for yes, 0 for no: "); // Getting mailing list
        int inMailingList = keyboard.nextInt();
        
        keyboard.nextLine();
        System.out.println("Enter client's doctor's name: "); // Getting doctor name
        String doctorName = keyboard.nextLine();
        
        System.out.println("Enter client's doctor's phone number: "); // Getting doctor phone
        String doctorPhone = keyboard.next();
        
        System.out.println("Enter client's date assign to doctor in yyyy-MM-dd format: "); // Getting date assigned
        String dateAssigned = keyboard.next();
        
        System.out.println("Enter client's needs in need1:value1,need2:value2,... format: "); // Getting needs
        String needs = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter client's insurances in policyID1,name1,address1,type1|policyID2,name2,address2,type2|.. format "); // Getting insurance
        String insurances = keyboard.nextLine();
        
        System.out.println("Enter client's teams in team1,team2,... format "); // Getting teams
        String teams = keyboard.nextLine();

        String sql = "{call EnterClient(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, personName); 
	        stmt.setString(2, SSN);
	        stmt.setString(3, gender); 
	        stmt.setString(4, profession);
	        stmt.setString(5, mailingAddress);
	        stmt.setString(6, emailAddress);
	        stmt.setString(7, phoneNumber);
	        stmt.setInt(8, inMailingList);
	        stmt.setString(9, doctorName);
	        stmt.setString(10, doctorPhone);
	        stmt.setString(11, dateAssigned);
	        stmt.setString(12, needs);
	        stmt.setString(13, insurances);
	        stmt.setString(14, teams);
	
	        stmt.execute(); // Execute the stored procedure
	        System.out.println("Client inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }

    private static void executeQuery3(Connection connection, Scanner keyboard) { 
    	keyboard.nextLine();
    	System.out.println("Enter volunteer's name: "); // Getting name
        String personName = keyboard.nextLine(); 

        System.out.println("Enter volunteer's SSN: "); // Getting SSN
        String SSN = keyboard.next(); 

        System.out.println("Enter volunteer's gender: "); // Getting gender
        String gender = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter volunteer's profession: "); // Getting profession
        String profession = keyboard.nextLine();
        
        System.out.println("Enter volunteer's mailing address: "); // Getting mail address
        String mailingAddress = keyboard.nextLine();
        
        System.out.println("Enter volunteer's email address: "); // Getting email address
        String emailAddress = keyboard.next();
        
        System.out.println("Enter volunteer's phone number: "); // Getting phone number
        String phoneNumber = keyboard.next();
        
        System.out.println("Is volunteer in mailing list? 1 for yes, 0 for no: "); // Getting mailing list
        int inMailingList = keyboard.nextInt();
        
        keyboard.nextLine();
        System.out.println("Enter volunteer's date joined in yyyy-MM-dd format: "); // Getting date joined
        String dateJoined = keyboard.next();
        
        System.out.println("Enter volunteer's last training date in yyyy-MM-dd format: "); // Getting training date
        String lastTrainingDate = keyboard.next();
        
        System.out.println("Enter volunteer's last training location:  "); // Getting training location
        String lastTrainingLocation = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter volunteers's teams/roles in team1:role1,team2:role2,... format: "); // Getting teams/roles
        String teams = keyboard.nextLine();
      

        String sql = "{call EnterVolunteer(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, personName); 
	        stmt.setString(2, SSN);
	        stmt.setString(3, gender); 
	        stmt.setString(4, profession);
	        stmt.setString(5, mailingAddress);
	        stmt.setString(6, emailAddress);
	        stmt.setString(7, phoneNumber);
	        stmt.setInt(8, inMailingList);
	        stmt.setString(9, dateJoined);
	        stmt.setString(10, lastTrainingDate);
	        stmt.setString(11, lastTrainingLocation);
	        stmt.setString(12, teams);
	
	        stmt.execute(); // Execute the stored procedure
	        System.out.println("Volunteer inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }

    private static void executeQuery4(Connection connection, Scanner keyboard) { 
    	System.out.println("Enter volunteer's SSN: "); // Getting team name
        String SSN = keyboard.next(); 

        keyboard.nextLine();
        System.out.println("Enter team name: "); // Getting team type
        String teamName = keyboard.nextLine(); 

        System.out.println("Enter number of hours to add: "); // Getting date formed
        int hours = keyboard.nextInt();

        String sql = "{call EnterVolunteerHours(?, ?, ?)}"; // Prepare the SQL call for the procedure
        try(CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, SSN); 
	        stmt.setString(2, teamName);
	        stmt.setInt(3, hours); 
	
	        stmt.execute(); // Execute the stored procedure
	        System.out.println("Volunteer hours inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery5(Connection connection, Scanner keyboard) { 
    	keyboard.nextLine();
    	System.out.println("Enter employee's name: "); // Getting name
        String personName = keyboard.nextLine(); 

        System.out.println("Enter employee's SSN: "); // Getting SSN
        String SSN = keyboard.next(); 

        System.out.println("Enter employee's gender: "); // Getting gender
        String gender = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter employee's profession: "); // Getting profession
        String profession = keyboard.nextLine();
        
        System.out.println("Enter employee's mailing address: "); // Getting mailing address
        String mailingAddress = keyboard.nextLine();
        
        System.out.println("Enter employee's email address: "); // Getting email address
        String emailAddress = keyboard.next();
        
        System.out.println("Enter employee's phone number: "); // Getting phone number
        String phoneNumber = keyboard.next();
        
        System.out.println("Is employee in mailing list? 1 for yes, 0 for no: "); // Getting mailing list
        int inMailingList = keyboard.nextInt();
        
        System.out.println("Enter employee's salary: "); // Getting salary
        double salary = keyboard.nextDouble();
        
        System.out.println("Enter employee's marital status:  "); // Getting marital status
        String maritalStatus = keyboard.next();
        
        System.out.println("Enter employee's hire date in yyyy-MM-dd format:  "); // Getting hire date
        String hireDate = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter employee's teams in team1,team2,... format: "); // Getting teams
        String teams = keyboard.nextLine();
      

        String sql = "{call EnterEmployee(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, personName); 
	        stmt.setString(2, SSN);
	        stmt.setString(3, gender); 
	        stmt.setString(4, profession);
	        stmt.setString(5, mailingAddress);
	        stmt.setString(6, emailAddress);
	        stmt.setString(7, phoneNumber);
	        stmt.setInt(8, inMailingList);
	        stmt.setDouble(9, salary);
	        stmt.setString(10, maritalStatus);
	        stmt.setString(11, hireDate);
	        stmt.setString(12, teams);
	
	        stmt.execute(); // Execute the stored procedure
	        System.out.println("Employee inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery6(Connection connection, Scanner keyboard) { 
    	System.out.println("Enter employee's SSN: "); // Getting employee SSN
        String SSN = keyboard.next(); 

        keyboard.nextLine();
        System.out.println("Enter expense amount: "); // Getting expense amount
        double amount = keyboard.nextDouble(); 

        keyboard.nextLine();
        System.out.println("Enter expense description: "); // Getting expense description
        String description = keyboard.nextLine();
        
        System.out.println("Enter expense date in yyyy-MM-dd format: "); // Getting expense date
        String date = keyboard.next();

        String sql = "{call EnterEmployeeExpense(?, ?, ?, ?)}"; // Prepare the SQL call for the procedure
        try(CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, SSN); 
	        stmt.setDouble(2, amount);
	        stmt.setString(3, description);
	        stmt.setString(4, date); 
	
	        stmt.execute(); // Execute the stored procedure
	        System.out.println("Employee expense inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery7(Connection connection, Scanner keyboard) { 
    	keyboard.nextLine();
    	System.out.println("Enter donor's name: "); // Getting donor name
        String personName = keyboard.nextLine(); 

        System.out.println("Enter donor's SSN: "); // Getting donor SSN
        String SSN = keyboard.next(); 

        System.out.println("Enter donor's gender: "); // Getting donor gender
        String gender = keyboard.next();
        
        keyboard.nextLine();
        System.out.println("Enter donor's profession: "); // Getting donor profession
        String profession = keyboard.nextLine();
        
        System.out.println("Enter donor's mailing address: "); // Getting donor mail address
        String mailingAddress = keyboard.nextLine();
        
        System.out.println("Enter donor's email address: "); // Getting donor email address
        String emailAddress = keyboard.next();
        
        System.out.println("Enter donor's phone number: "); // Getting donor phone number
        String phoneNumber = keyboard.next();
        
        System.out.println("Is donor in mailing list? 1 for yes, 0 for no: "); // Getting inMailingList
        int inMailingList = keyboard.nextInt();
        
        System.out.println("Is donor anonymous? 1 for yes, 0 for n "); // Getting isAnon
        int isAnon = keyboard.nextInt();
        
        keyboard.nextLine();
        System.out.println("Enter donations in format date,amount,type,campaign,check#,card#,cardtype,cardexpdate|...:  "); // Getting donations
        String donations = keyboard.nextLine();

        String sql = "{call EnterDonorWithDonations(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
        
	        // Setting parameters
	        stmt.setString(1, personName); 
	        stmt.setString(2, SSN);
	        stmt.setString(3, gender); 
	        stmt.setString(4, profession);
	        stmt.setString(5, mailingAddress);
	        stmt.setString(6, emailAddress);
	        stmt.setString(7, phoneNumber);
	        stmt.setInt(8, inMailingList);
	        stmt.setInt(9, isAnon);
	        stmt.setString(10, donations);
	
	        stmt.execute(); // Execute the stored procedure
	        System.out.println("Donor and donations inserted successfully."); // Confirm success
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery8(Connection connection, Scanner keyboard) { 
    	System.out.println("Enter client's SSN: "); // Getting client SSN
        String SSN = keyboard.next(); 

        String sql = "{call GetDoctorInfoByClient(?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        // Setting parameters
	        stmt.setString(1, SSN); 
	
	        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure
	        
	        while (rs.next()) { // Iterate through the result set
	            System.out.println("Doctor Name: " + rs.getString("doctor_name") + ", Doctor Phone Number: " + rs.getString("doctor_phone_number")); // Print each row
	        }
	        rs.close();
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery9(Connection connection, Scanner keyboard) { 
    	System.out.println("Enter start date in yyyy-MM-dd format: "); // Getting start date
        String startDate = keyboard.next(); 
        
        System.out.println("Enter end date in yyyy-MM-dd format: "); // Getting end date
        String endDate = keyboard.next(); 

        String sql = "{call GetExpensesByTime(?, ?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, startDate);
	        stmt.setString(2, endDate); 
	
	        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure
	        
	        while (rs.next()) { // Iterate through the result set
	            System.out.println("Employee SSN: " + rs.getString("SSN") + ", Total Expenses: " + rs.getString("total_expenses")); // Print each row
	        }
	        rs.close();
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery10(Connection connection, Scanner keyboard) { 
    	System.out.println("Enter client's SSN: "); // Getting client SSN
        String SSN = keyboard.next(); 

        String sql = "{call GetVolunteersByClient(?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	        
	        // Setting parameters
	        stmt.setString(1, SSN);
	
	        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure
	        
	        while (rs.next()) { // Iterate through the result set
	            System.out.println("Volunteer SSN: " + rs.getString("SSN") + ", Date Joined: " + rs.getString("date_joined")); // Print each row
	        }
	        rs.close();
	        stmt.close(); // Close the statement
	        } catch (SQLException e) {
		    	System.err.println("SQL Error occurred:");
		        System.err.println("SQL State: " + e.getSQLState());
		        System.err.println("Error Code: " + e.getErrorCode());
		        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery11(Connection connection, Scanner keyboard) { 
    	System.out.println("Enter date in yyyy-MM-dd format: "); // Getting date
        String date = keyboard.next(); 

        String sql = "{call GetTeamsByDate(?)}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
        
	        // Setting parameters
	        stmt.setString(1, date);
	
	        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure
	        
	        while (rs.next()) { // Iterate through the result set
	            System.out.println("Team Name: " + rs.getString("team_name")); // Print each row
	        }
	        rs.close();
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }

    private static void executeQuery12(Connection connection) { 
        String sql = "{call GetPeople()}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	
	        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure
	        
	        while (rs.next()) { // Iterate through the result set to print info
	            System.out.println("Name: " + rs.getString("person_name") + ", SSN: " + rs.getString("SSN") + ", Email: " + rs.getString("email_address") + ", Phone: " + rs.getString("phone_number")); // Print each row
	        }
	        rs.close();
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery13(Connection connection) { 
        String sql = "{call GetDonorEmployees()}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	
	        ResultSet rs = stmt.executeQuery(); // Execute the stored procedure
	        
	        while (rs.next()) { // Iterate through the result set to print info
	            System.out.println("Name: " + rs.getString("person_name") + ", SSN: " + rs.getString("SSN") + ", Total Donations: " + rs.getString("total_donations") + ", Anonymous?: " + rs.getString("isAnon")); // Print each row
	        }
	        rs.close();
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }

    private static void executeQuery14(Connection connection) { 
        String sql = "{call IncreaseSalary()}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
	
	        stmt.execute(); // Execute the stored procedure
	        
	        System.out.println("Salaries increased successfully.");
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
    private static void executeQuery15(Connection connection) { 
        String sql = "{call DeleteClients()}"; // Prepare the SQL call for the procedure
        try (CallableStatement stmt = connection.prepareCall(sql))  { // Create CallableStatement
	
	        stmt.execute(); // Execute the stored procedure
	        
	        System.out.println("Clients deleted successfully.");
	        stmt.close(); // Close the statement
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }

    private static void executeImportTeams(Connection connection, Scanner keyboard) throws IOException { 
    	System.out.print("Enter the input csv file name: ");
        String fileName = keyboard.next();
        
        BufferedReader reader = new BufferedReader(new FileReader(fileName));
        
        String line;
        while ((line = reader.readLine()) != null) {
            String[] parts = line.split(",");  // Assuming the file is CSV
            String teamName = parts[0].trim(); // Get team name
            String teamType = parts[1].trim(); // Get team type
            String dateFormed = parts[2].trim(); // Get date formed

            String sql = "{call EnterTeam(?, ?, ?)}"; // Prepare the SQL call for the procedure
            try (CallableStatement stmt = connection.prepareCall(sql)) { // Create CallableStatement
            
	            // Setting parameters
	            stmt.setString(1, teamName); 
	            stmt.setString(2, teamType);
	            stmt.setString(3, dateFormed); 
	
	            stmt.execute(); // Execute the stored procedure
	            stmt.close(); // Close the statement
            } catch (SQLException e) {
    	    	System.err.println("SQL Error occurred:");
    	        System.err.println("SQL State: " + e.getSQLState());
    	        System.err.println("Error Code: " + e.getErrorCode());
    	        System.err.println("Message: " + e.getMessage());
    	    }
        }
        reader.close();
        System.out.println("Teams inserted successfully from file.");
    }
    
    private static void executeExportMailing(Connection connection, Scanner keyboard) throws IOException {
    	System.out.print("Enter the output file name: ");
        String fileName = keyboard.next();
        
        BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));
        String sql = "{call GetMailingList()}";
        try (CallableStatement stmt = connection.prepareCall(sql)) {
	        
	        ResultSet rs = stmt.executeQuery(); // Execute getMailingList
	        while (rs.next()) {
	            String personName = rs.getString("person_name"); // Get name
	            String mailingAddress = rs.getString("mailing_address"); // Get address
	            writer.write(personName + ", " + mailingAddress); // Concatenate and write to file
	            writer.newLine();
	        }
	        rs.close();
	        stmt.close();
	        writer.close();
	        System.out.println("Mailing list exported successfully.");
        } catch (SQLException e) {
	    	System.err.println("SQL Error occurred:");
	        System.err.println("SQL State: " + e.getSQLState());
	        System.err.println("Error Code: " + e.getErrorCode());
	        System.err.println("Message: " + e.getMessage());
	    }
    }
    
}