---How to create database
---How to drop database
---How to rename database

create database DemoDB

drop database DemoDB

alter database DemoDB modify name=NewDemoDB

---using procedure
exec sp_renamedb NewDemoDB, DemoDB_2