--Create library
CREATE OR REPLACE LIBRARY pyaes
LANGUAGE plpythonu
FROM 'https://tinyurl.com/redshift-udfs/pyaes.zip?raw=true';
;

--- Create a separate schema to deploy encryption UDF
CREATE SCHEMA udf_enc;

--- Create UDF
--- Create encrypt function
CREATE OR REPLACE FUNCTION udf_enc.aes_encrypt(input VARCHAR(max), vKey VARCHAR(256))
RETURNS VARCHAR STABLE AS $$
  import pyaes
  import binascii
  if input is None:
     return None
  key = vKey # Your Key here
  aes=pyaes.AESModeOfOperationCTR(key)
  cipher_txt=aes.encrypt(input)
  cipher_txt2=binascii.hexlify(cipher_txt)
  return str(cipher_txt2.decode('utf-8'))
$$ LANGUAGE plpythonu ;

--- Create a separate schema to deploy Decryption UDF to control decryption access to only authorized users.
CREATE SCHEMA udf_dec;

--- Create UDF
--- Create decrypt function
CREATE OR REPLACE FUNCTION 
udf_dec.aes_decrypt(encrypted_msg varchar(max), vKey VARCHAR(256))
RETURNS VARCHAR STABLE AS $$
  import pyaes
  import binascii
  if encrypted_msg is None or len(str(encrypted_msg)) == 0:
       return None
  key = vKey # Your decryption key here
  aes = pyaes.AESModeOfOperationCTR(key)
  encrypted_msg2=binascii.unhexlify(encrypted_msg)
  decrypted_msg2 = aes.decrypt(encrypted_msg2)
  return str(decrypted_msg2.decode('utf-8'))
$$ LANGUAGE plpythonu ;


