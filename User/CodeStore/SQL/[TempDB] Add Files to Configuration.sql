ALTER DATABASE tempdb
ADD FILE (NAME = tempdev2, FILENAME = 'W:\tempdb2.mdf', SIZE = 256);
ALTER DATABASE tempdb
ADD FILE (NAME = tempdev3, FILENAME = 'X:\tempdb3.mdf', SIZE = 256);
ALTER DATABASE tempdb
ADD FILE (NAME = tempdev4, FILENAME = 'Y:\tempdb4.mdf', SIZE = 256);
GO