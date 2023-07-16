CREATE OR REPLACE PROCEDURE MANAGERS_WITHOUT_PROMOTION
  (FilialID IN NUMBER,
   Managers OUT SYS_REFCURSOR) IS
BEGIN
  OPEN Managers FOR
    SELECT *
      FROM Managers m
      JOIN Managerpositions mp
        ON m.managerid = mp.managerid
     WHERE m.filialid = FilialID
       AND mp.datestart < add_months(trunc(sysdate), -24)
       AND EXISTS (SELECT Managerid,
           COUNT(Salary) FROM Managerpositions GROUP BY Managerid HAVING COUNT(Salary) > 1);
END;
/
