
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	АдресПиктограммы = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "Пиктограмма");
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи) 
	Если АдресИзменен = Ложь Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоАдресВременногоХранилища(АдресПиктограммы) Тогда
        ТекущийОбъект.Пиктограмма = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресПиктограммы));  
	Иначе
		ТекущийОбъект.Пиктограмма = Неопределено;
    КонецЕсли;
КонецПроцедуры

&НаКлиенте
Асинх Процедура ЗагрузитьПиктограмму(Команда)       
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов("Выберите файл с пиктограммой", Ложь, "Все файлы (*.*)", 0);      
	Обещание = ПоместитьФайлНаСерверАсинх( , , , ПараметрыДиалога, ЭтаФорма.УникальныйИдентификатор);    
    Результат = Ждать Обещание;     
	Если Результат = Неопределено  Тогда
	    Возврат;
	КонецЕсли;
	АдресПиктограммы = Результат.Адрес;
	Модифицированность = Истина; 
	АдресИзменен = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПиктограмму(Команда)
	АдресПиктограммы = "";   
	АдресИзменен = Истина;
КонецПроцедуры

