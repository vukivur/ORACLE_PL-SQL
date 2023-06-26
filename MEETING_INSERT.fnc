CREATE OR REPLACE FUNCTION MEETING_INSERT(
  pRESULT      OUT VARCHAR,
  pFILIALID    NUMBER,
  pDATESTART   DATE,
  pTIMEMIN     NUMBER   DEFAULT 15,
  pCLIENTID    NUMBER   DEFAULT NULL,
  pCLIENTNAME  VARCHAR  DEFAULT NULL,
  pMANAGERID   NUMBER   DEFAULT 0
 ) RETURN NUMBER IS
  vCountMeetings NUMBER;
  vDateEnd       DATE;
  vManagerID     NUMBER;
  vMeetingID     NUMBER;
BEGIN
  IF pCLIENTID IS NULL AND pCLIENTNAME IS NULL THEN
    pRESULT := '������� ������������� ������� ��� ��� ���.';
    RETURN 0;
  END IF;
  
  /*���������� �� ��������� + 1: ����. � ��� ����� - ������. ��������� ���� � ������.
    1 ������ = 1/24/60 = 0,000694444 ���.*/
  vDateEnd := pDATESTART + 1/24/60 * pTIMEMIN;
  
  IF pMANAGERID > 0 THEN
    SELECT COUNT(*)
      INTO vCountMeetings
      FROM meetings
     WHERE managerid = pMANAGERID
       AND filialid = pFILIALID
       AND pDATESTART < dateend
       AND vDateEnd > datestart;
       
    IF vCountMeetings > 0 THEN
      pRESULT := '��������� �������� ����� �� ������������� �����.';
      RETURN 0; 
    END IF;  
    
    vManagerID := pMANAGERID;
  ELSE
    SELECT MIN(m.managerid)
      INTO vManagerID
      FROM managers m
     WHERE m.filialid = pFILIALID
       AND NOT EXISTS (SELECT *
                         FROM meetings
                        WHERE managerid = m.managerid
                          AND filialid = pFILIALID
                          AND pDATESTART < dateend
                          AND vDateEnd > datestart);
                          
    IF vManagerID IS NULL THEN
      pRESULT := '��������� ����� ��������� �������������. ���������� � ������ �����.';
      RETURN 0;
    END IF;    
  END IF;
  
  INSERT INTO meetings 
    (clientname, 
     clientid, 
     managerid, 
     filialid,  
     datestart, 
     dateend)
  VALUES
    (pCLIENTNAME,
     pCLIENTID,
     vManagerID,
     pFILIALID,
     pDATESTART,
     vDateEnd)
  RETURNING meetingid INTO vMeetingID;
  
  pRESULT := '������� ������� ���������.';
  RETURN vMeetingID;
END;
/
