/*
==================== SET (k?me) OPERATORLERI: UNION, UNION ALL======================
    set=k?me diyelim di?er set (sql komutu) ile kar??mas?n
    UNION, UNION ALL, INTERSECT, ve MINUS gibi SET operatorleri yardimiyla
    ?oklu Sorgular birlestirilebilirler.ayn? tablodan yada farkl? tablodan s?tunlar? birle?tirip ayn? s?tunda yazd?rma
    UNION :  Bir SET operatorudur. 2 veya daha fazla Sorgu ifadesinin sonuc
    kumelerini birlesitirerek tek bir sonuc kumesi olusturur. (iki k?menin birle?imi)
    -- UNION
-- Eger tek sorguda birlestiremeyecegim iki sorgunun sonucunu ayni tabloda
-- gormek istersek UNION islemi kullanilir
-- Bu durumda dikkat etmemiz gereken konu iki sorguda da field sayisi ve
-- alt alta gelecek field data tiplerinin ayni olmasidir
    -- UNION ALL komutu ise tekrara bakmaksizin iki sorgudan gelen tum sonuclari listeler
-- UNION ALL komutunda da iki sorgunun sonucunun esit sayida field'a ve data
-- tiplerine sahip olmasi gereklidir
     S?TUN birle?tirme=> SET
     TABLO birle?tirme=> JOIN
    Syntax:
    ----------
    SELECT sutun_adi,sutun_adi2, .. FROM tablo_adi1
    UNION
    SELECT sutun_adi1, sutun_adi2, .. FROM tablo_adi2;
    NOT: UNION operatoru SADECE benzersiz degerleri al?r. Benzerli verileri almak
    i?in UNION ALL kullan?l?r.
*/

drop table personel;
    CREATE TABLE personel
    (
        id NUMBER(9),
        isim VARCHAR2(50),
        sehir VARCHAR2(50),
        maas NUMBER(20),
        sirket VARCHAR2(20)
    );
    INSERT INTO personel VALUES(123456789, 'Ali Yilmaz', 'Istanbul', 5500, 'Honda');
    INSERT INTO personel VALUES(234567890, 'Veli Sahin', 'Istanbul', 4500, 'Toyota');
    INSERT INTO personel VALUES(345678901, 'Mehmet Ozturk', 'Ankara', 3500, 'Honda');
    INSERT INTO personel VALUES(456789012, 'Mehmet Ozturk', 'Izmir', 6000, 'Ford');
    INSERT INTO personel VALUES(567890123, 'Mehmet Ozturk', 'Ankara', 7000, 'Tofas');
    INSERT INTO personel VALUES(453445611, 'Veli Sahin', 'Ankara', 4500, 'Ford');
    INSERT INTO personel VALUES(123456710, 'Hatice Sahin','Bursa', 4200, 'Honda');
    
--ORNEK1: Maasi 4000?den cok olan isci isimlerini ve 5000 liradan fazla maa?
--alinan sehirleri gosteren sorguyu yaziniz. maaslar? sonradan
    
    select isim as isim_veya_sehir,maas from personel
    where maas>4000
    UNION
    select sehir, maas from personel
    where maas>5000;
    
--ORNEK2: Mehmet Ozturk ismindeki kisilerin aldigi maaslari ve Istanbul?daki
--personelin maaslarini y?ksekten al?a?a do?ru s?ralayarak bir tabloda gosteren sorguyu yaziniz.

select isim as isim_sehir, maas from personel--tekrar? olmad??? i?in union alll kullanmad?k
where isim='Mehmet Ozturk'
UNION
select sehir,maas from personel
where sehir='Istanbul'
order by maas desc;

