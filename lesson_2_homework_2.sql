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
    DBMS_OUTPUT.put_line('� ������� � ID = ' || :id_client || ' ��������� �������� �������. 
    ������ �� ����� ���� ���������.');
    
  ELSIF vCountDeposits = 1 THEN
    :result_text := '� ������� 1 �������� �����. ';
    
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
      :result_text := :result_text || '�������� ' || vFull_name || ' �� ����� ���� ��� ������ � ���������.';
    ELSE
      :result_text := :result_text || '�������� ����� ��������. ';
      UPDATE deposits
         SET deposit_status = 2, date_close = trunc(sysdate())
       WHERE clientid = :id_client
         AND date_close IS NULL; 
      DBMS_OUTPUT.put_line('����� �� �������� ����� ' || vDog_num ||
       ' �� ' || to_char(vDog_date, 'dd.mm.yyyy') ||  ' ������.');
      :result_text := :result_text || '����� ������.';
      COMMIT; 
    END IF;
     
  ELSE
    DBMS_OUTPUT.put_line('� ������� � ID = ' || :id_client || ' ��� �������� �������.');
  END IF;
END;
