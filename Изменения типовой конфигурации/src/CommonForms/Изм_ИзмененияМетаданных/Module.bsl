
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)     
	Если Параметры.Свойство("Ссылка") = Ложь Тогда
		Возврат;
	КонецЕсли;
	УстановитьПараметрыСписков();
	УстановитьУсловноеОформление();
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	ЭлементОформления = СписокКоммитов.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьСвязьСТехПроектами"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
	ЭлементОтбора.ПравоеЗначение  = Ложь; 
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ТемноСерый);
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыСписков()
	ТипСсылки = ТипЗнч(Параметры.Ссылка);
	Если ТипСсылки = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") 
		ИЛИ ТипСсылки = Тип("СправочникСсылка.ИдентификаторыОбъектовРасширений") Тогда
		ИдентификаторМетаданных = Параметры.Ссылка;
	Иначе
		ИдентификаторМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Параметры.Ссылка));	
	КонецЕсли;
	СписокТехническихПроектов.Параметры.УстановитьЗначениеПараметра("ОбъектМетаданных", ИдентификаторМетаданных);
	СписокКоммитов.Параметры.УстановитьЗначениеПараметра("ОбъектМетаданных", ИдентификаторМетаданных);
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторМетаданныхПриИзменении(Элемент)
	СписокТехническихПроектов.Параметры.УстановитьЗначениеПараметра("ОбъектМетаданных", ИдентификаторМетаданных);
	СписокКоммитов.Параметры.УстановитьЗначениеПараметра("ОбъектМетаданных", ИдентификаторМетаданных);
КонецПроцедуры
