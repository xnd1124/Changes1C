#Область ПрограммныйИнтерфейс
Процедура ЗагрузитьИзРепозиторияКоммиты() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ОписаниеКоммитов = ОписаниеКоммитов();
	ТаблицаКоммитов = ТаблицаКоммитов(ОписаниеКоммитов);
	АкутализироватьИдентификаторыМетаданных();
	ОбработатьТаблицуКоммитов(ТаблицаКоммитов);
	ЗапомнитьПоследнийКоммит(ТаблицаКоммитов);
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции
Функция ОписаниеКоммитов()
	ПоследнийКоммит = Константы.Изм_ПоследнийИзвлеченныйКоммит.Получить();
	Если ЗначениеЗаполнено(ПоследнийКоммит) Тогда
		Команда = СтрШаблон("log %1..HEAD --pretty=medium --date=format:%2", ПоследнийКоммит, "%Y%m%d%H%M%S");
	Иначе
		Команда = СтрШаблон("log  --pretty=medium --date=format:%1", "%Y%m%d%H%M%S");
	КонецЕсли;
	Каталог = Константы.Изм_ЛокальныйКаталогРепозиторияGIt.Получить();
	ОписаниеКоммитов = Изм_РаботаСГИТ.КомандаГИТ(Команда, Каталог);
	Возврат ОписаниеКоммитов;
КонецФункции // ()

Функция ТаблицаКоммитов(Вывод)
	Результат = ПустаяТаблицаКоммитов();
	СтрокиВывода = СтрРазделить(Вывод, Символы.ПС);
	Для Каждого СтрокаВывода Из СтрокиВывода Цикл
		Если ЭтоСтрокаСХешем(СтрокаВывода) Тогда
			НоваяСтрока = Результат.Добавить();
			НоваяСтрока.Хеш = Хеш(СтрокаВывода);
			Продолжить;
		КонецЕсли;
		РазобратьСодержимоеСтроки(СтрокаВывода, НоваяСтрока);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ()

Процедура ОбработатьТаблицуКоммитов(ТаблицаКоммитов)
	Для Каждого Строка Из ТаблицаКоммитов Цикл
		ОбъектКоммит = КоммитПоХешу(Строка.Хеш);
		ОбъектКоммит.Файлы.Очистить();
		ОбъектКоммит.ИзмененныеМетаданные.Очистить();
		ОбъектКоммит.ТехническиеПроекты.Очистить();
		ЗаполнитьЗначенияСвойств(ОбъектКоммит, Строка);
		ЗаполнитьФайлыКоммита(ОбъектКоммит);
		ЗаполнитьМетаданныеКоммита(ОбъектКоммит);
		ЗаполнитьТехПроектыКоммита(ОбъектКоммит);
		ОбъектКоммит.Записать();
	КонецЦикла;
КонецПроцедуры

Функция ПустаяТаблицаКоммитов()
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Хеш");
	Результат.Колонки.Добавить("Автор");
	Результат.Колонки.Добавить("Дата");
	Результат.Колонки.Добавить("Описание");
	Возврат Результат;
КонецФункции // ()

Функция ЭтоСтрокаСХешем(СтрокаВывода)
	Возврат СтрНачинаетсяС(СтрокаВывода, "commit ");
КонецФункции // ()

Функция Хеш(СтрокаВывода)
	СтрокаВывода = СтрЗаменить(СтрокаВывода, "commit ", "");
	Возврат СтрокаВывода;
КонецФункции // ()

Процедура РазобратьСодержимоеСтроки(СтрокаВывода, НоваяСтрока)  
	Если НоваяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоСтрокаАвтора(СтрокаВывода) Тогда
		НоваяСтрока.Автор = Автор(СтрокаВывода);
	ИначеЕсли ЭтоСтрокаДаты(СтрокаВывода) Тогда
		НоваяСтрока.Дата = ДатаКоммита(СтрокаВывода);
	Иначе
		НоваяСтрока.Описание = "" + СокрЛП(НоваяСтрока.Описание) + СтрокаВывода;
	КонецЕсли;
КонецПроцедуры // ()

Функция КоммитПоХешу(Хеш)
	НайденныйЭлемент = Справочники.Изм_Коммиты.НайтиПоКоду(Хеш);
	Если НайденныйЭлемент = Справочники.Изм_Коммиты.ПустаяССылка() Тогда
		НовыйЭлемент = Справочники.Изм_Коммиты.СоздатьЭлемент();
		НовыйЭлемент.Код = Хеш;
		Возврат НовыйЭлемент;
	Иначе
		Возврат НайденныйЭлемент.ПолучитьОбъект();
	КонецЕсли;
