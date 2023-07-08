CREATE OR REPLACE PROCEDURE CLIENT_INSERT (
  pNAME       VARCHAR,
  pFAM        VARCHAR,
  pOTCH       VARCHAR,
  pBIRTHDATE  DATE,
  pGENDER     NUMBER,
  pFILIALID   NUMBER,
  pMANAGERID  NUMBER,
  pIS_JUR     NUMBER,
  pINN        VARCHAR,
  pKPP        VARCHAR,
  pEMAIL      VARCHAR) IS
  
  EX_IS_JUR   EXCEPTION;
  EX_NO_INN   EXCEPTION;
BEGIN
  IF pIS_JUR NOT IN (0, 1) THEN
    RAISE EX_IS_JUR;
  END IF;
  
  IF pINN IS NULL THEN
    RAISE EX_NO_INN;
  END IF;
  
  INSERT INTO clients(name, 
                      fam, 
                      otch, 
                      birthdate, 
                      gender, 
                      filialid, 
                      managerid, 
                      is_jur, 
                      inn, 
                      kpp, 
                      email)
              VALUES (pNAME,
                      pFAM,
                      pOTCH,
                      pBIRTHDATE,
                      pGENDER,
                      pFILIALID,
                      pMANAGERID,
                      pIS_JUR,
                      pINN,
                      pKPP,
                      pEMAIL);
EXCEPTION 
  WHEN EX_IS_JUR THEN
    RAISE_APPLICATION_ERROR(-20001, 'Некорректное значение
                            признака юр.лица для графы "IS_JUR".');
  WHEN EX_NO_INN THEN
    RAISE_APPLICATION_ERROR(-20002, 'Не указан ИНН при сохранении клиента.');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'Другая ошибка.', TRUE);
  /*TRUE в конце параметр - показать весь стек ошибок*/
END;
/
