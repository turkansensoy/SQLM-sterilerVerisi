USE CUSTOMERS
SELECT *FROM CUSTOMERS WHERE  CUSTOMERNAME LIKE 'A%' and GENDER='E'
-----------------------------------------------------------------------------------------------------------------------------------------
---1990 ve 1995 yılları arasında doğan müşterileri çekiniz.
SELECT *FROM CUSTOMERS WHERE YEAR(BIRHTDATE) BETWEEN 1990 AND 1995
-----------------------------------------------------------------------------------------------------------------------------------------
--- İSTANBULDA yaşayan kişileri join kullanarak getirme
SELECT *FROM CUSTOMERS CUS
INNER JOIN CITYS C ON C.ID= CUS.CITYID WHERE C.CITY = 'İSTANBUL'
----İstanbulda yaşayan kişileri subquery kullanarak getiren
SELECT *FROM CUSTOMERS WHERE CUSTOMERS.CITYID= (SELECT ID FROM CITYS WHERE CITY='İSTANBUL')
-----------------------------------------------------------------------------------------------------------------------------------------
---Hangi şehirde kaç müşterimizin oldugu bilgisini getiren sorgu
SELECT  COUNT(CUS.CUSTOMERNAME),C.CITY FROM CUSTOMERS CUS INNER JOIN CITYS C 
ON CUS.CITYID= C.ID GROUP BY C.CITY
	---OR 
SELECT C.CITY, (SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID= C.ID) AS CUSTORMER_COUNT  FROM CITYS C
-----------------------------------------------------------------------------------------------------------------------------------------
--- 10'dan fazla müşterimiz olan şehirleri müşteri sayısı ile birlikte müşteri sayısına göre 
--fazladan aza doğru sıralı şekilde getiriniz.
SELECT COUNT(CUS.CUSTOMERNAME) 'MÜŞTERİ SAYISI', C.CITY FROM CUSTOMERS CUS INNER JOIN CITYS C
ON CUS.CITYID= C.ID GROUP BY C.CITY HAVING COUNT(CUS.CUSTOMERNAME)>10  ORDER BY 'MÜŞTERİ SAYISI' DESC
-----------------------------------------------------------------------------------------------------------------------------------------
---Hangi şehirde kaç erkek, kaç kadın müşterimizin olduğu bilgisini
SELECT C.CITY,CUS.GENDER,COUNT(CUS.ID) FROM CUSTOMERS CUS  INNER JOIN CITYS C 
ON CUS.CITYID= C.ID GROUP BY C.CITY,CUS.GENDER ORDER BY C.CITY,CUS.GENDER

---OR
 SELECT CITY AS SEHIRADİ,(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID= C.ID AND GENDER='E' ) AS ERKEKSAYİSİ,
(SELECT COUNT(*) FROM CUSTOMERS WHERE CITYID=C.ID AND GENDER='K') AS KİZSAYİSİ
 FROM  CITYS C
-----------------------------------------------------------------------------------------------------------------------------------------
---- CUSTOMERS TABLOSUNA EKLENEN AGEGROUP alanını 20-35 yaş arası, 36-45 yaş arası, 55-65 yaş arası 
--ve 65 yaş üstü olarak güncelleyin.
SELECT BIRHTDATE, YEAR(GETDATE())- YEAR(BIRHTDATE) AS FARK FROM CUSTOMERS 

UPDATE CUSTOMERS SET AGEGROUP=
	CASE
		WHEN YEAR(GETDATE())-YEAR(BIRHTDATE) BETWEEN 20 AND 35 THEN '20-35 arası'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE) BETWEEN 36 AND 45 THEN '36-45 arası'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE) BETWEEN 46 AND 55 THEN '46-55 arası'
		WHEN YEAR(GETDATE())- YEAR(BIRHTDATE)> 55 THEN ' 65 üzeri' 
	END;
SELECT *FROM CUSTOMERS
---0R-----------------------------------------------------------------------------
SELECT DATEDIFF(YEAR,BIRHTDATE,GETDATE()),*FROM CUSTOMERS

UPDATE CUSTOMERS SET AGEGROUP='20-35 yas'
 WHERE DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35

