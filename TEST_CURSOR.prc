CREATE OR REPLACE PROCEDURE TEST_CURSOR
  (pIS_JUR  IN NUMBER,
   pClients OUT SYS_REFCURSOR) IS
BEGIN
  OPEN pClients FOR
    SELECT *
      FROM Clients c
     WHERE c.is_jur = pIS_JUR
     ORDER BY c.name;
END;
/
