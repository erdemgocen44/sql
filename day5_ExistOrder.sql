CREATE TABLE mart_satislar
    (
        urun_id number(10),
        musteri_isim varchar2(50),
        urun_isim varchar2(50)
    );
CREATE TABLE nisan_satislar
    (
        urun_id number(10),
        musteri_isim varchar2(50),
        urun_isim varchar2(50)
    );
    
    INSERT INTO mart_satislar VALUES (10, 'Mark', 'Honda');
    INSERT INTO mart_satislar VALUES (10, 'Mark', 'Honda');
    INSERT INTO mart_satislar VALUES (20, 'John', 'Toyota');
    INSERT INTO mart_satislar VALUES (30, 'Amy', 'Ford');
    INSERT INTO mart_satislar VALUES (20, 'Mark', 'Toyota');
    INSERT INTO mart_satislar VALUES (10, 'Adem', 'Honda');
    INSERT INTO mart_satislar VALUES (40, 'John', 'Hyundai');
    INSERT INTO mart_satislar VALUES (20, 'Eddie', 'Toyota');
    INSERT INTO nisan_satislar VALUES (10, 'Hasan', 'Honda');
    INSERT INTO nisan_satislar VALUES (10, 'Kemal', 'Honda');
    INSERT INTO nisan_satislar VALUES (20, 'Ayse', 'Toyota');
    INSERT INTO nisan_satislar VALUES (50, 'Yasar', 'Volvo');
    INSERT INTO nisan_satislar VALUES (20, 'Mine', 'Toyota');
    
select * from mart_satislar;
select * from nisan_satislar;

--ORNEK1: MART VE N?SAN aylar?nda ayn? URUN_ID ile sat?lan ?r?nlerin
--URUN_ID?lerini listeleyen ve ayn? zamanda bu ?r?nleri MART ay?nda alan
--MUSTERI_ISIM 'lerini listeleyen bir sorgu yaz?n?z.

select urun_id,musteri_isim  FROM mart_sat?slar
WHERE EXISTS(SELECT urun_id from nisan_satislar
                    where mart_satislar. urun_id=nisan_satislar. urun_id);
                    
--ORNEK2: Her iki ayda da sat?lan ?r?nlerin URUN_ISIM'lerini ve bu ?r?nleri
--N?SAN ay?nda sat?n alan MUSTERI_ISIM'lerini listeleyen bir sorgu yaz?n?z.

select urun_isim, musteri_isim from nisan_sat?slar n
where exists(SELECT urun_isim from mart_satislar m
            where m.urun_isim=n.urun_isim);
            
--ORNEK3: Her iki ayda da ortak olarak sat?lmayan ?r?nlerin URUN_ISIM'lerini
--ve bu ?r?nleri N?SAN ay?nda sat?n alan MUSTERI_ISIM'lerini listeleyiniz.

select urun_isim,musteri_isim from nisan_satislar n
where not exists(select urun_isim from mart_satislar m
            where m.urun_isim=n.urun_isim);
            
===================== IS NULL, IS NOT NULL, COALESCE(kulesk=birle?mek) ========================
    IS NULL, ve IS NOT NULL BOOLEAN operat?rleridir. Bir ifadenin NULL olup
    olmad???n? kontrol ederler.
