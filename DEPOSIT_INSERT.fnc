CREATE OR REPLACE FUNCTION DEPOSIT_INSERT
(pClientID NUMBER,
 pDogNum   VARCHAR,
 pSum      NUMBER,
 pDays     NUMBER,
 pPrc      NUMBER,
 pCurrencyName VARCHAR) RETURN NUMBER IS
  vAccountID NUMBER;
  vDepositID NUMBER;
BEGIN
   vAccountID := DEPOSIT_ACCOUNT_INSERT(pClientID, 
                                        pCurrencyName,
                                        pDays);
   INSERT INTO deposits
             (date_open,  
              clientid, 
              accountid, 
              dog_num, 
              dog_date, 
              depositsum, 
              depositdays, 
              depositprc) 
      VALUES (trunc(sysdate),
              pClientID,
              vAccountID,
              pDogNum,
              trunc(sysdate),
              pSum,
              pDays,
              pPrc)
      RETURNING DepositID INTO vDepositID;
      
  RETURN vDepositID;                   
END;
/
