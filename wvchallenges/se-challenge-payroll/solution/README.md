# Solution

As per the challenge requirements, the solution handles the payroll data with the following workflow:

1. I/O operation of uploading/storing/flagging the payroll cvs files
1. formatted text file (.cvs) parsing and DB operation to store payroll data
1. querying on DB to provide summarized payroll data to MVC to present

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

## Entity model design

Following the DDD pattern, the relevant entities are:

* timesheet_status

  After read and imported a "time report" file, the file importing result needs to be logged into storage. MongoDB is a good choice; in this project the log will be saved into Sqlite db directly to save the cost of both db management and deploy management. The records with "status" field has success value (0) will be used to prevent same report_id file imported twice.

  The timesheet_status entity should look like:

  ```
  {
    "timesheetStatus": [
      {
        "id": 100,
        "report_id": 40   // indexed, > 0
        "process_time": "2017-01-02T05:00:00.000Z",   // not null
        "status": 0,  // int/enum {success|failure}
        "error": 0,   // int/enum {no_error|filepath|content_type|duplicate_report|employee_id_not_exist|workgroup_id_not_exist|record_format_invalid|other_issue}
        "employees": [1,2,3,5,7,11],  // ids
        "workgroups": [1,2],        // ids
        "filename": "20170616121252_sample.csv"   // not null
      }
    ]
  }
  ```

* dailywork

  All the "time report" data essentially present the works done by employees in daily based hours. Even though the requirements mentions every employees belong to specific "Job Group", it doesn't mean one employee cannot move to another group. It's the work which has been done directly connects to a group.

  The dailywork entity should look like:

  ```
  {
    "dailywork": [
      {
        "id": 1,
        "employee_id": 1,   // FK
        "date": "2017-01-02T05:00:00.000Z",   // not null
        "hours": 3.5,     // > 0
        "group_id": 10,   // FK
        "report_id": 40   // > 0
      },
      {
        "id": 2,
        "employee_id": 1,
        "date": "2017-01-10T05:00:00.000Z",
        "hours": 2,
        "group_id": 20,
        "report_id": 40
      },
      {
        "id": 3,
        "employee_id": 2,
        "date": "2017-01-02T05:00:00.000Z",
        "hours": 8,
        "group_id": 20,
        "report_id": 40
      }
    ]
  }
  ```

* workgroup

  The entity workgroup defines the rate of the work:

  ```
  {
    "workgroup": [
      {
        "id": 10,
        "category": "A",  // not null
        "name": "Junior",
        "rate": 20.0      // > 0
      },
      {
        "id": 20,
        "category": "B",
        "name": "Senior",
        "rate": 30.0
      }
    ]
  }
  ```

* employee

  The entity employee indentifies each individual who involve into the work:

  ```
  {
    "employee": [
      {
        "id": 1,
        "first_name": "Jerry",  // not null
        "last_name": "Land",    // not null
        "gender": "Male",       // int/enum: {unknown|male|female}
        "description": ""
      },
      {
        "id": 2,
        "name": "Larry",
        "last_name": "Ocean",
        "gender": "Unknown",
        "description": ""
      }
    ]
  }
  ```

There are 4 corresponding tables to store the entity data loaded from the input file.

## Business/view model design

* timesheet

  Use timesheet model to parse and validate the input working time records. It decouples the input data and entities, and can provide more variants to support different types of time records in the future.

  ```
  {
    "timesheet": [
      {
        "reportId": 40,   // > 0
        "filepath": "~/solution/public/uploads/20170616121252_sample.csv",   // not null
        "filename": "20170616121252_sample.csv",   // not null
        "processTime": "2017-06-02T05:00:00.000Z",      // not null
        "timeRecords": [  // corresponding to dailywork
          {
            "date": "2016-11-04T04:00:00.000Z",   // not null
            "hours": 10.0,    // > 0
            "employee_id": 1,  // > 0
            "group": "A",     // not null
            "group_id": 10     // > 0
          },
          {
            "date": "2016-11-14T05:00:00.000Z",
            "hours": 5.0,
            "employee_id": 1,
            "group": "A",
            "group_id": 10
          },
          {
            "date": "2016-11-20T05:00:00.000Z",
            "hours": 3.0,
            "employee_id": 2,
            "group": "B",
            "group_id": 20
          }
        ]
      }
    ]
  }
  ```

