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
        
     
  :currentDate := '������� ���� ' || to_char(sysdate(), 'dd.mm.yyyy');   
  :openDate := '���� �������� �������� ' || to_char(vDateOpen, 'dd.mm.yyyy');
  :allDays := '����� ���������� ���� �� ������ ' || vDepositdays; 
  
  vPassedDays := round(sysdate(), 'dd') - vDateOpen;
  :passedDays := '�������� ���� ' || to_char(vPassedDays);
  :leftDays := '�������� ���� �� ������ ' || to_char(vDepositdays - to_number(vPassedDays));      
        
  DBMS_OUTPUT.put_line('��������� ������� ����� ' || vDog_num || ' �� ' || to_char(vDog_date, 'dd.mm.yyyy'));
  DBMS_OUTPUT.put_line(:leftDays);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    :result := '������� �� ������.';
  WHEN TOO_MANY_ROWS THEN
    :result := '������ ������ ���� �� ����� ���� ���������.';
END;

