﻿#Область УправлениеПроведением

// Выполняет инициализацию дополнительных свойств для проведения документа.
//
Процедура ИнициализироватьДополнительныеСвойстваДляПроведения(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	// В структуре "ДополнительныеСвойства" создаются свойства с ключами "ТаблицыДляДвижений", "ДляПроведения", "УчетнаяПолитика".
	
	// "ТаблицыДляДвижений" - структура, которая будет содержать таблицы значений с данными для выполнения движений.
	СтруктураДополнительныеСвойства.Вставить("ТаблицыДляДвижений", Новый Структура);
	
	// "ДляПроведения" - структура, содержащая свойства и реквизиты документа, необходимые для проведения.
	СтруктураДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	
	// Структура, содержащая ключ с именем "МенеджерВременныхТаблиц", в значении которого хранится менеджер временных таблиц.
	// Содержит для каждой временной таблицы ключ (имя временной таблицы) и значение (признак наличия записей во временной таблице).
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("МетаданныеДокумента", ДокументСсылка.Метаданные());
	
	// "УчетнаяПолитика" - структура, содержащая значения всех параметров учетной политики на момент времени документа
	// и по выбранной в документе организации или по компании (в случае ведения учета по компании).
	СтруктураДополнительныеСвойства.Вставить("УчетнаяПолитика", Новый Структура);
	
	// Запрос, получающий данные документа.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	_Документ_.Ссылка КАК Ссылка,
	|	_Документ_.Номер КАК Номер,
	|	_Документ_.Дата КАК Дата,
	|	_Документ_.МоментВремени КАК МоментВремени,
	|	_Документ_.Представление КАК Представление
	|ИЗ
	|	Документ." + СтруктураДополнительныеСвойства.ДляПроведения.МетаданныеДокумента.Имя + " КАК _Документ_
	|ГДЕ
	|	_Документ_.Ссылка = &ДокументСсылка");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	// Формирование ключей, содержащих данные документа.
	Для каждого Колонка Из РезультатЗапроса.Колонки Цикл
		
		СтруктураДополнительныеСвойства.ДляПроведения.Вставить(Колонка.Имя);
		
	КонецЦикла;
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Заполнение значений для ключей, содержащих данные документа.
	ЗаполнитьЗначенияСвойств(СтруктураДополнительныеСвойства.ДляПроведения, ВыборкаИзРезультатаЗапроса);
	
	// Определение и установка значения момента, на который должен быть выполнен контроль документа.
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("МоментКонтроля", Дата('00010101'));
	СтруктураДополнительныеСвойства.ДляПроведения.Вставить("ПериодКонтроля", Дата("39991231"));
		
КонецПроцедуры // ИнициализироватьДополнительныеСвойстваДляПроведения()

// Формирует массив имен регистров, по которым есть движения документа.
//
Функция ПолучитьМассивИменИспользуемыхРегистров(Регистратор, МетаданныеДокумента)
	
	МассивРегистров = Новый Массив;
	ТекстЗапроса = "";
	СчетчикТаблиц = 0;
	СчетчикЦикла = 0;
	ВсегоРегистров = МетаданныеДокумента.Движения.Количество();
	
	Для каждого Движение из МетаданныеДокумента.Движения Цикл
		
		Если СчетчикТаблиц > 0 Тогда
			
			ТекстЗапроса = ТекстЗапроса + "
			|ОБЪЕДИНИТЬ ВСЕ
			|";
			
		КонецЕсли;
		
		СчетчикТаблиц = СчетчикТаблиц + 1;
		СчетчикЦикла = СчетчикЦикла + 1;
		
		ТекстЗапроса = ТекстЗапроса + 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|""" + Движение.Имя + """ КАК ИмяРегистра
		|
		|ИЗ " + Движение.ПолноеИмя() + "
		|
		|ГДЕ Регистратор = &Регистратор
		|";
		
		Если СчетчикТаблиц = 256 ИЛИ СчетчикЦикла = ВсегоРегистров Тогда
			
			Запрос = Новый Запрос(ТекстЗапроса);
			Запрос.УстановитьПараметр("Регистратор", Регистратор);
			
			ТекстЗапроса  = "";
			СчетчикТаблиц = 0;
			
			Если МассивРегистров.Количество() = 0 Тогда
				
				МассивРегистров = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРегистра");
				
			Иначе
				
				Выборка = Запрос.Выполнить().Выбрать();
				
				Пока Выборка.Следующий() Цикл
					
					МассивРегистров.Добавить(Выборка.ИмяРегистра);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивРегистров;
	
КонецФункции // ПолучитьМассивИменИспользуемыхРегистров()

// Выполняет подготовку наборов записей документа.
//
Процедура ПодготовитьНаборыЗаписейКРегистрацииДвижений(СтруктураОбъект) Экспорт
	
	Для каждого НаборЗаписей из СтруктураОбъект.Движения Цикл
		
		Если ТипЗнч(НаборЗаписей) = Тип("КлючИЗначение") Тогда
			
			НаборЗаписей = НаборЗаписей.Значение;
			
		КонецЕсли;
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			НаборЗаписей.Очистить();
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивИменРегистров = ПолучитьМассивИменИспользуемыхРегистров(СтруктураОбъект.Ссылка, СтруктураОбъект.ДополнительныеСвойства.ДляПроведения.МетаданныеДокумента);
	
	Для каждого ИмяРегистра из МассивИменРегистров Цикл
		
		СтруктураОбъект.Движения[ИмяРегистра].Записывать = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

// Записывает наборы записей документа.
//
Процедура ЗаписатьНаборыЗаписей(СтруктураОбъект) Экспорт
	
	Для каждого НаборЗаписей из СтруктураОбъект.Движения Цикл
		
		Если ТипЗнч(НаборЗаписей) = Тип("КлючИЗначение") Тогда
			
			НаборЗаписей = НаборЗаписей.Значение;
			
		КонецЕсли;
		
		Если НаборЗаписей.Записывать Тогда
			
			Если НЕ НаборЗаписей.ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
				
				НаборЗаписей.ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
				
			КонецЕсли;
			
			Если НЕ НаборЗаписей.ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
				
				НаборЗаписей.ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", СтруктураОбъект.ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы);
				Если СтруктураОбъект.ДополнительныеСвойства.Свойство("РежимЗаписи") Тогда
					НаборЗаписей.ДополнительныеСвойства.ДляПроведения.Вставить("РежимЗаписи", СтруктураОбъект.ДополнительныеСвойства.РежимЗаписи);
				КонецЕсли;
			КонецЕсли;
			
			НаборЗаписей.Записать();
			НаборЗаписей.Записывать = Ложь;
			
		Иначе
				
			МетаданныеНабора = НаборЗаписей.Метаданные();
			Если ОбщегоНазначения.ЭтоРегистрНакопления(МетаданныеНабора)
				И ЕстьПроцедураСоздатьПустуюВременнуюТаблицуИзменение(МетаданныеНабора.ПолноеИмя()) Тогда
				
				МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеНабора.ПолноеИмя());
				МенеджерОбъекта.СоздатьПустуюВременнуюТаблицуИзменение(СтруктураОбъект.ДополнительныеСвойства);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЕстьПроцедураСоздатьПустуюВременнуюТаблицуИзменение(ПолноеИмяРегистра)
	
	РегистрыСПроцедурой = Новый Массив;
	
	
	Возврат РегистрыСПроцедурой.Найти(ПолноеИмяРегистра) <> Неопределено;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыФормированияДвиженийРегистров

// Выполняет движения регистра сведений ЗаписиНаПрием.
//
Процедура ОтразитьЗаписиНаПрием(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаЗаписиНаПрием = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗаписиНаПрием;
	
	Если Отказ
	 ИЛИ ТаблицаЗаписиНаПрием.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаписиНаПрием = Движения.ЗаписиНаПрием;
	ДвиженияЗаписиНаПрием.Записывать = Истина;
	ДвиженияЗаписиНаПрием.Загрузить(ТаблицаЗаписиНаПрием);
	
КонецПроцедуры

// Выполняет движения регистра сведений НапоминанияКонтрагента.
//
Процедура ОтразитьНапоминанияКонтрагента(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаНапоминанияКонтрагента = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНапоминанияКонтрагента;
	
	Если Отказ
		ИЛИ ТаблицаНапоминанияКонтрагента.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаНапоминанияКонтрагента Цикл 
		
		МенеджерЗаписи = РегистрыСведений.НапоминанияКонтрагента.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.СрокНапоминания = СтрокаТаблицы.СрокНапоминания;
		МенеджерЗаписи.Контрагент = СтрокаТаблицы.Контрагент;
		МенеджерЗаписи.Источник = СтрокаТаблицы.Источник;
		МенеджерЗаписи.ВремяСобытия = СтрокаТаблицы.ВремяСобытия;
		МенеджерЗаписи.Доставлено = Ложь;
		МенеджерЗаписи.Описание = СтрокаТаблицы.Описание;
		
		Попытка
			МенеджерЗаписи.Записать();	
		Исключение
			ТекстСообщения = "Помилка збереження запису! Зверніться, будь ласка, в технічну підтримку за тел. (067) 260-31-07";
			СообщениеПользователю = Новый СообщениеПользователю;
			
			Комментарий = "Текст сообщения пользователю: " + ТекстСообщения + Символы.ПС
			+ "ОписаниеОшибки:" + ОписаниеОшибки() + Символы.ПС
			+ "ИнформацияОбОшибкеКраткое:" + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) + Символы.ПС
			+ "ПодробноеОбОшибкеКраткое:" + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()) + Символы.ПС;
			
			СообщениеПользователю.Текст = Комментарий;//ТекстСообщения;
			СообщениеПользователю.Сообщить();
			
			//ЗаписьЖурналаРегистрации("МобильныйКлиент", УровеньЖурналаРегистрации.Ошибка,,,Комментарий);
			//ОписаниеОшибки()
		КонецПопытки;
		
		
	КонецЦикла; 
	
	//ДвиженияНапоминанияКонтрагента = Движения.НапоминанияКонтрагента;
	//ДвиженияНапоминанияКонтрагента.Записывать = Истина;
	//ДвиженияНапоминанияКонтрагента.Загрузить(ТаблицаНапоминанияКонтрагента);
	
КонецПроцедуры

#КонецОбласти
