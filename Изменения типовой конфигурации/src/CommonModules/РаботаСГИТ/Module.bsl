#Область ПрограмныйИнтерфейс
Функция КомандаГИТ(Команда, ТекущийКаталог = "", ВызыватьИсключение = Истина) Экспорт
	РасположениеГИТ = Константы.Изм_РасположениеЗапускаемогоФайлаGIT.Получить();
	Если Не ЗначениеЗаполнено(РасположениеГИТ) Тогда
		РасположениеГИТ = "git";
	КонецЕсли;        
	ШаблонЗапуска = """%1"" %2";
	СтрокаЗапуска = СтрШаблон(ШаблонЗапуска, РасположениеГИТ, Команда);
	Возврат ЗапуститьКоманду(СтрокаЗапуска, ТекущийКаталог, ВызыватьИсключение);
КонецФункции	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ЗапуститьКоманду(Команда, ТекущийКаталог = "", ВызыватьИсключение = Истина)
	
	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
	ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок = Истина; 
	ПараметрыЗапускаПрограммы.КодировкаИсполнения = "UTF8";
	ПараметрыЗапускаПрограммы.КодировкаПотоков = "UTF8";
	Если ЗначениеЗаполнено(ТекущийКаталог) Тогда
		ПараметрыЗапускаПрограммы.ТекущийКаталог = ТекущийКаталог;  
	КонецЕсли;
	
	Результат = ФайловаяСистема.ЗапуститьПрограмму(Команда, ПараметрыЗапускаПрограммы);  
	ПотокВывода = Результат.ПотокВывода;
	ПотокОшибок = Результат.ПотокОшибок;
	
	Если ВызыватьИсключение = Ложь Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПотокОшибок) Тогда
		ВызватьИсключение ПотокОшибок;
	Иначе
		Возврат  ПотокВывода;
	КонецЕсли;
	
КонецФункции

#КонецОбласти




