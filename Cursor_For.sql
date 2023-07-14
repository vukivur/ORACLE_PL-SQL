DECLARE
  i   NUMBER := 0;
BEGIN
  FOR Cur IN (SELECT c.*
                FROM Clients c
               WHERE c.is_jur = 0
               ORDER BY c.name)
  LOOP
    DBMS_OUTPUT.put_line('Имя: ' || Cur.NAME);
    i := i + 1;
  END LOOP;
  DBMS_OUTPUT.put_line('Всего строк: ' || i);
END;
