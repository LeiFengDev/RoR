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

## Configuration

...

## Entity model design

Following the DDD pattern, the relevant entities are:

* dailyWork

  All the "time report" data essentially present the works done by employees in daily based hours. Even though the requirements mentions every employees belong to specific "Job Group", it doesn't mean one employee cannot move to another group. It's the work which has been done directly connects to a group.

  The dailyWork entity should look like:

  ```
  {
    "dailyWork": [
      {
        "employeeId": 1,
        "date": "2017-01-02T05:00:00.000Z",
        "hours": 3.5,
        "groupId": 10
      },
      {
        "employeeId": 1,
        "date": "2017-01-10T05:00:00.000Z",
        "hours": 2,
        "groupId": 20
      },
      {
        "employeeId": 2,
        "date": "2017-01-02T05:00:00.000Z",
        "hours": 8,
        "groupId": 20
      }
    ]
  }
  ```

* workGroup

  The entity workGroup defines the rate of the work:

  ```
  {
    "workGroup": [
      {
        "id": 10,
        "categoty": "A",
        "name": "Junior",
        "rate": 20.0
      },
      {
        "id": 20,
        "categoty": "B",
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
        "name": "Jerry"
      },
      {
        "id": 2,
        "name": "Larry"
      }
    ]
  }
  ```

There are 3 corresponding tables to store the entity data loaded from the input file.

## Business model design

* timeSheet

  Use timeSheet model to parse and validate the input working time records. It decouples the input data and entities, and can provide more variants to support different types of time records in the future.

  ```
  {
    "timeSheet": [
      {
        "reportId": 40,
        "record": [
          {
            "date": "2016-11-04T04:00:00.000Z",
            "hours": 10.0,
            "employeeId": 1,
            "group": "A",
            "groupId": 10
          },
          {
            "date": "2016-11-14T05:00:00.000Z",
            "hours": 5.0,
            "employeeId": 1,
            "group": "A",
            "groupId": 10
          },
          {
            "date": "2016-11-20T05:00:00.000Z",
            "hours": 3.0,
            "employeeId": 2,
            "group": "B",
            "groupId": 20
          }
        ]
      }
    ]
  }
  ```

* payment

  Model payment is the data model to keep the individual pay stubs based on selected payment reporting time period. Based on its design, it can provide various formats to the view, such as:
  - provides daily/weekly/bi-weekly/semi-monthly/monthly payment methods based on payStub.ordinal
  - provides payment reporting period based on start and end dates
  - provide sorting by employee or pay stub order
  - support employee switch work group (rate)

  ```
  {
    "payment": [
      {
        "employeeId": 1,
        "payStub": [
          {
            "ordinal": 1,
            "startDate": "2017-01-01T05:00:00.000Z",
            "endDate": "2017-01-15T05:00:00.000Z",
            "amount": 500,
            "hours": 25,
            "rate": 20
          },
          {
            "ordinal": 1,
            "startDate": "2017-01-01T05:00:00.000Z",
            "endDate": "2017-01-15T05:00:00.000Z",
            "amount": 300,
            "hours": 10,
            "rate": 30
          },
          {
            "ordinal": 2,
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
            "startDate": "2017-01-01T05:00:00.000Z",
            "endDate": "2017-01-15T05:00:00.000Z",
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

* TimeSheet/index
* Payment/index

## Dev/Test environment

...

## Deployment and host

...