КонецФункции // ()

Функция СписокФайловКоммита(Хеш)
	Команда = СтрШаблон("show --pretty=format: --name-only %1", Хеш);
	Каталог = Константы.Изм_ЛокальныйКаталогРепозиторияGIt.Получить();
	Вывод = Изм_РаботаСГИТ.КомандаГИТ(Команда, Каталог);
	Результат = СтрРазделить(Вывод, Символы.ПС); 
	МаксимальноеКоличествоФайлов = 99998;
	Если Результат.Количество() > МаксимальноеКоличествоФайлов Тогда
		Ошибка = Новый Массив;
		Ошибка.Добавить("Слишком много файлов в коммите");
		Возврат Ошибка;
	КонецЕсли;
	Возврат Результат;
КонецФункции // ()

Процедура ЗаполнитьФайлыКоммита(ОбъектКоммит)
	СписокФайловКоммита = СписокФайловКоммита(ОбъектКоммит.Код);
	Для Каждого Значение Из СписокФайловКоммита Цикл
		Если НЕ ЗначениеЗаполнено(Значение) Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ОбъектКоммит.Файлы.Добавить();
		НоваяСтрока.ПутьКФайлу = Значение;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьМетаданныеКоммита(ОбъектКоммит) Экспорт
	РаспознанныеМетаданные = Новый Соответствие;
	Для Каждого Строка Из ОбъектКоммит.Файлы Цикл
		ПутьКФайлу = Строка.ПутьКФайлу;
		Рез = РезультатРаспознавания(ПутьКФайлу);
		Если Рез = "Служебный" 
			ИЛИ Рез = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Строка.Распознан = Истина;
		РаспознанныеМетаданные.Вставить(Рез);
	КонецЦикла;
	Для Каждого Пара Из РаспознанныеМетаданные Цикл  
		ОбъектМетаданных = Пара.Ключ;
		Отбор = Новый Структура("ОбъектМетаданных", ОбъектМетаданных);  
		Если  ОбъектКоммит.ИзмененныеМетаданные.НайтиСтроки(Отбор).Количество() > 0 тогда
			Продолжить;
		КонецЕсли;	
		НоваяСтрока = ОбъектКоммит.ИзмененныеМетаданные.Добавить();
		НоваяСтрока.ОбъектМетаданных = Пара.Ключ;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьТехПроектыКоммита(ОбъектКоммит)
	РегулярноеВыражение = "#([0-9]+)";
	Строка = ОбъектКоммит.Описание;
	РезультатыПоиска = СтрНайтиВсеПоРегулярномуВыражению(Строка, РегулярноеВыражение, Истина, Истина);
	НайденныеПроекты = Новый Соответствие;
	ДлинаКодаТехПроекта = 6;
	Для Каждого Результат Из РезультатыПоиска Цикл
		Группы = Результат.ПолучитьГруппы();
		НайденныеЦифры = Группы[0].Значение;       
		ИскомыйКод = Прав("00000" + НайденныеЦифры, ДлинаКодаТехПроекта);
		НайденныйПроект = Справочники.Изм_ТехническиеПроекты.НайтиПоКоду(ИскомыйКод);
		Если НайденныйПроект = Справочники.Изм_ТехническиеПроекты.ПустаяССылка() Тогда
			Продолжить;
		КонецЕсли;
		НайденныеПроекты.Вставить(НайденныйПроект);
	КонецЦикла;
	
	Для Каждого Пара Из НайденныеПроекты Цикл
		НоваяСтрока = ОбъектКоммит.ТехническиеПроекты.Добавить();
		НоваяСтрока.ТехническийПроект = Пара.Ключ;
	КонецЦикла;
	
КонецПроцедуры

Функция ЭтоСтрокаАвтора(СтрокаВывода)
	Возврат СтрНачинаетсяС(СтрокаВывода, "Author: ");
КонецФункции // ()

Функция ЭтоСтрокаДаты(СтрокаВывода)
	Возврат СтрНачинаетсяС(СтрокаВывода, "Date: ");
КонецФункции // ()

Функция Автор(СтрокаВывода)
	СтрокаВывода = СтрЗаменить(СтрокаВывода, "Author:", "");
	Возврат СокрЛП(СтрокаВывода);
