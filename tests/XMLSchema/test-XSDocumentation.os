Перем ЮнитТест;

#Область ОбработчикиСобытийМодуля

Функция ПолучитьСписокТестов(МенеджерТестирования) Экспорт
	
	ЮнитТест = МенеджерТестирования;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("ТестКонструктор");
	СписокТестов.Добавить("TestConstructor");
	СписокТестов.Добавить("ТестУстановитьЯзык");
	СписокТестов.Добавить("ТестУстановитьИсточник");

	Возврат СписокТестов;

КонецФункции

#КонецОбласти

#Область ОбработчикиТестирования

Процедура ТестКонструктор() Экспорт

	Документация = Новый ДокументацияXS;
	
	ЮнитТест.ПроверитьРавенство(ТипЗнч(Документация), Тип("ДокументацияXS"));
	ЮнитТест.ПроверитьРавенство(Документация.ТипКомпоненты, ТипКомпонентыXS.Документация);
	
КонецПроцедуры

Procedure TestConstructor() Export

	Documentation = New XSDocumentation;
	
	ЮнитТест.ПроверитьРавенство(TypeOf(Documentation), Type("XSDocumentation"));
	ЮнитТест.ПроверитьРавенство(Documentation.ComponentType, XSComponentType.Documentation);

EndProcedure

Процедура ТестУстановитьЯзык() Экспорт

	Документация = Новый ДокументацияXS;
	Документация.Язык = "ru";

	ЮнитТест.ПроверитьРавенство(Документация.Язык, "ru");

КонецПроцедуры

Процедура ТестУстановитьИсточник() Экспорт

	Документация = Новый ДокументацияXS;
	Документация.Источник = "https://oscript.io";

	ЮнитТест.ПроверитьРавенство(Документация.Источник, "https://oscript.io");

КонецПроцедуры

#КонецОбласти