DECLARE
  vDog_num       VARCHAR(10);
  vDog_date      DATE;
  vDateOpen      DATE;
  vDepositdays   NUMBER;
  vPassedDays    NUMBER;

BEGIN
  SELECT dog_num, dog_date, date_open, depositdays
    INTO vDog_num, vDog_date, vDateOpen, vDepositdays
    FROM deposits
   WHERE ClientID = :ClientID;
        
     
  :currentDate := 'Текущая дата ' || to_char(sysdate(), 'dd.mm.yyyy');   
  :openDate := 'Дата открытия договора ' || to_char(vDateOpen, 'dd.mm.yyyy');
  :allDays := 'Общее количество дней по вкладу ' || vDepositdays; 
  
  vPassedDays := round(sysdate(), 'dd') - vDateOpen;
  :passedDays := 'Пройдено дней ' || to_char(vPassedDays);
  :leftDays := 'Осталось дней по вкладу ' || to_char(vDepositdays - to_number(vPassedDays));      
        
  DBMS_OUTPUT.put_line('Кредитный договор номер ' || vDog_num || ' от ' || to_char(vDog_date, 'dd.mm.yyyy'));
  DBMS_OUTPUT.put_line(:leftDays);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    :result := 'Договор не найден.';
  WHEN TOO_MANY_ROWS THEN
    :result := 'Данный запрос пока не может быть обработан.';
END;

