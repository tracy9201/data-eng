GRANT USAGE ON SCHEMA dwh_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA gaia_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA kronos_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA p2pe_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA merchant${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA odf${environment} to ${lookerUser};

GRANT USAGE ON SCHEMA gaia_stg_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA kronos_stg_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA p2pe_stg_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA gaia_metadata_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA kronos_metadata_opul${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA p2pe_metadata_opul${environment} to ${lookerUser}
GRANT USAGE ON SCHEMA merchant_stg${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA odf_stg${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA merchant_metadata${environment} to ${lookerUser};
GRANT USAGE ON SCHEMA odf_metadata${environment} to ${lookerUser};


GRANT SELECT ON ALL TABLES IN SCHEMA dwh_opul${environment} to ${lookerUser};
GRANT SELECT ON ALL TABLES IN SCHEMA gaia_opul${environment} to ${lookerUser};
GRANT SELECT ON ALL TABLES IN SCHEMA kronos_opul${environment} to ${lookerUser};
GRANT SELECT ON ALL TABLES IN SCHEMA p2pe_opul${environment} to ${lookerUser};
GRANT SELECT ON ALL TABLES IN SCHEMA merchant${environment} to ${lookerUser};
GRANT SELECT ON ALL TABLES IN SCHEMA odf${environment} to ${lookerUser};

alter default privileges in schema dwh_opul${environment} grant select on tables to ${lookerUser};
alter default privileges in schema gaia_opul${environment} grant select on tables to ${lookerUser};
alter default privileges in schema kronos_opul${environment} grant select on tables to ${lookerUser};
alter default privileges in schema p2pe_opul${environment} grant select on tables to ${lookerUser};
alter default privileges in schema merchant${environment} grant select on tables to ${lookerUser};
alter default privileges in schema odf${environment} grant select on tables to ${lookerUser};