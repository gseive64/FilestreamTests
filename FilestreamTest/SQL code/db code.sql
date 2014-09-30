EXEC sp_configure filestream_access_level, 2
RECONFIGURE


CREATE DATABASE Archive 
ON
PRIMARY ( NAME = Arch1,
    FILENAME = 'c:\data\archdat1.mdf'),
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM( NAME = Arch3,
    FILENAME = 'c:\data\filestream1')
LOG ON  ( NAME = Archlog1,
    FILENAME = 'c:\data\archlog1.ldf')
GO


CREATE TABLE Archive.dbo.Records
(
	[Id] [uniqueidentifier] ROWGUIDCOL NOT NULL UNIQUE, 
	[SerialNumber] INTEGER UNIQUE,
	[Chart] VARBINARY(MAX) FILESTREAM NULL
)
GO



INSERT INTO Archive.dbo.Records
    VALUES (newid (), 1, NULL);
GO


INSERT INTO Archive.dbo.Records
    VALUES (newid (), 2, 
      CAST ('' as varbinary(max)));
GO


INSERT INTO Archive.dbo.Records
    VALUES (newid (), 3, 
      CAST ('Seismic Data' as varbinary(max)));
GO


-- Declare a variable to store the image data
DECLARE @img AS VARBINARY(MAX)
 
-- Load the image data
SELECT @img = CAST(bulkcolumn AS VARBINARY(MAX))
      FROM OPENROWSET(
            BULK
            'C:\tests\portraitpack.png',
            SINGLE_BLOB ) AS x
           
-- Insert the data to the table          
INSERT INTO Records(Id, SerialNumber, Chart)
SELECT NEWID(), 4, @img


select * from records


DECLARE @filePath varchar(max)

SELECT @filePath = Chart.PathName()
FROM Archive.dbo.Records
WHERE SerialNumber = 3

PRINT @filepath