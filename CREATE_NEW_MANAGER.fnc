CREATE OR REPLACE FUNCTION CREATE_NEW_MANAGER(
  pResult    OUT  VARCHAR,
  pFull_Name      VARCHAR,
  pFilial_ID      NUMBER,
  pPosition_Name  VARCHAR,
  pSalary         NUMBER DEFAULT 0) RETURN NUMBER IS
 vSalary          NUMBER; 
 vMax_Salary      NUMBER;
 vManager_ID      NUMBER;
 vPosition_ID     NUMBER;
 vDate_Start      DATE;
 vManagerPos_ID   NUMBER;
BEGIN
  
  SELECT positionid 
    INTO vPosition_ID
    FROM positions
   WHERE positionname = pPosition_Name
     AND filialid = pFilial_ID;
             
  SELECT salaryto 
    INTO vMax_Salary
    FROM positions  
   WHERE positionname = pPosition_Name
     AND filialid = pFilial_ID;
  

  IF pSalary < 0 THEN
    pResult := 'Введены некорректные данные. Зарплата не может быть отрицательной. Попробуйте заново.';
    RETURN 0;
      
  ELSIF pSalary = 0 THEN
    SELECT salaryfrom 
      INTO vSalary
      FROM positions
     WHERE positionname = pPosition_Name
       AND filialid = pFilial_ID;
     DBMS_OUTPUT.put_line(vSalary);
       
  ELSIF pSalary > 0 AND pSalary > vMax_Salary THEN
    pResult := 'Менеджер не может быть создан. Указанная зарплата выше максимально доступной границы.';
    RETURN 0;
  ELSIF pSalary > 0 AND pSalary < vMax_Salary THEN
    vSalary := pSalary;   
  END IF;
  
  vDate_Start := TRUNC(sysdate);
  
  INSERT INTO managers
              (full_name, 
               filialid)
       VALUES (pFull_Name,
               pFilial_ID)
       RETURNING managerid INTO vManager_ID;
       
  INSERT INTO managerpositions
              (managerid, 
               datestart, 
               positionid, 
               salary)
       VALUES (vManager_ID,
               vDate_Start,
               vPosition_ID,
               vSalary)
       RETURNING managerpositionid INTO vManagerPos_ID;
  pResult := 'Операция выполнена. Менеджер ID: ' || vManager_ID || ' добавлен.';
  RETURN vManagerPos_ID;
    
EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line('Введены некорректные данные.');
    RETURN 0;
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.put_line('Некорректный ввод. Много строк.'); 
    RETURN 0;
END;
/
