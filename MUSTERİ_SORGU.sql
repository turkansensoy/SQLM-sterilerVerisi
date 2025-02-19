USE CUSTOMERS
SELECT *FROM CUSTOMERS WHERE  CUSTOMERNAME LIKE 'A%' and GENDER='E'
-----------------------------------------------------------------------------------------------------------------------------------------
---1990 ve 1995 y�llar� aras�nda do�an m��terileri �ekiniz.
SELECT *FROM CUSTOMERS WHERE YEAR(BIRHTDATE) BETWEEN 1990 AND 1995
-----------------------------------------------------------------------------------------------------------------------------------------
--- �STANBULDA ya�ayan ki�ileri join kullanarak getirme
SELECT *FROM CUSTOMERS CUS
INNER JOIN CITYS C ON C.ID= CUS.CITYID WHERE C.CITY = '�STANBUL'
----�stanbulda ya�ayan ki�ileri subquery kullanarak getiren
SELECT *FROM CUSTOMERS WHERE CUSTOMERS.CITYID= (SELECT ID FROM CITYS WHERE CITY='�STANBUL')
-----------------------------------------------------------------------------------------------------------------------------------------
---Hangi �ehirde ka� m��terimizin oldugu bilgisini getiren sorgu
SELECT  COUNT(CUS.CUSTOMERNAME),C.CITY FROM CUSTOMERS CUS INNER JOIN CITYS C 
ON CUS.CITYID= C.ID GROUP BY C.CITY
	---OR 
SELECT C.CITY, (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID= C.ID) AS CUSTORMER_COUNT  FROM CITYS C
-----------------------------------------------------------------------------------------------------------------------------------------
--- 10'dan fazla m��terimiz olan �ehirleri m��teri say�s� ile birlikte m��teri say�s�na g�re 
--fazladan aza do�ru s�ral� �ekilde getiriniz.
SELECT COUNT(CUS.CUSTOMERNAME) 'M��TER� SAYISI', C.CITY FROM CUSTOMERS CUS INNER JOIN CITYS C
ON CUS.CITYID= C.ID GROUP BY C.CITY HAVING COUNT(CUS.CUSTOMERNAME)>10  ORDER BY 'M��TER� SAYISI' DESC
-----------------------------------------------------------------------------------------------------------------------------------------
---Hangi �ehirde ka� erkek, ka� kad�n m��terimizin oldu�u bilgisini
SELECT C.CITY,CUS.GENDER,COUNT(CUS.ID) FROM CUSTOMERS CUS  INNER JOIN CITYS C 
ON CUS.CITYID= C.ID GROUP BY C.CITY,CUS.GENDER ORDER BY C.CITY,CUS.GENDER

---OR
 SELECT CITY AS SEHIRAD�,(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID= C.ID AND GENDER='E' ) AS ERKEKSAY�S�,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='K') AS K�ZSAY�S�
 FROM  CITYS C
-----------------------------------------------------------------------------------------------------------------------------------------
---- CUSTOMERS TABLOSUNA EKLENEN AGEGROUP alan�n� 20-35 ya� aras�, 36-45 ya� aras�, 55-65 ya� aras� 
--ve 65 ya� �st� olarak g�ncelleyin.
SELECT BIRHTDATE, YEAR(GETDATE())- YEAR(BIRHTDATE) AS FARK FROM CUSTOMERS 

UPDATE CUSTOMERS SET AGEGROUP=
	CASE
		WHEN YEAR(GETDATE())-YEAR(BIRHTDATE) BETWEEN 20 AND 35 THEN '20-35 aras�'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE) BETWEEN 36 AND 45 THEN '36-45 aras�'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE) BETWEEN 46 AND 55 THEN '46-55 aras�'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE)> 55 THEN ' 65 �zeri' 
	END;
SELECT *FROM CUSTOMERS
---0R-----------------------------------------------------------------------------
SELECT DATEDIFF(YEAR,BIRHTDATE,GETDATE()),*FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='20-35 yas'
 WHERE DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35