* payment

  Model payment is the data model to keep the individual pay stubs based on selected payment reporting time period. Based on its design, it can provide various formats to the view, such as:
  - support employee switching work group (rate)
  - provides weekly/bi-weekly/semi-monthly/monthly payment methods based on `PayPeriod` enum and `week_number` of the period `start_date`
  - provides payment reporting period based on start and end dates
  - provide filtering by `employee_id` or `workgroup_id`

  ```
  {
    "payment": [
      {
        "employee_id": 1,
        "payStub": [
          {
            "ordinal": 1,
            "weekNumber": "2017_01",
            "startDate": "2017-01-01T05:00:00.000Z",
            "endDate": "2017-01-15T05:00:00.000Z",
            "amount": 500,
            "hours": 25,
            "rate": 20
          },
          {
            "ordinal": 1,
            "weekNumber": "2017_01",
            "startDate": "2017-01-01T05:00:00.000Z",
            "endDate": "2017-01-15T05:00:00.000Z",
            "amount": 300,
            "hours": 10,
            "rate": 30
          },
          {
            "ordinal": 2,
            "weekNumber": "2017_03",
            "startDate": "2017-01-16T05:00:00.000Z",
            "endDate": "2017-01-31T05:00:00.000Z",
            "amount": 600,
            "hours": 20,
            "rate": 30
          }
        ]
      },
      {
        "employeeId": 2,
        "payStub": [
          {
            "ordinal": 1,
            "weekNumber": "2017_01",
            "startDate": "2017-01-01T05:00:00.000Z",
            "endDate": "2017-01-15T05:00:00.000Z",
            "amount": 750,
            "hours": 25,
            "rate": 30
          },
          {
            "ordinal": 2,
            "weekNumber": "2017_05",
            "startDate": "2017-02-01T05:00:00.000Z",
            "endDate": "2017-02-15T05:00:00.000Z",
            "amount": 750,
            "hours": 25,
            "rate": 30
          }
        ]
      }
    ]
  }
  ```

## MVC routing

* timesheet/index
  1. upload new CSV file into server under directory "~/public/uploads/"
  1. verify CSV file and create status record into timesheet_statuses table
  1. when CSV file valid load working time records into dailyworks table
  1. display result information of the uploads

* report/index
  1. display payment report as required
  1. provide semantic urls with proper parameters for different way to construct the payment report

## Build and run 

1. Have your local Ruby on Rails environment ready. Current development applies the versions:
    * Ruby 2.4.1 + Rails 5.1.1
    * Sqlite 3.11.0

  The version can be checked by terminal commands:
  ```
  $ rvm -v
  rvm 1.29.1 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io/]

  $ ruby -v
  ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]

  $ rails -v
  Rails 5.1.1

  $ sqlite3 --version
  3.11.0 2016-02-15 17:29:24 3d862f207e3adc00f78066799ac5a8c282430a5f
  ```
  Installation details please see the section 3.1 in the following link: http://guides.rubyonrails.org/getting_started.html

2. Use a directory to fetch code from git repo
  ```
  $ cd _your_folder_path_
  $ git clone https://github.com/LeiFengDev/RoR.git
  ```
3. Enter the working directory and prepare the dependencies and db tables
  ```
  $ cd RoR/wvchallenges/se-challenge-payroll/solution/
  $ bundle install
  $ bin/rails db:migrate
  ```
4. Run rails server and view the report page in browser with url: localhost:3000
  ```
  $ bin/rails server
  ```
5. view the report page in browser with url `localhost:3000`

## Deployment and host

...
