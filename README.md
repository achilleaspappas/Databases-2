# Databases 2
The goal of this project is to create an SQL database for a travel company that offers travel packages to customers. 
The database includes tables for customers, travel packages, categories, and a link table between packages and categories. 
It also includes triggers for updating the sum of reserved packages in each category and a stored procedure to find the number of 
reserved packets and the total cost for a given customer email.

## Prerequisites
To use the files in this repository, you will need the following:
1. [MySQL](https://www.mysql.com/) or a compatible database management system.
2. [PHP](https://www.php.net/)

## Getting Started
To get started with this project, follow these steps:
1. Clone this repository to your local machine.
2. Open your preferred MySQL client and connect to your local or remote database server.
3. Run the code.

## Contents
This repository contains the following files:
1. WebPage - contain php source code files.
2. travel_packets.sql 

## Specifications

### Functionality

The program defines a database schema named travel_packets that stores information about travel packets, customers, and categories of travel packets. The schema includes several tables such as packets, customers, chosen_packet, and category. The packets table stores information about each travel packet such as its destination, start and end dates, transport, and cost. The customers table stores information about customers such as their name, address, phone number, and email. The chosen_packet table stores the chosen packets for each customer. The category table stores information about different categories of travel packets and the number of reserved packets for each category.
The program also includes a function named duration() that calculates the duration (in days) of each package in the packets table. Additionally, there is a procedure named find_packets() that takes an input parameter client_email and returns the number of reserved packets and total cost for the customer with the specified email.i
Finally, the program defines three triggers that update the sum_reserved field in the category table whenever a row is inserted, deleted, or updated in the chosen_packet table. This ensures that the number of reserved packets for each category is always up-to-date.

## Contributing

This is a university project so you can not contribute.

## Authors

* **[University of West Attica]** - *Provided the exersice*
* **[Achilleas Pappas]** - *Wrote the code*

## License

This project is licensed by University of West Attica as is a part of a university course. Do not redistribute.

## Acknowledgments

Thank you to **University of West Attica** and my professors for providing the resources and knowledge to complete this project.
