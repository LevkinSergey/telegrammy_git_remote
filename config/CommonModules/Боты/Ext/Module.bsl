﻿
Процедура СборщикМусора() Экспорт

	// Удаление данные старых сессий
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СессииБотов.Бот,
	|	СессииБотов.Сессия
	|ИЗ
	|	РегистрСведений.СессииБотов КАК СессииБотов
	|ГДЕ
	|	СессииБотов.ДатаСоздания <= &Граница";
	Запрос.УстановитьПараметр("Граница", ТекущаяДата() - 86400);
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		МенеджерЗаписи = РегистрыСведений.СессииБотов.СоздатьМенеджерЗаписи();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			МенеджерЗаписи.Бот = Выборка.Бот;
			МенеджерЗаписи.Сессия = Выборка.Сессия;
			МенеджерЗаписи.Удалить();
		КонецЦикла;
	КонецЕсли;

	// Сессии контрагентов тоже надо удалять

КонецПроцедуры

// Процедура ПланЧтения
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ПланЧтения() Экспорт 
	
	PlanBible2017Bot = Справочники.Боты.PlanBible2017Bot;
	
	Телеграм = Обработки.Телеграм.Создать();
	Телеграм.Бот = PlanBible2017Bot;
	Телеграм.getUpdate();
	
	ОбработкаБота = Обработки.PlanBible2017Bot.Создать();
	ОбработкаБота.Телеграм = Телеграм;
	
	ОбработатьЗапросыНаСервере(ОбработкаБота);
	
КонецПроцедуры //ПланЧтения

// Процедура ПланЧтения
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ПостПланЧтения() Экспорт 
	
	PlanBible2017Bot = Справочники.Боты.PlanBible2017Bot;
	
	Телеграм = Обработки.Телеграм.Создать();
	Телеграм.Бот = PlanBible2017Bot;
	//Телеграм.getUpdate();
	
	ОбработкаБота = Обработки.PlanBible2017Bot.Создать();
	ОбработкаБота.Телеграм = Телеграм;
	ОбработкаБота.Бот = PlanBible2017Bot;
	ОбработкаБота.ПостПланЧтения();
	//ОбработатьЗапросыНаСервере(ОбработкаБота);
	
КонецПроцедуры //ПланЧтения

////////////////////////////////////////////////////////////////////////////////
//
// Процедура ПостБожьяБлагодатьУтром
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ПостБожьяБлагодатьВКанал() Экспорт
	
	bogblagodat_infobot = Справочники.Боты.bogblagodat_infobot;
	
	Телеграм = Обработки.Телеграм.Создать();
	Телеграм.Бот = bogblagodat_infobot;
	//Телеграм.getUpdate();
	
	ОбработкаБота = Обработки.bogblagodat_infoBot.Создать();
	ОбработкаБота.Телеграм = Телеграм;
	ОбработкаБота.Бот = bogblagodat_infobot;
	ОбработкаБота.ПостБожьяБлагодатьВКанал();
	
КонецПроцедуры //ПостБожьяБлагодатьВКанал

////////////////////////////////////////////////////////////////////////////////
//
// Процедура ПостБожьяБлагодатьУтром
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ПостБожьяБлагодатьВГруппу() Экспорт
	
	bogblagodat_infobot = Справочники.Боты.bogblagodat_infobot;
	
	Телеграм = Обработки.Телеграм.Создать();
	Телеграм.Бот = bogblagodat_infobot;
	//Телеграм.getUpdate();
	
	ОбработкаБота = Обработки.bogblagodat_infoBot.Создать();
	ОбработкаБота.Телеграм = Телеграм;
	ОбработкаБота.Бот = bogblagodat_infobot;
	ОбработкаБота.ПостБожьяБлагодатьВГруппу();
	//ОбработатьЗапросыНаСервере(ОбработкаБота); 
	
КонецПроцедуры //ПостБожьяБлагодатьВГруппу

////////////////////////////////////////////////////////////////////////////////
//
// Процедура ПостБожьяБлагодатьУтром
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ОбъявленияВГруппу() Экспорт
	
	bogblagodat_infobot = Справочники.Боты.bogblagodat_infobot;
	
	Телеграм = Обработки.Телеграм.Создать();
	Телеграм.Бот = bogblagodat_infobot;
	//Телеграм.getUpdate();
	
	ОбработкаБота = Обработки.bogblagodat_infoBot.Создать();
	ОбработкаБота.Телеграм = Телеграм;
	ОбработкаБота.Бот = bogblagodat_infobot;
	ОбработкаБота.Объявления();
	//ОбработатьЗапросыНаСервере(ОбработкаБота); 
	
