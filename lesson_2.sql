DECLARE 
  vCreditID     NUMBER;
  vDogNum       VARCHAR(10);
  vDogDate      DATE;
  vCalendarID   NUMBER;
  vCalendardate DATE;
  vSum          NUMBER;

BEGIN
  /*Подблок обработка ошибки*/
  BEGIN
    SELECT CreditID, dog_num, dog_date
      INTO vCreditID, vDogNum, vDogDate
      FROM Credits
     WHERE ClientID = :ClientID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      :result := 'Кредитный договор не найден.';
      vCreditID := 0;
    WHEN TOO_MANY_ROWS THEN
      :result := 'Запрос не может быть обработан!';
      vCreditID := 0;
  END;
  
  IF vCreditID = 0 THEN
    GOTO the_end;
  END IF;
   
  :result := 'Кредитный договор номер ' || vDogNum || ' от ' || to_char(vDogDate, 'dd.mm.yyyy');
  
  
  /*Получение идентификатора графика платежей*/
  SELECT calendarid
    INTO vCalendarID
    FROM CreditCalendar
   WHERE CreditID = vCreditID;
   
  SELECT MIN(calendardate)
    INTO vCalendardate
    FROM creditcalendardays
   WHERE calendarid = vCalendarID
     AND issuccess = 0;
     
   IF vCalendardate IS NULL THEN
     :result := 'Кредит закрыт.';
   ELSE
     /*Находим сумму платежа*/
     SELECT calendarsum
      INTO vSum
      FROM creditcalendardays
     WHERE calendarid = vCalendarID
       AND issuccess = 0
       AND calendardate = vCalendardate;
          
     :result := :result || '. Следующий платеж ' || to_char(vCalendardate, 'dd.mm.yyyy') || ' на сумму ' || vSum;
   END IF;
   
  /*Метка для перехода. NULL - заглушка(просто правило что метками заканчивать код нельзя).*/
  <<the_end>>
  NULL;
END;
