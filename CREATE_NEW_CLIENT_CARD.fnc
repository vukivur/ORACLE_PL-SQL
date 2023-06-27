CREATE OR REPLACE FUNCTION CREATE_NEW_CLIENT_CARD
 (pResult   OUT  VARCHAR,
  pCardID_2 OUT  NUMBER,
  pClientID      NUMBER,
  pDays          NUMBER,
  pSum           NUMBER,
  pCurrencyName  VARCHAR,
  pQuantityCards NUMBER DEFAULT 1) RETURN NUMBER IS
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
    pResult := '������� � ID: ' || pClientID || ' ��� � ����. ���������� ������� �����.';
    RETURN 0;
  END IF;
  
  IF pQuantityCards < 1 THEN
    pResult := '������ �����. ���������� ������� ���������� ����: 1(�� ���������) ��� 2.';
    RETURN 0;
  ELSIF pQuantityCards > 2 THEN
    pResult := '������ �����. ����������� ��������� ���������� ����: 2. � � ������ �������: ' 
    || pQuantityCards || '.';
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
  pResult := '�������� ���������. ����� ��� ������� ID: ' || pClientID||  ' �������.';
      
  IF pQuantityCards = 2 THEN
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
      RETURNING cardid INTO pCardID_2;
    pResult := '�������� ���������. ��� ����� ��� ������� ID: ' || pClientID||  ' �������.'; 
  END IF;
        
  RETURN vCardID; 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('������� ������������ ������.');
    RETURN 0; 
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.put_line('������������ ����. ����� �����.'); 
    RETURN 0;
END;
/
