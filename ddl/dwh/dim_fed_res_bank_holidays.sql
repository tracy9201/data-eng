create table IF NOT EXISTS dwh.dim_fed_res_bank_holidays
(
  date     DATE,
	holiday  VARCHAR(255),
  primary key(date)
)
DISTSTYLE ALL
