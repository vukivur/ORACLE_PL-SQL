CREATE OR REPLACE PROCEDURE REISSUE_CLIENT_CARD IS
  CURSOR Ending_Cards IS
    SELECT DISTINCT cl.name || ' ' || cl.otch FAM, cl.clientid, cl.email, cd.cardnomer,  
           COUNT(cl.name || ' ' || cl.otch) OVER (PARTITION BY cl.name || ' ' || cl.otch) Count_Cards
      FROM Cards cd
      JOIN Accounts ac
        ON ac.accountid = cd.accountid
      JOIN Clients cl
        ON cl.clientid = ac.clientid
     WHERE cl.is_jur = 0
       AND cd.expireyear = to_number(to_char(sysdate, 'yy'))
       AND cd.expiremonth = to_number(to_char(sysdate, 'mm')) + 1;  
  vFAM           VARCHAR(100);
  vClientid      NUMBER;
  vEmail         VARCHAR(100);
  vOldCardNomer  VARCHAR2(16);
  vCountCards    NUMBER;
  vText          VARCHAR(300);
  vRes           NUMBER;
BEGIN
  OPEN Ending_Cards;
  LOOP
    
    FETCH Ending_Cards
     INTO vFAM, vClientid, vEmail, vOldCardNomer, vCountCards;     
  
    EXIT WHEN Ending_Cards%NOTFOUND;
    
    BEGIN
      FOR i IN 1..vCountCards
        LOOP
          vRes := CREATE_NEW_CLIENT_CARD(pClientID => vClientid, pCardNomer => vOldCardNomer);
        END LOOP;
    END; 
    COMMIT;
    
    IF vCountCards = 1 THEN
      vText := 'Уважаемый (-ая), ' || vFAM || ', Ваша банковская карта перевыпущена. Обратитесь в банк, 
                чтобы её забрать. Карта будет готова: ' || to_char(sysdate + 5, 'dd.mm.yyyy') || '.';
    ELSE
      vText := 'Уважаемый (-ая), ' || vFAM || ', Ваши ' || vCountCards || ' банковские карты перевыпущены.
                Обратитесь в банк, чтобы их забрать. Карты будут готовы: ' ||
                to_char(sysdate + 5, 'dd.mm.yyyy') || '.';
    END IF;
    
    BEGIN
      EMAIL_SEND(vEmail, vText, 'Информирование - перевыпуск банковских карт.');
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Ошибка отправки для клиента ' || vFAM || ' (' || vClientid || '): ' || SQLERRM);
    END;
  END LOOP;
  CLOSE Ending_Cards;
END;
/
