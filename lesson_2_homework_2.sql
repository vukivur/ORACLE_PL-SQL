DECLARE
  vCountDeposits   NUMBER;
  vClients_access  NUMBER;
  vFull_name       VARCHAR(100);
  vDog_num         VARCHAR(10);
  vDog_date        DATE;
  
BEGIN
  SELECT COUNT(*)
    INTO vCountDeposits
    FROM deposits
   WHERE clientid = :id_client
     AND date_close IS NULL;
     
  
  IF vCountDeposits > 1 THEN
    DBMS_OUTPUT.put_line('У клиента с ID = ' || :id_client || ' несколько открытых вкладов. 
    Запрос не может быть обработан.');
    
  ELSIF vCountDeposits = 1 THEN
    :result_text := 'У клиента 1 открытый вклад. ';
    
    SELECT dog_num, dog_date
      INTO vDog_num, vDog_date
      FROM deposits
     WHERE clientid = :id_client
       AND date_close IS NULL;
     
    SELECT clients_access, full_name
      INTO vClients_access, vFull_name
      FROM managers
     WHERE managerid = :id_manager;
    
    IF vClients_access = 0 THEN
      :result_text := :result_text || 'Менеджер ' || vFull_name || ' не имеет прав для работы с клиентами.';
    ELSE
      :result_text := :result_text || 'Менеджер может работать. ';
      UPDATE deposits
         SET deposit_status = 2, date_close = trunc(sysdate())
       WHERE clientid = :id_client
         AND date_close IS NULL; 
      DBMS_OUTPUT.put_line('Вклад по договору номер ' || vDog_num ||
       ' от ' || to_char(vDog_date, 'dd.mm.yyyy') ||  ' закрыт.');
      :result_text := :result_text || 'Вклад закрыт.';
      COMMIT; 
    END IF;
     
  ELSE
    DBMS_OUTPUT.put_line('У клиента с ID = ' || :id_client || ' нет открытых вкладов.');
  END IF;
END;
