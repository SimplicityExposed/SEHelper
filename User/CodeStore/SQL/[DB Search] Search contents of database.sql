declare @vcTableName varchar(100), @vcColumnName varchar(100)

select 
  @vcTableName = '' -- insert text you are looking for (optional)
, @vcColumnName = '' -- insert text you are looking for (optional) must have one if not both

SELECT DISTINCT SUBSTRING(o.NAME,1,60) ObjName, 'Stored Procedure' ObjType
FROM sysobjects o
       INNER JOIN syscomments c ON o.ID = c.ID
WHERE o.XTYPE = 'P' AND c.Text LIKE '%' + @vcColumnName + '%' + @vcTableName + '%'  
UNION SELECT DISTINCT  SUBSTRING(o.NAME,1,60) ObjName, 'View' ObjType
FROM sysobjects o
       INNER JOIN syscomments c ON o.ID = c.ID
WHERE o.XTYPE = 'V' AND c.Text LIKE '%' + @vcColumnName + '%' + @vcTableName + '%'  
UNION SELECT DISTINCT SUBSTRING(o.NAME,1,60) ObjName, 
              'Function (' + 
              CASE WHEN o.XTYPE = 'FN' THEN 'Scalar'
                     WHEN o.XTYPE = 'IF' THEN 'Inline'
                     WHEN o.XTYPE = 'TF' THEN 'Table'
                     ELSE '?'
              END + ')' ObjType
FROM sysobjects o
              INNER JOIN syscomments c ON o.ID = c.ID
WHERE o.XTYPE IN ('FN','IF','TF') AND c.Text LIKE '%' + @vcColumnName + '%' + @vcTableName + '%'  
UNION SELECT DISTINCT SUBSTRING(o.NAME,1,60) ObjName, 'Trigger' ObjType
FROM sysobjects o
       INNER JOIN syscomments c ON o.ID = c.ID
WHERE o.XTYPE = 'TR' AND c.Text LIKE '%' + @vcColumnName + '%' + @vcTableName + '%'  
ORDER BY ObjType, ObjName

