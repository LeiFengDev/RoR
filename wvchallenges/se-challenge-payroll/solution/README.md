# Solution

As per the challenge requirements, the solution handles the payroll data with the following workflow:

* I/O operation of uploading/storing/flagging the payroll cvs files
* formatted text file (.cvs) parsing and DB operation to store payroll data
* querying on DB to provide summarized payroll data to MVC to present

## Language and DB selection

For the purpose of above along with fast pace developement, both RoR and Node.js could be good choices. This solution is built with RoR and Sqlite for the following considerations:

* business logic focusing
  - RoR is relatively more mutural for CRUD application
  - Node.js has strong benefit on presentation but less on business layer. This application is obviously focusing on backend;
* productive stability
  - The Node.js adaptability needs more carefulness when do the configuration, development, testing and delpoyment
* performance and consistency
  - Sqlite3 is enough for the application and less management cost
  - Sqlite running in the same process will help on building the solid connection and execution performance
  - RoR is better on server side DB (I/O) operatrions
  - The strong async feature of Node.js has no benefit here on data consistency: payroll data correctness is more important than smooth UX

Therefore, the picked solution is consist of:

* Ruby 2.4.1 + Rails 5.1.1
* Sqlite 3.11.0

## Configuration

...

## Entity model design

...

## MVC routing

...

## Dev/Test environment

...

## Deployment and host

...
