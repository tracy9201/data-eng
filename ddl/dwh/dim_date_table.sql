create table IF NOT EXISTS dwh.dim_date_table
  (
    date date,
    day SMALLINT,
    MONTH SMALLINT,
    week SMALLINT,
    QUARTER SMALLINT,
    day_of_week SMALLINT,
    day_of_year SMALLINT,
    year SMALLINT,
      primary key(date)

  )
  DISTSTYLE EVEN;