------------------------------- kronos_status table create query ---------------------
create table dwh.kronos_status
( id int,
  status int,
  value varchar(50),
  description varchar(max),
 	primary key(id)
);
------------------------------- gaia_status table create query -----------------------

create table dwh.gaia_status
( id int,
  status int,
  value varchar(50),
  description varchar(max)
            primary key(id)
);

-------------------------------   Grant statement   ---------------------------------

GRANT SELECT ON ALL TABLES IN SCHEMA dwh TO looker;
------------------------------- gaia_status Insert Statement ------------------------

insert into dwh.gaia_status values
(1, 0, 'Inactive', '' ),
(2, 1, 'Active','' ),
(3, 2, 'Pending','' ),
(4, 3, 'To Be Billed','' ),
(5, 4, 'Processing','' ),
(6, 7, 'Delivered','' ),
(7, 10, 'Confirmed','Transaction confirmed but not approved' ),
(8, 12, 'Approved','Transaction approved' ),
(9, 15, 'Past Due','Payment is not yet done' ),
(10, 16, 'Rejected','' ),
(11, 18, 'Partially Completed','' ),
(12, 20, 'Completed','' ),
(13, 25, 'Forgiven','' ),
(14, 30, 'Collection','' ),
(15, 99, 'Failed' ,''),
(16, -1, 'Updated','' ),
(17, -2, 'To Be Canceled','' ),
(18, -3, 'Canceled','' ),
(19, -4, 'Deleted','' ),
(20, -5, 'Unknown','' ),
(21, -6, 'Expired','' );

------------------------------- Kronos_Status Insert Statement ------------------------

insert into dwh.kronos_status values
(1, 0, 'Active','' ),
(2, 1, 'Archived','' ),
(3, 2, 'Pending','' ),
(4, 3, 'Default','' ),
(5, 4, 'Temporary','' ),
(6, 5, 'Completed','' ),
(7, 6, 'Abandoned','' ),
(8, 7, 'Updated','Changes made to the original record.' ),
(9, 8, 'Ready For Activation','' ),
(10, 9, 'Invalid','' ),
(11, 10, 'Valid','' ),
(12, 11, 'To Be Canceled','' ),
(13, 12, 'Suppressed','' ),
(14, 13, 'Failed','' ),
(15, 14, 'Initial','' ),
(16, 15, 'Partially Completed','' ),
(17, 16, 'In Progress','' ),
(18, 17, 'Approved','' ),
(19, 18, 'Declined','' ),
(20, 19, 'Submitted','' ),
(21, 20, 'Boarded','' ),
(22, 21, 'Canceled','');
