UPDATE dwh_opul.dim_customer
SET lastname = udf_enc.aes_encrypt(lastname, LPAD('customerlastnameKey/fhci5=dnv84', 16, 'z'))
;
commit;

UPDATE dwh_opul.dim_customer
SET firstname = udf_enc.aes_encrypt(firstname, LPAD('customerfirstnameKey/fhci5=dnv84', 16, 'z'))
;
commit;