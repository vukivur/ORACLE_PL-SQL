DECLARE 
  vCreditID     NUMBER;
  vDogNum       VARCHAR(10);
  vDogDate      DATE;
  vCalendarID   NUMBER;
  vCalendardate DATE;
  vSum          NUMBER;

BEGIN
  /*������� ��������� ������*/
  BEGIN
    SELECT CreditID, dog_num, dog_date
      INTO vCreditID, vDogNum, vDogDate
      FROM Credits
     WHERE ClientID = :ClientID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      :result := '��������� ������� �� ������.';
      vCreditID := 0;
    WHEN TOO_MANY_ROWS THEN
      :result := '������ �� ����� ���� ���������!';
      vCreditID := 0;
  END;
  
  IF vCreditID = 0 THEN
    GOTO the_end;
  END IF;
   
  :result := '��������� ������� ����� ' || vDogNum || ' �� ' || to_char(vDogDate, 'dd.mm.yyyy');
  
  
  /*��������� �������������� ������� ��������*/
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
     :result := '������ ������.';
   ELSE
     /*������� ����� �������*/
     SELECT calendarsum
      INTO vSum
      FROM creditcalendardays
     WHERE calendarid = vCalendarID
       AND issuccess = 0
       AND calendardate = vCalendardate;
          
     :result := :result || '. ��������� ������ ' || to_char(vCalendardate, 'dd.mm.yyyy') || ' �� ����� ' || vSum;
   END IF;
   
  /*����� ��� ��������. NULL - ��������(������ ������� ��� ������� ����������� ��� ������).*/
  <<the_end>>
  NULL;
END;
