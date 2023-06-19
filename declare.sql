DECLARE
  id_client     NUMBER;
  count_credits NUMBER;
  num_dog       VARCHAR(10);
  date_dog      DATE;
BEGIN
  /*Âñå ïåðåìåííûå, èñïîüçóåìûå äàëåå*/
  id_client := 104;  

  SELECT COUNT(*)
    INTO count_credits
    FROM Credits
   WHERE ClientID = id_client;
   
  DBMS_OUTPUT.put_line('Êîëè÷åñòâî êðåäèòîâ: ' || count_credits);
  
  IF count_credits > 0 THEN 
    SELECT c.dog_num, c.date_start
      INTO num_dog, date_dog
      FROM Credits c
    WHERE ClientID = id_client;
    
    DBMS_OUTPUT.put_line(num_dog || ' îò ' || to_char(date_dog, 'dd.mm.yyyy'));
  ELSE
    DBMS_OUTPUT.put_line('Äîãîâîðîâ íåò.');
  END IF;
END;     