--======================== FARKLI TABLOLARDAN BIRLESTIRME ====================*/
 --   hata verirse personel i sil bir daha create et
    CREATE TABLE personel_bilgi
    (
        id NUMBER(9),
        tel char(10) UNIQUE ,
        cocuk_sayisi NUMBER(2)
 
    );
    INSERT INTO personel_bilgi VALUES(123456789, '5302345678' , 5);
    INSERT INTO personel_bilgi VALUES(234567890, '5422345678', 4);
    INSERT INTO personel_bilgi VALUES(345678901, '5354561245', 3);
    INSERT INTO personel_bilgi VALUES(456789012, '5411452659', 3);
    INSERT INTO personel_bilgi VALUES(567890123, '5551253698', 2);
    INSERT INTO personel_bilgi VALUES(453445611, '5524578574', 2);
    INSERT INTO personel_bilgi VALUES(123456710, '5537488585', 1);
    
-- Ornek 3: id' si 123456789 olan personelin personel tablosu' ndan sehir ve maasini, personel_bilgi tablosundan da tel ve cocuk sayisini yazdiriniz (edited) 

select id,sehir as sehir_ve_tel,maas as maas_ve_cocuk from personel
where id=123456789
UNION
select id, tel, cocuk_sayisi from personel_bilgi
where id=123456789;

/*
========================= SET OPERATORLERI: INTERSECT ========================
    --?ntersect=> iki k?menin kesi?imini d?nd?r?r
    INTERSECT operarotu 2 veya daha fazla Sorgu ifadesinin sonuclarini
    dondurmek icin kullanilir. Ancak, intersect SADECE tum sorgularin ortak
    verilerini (kesimlerini) dondurur.
    Syntax:
    ----------
    SELECT sutun_adi,sutun_adi2, .. FROM tablo_adi1
    INTERSECT
    SELECT sutun_adi1, sutun_adi2, .. FROM tablo_adi2;
     ORNEK5: Personel tablosundan Istanbul veya Ankara?da calisanlarin id?lerini
  sorgulayiniz.
  Personel_bilgi tablosundan 2 veya 3 cocugu olanlarin id lerini sorgulayiniz.
  Bu iki sorguyu INTERSECT ile birlesitiriniz.
------------------------------------------------------------------------------*/


select id from personel
where sehir  IN('Istanbul', 'Ankara')
INTERSECT
select id from personel_bilgi
where cocuk_sayisi IN (2,3);


--ORNEK Honda tofas ve ford da ortak ?al??an
select isim from personel--tek sat?rda bir ka? veri isteniyorsa AND ile, farkl? sat?rlardan ortakl?k isteniyorsa INTERSECT
where sirket='Honda'
INTERSECT
select isim from personel
where sirket='Ford'
INTERSECT
select isim from personel
where sirket='Tofas';

--ORNEK7: Toyota ve Ford sirketlerinde ayni maasi alan personel isimlerini listeleyin

select isim,maas from personel
where sirket='Toyota'
INTERSECT
select isim,maas from personel
where sirket='Ford';


/*
========================= SET OPERATORLERI: MINUS ============================
    MINUS operatoru ilk Sorgu ifadesinde olup da diger sorgu ifadesinde olmayan
    verileri dondurur. Yani 1. sorgu ile 2. sorgu arasindaki farkl? olanlar?
    dondurur
    Syntax:
    ----------
    SELECT sutun_adi,sutun_adi2, .. FROM tablo_adi1
    MINUS
    SELECT sutun_adi1, sutun_adi2, .. FROM tablo_adi2;
==============================================================================*/
/* -----------------------------------------------------------------------------
  ORNEK8: 5000?den az maas alan ve Honda calisani olmayanlar?n bilgilerini
  listeleyen bir sorgu yaziniz.*/

--birinci y?ntem
select isim, maas, sirket from personel
where maas<5000
INTERSECT
select isim, maas, sirket from personel
where s?rket!='Honda';

--ikinci ??z?m yolu MINUS 

select isim, maas, sirket from personel
where maas<5000
MINUS
select isim, maas, sirket from personel
where s?rket='Honda';

--ORNEK8: Ismi Mehmet Ozturk olup Izmir?de calismayanlarin isimlerini ve
--sehirlerini listeleyen sorguyu yaziniz.

select isim,sehir from personel
where isim='Mehmet Ozturk'
MINUS
select isim,sehir from personel
where sehir='Izmir';
--MINUS ta UNION gibi tekrarl? sat?rlardan sadeec birini yazd?r?r.



