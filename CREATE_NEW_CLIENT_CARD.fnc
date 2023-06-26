CREATE OR REPLACE FUNCTION CREATE_NEW_CLIENT_CARD
 (pClientID      NUMBER,
  pDays          NUMBER,
  pSum           NUMBER,
  pCurrencyName  VARCHAR) RETURN NUMBER IS
 vCountAccounts  NUMBER;
 vCardID         NUMBER;
 vBicSber        VARCHAR(9) := '044525225';
 vCardnomer      VARCHAR2(16);
 vExpiremonth    NUMBER;
 vExpireyear     NUMBER;
 vCardholdername VARCHAR2(30);
 vCvc            VARCHAR2(3);
 vAccountID      NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO vCountAccounts
    FROM accounts
   WHERE clientid = pClientID;
   
  IF vCountAccounts = 0 THEN
    DBMS_OUTPUT.put_line('Клиента с ID: ' || pClientID || ' нет в базе. Невозможно сделать карту.');
    RETURN 0;
  END IF;
   
  vAccountID := CARD_ACCOUNT_INSERT(pClientID, 
                                   pCurrencyName, 
                                   pDays,
                                   pSum);
                                       
  vCardnomer := vBicSber || LPAD(pClientID, 7, '0');
  vExpiremonth := to_number(to_char(sysdate, 'mm'));
  vExpireyear := to_number(to_char(sysdate, 'yy')) + 3;
  vCardholdername := 'CARDHOLDERNAME';
  vCvc := LPAD(SUBSTR(trunc(DBMS_RANDOM.value * 100000), 1, 3), 3, '0');
                                                                             
  INSERT INTO cards
             (cardnomer, 
              expiremonth, 
              expireyear, 
              cardholdername, 
              cvc,  
              accountid)
      VALUES (vCardnomer,
              vExpiremonth,
              vExpireyear,
              vCardholdername,
              vCvc,
              vAccountID)
      RETURNING cardid INTO vCardID;
        
  RETURN vCardID; 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('Введены некорректные данные.');
    RETURN 0; 
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.put_line('Некорректный ввод. Много строк.'); 
    RETURN 0;
END;
/
