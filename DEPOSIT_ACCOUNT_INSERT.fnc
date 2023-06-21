CREATE OR REPLACE FUNCTION DEPOSIT_ACCOUNT_INSERT 
 (pClientID NUMBER, 
  pCurrencyName VARCHAR,
  pDays NUMBER) RETURN NUMBER IS
 vAccountNomer  VARCHAR(20);
 vCountAccounts NUMBER;
 vAccountID     NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO vCountAccounts
    FROM accounts
   WHERE clientid = pClientID;
   
  vCountAccounts := vCountAccounts + 1;
   
  IF pDays <= 30 THEN
    vAccountNomer := '42302';
  ELSIF pDays BETWEEN 31 AND 90 THEN
    vAccountNomer := '42303';
  ELSIF pDays BETWEEN 91 AND 180 THEN
    vAccountNomer := '42304';
  ELSE
    vAccountNomer := '42305';
  END IF;
  
  vAccountNomer := vAccountNomer || pCurrencyName 
    || LPAD(pClientID, 10, '0') 
    || LPAD(vCountAccounts, 2, '0');  
    
  INSERT INTO ACCOUNTS (accountname, 
                       accountnomer, 
                       currencyname, 
                       clientid, 
                       accountstatus, 
                       dateopen)
    VALUES('¬клад фл на срок до ' || pDays || ' дней',
           vAccountNomer,
           pCurrencyName,
           pClientID,
           1,
           trunc(sysdate))
    RETURNING accountid INTO vAccountID;
    
  RETURN vAccountID;
END; 
/
