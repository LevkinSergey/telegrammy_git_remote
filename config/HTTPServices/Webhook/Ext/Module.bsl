﻿Функция СтруктуруВСтроку(Структура, Строка = "")
	
	Для каждого Элемент Из Структура Цикл
		
		Если ТипЗнч(Элемент.Значение) = Тип("Структура") Тогда
			Строка = СтруктуруВСтроку(Элемент.Значение, Строка);
		КонецЕсли;
		
		Строка = Элемент.Ключ + ": " + Элемент.Значение + Символы.ПС;	
		
	КонецЦикла;
	
	Возврат Строка;
	
КонецФункции

Функция Выполнение(Запрос)
	
	ЗаписьЖурналаРегистрации("Телеграм.HTTP-запрос",УровеньЖурналаРегистрации.Информация,,,"Функция POST Выполнение");
	
	//Определяем вызванный метод
	ИмяМетода = Запрос.ПараметрыURL["ИмяМетода"];
	
	ЗаписьЖурналаРегистрации("Телеграм.HTTP-запрос",УровеньЖурналаРегистрации.Информация,,,"Получен запрос:" + Запрос.ПолучитьТелоКакСтроку());
	
	НайденныйБот = Справочники.Боты.НайтиПоКоду(ИмяМетода);
	Если НайденныйБот = Справочники.Боты.ПустаяСсылка() Тогда
		ЗаписьЖурналаРегистрации("Телеграм",УровеньЖурналаРегистрации.Ошибка,,,"Неизвестный Бот:" + ИмяМетода);
	Иначе 
		// описываем обработчики полученные сервисом из запроса, исходя из имени методов...
		Боты.ОбработатьЗапросКБоту(НайденныйБот, Запрос);
	КонецЕсли;	
	
	//Створюємо структуру для формування відповіді
	СтруктураВыгрузки = Новый Структура;
	СтруктураВыгрузки.Вставить("Ok", Истина);
	//СтруктураВыгрузки.Вставить("Результат", Результат);
	//
	//ТекРез = СтруктуруВСтроку(Результат);
	//
	//ЗаписьЖурналаРегистрации("Телеграм.HTTP-структура",УровеньЖурналаРегистрации.Информация,,,Запрос.ПолучитьТелоКакСтроку());
	
	//Формуємо файл відповіді у форматі JSON
	НастройкиСериализации = Новый НастройкиСериализацииJSON;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.УниверсальнаяДата;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	НастройкиСериализации.СериализовыватьМассивыКакОбъекты = Ложь;
	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, " ", Истина);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ПроверятьСтруктуру = Истина;
	ЗаписьJSON.УстановитьСтроку(ПараметрыJSON);
	ЗаписатьJSON(ЗаписьJSON, СтруктураВыгрузки, НастройкиСериализации);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	//Створюємо об'єкт для відправки відповіді
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки(СтрокаJSON);
	
	Возврат Ответ;	
	
КонецФункции

Функция Любойpost(Запрос)
	
	ЗаписьЖурналаРегистрации("Телеграм.HTTP-запрос",УровеньЖурналаРегистрации.Информация,,,"Функция GET Выполнение");
	
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции
