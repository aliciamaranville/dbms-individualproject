# PAN Database System

This project implements a comprehensive database system for the **Patient Assistance Network (PAN)**, a non-profit organization supporting patients by managing personnel and resources. The database system was designed to handle various organizational needs, such as team assignments, volunteer hours tracking, expense reporting, and donor management, while providing efficient query execution.  

## Project Features  

The database system supports the following operations:  
1. **Data Entry Operations**  
   - Add new teams, clients, volunteers, employees, and donors to the database.  
   - Record volunteer hours and employee expenses.  
2. **Query Execution**  
   - Retrieve detailed information about clients, teams, volunteers, employees, and donors.  
   - Generate sorted reports of expenses, donations, and team assignments.  
   - Perform bulk updates (e.g., salary adjustments) and conditional deletions.  
3. **File Import/Export**  
   - Import and export certain database records using custom file formats.  
4. **Scalability**  
   - Includes indexed storage structures for optimized query performance.  

## Repository Contents  

- **`Maranville_Alicia_IP_Task4.sql`**: SQL script to create database tables with all necessary constraints and indexes.  
- **`Maranville_Alicia_IP_Task5a.sql`**: SQL script containing the stored procedures for all specified queries and operations.  
- **`Maranville_Alicia_IP_Task5b.java`**: Java application to connect to the Azure SQL Database using JDBC. Implements all database operations through a user-friendly menu interface.  
- **`Maranville_Alicia_IP_REPORT.pdf`**: Comprehensive documentation including:  
  - Entity-Relationship (ER) diagram  
  - Relational schemas  
  - Index file organization details  
  - Query testing results and analysis  

## Key Functionalities  

### Supported Queries  
The system implements 15 key queries, including but not limited to:  
- Adding new entities and associating them with teams.  
- Retrieving volunteer and client details.  
- Summarizing expenses and donations.  
- Managing employee salaries and bulk deletions based on conditions.  

### Database Design  
- **Storage Optimization**: Indexed key attributes to enhance query performance.  
- **Data Integrity**: Constraints to ensure accurate and consistent data storage.  

### Java Application Features  
- **Interactive Menu**: Allows users to execute queries, import/export data, and quit.  
- **Error Handling**: Robust error handling for database connectivity and query execution.  
- **Scalability**: Built to handle dynamic organizational needs with flexible query design.  

## Getting Started  

### Prerequisites  
- **Azure SQL Database** for deployment.  
- **JDK 11+** for running the Java application.  
- **JDBC Driver** for Azure SQL Database connectivity.  

### Setup  
1. Run `Maranville_Alicia_IP_Task4.sql` on your Azure SQL Database to set up the schema and indexes.  
2. Execute `Maranville_Alicia_IP_Task5a.sql` to create stored procedures.  
3. Compile and run `Maranville_Alicia_IP_Task5b.java` to interact with the database.  

## Documentation  

Refer to **`Maranville_Alicia_IP_REPORT.pdf`** for:  
- Full database design details.  
- Explanation of query design and index selection.  
- Query performance testing and results.  

## Future Improvements  
- Expand support for additional organizational workflows.  
- Implement advanced analytics and reporting.  
- Enhance user interface for non-technical stakeholders.  
