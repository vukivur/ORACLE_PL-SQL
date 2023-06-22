CREATE OR REPLACE FUNCTION PRC_DEPOSITRECOMMENDATIONS
(pClientID     NUMBER,
 pDays         NUMBER,
 pSum          NUMBER,
 pCurrencyName VARCHAR) RETURN NUMBER IS
  vCountDepositsBefore NUMBER;
  vPRC_Before  NUMBER;
  vPRC_New     NUMBER;
BEGIN
  IF pSum < 10000 OR pSum > 1000000 THEN
    DBMS_OUTPUT.put_line('Некорректный ввод. Вклад возможен на сумму от 10000 до 1000000 руб.');
    RETURN 0;
  END IF;
  
  SELECT COUNT(*)
    INTO vCountDepositsBefore
    FROM deposits d INNER JOIN accounts a
      ON d.accountid = a.accountid
   WHERE d.clientid = pClientID
     AND d.dog_date BETWEEN ADD_MONTHS(SYSDATE, - 12) AND SYSDATE
     AND a.currencyname = pCurrencyName;
  
  IF vCountDepositsBefore > 0 THEN
    SELECT MAX(depositprc)
      INTO vPRC_Before
      FROM deposits d INNER JOIN accounts a
        ON d.accountid = a.accountid
     WHERE d.clientid = pClientID
       AND d.dog_date BETWEEN ADD_MONTHS(SYSDATE, - 12) AND SYSDATE
       AND a.currencyname = pCurrencyName;
  END IF;
  
  SELECT prc
    INTO vPRC_New
    FROM depositrecommendations
   WHERE days = pDays
     AND deposit_sum_start <= pSum
     AND deposit_sum_end >= pSum
     AND currencyname = pCurrencyName;
     
  IF vPRC_Before > vPRC_New THEN 
    RETURN vPRC_Before;
  ELSE
    RETURN vPRC_New;
  END IF;
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('Некорректные данные заданы.');
    RETURN 0;
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.put_line('Некорректный ввод. Много строк.');
    RETURN 0;
END;
/