КонецПроцедуры //ПостБожьяБлагодатьВГруппу


////////////////////////////////////////////////////////////////////////////////
//
// Процедура ПостБожьяБлагодатьУтром
//
// Описание:
//
//
// Параметры (название, тип, дифференцированное значение)
//
Процедура ИнфоБот() Экспорт
	
	bogblagodat_infobot = Справочники.Боты.bogblagodat_infobot;
	
	Телеграм = Обработки.Телеграм.Создать();
	Телеграм.Бот = bogblagodat_infobot;
	Телеграм.getUpdate();
	
	ОбработкаБота = Обработки.bogblagodat_infoBot.Создать();
	ОбработкаБота.Телеграм = Телеграм;
	
	ОбработатьЗапросыНаСервере(ОбработкаБота); 
	
КонецПроцедуры //ПостБожьяБлагодатьУтром

////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ВСЕХ БОТОВ
//

Функция ПолучитьДанныеСообщения(Бот, Идентификатор) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗапросыБоту.ДанныеЗапроса
	|ИЗ
	|	РегистрСведений.ЗапросыБоту КАК ЗапросыБоту
	|ГДЕ
	|	ЗапросыБоту.update_id = &updateid
	|	И ЗапросыБоту.Бот = &Бот";
	Запрос.УстановитьПараметр("updateid", Идентификатор);
	Запрос.УстановитьПараметр("Бот", Бот);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ДанныеЗапроса.Получить();

КонецФункции // ПолучитьДанныеСообщения()

Процедура ЗакрытьСообщение(Бот, Идентификатор) Экспорт

	Запись = РегистрыСведений.ЗапросыБоту.СоздатьМенеджерЗаписи();
	Запись.Бот = Бот;
	Запись.update_id = Идентификатор;
	Запись.Прочитать();
	Запись.Обработан = Истина;
	Запись.Записать();

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С СЕССИЯМИ
//

Функция СоздатьСессию(Бот, ЗначениеСессии) Экспорт

	ЗаписьСессии = РегистрыСведений.СессииБотов.СоздатьМенеджерЗаписи();
	ЗаписьСессии.Бот = Бот;
	Идентификатор = Новый УникальныйИдентификатор();
	ЗаписьСессии.Сессия = Идентификатор;
	ЗаписьСессии.ДанныеСессии = ЗначениеВСтрокуВнутр(ЗначениеСессии);
	ЗаписьСессии.ДатаСоздания = ТекущаяДата();
	ЗаписьСессии.Записать();
	Возврат Идентификатор;

КонецФункции // 

Функция ПолучитьОписаниеСессии(ИдентификаторСессии) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СессииБотов.ДанныеСессии
	|ИЗ
	|	РегистрСведений.СессииБотов КАК СессииБотов
	|ГДЕ
	|	СессииБотов.Бот = ЗНАЧЕНИЕ(Справочник.Боты.КлёвыйBot)
	|	И СессииБотов.Сессия = &Сессия";
	Запрос.УстановитьПараметр("Сессия", Новый УникальныйИдентификатор(ИдентификаторСессии));
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат ЗначениеИзСтрокиВнутр(Выборка.ДанныеСессии);

КонецФункции // 

Процедура СоздатьСессиюКонтрагента(Бот, ИДКонтрагента, Сессия) Экспорт

	Запись = РегистрыСведений.СессииКонтрагентов.СоздатьМенеджерЗаписи();
	Запись.Бот = Бот;
	Запись.Идентификатор = ИДКонтрагента;
	Запись.ДанныеСессии = ЗначениеВСтрокуВнутр(Сессия);
	Запись.ДатаСоздания = ТекущаяДата();
	Запись.Записать();

КонецПроцедуры

Функция ПолучитьОписаниеСессииКонтрагента(Бот, ИДКонтрагента) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СессииКонтрагентов.ДанныеСессии КАК ДанныеСессии
	|ИЗ
	|	РегистрСведений.СессииКонтрагентов КАК СессииКонтрагентов
	|ГДЕ
	|	СессииКонтрагентов.Идентификатор = &ИДКонтрагента
	|	И СессииКонтрагентов.Бот = &Бот
	|
	|УПОРЯДОЧИТЬ ПО
	|	СессииКонтрагентов.ДатаСоздания УБЫВ";
	
	Запрос.УстановитьПараметр("ИДКонтрагента", ИДКонтрагента);
	Запрос.УстановитьПараметр("Бот", Бот);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Новый Структура();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат ЗначениеИзСтрокиВнутр(Выборка.ДанныеСессии);

