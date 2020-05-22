-- Для заведення timestamp у форматі 2016-01-07 замість 2016-JAN-07 (формат за замовчуванням)
ALTER SESSION SET nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS.FF';
-- для відображення тексту помилок процедури
set serveroutput on size 30000;

-- Робота процедури
BEGIN
  info_pkg.update_arrival(123, '2016-01-07 06:40:00', 'Vienna'); -- Оновлємо дату прибуття
  info_pkg.update_arrival(124, '2016-01-07 06:40:00', 'Vienna'); -- Помилка. Рейс не існує
  info_pkg.update_arrival(123, '2016-01-07 06:40:00', 'Moscow'); -- Помилка. Аеропорт не знайдено
END;

/

-- Робота функції
SELECT * FROM TABLE(info_pkg.select_YearAiportInfo('London', 2016)); -- рейси аеропорту Лондона за 2016
SELECT * FROM TABLE(info_pkg.select_YearAiportInfo('Kyiv', 2016)); -- рейси аеропорту Києва за 2016
SELECT * FROM TABLE(info_pkg.select_YearAiportInfo('Berlin', 2018)); -- рейси аеропорту Берліну за 2018

-- Тут no rows selected
SELECT * FROM TABLE(info_pkg.select_YearAiportInfo('Tokyo', 2017)); -- рейси аеропорту Токіо за 2017

/

-- Робота трігеру
INSERT INTO SOURCEDEST VALUES ('London', 'London'); -- Помилка. Початковий та кінцевий аеропорти співпадають
INSERT INTO SOURCEDEST VALUES ('London', 'Tokyo'); -- Додаємо початковий лондонський та кінцевий токійський аерропорти