==============================================================================*/
    CREATE TABLE insanlar
    (
        ssn CHAR(9),
        isim VARCHAR2(50),
        adres VARCHAR2(50)
    );
    INSERT INTO insanlar VALUES('123456789', 'Ali Can', 'Istanbul');
    INSERT INTO insanlar VALUES('234567890', 'Veli Cem', 'Ankara');
    INSERT INTO insanlar VALUES('345678901', 'Mine Bulut', 'Izmir');
    INSERT INTO insanlar (ssn, adres) VALUES('456789012', 'Bursa');
    INSERT INTO insanlar (ssn, adres) VALUES('567890123', 'Denizli');
    INSERT INTO insanlar (adres) VALUES('Sakarya');
    INSERT INTO insanlar (ssn) VALUES('999111222');
    
    select * from insanlar;
    
    --Ornek 1-- isim i null olanlar? sorgulay?n?z
    
    select * from insanlar
    where isim IS NULL;
    
    select * from insanlar
    where adres='Bursa';
    
    --Ornek 2 --isimi null olmayanlar? sorgula
    select * from insanlar
    where isim is not null;
    
    --Ornek3--ismi null olan ki?ilerin isminde NO NAME yaz?s? atay?n?z
    
    UPDATE insanlar
    SET isim='NO NAME'
    WHERE isim IS NULL;
    
    SELECT COALESCE(isim,ssn, adres) from insanlar;
    

    --Ornek 4--tablodaki b?t?n null verileri g?zerl birer c?mlecikle de?i?tirin
    
    UPDATE insanlar
    SET isim=COALESCE(isim, 'hen?z isim girilmedi'),
        adres=COALESCE (adres, 'hen?z adres girilmedi'),
        ssn=COALESCE(ssn,'No SSN');
    
 /*   ================================ ORDER BY  ===================================
   ORDER BY c?mleci?i bir SORGU deyimi i?erisinde belli bir SUTUN?a g?re
   SIRALAMA yapmak i?in kullan?l?r.
   Syntax
   -------
      ORDER BY sutun_adi ASC   -- ARTAN
      ORDER BY sutun_adi DESC  -- AZALAN
=========================================*/
CREATE TABLE kisiler
    (
        ssn CHAR(9) PRIMARY KEY,
        isim VARCHAR2(50),
        soyisim VARCHAR2(50),
        maas NUMBER,
        adres VARCHAR2(50)
    );
    INSERT INTO kisiler VALUES(123456789, 'Ali','Can', 3000,'Istanbul');
    INSERT INTO kisiler VALUES(234567890, 'Veli','Cem', 2890,'Ankara');
    INSERT INTO kisiler VALUES(345678901, 'Mine','Bulut',4200,'Ankara');
    INSERT INTO kisiler VALUES(256789012, 'Mahmut','Bulut',3150,'Istanbul');
    INSERT INTO kisiler VALUES (344678901, 'Mine','Yasa', 5000,'Ankara');
    INSERT INTO kisiler VALUES (345458901, 'Veli','Yilmaz',7000,'Istanbul');
    SELECT * FROM kisiler;

---  ORNEK1: kisiler tablosunu adres'e g?re s?ralayarak sorgulay?n?z.
    
select * from kisiler
order by adres;

--Ornek 2-- kisiler tablosnu maasa g?re ters s?ralayal?m

select * from kisiler
order by maas desc;

--ORNEK3: ismi Mine olanlar?, SSN'e g?re AZALAN(DESC) s?rada sorgulay?n?z.

select * from kisiler
where isim='Mine'
order by ssn desc;

--ORNEK5: soyismi 'i Bulut olanlar? isim s?ral? olarak sorgulay?n?z.

select * from kisiler
where soyisim='Bulut'
order by 2;  --isim yerine ismin s?tun s?ras?n? da yazabiliriz

/*
====================== FETCH NEXT, OFFSET (12C VE ?ST? oracle larda ?al???r, daha altsan?z ?al??maz) ======================
   FETCH c?mleci?i ile listelenecek kay?tlar? s?n?rland?rabiliriz. ?stersek
   sat?r say?s?na g?re istersek de toplam sat?r say?s?n?n belli bir y?zdesine
   g?re s?n?rland?rma koymak m?mk?nd?r. (?u kadar sat?r? getir)
   Syntax
   ---------
   FETCH NEXT satir_sayisi ROWS ONLY;
   FETCH NEXT satir_yuzdesi PERCENT ROWS ONLY;
   OFFSET C?mleci?i ile de listenecek olan sat?rlardan s?ras?yla istedi?imiz
   kadar?n? atlayabiliriz.
   Syntax
   ----------
   OFFSET sat?r_sayisi ROWS;
==============================================================================*/
/* ----------------------------------------------------------------------------
  ORNEK1: MAA?'? en y?ksek 3 ki?inin bilgilerini listeleyen sorguyu yaz?n?z.*/
  
  select * from kisiler
  order by maas desc
  fetch next 3 rows only;--  yeni s?r?mlerde ?al???r 11den sonraki
  
  SELECT * FROM (SELECT * FROM kisiler
    ORDER BY maas DESC)--(1) ki?ilerde maasa g?re ters s?rala
    WHERE ROWNUM < 4;-- 1.2.ve 3. sat?r? getir-- eski s?r?mlerde ?al???r...
  

--ORNEK2: MAA?'? en D???K 2 ki?inin bilgilerini listeleyen sorguyu yaz?n?z.
    
    select * from kisiler
    order by maas
    fetch next 2 rows only;
    
    SELECT * FROM (SELECT * FROM kisiler
    ORDER BY maas )
    WHERE ROWNUM < 3;
    
--ORNEK3: MAA?'a g?re azalan s?ralamada 4. 5. ve 6. ki?ilerin bilgilerini listeleyen
--sorguyu yaz?n?z.

select * from (select * from kisiler
order by maas desc )
offset 3 rows
fetch next 3 rows only;

SELECT * FROM-- eski ??z?m
   (SELECT * FROM
   (SELECT *
            FROM   kisiler
            ORDER BY maas DESC)
        WHERE ROWNUM <=6)
WHERE  ROWNUM <=3;
    
                    
                    