КонецФункции // 

Процедура УдалитьСессиюКонтрагента(Бот, ИДКонтрагента) Экспорт

	ЗаписьСессии = РегистрыСведений.СессииКонтрагентов.СоздатьМенеджерЗаписи();
	ЗаписьСессии.Бот = Бот;
	ЗаписьСессии.Идентификатор = ИДКонтрагента;
	ЗаписьСессии.Удалить();

КонецПроцедуры //


////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД БОТОВ
//

Функция ДоступныеКоманды(Бот, Команда) Экспорт

	Если Лев(Команда, 1) = "/" Тогда
		Команда = Сред(НРег(Команда), 2);
		ПозицияИмениБота = СтрНайти(Команда, "@");
		Если ПозицияИмениБота > 0 Тогда
			Если НРег(Бот.Код) <> Сред(Команда, ПозицияИмениБота) Тогда	// Не тому боту команду шлют
				Возврат Справочники.КомандыБота.ПустаяСсылка();
			КонецЕсли;
			Команда = Лев(Команда, ПозицияИмениБота - 1);
		КонецЕсли;
	Иначе
		Возврат Справочники.КомандыБота.ПустаяСсылка();
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КомандыБота.Ссылка КАК КомандаБота
	|ИЗ
	|	Справочник.КомандыБота КАК КомандыБота
	|ГДЕ
	|	НЕ КомандыБота.ЭтоГруппа
	|	И НЕ КомандыБота.ПометкаУдаления
	|	И КомандыБота.Бот = &Бот
	|	И КомандыБота.Наименование = &Команда";
	Запрос.УстановитьПараметр("Команда", Команда);
	Запрос.УстановитьПараметр("Бот", Бот);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.КомандыБота.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.КомандаБота;

КонецФункции // ДоступныеКоманды()


////////////////////////////////////////////////////////////////////////////////////
// ГЛОБАЛЬНЫЕ КОМАНДЫ
//

// Обработка загруженных сообщений
Процедура ОбработатьЗапросыНаСервере(ОбработкаБота) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗапросыБоту.update_id КАК update_id,
	|	ЗапросыБоту.Контрагент КАК Контрагент,
	|	ЗапросыБоту.id КАК Чат,
	|	ЗапросыБоту.ТипОтвета КАК ТипОтвета
	|ИЗ
	|	РегистрСведений.ЗапросыБоту КАК ЗапросыБоту
	|ГДЕ
	|	ЗапросыБоту.Бот = &Бот
	|	И НЕ ЗапросыБоту.Обработан
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗапросыБоту.МоментВремени";
	
	Запрос.УстановитьПараметр("Бот", ОбработкаБота.Телеграм.Бот);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбработкаБота.ПрочитатьИОбработатьСообщение(Выборка);
	КонецЦикла;

КонецПроцедуры	// ОбработатьЗапросыНаСервере

Процедура ПостБожьяБлагодать() Экспорт
	ПостБожьяБлагодатьВКанал();
КонецПроцедуры

Процедура ОбработатьЗапросКБоту(НастройкиБота, Запрос = Неопределено) Экспорт
	
	АПИТелеграм = Обработки.Телеграм.Создать();
	АПИТелеграм.Бот = НастройкиБота;
	
	ДвижокБота = Обработки[НастройкиБота.Обработка].Создать();
	ДвижокБота.Телеграм = АПИТелеграм;
	
	Если НастройкиБота.УстановленWebHook Тогда
		Если НЕ Запрос = Неопределено Тогда
			АПИТелеграм.UpdateОбработкаОтвета(Запрос.ПолучитьТелоКакСтроку());	
		КонецЕсли;
	Иначе 
		АПИТелеграм.getUpdate();	
	КонецЕсли;
	
	АПИТелеграм.ОбработатьАпдейты(ДвижокБота);
	
КонецПроцедуры

Функция НайтиКлиентаПоИДТелеграм(ИДКонтрагента) Экспорт 
	
	Результат = Новый Структура;
	Результат.Вставить("Существует", Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Идентификатор = &ИДКонтрагента";
	
	Запрос.УстановитьПараметр("ИДКонтрагента", ИДКонтрагента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить("Контрагент", Выборка.Контрагент);
		Результат.Вставить("Существует", Истина);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции