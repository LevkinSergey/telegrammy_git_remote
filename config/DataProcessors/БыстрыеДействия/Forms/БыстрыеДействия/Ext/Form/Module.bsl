﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализация(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	ЗагрузитьНастройки();
	СоздатьЭлементыБыстрыеДействия();
	
	АдресНастроекБыстрыхДействий = ПоместитьВоВременноеХранилище(НастройкиБыстрыхДействий.Выгрузить(), УникальныйИдентификатор);
	
	//
	ТекущийМастер = Регистратура.ПолучитьМастераПоЛогину(ПараметрыСеанса.ТекущийПользователь);
	Если ТекущийМастер = Справочники.Мастера.ПустаяСсылка() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуКонтрагентов();
	
	Контрагент = НайтиКонтрагентаПоТелефону("0979518043");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКонтрагентов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Контрагент,
		|	Контрагенты.Телефон КАК Телефон
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.ПометкаУдаления = ЛОЖЬ
		|	И Контрагенты.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец", ТекущийМастер.Бот);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовСтр = ТаблицаКонтрагентов.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВыбранноеЗначение.Событие="НастройкаБыстрыхДействий" Тогда
		
		ДобавленныеБыстрыеДействия.Очистить();
		Для каждого Идентификатор Из ВыбранноеЗначение.БыстрыеДействия Цикл
			ДобавленныеБыстрыеДействия.Добавить().Идентификатор = Идентификатор;
		КонецЦикла;
		СохранитьНастройкуБыстрыхДействийСервер();

	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Подключаемый_БыстроеДействиеНажатие(Элемент)
	
	Идентификатор = СтрЗаменить(Элемент.Имя, "БыстроеДействие", "");
	ВыполнитьБыстроеДействие(Идентификатор);
	
	#Если ВебКлиент Тогда
		
	Если Элементы.Найти("БыстроеДействиеНастройка")<>Неопределено Тогда
		ТекущийЭлемент = Элементы.БыстроеДействиеНастройка;
	КонецЕсли; 
	
	#КонецЕсли 
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура Инициализация(Отказ)
	
	//ПолныеПрава = РольДоступна("ПолныеПрава");
	//ДоступныПродажи = (РольДоступна("ДобавлениеИзменениеПодсистемыПродажи") ИЛИ ПолныеПрава);
	
	//Если ДоступныПродажи Тогда
	ДобавитьБыстроеДействие("ДобавитьЗаписьНаПрием", НСтр("ru='Оформить запись';uk='Оформити запис'"), "БыстроеДействиеСоздатьЗаписьНаПрием");
	ДобавитьБыстроеДействие("УстановитьВыходныеРабочиеДни", НСтр("ru='Установить выходные/рабочие дни';uk='Встановити вихідні/робочі дні'"), "БыстроеДействиеЗаписатьРабочиеДниМастеров");
	ДобавитьБыстроеДействие("ОткрытьНоменклатуру", НСтр("ru='Номенклатура';uk='Номенклатура'"), "БыстроеДействиеОткрытьНоменклатуру");
	//ДобавитьБыстроеДействие("ОткрытьНастройкиПрограммы", НСтр("ru='Настройки';uk='Налаштування'"), "БыстроеДействиеОткрытьНастройкиПрограммы");
	//КонецЕсли;
	
	
	Если НастройкиБыстрыхДействий.Количество()=0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	// Прочие операции инициализации
	
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеВводовОстатков()
	
	Если НЕ РольДоступна("ПолныеПрава") Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ДенежныеСредства.Регистратор
	|ИЗ
	|	РегистрНакопления.ДенежныеСредства КАК ДенежныеСредства
	|ГДЕ
	|	НЕ ДенежныеСредства.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЗапасыНаСкладах.Регистратор
	|ИЗ
	|	РегистрНакопления.ЗапасыНаСкладах КАК ЗапасыНаСкладах
	|ГДЕ
	|	НЕ ЗапасыНаСкладах.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РасчетыСПокупателями.Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСПокупателями КАК РасчетыСПокупателями
	|ГДЕ
	|	НЕ РасчетыСПокупателями.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РасчетыСПоставщиками.Регистратор
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК РасчетыСПоставщиками
	|ГДЕ
	|	НЕ РасчетыСПоставщиками.Регистратор ССЫЛКА Документ.ВводНачальныхОстатков";
	Результат = Запрос.ВыполнитьПакет();
	ЕстьВводыОстатков = (НЕ Результат.Получить(0).Пустой() ИЛИ НЕ Результат.Получить(1).Пустой() ИЛИ НЕ Результат.Получить(2).Пустой() ИЛИ НЕ Результат.Получить(3).Пустой());
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройки()
	
	//ТаблицаБыстрыхДействий = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПульсБизнеса", "БыстрыеДействия");
	//
	//Если ТаблицаБыстрыхДействий=Неопределено Тогда
		БыстрыеДействияПоУмолчанию();
	//Иначе
	//	ДобавленныеБыстрыеДействия.Очистить();
	//	Для каждого Стр Из ТаблицаБыстрыхДействий Цикл
	//		СтруктураОтбора = Новый Структура;
	//		СтруктураОтбора.Вставить("Идентификатор", Стр.Идентификатор);
	//		Строки = НастройкиБыстрыхДействий.НайтиСтроки(СтруктураОтбора);
	//		Если Строки.Количество()=0 Тогда
	//			// Недостаточно прав или устаревшее быстрое действие
	//			Продолжить;
	//		КонецЕсли;
	//		НоваяСтрока = ДобавленныеБыстрыеДействия.Добавить();
	//		НоваяСтрока.Идентификатор = Стр.Идентификатор;
	//	КонецЦикла; 
	//КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки(ВидНастроек)
	
	Если ПустаяСтрока(ВидНастроек) ИЛИ ВидНастроек="БыстрыеДействия" Тогда
		Таб = ДобавленныеБыстрыеДействия.Выгрузить(, "Идентификатор");
		//ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ПульсБизнеса", "БыстрыеДействия", Таб);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура БыстрыеДействияПоУмолчанию()
	
	ОтобразитьБыстроеДействие("ДобавитьЗаписьНаПрием");
	ОтобразитьБыстроеДействие("УстановитьВыходныеРабочиеДни");
	ОтобразитьБыстроеДействие("ОткрытьНоменклатуру");
	ОтобразитьБыстроеДействие("ОткрытьНастройкиПрограммы");
	
	СохранитьНастройки("БыстрыеДействия");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьБыстроеДействие(Идентификатор, Представление, ИмяКартинки)
	
	СтрокаТабличнойЧасти = НастройкиБыстрыхДействий.Добавить();
	СтрокаТабличнойЧасти.Идентификатор = Идентификатор;
	СтрокаТабличнойЧасти.Представление = Представление;
	СтрокаТабличнойЧасти.ИмяКартинки = ИмяКартинки;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьБыстроеДействие(Идентификатор)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Идентификатор", Идентификатор);
	ДобавленныеСтроки = ДобавленныеБыстрыеДействия.НайтиСтроки(СтруктураОтбора);
	Если ДобавленныеСтроки.Количество()>0 Тогда
		Возврат;
	КонецЕсли; 
	Строки = НастройкиБыстрыхДействий.НайтиСтроки(СтруктураОтбора);
	Если Строки.Количество()=0 Тогда
		// Недостаточно прав или устаревшее быстрое действие
		Возврат;
	КонецЕсли; 
	НоваяСтрока = ДобавленныеБыстрыеДействия.Добавить();
	НоваяСтрока.Идентификатор = Идентификатор;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкуБыстрыхДействийСервер()
	
	СохранитьНастройки("БыстрыеДействия");
	СоздатьЭлементыБыстрыеДействия();
	
КонецПроцедуры

&НаСервере
Процедура СоздатьЭлементыБыстрыеДействия()
	
	УдалитьЭлементыРекурсивно(Элементы.ГруппаБыстрыеДействия); 
	
	Для каждого Стр Из ДобавленныеБыстрыеДействия Цикл
		ИмяЭлемента = "БыстроеДействие"+Стр.Идентификатор;
		ИмяГруппы = "ГруппаБыстроеДействие"+Стр.Идентификатор;
		ИмяЗаголовка = "ЗаголовокБыстроеДействие"+Стр.Идентификатор;
		Если Элементы.Найти(ИмяЭлемента)<>Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Идентификатор", Стр.Идентификатор);
		СтрокиНастроек = НастройкиБыстрыхДействий.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрНастроек Из СтрокиНастроек Цикл
			Группа = Элементы.Добавить(ИмяГруппы, Тип("ГруппаФормы"), Элементы.ГруппаБыстрыеДействия);
			Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			Группа.ОтображатьЗаголовок = Ложь;
			Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
			Элемент = Элементы.Добавить(ИмяЭлемента, Тип("ДекорацияФормы"), Группа);
			Элемент.Вид = ВидДекорацииФормы.Картинка;
			Элемент.Гиперссылка = Истина;
			Элемент.Ширина = 14;
			Элемент.Высота = 6;
			Элемент.РазмерКартинки = РазмерКартинки.Пропорционально;
			//Элемент.Заголовок = "Заголовок";
			Элемент.Подсказка = СтрНастроек.Представление;
			Если НЕ ПустаяСтрока(СтрНастроек.ИмяКартинки) Тогда
				Элемент.Картинка = БиблиотекаКартинок[СтрНастроек.ИмяКартинки];
			КонецЕсли; 
			Элемент.УстановитьДействие("Нажатие", "Подключаемый_БыстроеДействиеНажатие");
		КонецЦикла;
	КонецЦикла; 
	//Элемент = Элементы.Добавить("БыстроеДействиеНастройка", Тип("ДекорацияФормы"), Элементы.ГруппаБыстрыеДействия);
	//Элемент.Вид = ВидДекорацииФормы.Картинка;
	//Элемент.Гиперссылка = Истина;
	//Элемент.Ширина = 2;
	//Элемент.Высота = 3;
	//Элемент.РазмерКартинки = РазмерКартинки.Растянуть;
	//Элемент.Подсказка = НСтр("ru='Настройка';uk='Налаштування'");
	//Элемент.Картинка = БиблиотекаКартинок.ПульсБизнесаНастроитьБыстрыеДействия;
	//Элемент.УстановитьДействие("Нажатие", "Подключаемый_БыстроеДействиеНажатие");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыРекурсивно(Группа)
	
	Пока Группа.ПодчиненныеЭлементы.Количество()>0 Цикл
		Элемент = Группа.ПодчиненныеЭлементы[0];
		Если ТипЗнч(Элемент)=Тип("КнопкаФормы") Тогда
			Команды.Удалить(Элемент.ИмяКоманды);
		ИначеЕсли ТипЗнч(Элемент)=Тип("ГруппаФормы") Тогда
			УдалитьЭлементыРекурсивно(Элемент);
		КонецЕсли; 
		Элементы.Удалить(Элемент);
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьБыстроеДействие(Идентификатор)
	
	Если Идентификатор="ДобавитьЗаписьНаПрием" Тогда
		П = Новый Структура;
		П.Вставить("Основание", Контрагент);
		ОткрытьФорму("Документ.ЗаписьНаПрием.Форма.ФормаМастерЗаполнения", П);
	ИначеЕсли Идентификатор="УстановитьВыходныеРабочиеДни" Тогда
		ОткрытьФорму("РегистрСведений.РабочиеДниМастеров.ФормаСписка");
	ИначеЕсли Идентификатор="ОткрытьНоменклатуру" Тогда
		//П = Новый Структура;
		//П.Вставить("Основание", Контрагент);
		ОткрытьФорму("Справочник.НоменклатураМастеров.ФормаСписка", , ТекущийМастер);
	ИначеЕсли Идентификатор="ОткрытьНастройкиПрограммы" Тогда
		//П = Новый Структура;
		//П.Вставить("Основание", Контрагент);
		ОткрытьФорму("Справочник.НоменклатураМастеров.ФормаСписка", , ТекущийМастер);
		
		//ИначеЕсли Идентификатор="Настройка" Тогда
		//	СтруктураОткрытия = Новый Структура;
	//	Идентификаторы = Новый Массив;
	//	Для каждого Стр Из ДобавленныеБыстрыеДействия Цикл
	//		Идентификаторы.Добавить(Стр.Идентификатор);
	//	КонецЦикла; 
	//	СтруктураОткрытия.Вставить("ДобавленныеБыстрыеДействия", Идентификаторы);
	//	СтруктураОткрытия.Вставить("АдресНастроекБыстрыхДействий", АдресНастроекБыстрыхДействий);
	//	СтруктураОткрытия.Вставить("ЕстьВводыОстатков", ЕстьВводыОстатков);
	//	ОткрытьФорму("Обработка.БыстрыеДействия.Форма.ФормаНастройкиБыстрыхДействий", СтруктураОткрытия, ЭтотОбъект);
	КонецЕсли; 	
	
КонецПроцедуры

&НаКлиенте
Функция ТребуетсяОткрытьОкноВыбораКассы(ЗначенияЗаполнения)
	
	Если Не ЗначениеЗаполнено(ЗначенияЗаполнения.КассаККМ) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗначенияЗаполнения.КоличествоЭквайринговыхТерминалов)
		И Не ЗначениеЗаполнено(ЗначенияЗаполнения.ЭквайринговыйТерминал) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ПолучитьКассуККМИТерминалПоУмолчанию() Экспорт
	
	СтруктураПараметров = Новый Структура("КассаККМ, ЭквайринговыйТерминал, КоличествоЭквайринговыхТерминалов, Организация, СтруктурнаяЕдиница", 
		Справочники.КассыККМ.ПустаяСсылка(), Справочники.ЭквайринговыеТерминалы.ПустаяСсылка(), 0);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	КассыККМ.Ссылка КАК КассаККМ,
	|	КассыККМ.СтруктурнаяЕдиница,
	|	КассыККМ.Владелец КАК Организация
	|ПОМЕСТИТЬ КассыККМ
	|ИЗ
	|	Справочник.КассыККМ КАК КассыККМ
	|ГДЕ
	|	НЕ КассыККМ.ПометкаУдаления
	|	И КассыККМ.ТипКассы = &ТипКассы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЭквайринговыеТерминалы.Ссылка КАК ЭквайринговыйТерминал,
	|	ЭквайринговыеТерминалы.Касса
	|ИЗ
	|	Справочник.ЭквайринговыеТерминалы КАК ЭквайринговыеТерминалы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КассыККМ КАК КассыККМ
	|		ПО ЭквайринговыеТерминалы.Касса = КассыККМ.КассаККМ
	|ГДЕ
	|	НЕ ЭквайринговыеТерминалы.ПометкаУдаления
	|	И ЭквайринговыеТерминалы.Касса.ТипКассы = &ТипКассы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КассыККМ.КассаККМ,
	|	КассыККМ.СтруктурнаяЕдиница,
	|	КассыККМ.Организация
	|ИЗ
	|	КассыККМ КАК КассыККМ");
	
	Запрос.УстановитьПараметр("ТипКассы", Перечисления.ТипыКассККМ.ФискальныйРегистратор);
	
	МРезультатов = Запрос.ВыполнитьПакет();
	Выборка = МРезультатов[2].Выбрать();
	КоличествоКассККМ = Выборка.Количество();
	Если КоличествоКассККМ = 1 
	   И Выборка.Следующий() Тогда
	
		СтруктураПараметров.КассаККМ = Выборка.КассаККМ;
		СтруктураПараметров.СтруктурнаяЕдиница = Выборка.СтруктурнаяЕдиница;
		СтруктураПараметров.Организация = Выборка.Организация;
		
	Иначе
		
		СтруктураПараметров.КассаККМ = Неопределено;
		
	КонецЕсли;
	
	Если КоличествоКассККМ = 1 Тогда
		ТЗ_ЭТ = МРезультатов[1].Выгрузить();
		
		ЭТКассыПоУмолчанию = ТЗ_ЭТ.НайтиСтроки(Новый Структура("Касса", СтруктураПараметров.КассаККМ));
		
		СтруктураПараметров.КоличествоЭквайринговыхТерминалов = ЭТКассыПоУмолчанию.Количество();
		Если ЭТКассыПоУмолчанию.Количество() = 1 Тогда
			
			СтруктураПараметров.ЭквайринговыйТерминал = ЭТКассыПоУмолчанию[0].ЭквайринговыйТерминал;
			
		Иначе
			
			СтруктураПараметров.ЭквайринговыйТерминал = Неопределено;
			
		КонецЕсли;
	Иначе
		СтруктураПараметров.ЭквайринговыйТерминал = Неопределено;
	КонецЕсли;
	
	Возврат СтруктураПараметров;

КонецФункции // ПолучитьКассуПоУмолчанию()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если МобильныйКлиент Тогда
		Если СредстваТелефонии.ПоддерживаетсяОбработкаЗвонков() Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьЗвонок", ЭтаФорма);
			СредстваТелефонии.ПодключитьОбработчикЗвонков(ОписаниеОповещения);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗвонок(НомерТелефона, Дата, ВариантСобытия=Неопределено, ТипЗвонка=Неопределено, ДополнительныйПараметр=Неопределено) Экспорт 
	
	#Если МобильныйКлиент Тогда
		Если ВариантСобытия = ВариантСобытияЗвонкаСредствТелефонии.НачалоВходящего Тогда
			Контрагент = НайтиКонтрагентаПоТелефону(НомерТелефона);	
			//Если Не Контрагент = Неопределено Тогда
			//	
			//	докЗаписьНаПрием = СоздатьЗаписьНаПриемНаСервере(Контрагент);
			//	
			//	//ФормаОбъекта = докЗаписьНаПрием.ПолучитьФорму("Документ.ЗаписьНаПрием.ФормаОбъекта");
			//	//ФормаОбъекта.Открыть();
			//	ПараметрыФормы = Новый Структура("Ключ", докЗаписьНаПрием);
			//	ОткрытьФорму("Документ.ЗаписьНаПрием.Форма.ФормаДокумента", ПараметрыФормы);
			//КонецЕсли;
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция НайтиКонтрагентаПоТелефону(НомерТелефона)
	
	Контрагент = Неопределено;
	
	Если ЗначениеЗаполнено(НомерТелефона) Тогда
		НомерТелефона = СтрЗаменить(НомерТелефона,"+","");
		НомерТелефона = Прав(НомерТелефона, 10);
		Отбор = Новый Структура("Телефон", НомерТелефона);
		
		Строки = ТаблицаКонтрагентов.НайтиСтроки(Отбор);
		
		Если Строки.Количество() > 0 Тогда
			Контрагент = Строки[0].Контрагент; 
		КонецЕсли;
	КонецЕсли;
	
	Возврат Контрагент;
	
КонецФункции

#КонецОбласти
 