SELECT *FROM CUSTOMERS
---------------------------------------------------------------------------------------------------------------------------------------
--CUSTOMERS TABLOSUNDA 20-35 yaş arası, 36-45 yaş arası, 46-55 yaş arası,56-64 yaş arası ve 65 yaş üstü kaç kişi***************
SELECT   CASE
			WHEN DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arası'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arası'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arası'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arası'
			WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERİ'
		END AS YAS_ARALIK,
		COUNT(*) FROM CUSTOMERS CUS 
	GROUP BY CASE
					WHEN DATEDIFF(YEAR,BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arası'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arası'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arası'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arası'
					WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERİ'
			 END
	ORDER BY YAS_ARALIK;
-----OR----

SELECT YAS_ARALIK,COUNT(TMP.ID) FROM 
(SELECT *,
	CASE
	  WHEN DATEDIFF(YEAR , BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arası'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arası'
   	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arası'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arası'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERİ'
	END AS YAS_ARALIK
FROM CUSTOMERS )TMP
GROUP BY YAS_ARALIK ORDER BY YAS_ARALIK

---OR----
WITH TMP AS (SELECT *,
	CASE
	  WHEN DATEDIFF(YEAR , BIRHTDATE,GETDATE()) BETWEEN 20 AND 35 THEN '20-35 arası'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45 arası'
   	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55 arası'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) BETWEEN 56 AND 64 THEN '56-64 arası'
	  WHEN DATEDIFF(YEAR, BIRHTDATE, GETDATE()) >65 THEN '65 ÜZERİ'
	END AS YAS_ARALIK
  FROM CUSTOMERS ) 
SELECT YAS_ARALIK,COUNT(TMP.ID) FROM TMP  GROUP BY YAS_ARALIK ORDER BY YAS_ARALIK;
-----------------------------------------------------------------------------------------------------------------------------------------
--İstanbulda yaşayıp ilçesi Kadıköy dışında olanları listele
SELECT  COUNT(*) FROM CUSTOMERS CUS 
INNER JOIN CITYS C ON CUS.CITYID= C.ID WHERE C.CITY='İSTANBUL' AND CUS.DISTRICTID !=(SELECT ID FROM DISTRICTS D WHERE D.DISTRICT='KADIKÖY') ;

---OR----
SELECT COUNT(*) FROM CUSTOMERS CUS
INNER JOIN CITYS C ON CUS.CITYID= C.ID
INNER JOIN DISTRICTS D ON CUS.DISTRICTID=D.ID WHERE C.CITY= 'İSTANBUL' AND D.DISTRICT <> 'KADIKÖY';
-----------------------------------------------------------------------------------------------------------------------------------------
---Müşterilerimizin telefon numaralarının operatör bilgisini getirmek istiyoruz.TELNR1 VE TELNR2 alanlarının 
--yanına operatör numarasını (532)(505) gibi getirme
SELECT *FROM CUSTOMERS
SELECT CUSTOMERNAME, TELNR1,TELNR2, 
SUBSTRING(TELNR1,1,5) AS OPERATOR1, 
SUBSTRING(TELNR2,1,5 ) AS OPERATOR2 
FROM CUSTOMERS
-----------------------------------------------------------------------------------------------------------------------------------------
--Her ilde en cok müşteriye sahip olduğumuz ilçeleri müşteri sayısına göre 
--çoktan aza doğru sıralı şekilde getirme.

SELECT C.CITY AS ŞEHİR,D.DISTRICT AS İLÇE, COUNT(CUS.TCNUMBER) AS MÜSTERİSAYİSİ FROM CUSTOMERS CUS
INNER JOIN CITYS C ON CUS.CITYID=C.ID 
INNER JOIN  DISTRICTS D ON D.ID=CUS.DISTRICTID GROUP BY D.DISTRICT,C.CITY ;

-----------------------------------------------------------------------------------------------------------------------------------------
--MÜŞTERİLERİN DOGUM GÜNLERİNİ  HAFTANIN GÜNÜ OLARAK LİSTELEME
SELECT CUSTOMERNAME,
	CASE DATENAME(WEEKDAY,BIRHTDATE)
		WHEN 'Monday' THEN 'Pazartesi'
		WHEN 'Tuesday' THEN 'Salı'
		WHEN 'Wednesday' THEN 'Çarşamba'
		WHEN 'Thursday' THEN 'Perşembe'
		WHEN 'Friday' THEN 'Cuma'
		WHEN 'Saturday' THEN 'Cumartesi'
		WHEN 'Sunday' THEN 'Pazar'
		else 'Bilinmiyor'
	End
FROM CUSTOMERS
-----------------------------------------------------------------------------------------------------------------------------------------
--DOGUM GÜNÜ BUGÜN OLAN MÜŞTERİLERİ LİSTELEYİNİZ
SELECT* FROM CUSTOMERS WHERE DAY(BIRHTDATE)= DAY(GETDATE()) AND MONTH(BIRHTDATE)= MONTH(GETDATE()); 
-----------------------------------------------------------------------------------------------------------------------------------------