КонецФункции // ()

Функция ДатаКоммита(СтрокаВывода)
	СтрокаВывода = СтрЗаменить(СтрокаВывода, "Date:", "");
	ДатаСтрокой = СокрЛП(СтрокаВывода);
	Возврат Дата(ДатаСтрокой);
КонецФункции // ()

Функция РезультатРаспознавания(Файл) Экспорт
	Если ЭтоСлужебныйФайл(Файл) Тогда
		Возврат "Служебный";
	ИначеЕсли ЭтоОбщийМодуль(Файл) Тогда
		Возврат РаспознаваниеОбщегоМодуля(Файл);
	ИначеЕсли ЭтоДокумент(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Документ");
	ИначеЕсли ЭтоРегистрСведений(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "РегистрСведений");
	ИначеЕсли ЭтоРоль(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Роль");
	ИначеЕсли ЭтоСправочник(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Справочник");
	ИначеЕсли ЭтоОбработка(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Обработка");
	ИначеЕсли ЭтоОтчет(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Отчет");
	ИначеЕсли ЭтоРегистрНакопления(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "РегистрНакопления");
	ИначеЕсли ЭтоБизнесПроцесс(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "БизнесПроцесс");
	ИначеЕсли ЭтоПланВидовХарактеристик(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "ПланВидовХарактеристик");
	ИначеЕсли ЭтоЗадача(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Задача");
	ИначеЕсли ЭтоЖурналДокументов(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "ЖурналДокументов");
	ИначеЕсли ЭтоПланСчетов(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "ПланСчетов");
	ИначеЕсли ЭтоКонстанта(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Константа");
	ИначеЕсли ЭтоПодсистема(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "Подсистема");
	ИначеЕсли ЭтоПланОбмена(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "ПланОбмена");
	ИначеЕсли ЭтоРегистрРасчета(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "РегистрРасчета");
	ИначеЕсли ЭтоРегистрБухгалтерии(Файл) Тогда
		Возврат РаспознаваниеМетаданного(Файл, "РегистрБухгалтерии");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции // ()

Функция ЭтоСлужебныйФайл(Строка)
	СлужебныеФайлы = СлужебныеФайлы();
	Возврат СлужебныеФайлы[Строка] <> Неопределено;
КонецФункции // ()

Функция ЭтоОбщийМодуль(Строка)
	Возврат СтрНайти(Строка, "CommonModules") > 0;
КонецФункции // ()

Функция ЭтоДокумент(Строка)
	Возврат СтрНайти(Строка, "Documents") > 0;
КонецФункции // ()

Функция ЭтоРегистрСведений(Строка)
	Возврат СтрНайти(Строка, "InformationRegisters") > 0;
КонецФункции // ()

Функция ЭтоРоль(Строка)
	Возврат СтрНайти(Строка, "Roles") > 0;
КонецФункции // ()

Функция ЭтоСправочник(Строка)
	Возврат СтрНайти(Строка, "Catalogs") > 0;
КонецФункции // ()

Функция ЭтоОбработка(Строка)
	Возврат СтрНайти(Строка, "DataProcessors") > 0;
КонецФункции // ()

Функция ЭтоРегистрНакопления(Строка)
	Возврат СтрНайти(Строка, "AccumulationRegisters") > 0;
КонецФункции // ()

Функция ЭтоБизнесПроцесс(Строка)
	Возврат СтрНайти(Строка, "BusinessProcesses") > 0;
КонецФункции // ()

Функция ЭтоЗадача(Строка)
	Возврат СтрНайти(Строка, "Tasks") > 0;
КонецФункции // ()

Функция ЭтоЖурналДокументов(Строка)
	Возврат СтрНайти(Строка, "DocumentJournals") > 0;
КонецФункции // ()

Функция ЭтоОтчет(Строка)
	Возврат СтрНайти(Строка, "Reports") > 0;
КонецФункции // ()

Функция ЭтоПланСчетов(Строка)
	Возврат СтрНайти(Строка, "ChartsOfAccounts") > 0;
КонецФункции // ()

Функция ЭтоКонстанта(Строка)
	Возврат СтрНайти(Строка, "Constants") > 0;
КонецФункции // ()

Функция ЭтоПодсистема(Строка)
	Возврат СтрНайти(Строка, "Subsystems") > 0;
КонецФункции // ()

Функция ЭтоПланОбмена(Строка)
	Возврат СтрНайти(Строка, "ExchangePlans") > 0;
КонецФункции // ()

Функция ЭтоРегистрБухгалтерии(Строка)
	Возврат СтрНайти(Строка, "AccountingRegisters") > 0;
КонецФункции // ()

Функция ЭтоРегистрРасчета(Строка)
	Возврат СтрНайти(Строка, "CalculationRegisters") > 0;
КонецФункции // ()

Функция ЭтоПланВидовХарактеристик(Строка)
	Возврат СтрНайти(Строка, "ChartsOfCharacteristicTypes") > 0;
КонецФункции // ()

Функция РаспознаваниеОбщегоМодуля(Строка)
	ЧастиСтроки = СтрРазделить(Строка, "/.");
	ИмяМодуля = ЧастиСтроки[1];
	ИмяБезПрефиксов = ИмяБезПрефиксовИСуффиксов(ИмяМодуля);
	
	ВозможныеОбъектыМетаданных = ВозможныеОбъектыМетаданных();
	ШаблонИмени = "%1.%2";
	Для Каждого ВозможныйОбъект Из ВозможныеОбъектыМетаданных Цикл
		ПолноеИмя = СтрШаблон(ШаблонИмени, ВозможныйОбъект, ИмяБезПрефиксов);
		ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ПолноеИмя);
		Если ОбъектМетаданных <> Неопределено Тогда
			ИдентификаторМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных, Ложь);
			Возврат ИдентификаторМетаданных;
		КонецЕсли;
	КонецЦикла;
КонецФункции // ()

Функция РаспознаваниеМетаданного(Строка, СтрокаМетаданных)
	ЧастиСтроки = СтрРазделить(Строка, "/.");
	ИмяДокумента = ЧастиСтроки[1];
	ШаблонИмени = "%1.%2";
	ПолноеИмя = СтрШаблон(ШаблонИмени, СтрокаМетаданных, ИмяДокумента);
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ПолноеИмя);
	Если ОбъектМетаданных <> Неопределено Тогда
		ИдентификаторМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных, Ложь);
		Возврат ИдентификаторМетаданных;
	КонецЕсли;
КонецФункции // ()

Функция ИмяБезПрефиксовИСуффиксов(Строка)
	СлужебныеПрефиксыСуффиксы = СлужебныеПрефиксыСуффиксы();
	Для Каждого Префикс Из СлужебныеПрефиксыСуффиксы Цикл
		Строка = СтрЗаменить(строка, Префикс, "");
	КонецЦикла;
	Возврат Строка;
КонецФункции // ()

Функция СлужебныеПрефиксыСуффиксы()
	Результат = Новый Массив;
	Результат.Добавить("txl_");
	Результат.Добавить("ВызовСервера");
	Результат.Добавить("Сервер");
	Возврат Результат;
КонецФункции // ()

Функция СлужебныеФайлы()
	Результат = Новый Соответствие;
	Результат.Вставить("ConfigDumpInfo.xml", Истина);
	Результат.Вставить("VERSION", Истина);
	Результат.Вставить("Configuration.xml", Истина);
	Возврат Результат;
КонецФункции // ()

Функция ВозможныеОбъектыМетаданных()
	Результат = Новый Массив;
	Результат.Добавить("Справочник");
	Результат.Добавить("Документ");
	Результат.Добавить("ЖурналДокументов");
	Результат.Добавить("Отчет");
	Результат.Добавить("Обработка");
	Результат.Добавить("ПланВидовХарактеристик");
	Результат.Добавить("ПланСчетов");
	Результат.Добавить("ПланВидовРасчета");
	Результат.Добавить("РегистрСведений");
	Результат.Добавить("РегистрНакопления");
	Результат.Добавить("РегистрБухгалтерии");
	Результат.Добавить("РегистрРасчета");
	Результат.Добавить("БизнесПроцесс");
	Результат.Добавить("Задача");
	Возврат Результат;
	
КонецФункции // ()

Процедура ЗапомнитьПоследнийКоммит(ТаблицаКоммитов)
	Если ТаблицаКоммитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Константы.Изм_ПоследнийИзвлеченныйКоммит.Установить(ТаблицаКоммитов[0].Хеш);
КонецПроцедуры

Процедура АкутализироватьИдентификаторыМетаданных()
	Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьДанныеСправочника();
	Справочники.ИдентификаторыОбъектовРасширений.ОбновитьДанныеСправочника();
КонецПроцедуры

	
#КонецОбласти