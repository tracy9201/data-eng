CREATE SCHEMA if not EXISTS gaia_stg_opul;
GRANT USAGE ON SCHEMA gaia_stg_opul to prodredshiftdba;


CREATE SCHEMA if not EXISTS kronos_stg_opul;
GRANT USAGE ON SCHEMA kronos_stg_opul to prodredshiftdba;

CREATE SCHEMA if not EXISTS p2pe_stg_opul;
GRANT USAGE ON SCHEMA p2pe_stg_opul to prodredshiftdba;
----------------------------------------

CREATE SCHEMA if not EXISTS gaia_metadata_opul;
GRANT USAGE ON SCHEMA gaia_metadata_opul to prodredshiftdba;


CREATE SCHEMA if not EXISTS kronos_metadata_opul;
GRANT USAGE ON SCHEMA kronos_metadata_opul to prodredshiftdba;

CREATE SCHEMA if not EXISTS p2pe_metadata_opul;
GRANT USAGE ON SCHEMA p2pe_metadata_opul to prodredshiftdba;
---------------------------------------------
CREATE SCHEMA if not EXISTS gaia_opul;
GRANT USAGE ON SCHEMA gaia_opul to prodredshiftdba;


CREATE SCHEMA if not EXISTS kronos_opul;
GRANT USAGE ON SCHEMA kronos_opul to prodredshiftdba;

CREATE SCHEMA if not EXISTS p2pe_opul;
GRANT USAGE ON SCHEMA p2pe_opul to prodredshiftdba;

-----------------------------------------------
CREATE SCHEMA if not EXISTS dwh_opul;
GRANT USAGE ON SCHEMA dwh_opul to prodredshiftdba;

GRANT SELECT ON ALL TABLES IN SCHEMA dwh_opul to lookerprod;

------------------------

CREATE SCHEMA if not EXISTS merchant_stg;
GRANT USAGE ON SCHEMA merchant_stg to prodredshiftdba;

CREATE SCHEMA if not EXISTS odf_stg;
GRANT USAGE ON SCHEMA odf_stg to prodredshiftdba;

---------------------------

CREATE SCHEMA if not EXISTS merchant_metadata;
GRANT USAGE ON SCHEMA merchant_metadata to prodredshiftdba;

CREATE SCHEMA if not EXISTS odf_metadata;
GRANT USAGE ON SCHEMA odf_metadata to prodredshiftdba;

-----------------------------

CREATE SCHEMA if not EXISTS merchant;
GRANT USAGE ON SCHEMA merchant to prodredshiftdba;

CREATE SCHEMA if not EXISTS odf;
GRANT USAGE ON SCHEMA odf to prodredshiftdba;
---------------------------------------------


GRANT SELECT ON ALL TABLES IN SCHEMA dwh_opul to lookerprod;
GRANT SELECT ON ALL TABLES IN SCHEMA gaia_opul to lookerprod;
GRANT SELECT ON ALL TABLES IN SCHEMA kronos_opul to lookerprod;
GRANT SELECT ON ALL TABLES IN SCHEMA p2pe_opul to lookerprod;
GRANT SELECT ON ALL TABLES IN SCHEMA merchant to lookerprod;
GRANT SELECT ON ALL TABLES IN SCHEMA odf to lookerprod;
