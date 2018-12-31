﻿///////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ

&НаКлиенте
Перем ПредыдущаяВыделеннаяДатаКалендаря;
&НаКлиенте
Перем ПредыдущееОтображение;

&НаКлиенте
Процедура ДатаКалендаряПриВыводеПериода(Элемент, ОформлениеПериода)
	
	мРабочиеДниМастера = ДниМастера(ОформлениеПериода.НачалоПериода, ОформлениеПериода.КонецПериода, Истина);
	мВыходныеДниМастера = ДниМастера(ОформлениеПериода.НачалоПериода, ОформлениеПериода.КонецПериода, Ложь);
	Попытка
		Для каждого ТекДата Из ОформлениеПериода.Даты Цикл
			Если НЕ мРабочиеДниМастера.Найти(ТекДата.Дата) = Неопределено Тогда
				ТекДата.ЦветФона = ЦветРабочий;
			ИначеЕсли НЕ мВыходныеДниМастера.Найти(ТекДата.Дата) = Неопределено Тогда
				ТекДата.ЦветФона = ЦветВыходной;
			Иначе
				ТекДата.ЦветФона = webЦвета.Белый;    
			КонецЕсли;     
			Если ДеньНедели(ТекДата.Дата)>=6 Тогда
				ТекДата.ЦветТекста = webЦвета.Красный; 
			КонецЕсли;
		КонецЦикла;
	Исключение
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура ДатаКалендаряПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Подключаемый_ОбработчикОжиданияДатаКалендаряПриИзменении", 0.1, Истина);
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОЖИДАНИЯ

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияДатаКалендаряПриИзменении()
	//Если	Объект.ТекущееОтображение = "День"
	//	Или Объект.ТекущееОтображение = "Неделя"
	//	Или Объект.ТекущееОтображение = "ПоРесурсам"
	//	Или Объект.ТекущееОтображение = "Расписание"
	//	Или Объект.ТекущееОтображение = "Список"
	//	Или Объект.ТекущееОтображение = "Диспетчеризация" Тогда
	//	//
	//	Если Объект.ТекущееОтображение = "Список" Тогда
	//		МассивВыбранныхДат = ПолучитьМассивВыбранныхДат();
	//		КалендарьСписокПериодНачало		= НачалоДня(МассивВыбранныхДат[0]);
	//		КалендарьСписокПериодОкончание	= НачалоДня(МассивВыбранныхДат[МассивВыбранныхДат.ВГраница()]);
	//	КонецЕсли;
	//	
	//	КалендарьОбновитьКлиент();
	//КонецЕсли;
	ПредыдущаяВыделеннаяДатаКалендаря = ДатаКалендаря;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВыходныеДниНаСервере(МассивВыделенныхДат)
	
	//удаляем все записи по Мастеру за Выделенные даты
	ЗапросОставляемыеЗаписи = Новый Запрос;
	ЗапросОставляемыеЗаписи.Текст = 
	"ВЫБРАТЬ
	|	РабочиеДниМастеров.Мастер КАК Мастер,
	|	РабочиеДниМастеров.НомерНедели КАК НомерНедели,
	|	РабочиеДниМастеров.ДатаВремяЗаписи КАК ДатаВремяЗаписи,
	|	РабочиеДниМастеров.Рабочий КАК Рабочий
	|ИЗ
	|	РегистрСведений.РабочиеДниМастеров КАК РабочиеДниМастеров
	|ГДЕ
	|	НЕ РабочиеДниМастеров.Мастер = &Мастер
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РабочиеДниМастеров.Мастер,
	|	РабочиеДниМастеров.НомерНедели,
	|	РабочиеДниМастеров.ДатаВремяЗаписи,
	|	РабочиеДниМастеров.Рабочий
	|ИЗ
	|	РегистрСведений.РабочиеДниМастеров КАК РабочиеДниМастеров
	|ГДЕ
	|	РабочиеДниМастеров.Мастер = &Мастер
	|	И НЕ НАЧАЛОПЕРИОДА(РабочиеДниМастеров.ДатаВремяЗаписи, ДЕНЬ) В (&мДат)";
	
	ЗапросОставляемыеЗаписи.УстановитьПараметр("Мастер", ТекущийМастер);
	ЗапросОставляемыеЗаписи.УстановитьПараметр("мДат", МассивВыделенныхДат);
	
	ТаблицаОставляемыхЗаписей = ЗапросОставляемыеЗаписи.Выполнить().Выгрузить();
	НаборЗаписей = РегистрыСведений.РабочиеДниМастеров.СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(ТаблицаОставляемыхЗаписей);
	НаборЗаписей.Записать();
	
	
	НаборЗаписей.Отбор.Мастер.Установить(ТекущийМастер);
	НаборЗаписей.Прочитать();
	
	Для каждого ВыделеннаяДата Из МассивВыделенныхДат Цикл
		//НаборЗаписей.Отбор.ДатаВремяЗаписи.Установить(ВыделеннаяДата);
		НаборЗаписей.Прочитать();
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Мастер = ТекущийМастер; 
		НоваяЗапись.НомерНедели = НеделяГода(ВыделеннаяДата); 
		НоваяЗапись.ДатаВремяЗаписи = ВыделеннаяДата;
		НоваяЗапись.Рабочий = Ложь;
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыходныеДни(Команда)
	МассивВыделенныхДат = Элементы.ДатаКалендаря.ВыделенныеДаты;
	ЗаписатьВыходныеДниНаСервере(МассивВыделенныхДат);
	ОбновитьНадписиНаФорме();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьРабочиеДни(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВводВремениЗаписиЗавершение", ЭтаФорма);
	стрПараметров = Новый Структура("ТекущийМастер", ТекущийМастер);
	ОткрытьФорму("РегистрСведений.РабочиеДниМастеров.Форма.ФормаВыбораВремени", стрПараметров, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВводВремениЗаписиЗавершение(Результат, Параметры) Экспорт 
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВремяЗаписи = Результат;
	МассивВыделенныхДат = Элементы.ДатаКалендаря.ВыделенныеДаты;
	ЗаписатьРабочиеДниНаСервере(МассивВыделенныхДат, ВремяЗаписи);
	ОбновитьНадписиНаФорме();
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРабочиеДниНаСервере(МассивВыделенныхДат, ВремяЗаписи)
	
	//получим ВремяЗаписи
	
	
	НаборЗаписей = РегистрыСведений.РабочиеДниМастеров.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Мастер.Установить(ТекущийМастер);
	//НаборЗаписей.Отбор.ДатаВремяЗаписи.Установить(ТекущийМастер)
	
	Для каждого ВыделеннаяДата Из МассивВыделенныхДат Цикл
		                                 
		Для каждого ВыбранноеВремя Из ВремяЗаписи Цикл
			
			НоваяЗапись = НаборЗаписей.Добавить(); 
			
			НоваяЗапись.Мастер = ТекущийМастер; 
			НоваяЗапись.НомерНедели = НеделяГода(ВыделеннаяДата);
			
			ДатаСтрока = Формат(ВыделеннаяДата, "ДФ=""ггггММдд""");
			ВремяСтрока = СтрЗаменить(ВыбранноеВремя,":","");
			ВремяСтрока = ?(СтрДлина(ВремяСтрока)<6,"0"+ВремяСтрока,ВремяСтрока);
			ВремяСтрока = Формат(ВремяСтрока, "ДФ=""ЧЧммсс""");
			Результат = Дата(ДатаСтрока + ВремяСтрока);
			НоваяЗапись.ДатаВремяЗаписи = Результат;
			
			НоваяЗапись.Рабочий = Истина;
			
		КонецЦикла;
		
	КонецЦикла;
	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЦветВыходной = webЦвета.Персиковый;
	ЦветРабочий = webЦвета.БледноЗеленый;
	ДатаКалендаря = ТекущаяДатаСеанса();
	ТекущееОтображение = "Неделя";
	
	Если Параметры.Отбор.Свойство("Мастер") Тогда
		ТекущийМастер = Параметры.Отбор.Мастер;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьИДоступностьФормы()
	
	Если НЕ РольДоступна("Администратор") Тогда
		Элементы.ГруппаСписок.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

	
&НаКлиенте
// Процедура - обработчик события формы "ПриОткрытии".
//
Процедура ПриОткрытии(Отказ)
	НастроитьВидимостьИДоступностьФормы();
	//ПрименитьНастройкиЭлементовОтборов();
	//НастройкиОбщие = ПолучитьНастройкиОбщиеКлиент();
	
	ПредыдущаяВыделеннаяДатаКалендаря = ДатаКалендаря;
	ПредыдущееОтображение = ТекущееОтображение;
	
	Элементы.ДекорацияВыходной.ЦветФона = ЦветВыходной;
	Элементы.ДекорацияРабочий.ЦветФона = ЦветРабочий;
	Элементы.ЗаписатьВыходныеДни.ЦветФона = ЦветВыходной;
	Элементы.ЗаписатьРабочиеДни.ЦветФона = ЦветРабочий;
	
	//Если СписокВыборМесяца.Количество() > 0 Тогда
	//	СписокВыборМесяцаНеОбрабатыватьПриАктивизацииСтроки = Истина;
	//	ВыделитьМесяцВСписке();
	//КонецЕсли;
	//ДеревоРесурсовЭлементы = ДеревоРесурсов.ПолучитьЭлементы();
	//Если ДеревоРесурсовЭлементы.Количество() > 0 Тогда
	//	ДеревоРесурсовНеОбрабатыватьПриАктивизацииСтроки = Истина;
	//	Элементы.ДеревоРесурсов.ТекущаяСтрока = ДеревоРесурсовЭлементы[0].ПолучитьИдентификатор();
	//КонецЕсли;
	//
	//Если Объект.ТекущееОтображение = "Неделя" Тогда
	//	ДатаКалендаряВыделитьНеделю();
	//КонецЕсли;
	//КалендарьОбновитьКлиент();
	//
	//Если Элементы.ГруппаСписокЗадач.Видимость Тогда
	//	РазвернутьСписокЗадач();
	//КонецЕсли;
	//
	//Если ИспользоватьГруппыПользователей Тогда
	//	Попытка Элементы.ГруппыПользователей.ТекущаяСтрока = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ВсеПользователи");
	//	Исключение КонецПопытки;
	//КонецЕсли;
	//
	//ОбновитьСодержимоеФормыПриИзмененииГруппы();
	//
	//Попытка Элементы.СписокПользователейДиспетчеризация.ТекущаяСтрока = ТекущийПользовательСеанса;
	//Исключение КонецПопытки;
	//Попытка Элементы.ДеревоПользователейДиспетчеризации.ТекущаяСтрока = ДеревоПользователейДиспетчеризации.ПолучитьЭлементы()[0].ПолучитьЭлементы()[0].ПолучитьИдентификатор();
	//Исключение КонецПопытки;
	//
	//Если	НастройкиОбщие.Свойство("Автообновление") И НастройкиОбщие.Автообновление = Истина
	//	И	НастройкиОбщие.Свойство("ПериодАвтообновления") И ТипЗнч(НастройкиОбщие.ПериодАвтообновления) = Тип("Число") Тогда
	//	//
	//	ПодключитьОбработчикОжидания("Подключаемый_Автообновление", Макс(НастройкиОбщие.ПериодАвтообновления * 60, 60));
	//КонецЕсли;
	//
	//Если НЕ ПолучитьИспользованиеПолнотекствогоПоиска() Тогда
	//	Элементы.ДекорацияПолнотекстовыйПоискОтлючен.Видимость = Истина;
	//КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Функция ДниМастера(НачПериода, КонПериода, Рабочий)
	
	мДниМастера = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(РабочиеДниМастеров.ДатаВремяЗаписи, ДЕНЬ) КАК ДатаВремяЗаписи
		|ИЗ
		|	РегистрСведений.РабочиеДниМастеров КАК РабочиеДниМастеров
		|ГДЕ
		|	РабочиеДниМастеров.Рабочий = &Рабочий
		|	И РабочиеДниМастеров.Мастер = &Мастер
		|	И РабочиеДниМастеров.ДатаВремяЗаписи МЕЖДУ &НачПериода И &КонПериода
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(РабочиеДниМастеров.ДатаВремяЗаписи, ДЕНЬ)
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("КонПериода", КонПериода);
	Запрос.УстановитьПараметр("Мастер", ТекущийМастер);
	Запрос.УстановитьПараметр("НачПериода", НачПериода);
	Запрос.УстановитьПараметр("Рабочий", Рабочий);
	
	мДниМастера = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДатаВремяЗаписи");
	
	Возврат мДниМастера;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьНадписиНаФорме()
	Элементы.Список.Обновить();
	Элементы.ДатаКалендаря.Обновить();
КонецПроцедуры


