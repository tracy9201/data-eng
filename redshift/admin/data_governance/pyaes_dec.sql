

select udf_dec.aes_decrypt(firstname, LPAD('customerfirstnameKey/fhci5=dnv84', 16, 'z')) as firstname
,udf_dec.aes_decrypt(lastname, LPAD('customerlastnameKey/fhci5=dnv84', 16, 'z')) as lastname
FROM dwh_opul.dim_customer;


