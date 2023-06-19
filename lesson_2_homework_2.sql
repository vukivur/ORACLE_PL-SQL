DECLARE
  vCountDeposits   NUMBER;
  vClients_access  NUMBER;
  vFull_name       VARCHAR(100);
  
BEGIN
  SELECT COUNT(*)
    INTO vCountDeposits
    FROM deposits
   WHERE clientid = :id_client;
  
  IF vCountDeposits > 1 THEN
    DBMS_OUTPUT.put_line('У клиента с ID = ' || :id_client || ' несколько открытых вкладов. 
    Запрос не может быть обработан.');
    
  ELSIF vCountDeposits = 1 THEN
    DBMS_OUTPUT.put_line('У клиента 1 вклад.');
    SELECT clients_access, full_name
      INTO vClients_access, vFull_name
      FROM managers
     WHERE managerid = :id_manager;
    
    IF vClients_access = 0 THEN
      :result_text := 'Менеджер ' || vFull_name || ' не имеет прав для работы с клиентами.';
    ELSE
      :result_text := 'Менеджер может работать.';
      UPDATE deposits
         SET deposit_status = 2, date_close = trunc(sysdate())
       WHERE clientid = :id_client; 
      DBMS_OUTPUT.put_line('Вклад закрыт.');
      COMMIT; 
    END IF;
     
  ELSE
    DBMS_OUTPUT.put_line('У клиента с ID = ' || :id_client || ' нет вкладов.');
  END IF;
END;
