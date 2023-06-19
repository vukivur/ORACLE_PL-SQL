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
    DBMS_OUTPUT.put_line('� ������� � ID = ' || :id_client || ' ��������� �������� �������. 
    ������ �� ����� ���� ���������.');
    
  ELSIF vCountDeposits = 1 THEN
    DBMS_OUTPUT.put_line('� ������� 1 �����.');
    SELECT clients_access, full_name
      INTO vClients_access, vFull_name
      FROM managers
     WHERE managerid = :id_manager;
    
    IF vClients_access = 0 THEN
      :result_text := '�������� ' || vFull_name || ' �� ����� ���� ��� ������ � ���������.';
    ELSE
      :result_text := '�������� ����� ��������.';
      UPDATE deposits
         SET deposit_status = 2, date_close = trunc(sysdate())
       WHERE clientid = :id_client; 
      DBMS_OUTPUT.put_line('����� ������.');
      COMMIT; 
    END IF;
     
  ELSE
    DBMS_OUTPUT.put_line('� ������� � ID = ' || :id_client || ' ��� �������.');
  END IF;
END;