SELECT *FROM CUSTOMERS
---------------------------------------------------------------------------------------------------------------------------------------
--CUSTOMERS TABLOSUNDA 20-35 ya� aras�, 36-45 ya� aras�, 46-55 ya� aras�,56-64 ya� aras� ve 65 ya� �st� ka� ki�i***************
SELECT   CASE
			WHEN DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 aras�'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 aras�'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 aras�'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 aras�'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 �ZER�'
		END AS YAS_ARALIK,
		COUNT(*) FROM CUSTOMERS CUS 
	GROUP BY CASE
					WHEN DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 aras�'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 aras�'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 aras�'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 aras�'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 �ZER�'
			 END
	ORDER BY YAS_ARALIK;
-----OR----

SELECT YAS_ARALIK,COUNT(TMP.ID) FROM 
(SELECT *,
	CASE
	  WHEN DATEDIFF(YEAR , BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 aras�'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 aras�'
   	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 aras�'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 aras�'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 �ZER�'
	END AS YAS_ARALIK
FROM CUSTOMERS )TMP
GROUP BY YAS_ARALIK ORDER BY YAS_ARALIK
-----------------------------------------------------------------------------------------------------------------------------------------
--�stanbulda ya�ay�p il�esi Kad�k�y d���nda olanlar� listele
SELECT  COUNT(*) FROM CUSTOMERS CUS 
INNER JOIN CITYS C ON CUS.CITYID= C.ID WHERE C.CITY='�STANBUL' AND CUS.DISTRICTID !=(SELECT ID FROM DISTRICTS D WHERE D.DISTRICT='KADIK�Y') ;

---OR----
SELECT COUNT(*) FROM CUSTOMERS CUS
INNER JOIN CITYS C ON CUS.CITYID= C.ID
INNER JOIN DISTRICTS D ON CUS.DISTRICTID=D.ID WHERE C.CITY= '�STANBUL' AND D.DISTRICT <> 'KADIK�Y';
-----------------------------------------------------------------------------------------------------------------------------------------
---M��terilerimizin telefon numaralar�n�n operat�r bilgisini getirmek istiyoruz.TELNR1 VE TELNR2 alanlar�n�n 
--yan�na operat�r numaras�n� (532)(505) gibi getirme
SELECT *FROM CUSTOMERS
SELECT CUSTOMERNAME, TELNR1,TELNR2, 
SUBSTRING(TELNR1,1,5) AS OPERATOR1, 
SUBSTRING(TELNR2,1,5 ) AS OPERATOR2 
FROM CUSTOMERS
-----------------------------------------------------------------------------------------------------------------------------------------
--Her ilde en cok m��teriye sahip oldu�umuz il�eleri m��teri say�s�na g�re 
--�oktan aza do�ru s�ral� �ekilde getirme.

SELECT C.CITY AS �EH�R,D.DISTRICT AS �L�E, COUNT(CUS.TCNUMBER) AS M�STER�SAY�S� FROM CUSTOMERS CUS
INNER JOIN CITYS C ON CUS.CITYID=C.ID 
INNER JOIN  DISTRICTS D ON D.ID=CUS.DISTRICTID GROUP BY D.DISTRICT,C.CITY ;

-----------------------------------------------------------------------------------------------------------------------------------------
--M��TER�LER�N DOGUM G�NLER�N�  HAFTANIN G�N� OLARAK L�STELEME
SELECT CUSTOMERNAME,
	CASE DATENAME(WEEKDAY,BIRHTDATE)
		WHEN 'Monday' THEN 'Pazartesi'
		WHEN 'Tuesday' THEN 'Sal�'
		WHEN 'Wednesday' THEN '�ar�amba'
		WHEN 'Thursday' THEN 'Per�embe'
		WHEN 'Friday' THEN 'Cuma'
		WHEN 'Saturday' THEN 'Cumartesi'
		WHEN 'Sunday' THEN 'Pazar'
		else 'Bilinmiyor'
	End
FROM CUSTOMERS
-----------------------------------------------------------------------------------------------------------------------------------------
--DOGUM G�N� BUG�N OLAN M��TER�LER� L�STELEY�N�Z
SELECT* FROM CUSTOMERS WHERE DAY(BIRHTDATE)= DAY(GETDATE()) AND MONTH(BIRHTDATE)= MONTH(GETDATE()); 
-----------------------------------------------------------------------------------------------------------------------------------------