DECLARE
  CURSOR Cur IS
    SELECT c.*
      FROM Clients c
     WHERE c.is_jur = 0
     ORDER BY c.name;
  vClient Clients%Rowtype;
BEGIN
  OPEN Cur;
  
  FETCH Cur INTO vClient;
  WHILE Cur%Found 
    LOOP
      DBMS_OUTPUT.put_line('Имя: ' || vClient.NAME);
      FETCH Cur INTO vClient;
    END LOOP;
  DBMS_OUTPUT.put_line('Количество строк: ' || Cur%Rowcount);   
  CLOSE Cur;
END;
