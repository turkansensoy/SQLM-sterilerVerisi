USE CUSTOMERS
SELECT *FROM CUSTOMERS WHERE  CUSTOMERNAME LIKE 'A%' and GENDER='E'
-----------------------------------------------------------------------------------------------------------------------------------------
---1990 ve 1995 yýllarý arasýnda doðan müþterileri çekiniz.
SELECT *FROM CUSTOMERS WHERE YEAR(BIRHTDATE) BETWEEN 1990 AND 1995
-----------------------------------------------------------------------------------------------------------------------------------------
--- ÝSTANBULDA yaþayan kiþileri join kullanarak getirme
SELECT *FROM CUSTOMERS CUS
INNER JOIN CITYS C ON C.ID= CUS.CITYID WHERE C.CITY = 'ÝSTANBUL'
----Ýstanbulda yaþayan kiþileri subquery kullanarak getiren
SELECT *FROM CUSTOMERS WHERE CUSTOMERS.CITYID= (SELECT ID FROM CITYS WHERE CITY='ÝSTANBUL')
-----------------------------------------------------------------------------------------------------------------------------------------
---Hangi þehirde kaç müþterimizin oldugu bilgisini getiren sorgu
SELECT  COUNT(CUS.CUSTOMERNAME),C.CITY FROM CUSTOMERS CUS INNER JOIN CITYS C 
ON CUS.CITYID= C.ID GROUP BY C.CITY
	---OR 
SELECT C.CITY, (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID= C.ID) AS CUSTORMER_COUNT  FROM CITYS C
-----------------------------------------------------------------------------------------------------------------------------------------
--- 10'dan fazla müþterimiz olan þehirleri müþteri sayýsý ile birlikte müþteri sayýsýna göre 
--fazladan aza doðru sýralý þekilde getiriniz.
SELECT COUNT(CUS.CUSTOMERNAME) 'MÜÞTERÝ SAYISI', C.CITY FROM CUSTOMERS CUS INNER JOIN CITYS C
ON CUS.CITYID= C.ID GROUP BY C.CITY HAVING COUNT(CUS.CUSTOMERNAME)>10  ORDER BY 'MÜÞTERÝ SAYISI' DESC
-----------------------------------------------------------------------------------------------------------------------------------------
---Hangi þehirde kaç erkek, kaç kadýn müþterimizin olduðu bilgisini
SELECT C.CITY,CUS.GENDER,COUNT(CUS.ID) FROM CUSTOMERS CUS  INNER JOIN CITYS C 
ON CUS.CITYID= C.ID GROUP BY C.CITY,CUS.GENDER ORDER BY C.CITY,CUS.GENDER

---OR
 SELECT CITY AS SEHIRADÝ,(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID= C.ID AND GENDER='E' ) AS ERKEKSAYÝSÝ,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='K') AS KÝZSAYÝSÝ
 FROM  CITYS C
-----------------------------------------------------------------------------------------------------------------------------------------
---- CUSTOMERS TABLOSUNA EKLENEN AGEGROUP alanýný 20-35 yaþ arasý, 36-45 yaþ arasý, 55-65 yaþ arasý 
--ve 65 yaþ üstü olarak güncelleyin.
SELECT BIRHTDATE, YEAR(GETDATE())- YEAR(BIRHTDATE) AS FARK FROM CUSTOMERS 

UPDATE CUSTOMERS SET AGEGROUP=
	CASE
		WHEN YEAR(GETDATE())-YEAR(BIRHTDATE) BETWEEN 20 AND 35 THEN '20-35 arasý'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE) BETWEEN 36 AND 45 THEN '36-45 arasý'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE) BETWEEN 46 AND 55 THEN '46-55 arasý'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE)> 55 THEN ' 65 üzeri' 
	END;
SELECT *FROM CUSTOMERS
---0R-----------------------------------------------------------------------------
SELECT DATEDIFF(YEAR,BIRHTDATE,GETDATE()),*FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='20-35 yas'
 WHERE DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35

