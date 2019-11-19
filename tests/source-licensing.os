﻿#Использовать asserts

Перем юТест;

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЧтоВсеФайлыИмеютПрефиксЛицензии");
	
	Возврат ВсеТесты;
КонецФункции

Процедура ТестДолжен_ПроверитьЧтоВсеФайлыИмеютПрефиксЛицензии() Экспорт

	КаталогИсходников = КаталогИсходниковПроекта();
	
	Если не КаталогИсходников.Существует() Тогда
		Возврат; // если запустили тесты вне каталога репы GIT, то тест не имеет смысла.
	КонецЕсли;
	
	юТест.ПроверитьИстину(ПротестироватьИсходники(КаталогИсходников.ПолноеИмя), "Какие-то файлы не имеют лицензии. См. полный лог сборки");

КонецПроцедуры

Функция КаталогИсходниковПроекта()
	Возврат Новый Файл(ОбъединитьПути(ТекущийСценарий().Каталог,"../src"));
КонецФункции

Функция ПротестироватьИсходники(Знач КаталогИсходников, Знач ИсправлятьТутЖе = Ложь) Экспорт

	ФайлыИсключения = Новый Массив; // чужой код
	ФайлыИсключения.Добавить("src/GlobalAssemblyInfo.cs");
	ФайлыИсключения.Добавить("src/oscript/Web/Multipart/");
	ФайлыИсключения.Добавить("src/DebugServer/DebugSession.cs");
	ФайлыИсключения.Добавить("src/DebugServer/ServiceProxy.cs");

	ВсеФайлы = НайтиФайлы(КаталогИсходников, ПолучитьМаскуВсеФайлы());
	ЕстьОшибки = Ложь;
	
	Для Каждого Файл Из ВсеФайлы Цикл
		
		Если Файл.Расширение = ".cs" Тогда
			
			ЭтоФайлИсключение = Ложь;
			ПриведенныйПуть = СтрЗаменить(Файл.ПолноеИмя, "\", "/");
			Для Каждого ФайлИсключение Из ФайлыИсключения Цикл
				Если Найти(ПриведенныйПуть, ФайлИсключение) > 0 Тогда
					ЭтоФайлИсключение = Истина;
				КонецЕсли;
			КонецЦикла;
			
			Если ЭтоФайлИсключение Тогда
				Продолжить;
			КонецЕсли;
			
			ЕстьОшибкиСейчас = Не ПроверитьФайл(Файл);
			ЕстьОшибки = ЕстьОшибки ИЛИ ЕстьОшибкиСейчас;
			
			Если ЕстьОшибкиСейчас и ИсправлятьТутЖе Тогда
				ИсправитьФайл(Файл);
			КонецЕсли;
			
		ИначеЕсли Файл.ЭтоКаталог() и Файл.Имя <> "obj" и Файл.Имя <> "packages" Тогда
			ЕстьОшибкиСейчас = Не ПротестироватьИсходники(Файл.ПолноеИмя, ИсправлятьТутЖе);
			ЕстьОшибки = ЕстьОшибки ИЛИ ЕстьОшибкиСейчас;
		КонецЕсли;
		
	КонецЦикла;

	Возврат Не ЕстьОшибки;
	
КонецФункции

Функция ПроверитьФайл(Знач Файл)
	
	Префикс = ПрефиксЛицензии();
	
	Документ = Новый ТекстовыйДокумент;
	Документ.Прочитать(Файл.ПолноеИмя);
	
	СтрокаВФайле = 
	СокрП(Документ.ПолучитьСтроку(1)) + "
	|" + СокрП(Документ.ПолучитьСтроку(2)) + "
	|" + СокрП(Документ.ПолучитьСтроку(3)) + "
	|" + СокрП(Документ.ПолучитьСтроку(4)) + "
	|" + СокрП(Документ.ПолучитьСтроку(5)) + "
	|" + СокрП(Документ.ПолучитьСтроку(6));

	Если СтрНайти(СтрокаВФайле, "<auto-generated>") > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Попытка
		юТест.ПроверитьРавенство(Префикс, СтрокаВФайле, "В файле " + Файл.ПолноеИмя + " должен присутствовать префикс лицензии");
	Исключение
		Сообщить(ИнформацияОбОшибке().Описание);
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Процедура ИсправитьФайл(Знач Файл)
	Сообщить("ИСПРАВЛЯЮ ФАЙЛ: " + Файл.ПолноеИмя);
	Документ = Новый ТекстовыйДокумент;
	Документ.Прочитать(Файл.ПолноеИмя);
	Документ.ВставитьСтроку(1, ПрефиксЛицензии());
	Документ.Записать(Файл.ПолноеИмя);
КонецПроцедуры

Функция ПрефиксЛицензии()
	Возврат 
	"/*----------------------------------------------------------
	|This Source Code Form is subject to the terms of the
	|Mozilla Public License, v.2.0. If a copy of the MPL
	|was not distributed with this file, You can obtain one
	|at http://mozilla.org/MPL/2.0/.
	|----------------------------------------------------------*/";
КонецФункции

Если СтартовыйСценарий().Источник = ТекущийСценарий().Источник Тогда
	Если АргументыКоманднойСтроки.Количество() и АргументыКоманднойСтроки[0] = "-fix" Тогда
		юТест = Утверждения;
		Сообщить("Автофикс");
		ПротестироватьИсходники(КаталогИсходниковПроекта().ПолноеИмя, Истина);
	КонецЕсли;
КонецЕсли;