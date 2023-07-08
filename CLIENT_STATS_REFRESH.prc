CREATE OR REPLACE PROCEDURE CLIENT_STATS_REFRESH IS
BEGIN
  MERGE INTO clients_stats cs
    USING (select a.clientid,
            min(a.date_operation) min_date_operation,
            max(a.date_operation) max_date_operation 
            from
                  (select 
                  (select clientid from  accounts where accountid= pro.accountid_deb )clientid,
                         pro.date_operation
                   from pro 
                   where pro.accountid_deb<>0 and pro.accountid_deb is not null
                   union all
                  select 
                  (select clientid from  accounts where accountid= pro.accountid_cred )clientid,
                  pro.date_operation
                   from pro 
                    where pro.accountid_cred<>0 and pro.accountid_cred is not null) a
            group by a.clientid 
            having  a.clientid is not null) minmax
       ON (cs.clientid = minmax.clientid)
    WHEN MATCHED THEN UPDATE
      SET cs.date_first = minmax.min_date_operation,
          cs.date_last = minmax.max_date_operation
    WHEN NOT MATCHED THEN INSERT
      (cs.clientid, cs.date_first, cs.date_last)
    VALUES
      (minmax.clientid, minmax.min_date_operation, minmax.max_date_operation);
END;
/