SELECT *FROM CUSTOMERS
---------------------------------------------------------------------------------------------------------------------------------------
--CUSTOMERS TABLOSUNDA 20-35 yaþ arasý, 36-45 yaþ arasý, 46-55 yaþ arasý,56-64 yaþ arasý ve 65 yaþ üstü kaç kiþi***************
SELECT   CASE
			WHEN DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arasý'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arasý'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arasý'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arasý'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERÝ'
		END AS YAS_ARALIK,
		COUNT(*) FROM CUSTOMERS CUS 
	GROUP BY CASE
					WHEN DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arasý'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arasý'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arasý'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arasý'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERÝ'
			 END
	ORDER BY YAS_ARALIK;
-----OR----

SELECT YAS_ARALIK,COUNT(TMP.ID) FROM 
(SELECT *,
	CASE
	  WHEN DATEDIFF(YEAR , BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arasý'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arasý'
   	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arasý'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arasý'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERÝ'
	END AS YAS_ARALIK
FROM CUSTOMERS )TMP
GROUP BY YAS_ARALIK ORDER BY YAS_ARALIK
-----------------------------------------------------------------------------------------------------------------------------------------
--Ýstanbulda yaþayýp ilçesi Kadýköy dýþýnda olanlarý listele
SELECT  COUNT(*) FROM CUSTOMERS CUS 
INNER JOIN CITYS C ON CUS.CITYID= C.ID WHERE C.CITY='ÝSTANBUL' AND CUS.DISTRICTID !=(SELECT ID FROM DISTRICTS D WHERE D.DISTRICT='KADIKÖY') ;

---OR----
SELECT COUNT(*) FROM CUSTOMERS CUS
INNER JOIN CITYS C ON CUS.CITYID= C.ID
INNER JOIN DISTRICTS D ON CUS.DISTRICTID=D.ID WHERE C.CITY= 'ÝSTANBUL' AND D.DISTRICT <> 'KADIKÖY';
-----------------------------------------------------------------------------------------------------------------------------------------
---Müþterilerimizin telefon numaralarýnýn operatör bilgisini getirmek istiyoruz.TELNR1 VE TELNR2 alanlarýnýn 
--yanýna operatör numarasýný (532)(505) gibi getirme
SELECT *FROM CUSTOMERS
SELECT CUSTOMERNAME, TELNR1,TELNR2, 
SUBSTRING(TELNR1,1,5) AS OPERATOR1, 
SUBSTRING(TELNR2,1,5 ) AS OPERATOR2 
FROM CUSTOMERS
-----------------------------------------------------------------------------------------------------------------------------------------
--Her ilde en cok müþteriye sahip olduðumuz ilçeleri müþteri sayýsýna göre 
--çoktan aza doðru sýralý þekilde getirme.

SELECT C.CITY AS ÞEHÝR,D.DISTRICT AS ÝLÇE, COUNT(CUS.TCNUMBER) AS MÜSTERÝSAYÝSÝ FROM CUSTOMERS CUS
INNER JOIN CITYS C ON CUS.CITYID=C.ID 
INNER JOIN  DISTRICTS D ON D.ID=CUS.DISTRICTID GROUP BY D.DISTRICT,C.CITY ;

-----------------------------------------------------------------------------------------------------------------------------------------
--MÜÞTERÝLERÝN DOGUM GÜNLERÝNÝ  HAFTANIN GÜNÜ OLARAK LÝSTELEME
SELECT CUSTOMERNAME,
	CASE DATENAME(WEEKDAY,BIRHTDATE)
		WHEN 'Monday' THEN 'Pazartesi'
		WHEN 'Tuesday' THEN 'Salý'
		WHEN 'Wednesday' THEN 'Çarþamba'
		WHEN 'Thursday' THEN 'Perþembe'
		WHEN 'Friday' THEN 'Cuma'
		WHEN 'Saturday' THEN 'Cumartesi'
		WHEN 'Sunday' THEN 'Pazar'
		else 'Bilinmiyor'
	End
FROM CUSTOMERS
-----------------------------------------------------------------------------------------------------------------------------------------
--DOGUM GÜNÜ BUGÜN OLAN MÜÞTERÝLERÝ LÝSTELEYÝNÝZ
SELECT* FROM CUSTOMERS WHERE DAY(BIRHTDATE)= DAY(GETDATE()) AND MONTH(BIRHTDATE)= MONTH(GETDATE()); 
-----------------------------------------------------------------------------------------------------------------------------------------