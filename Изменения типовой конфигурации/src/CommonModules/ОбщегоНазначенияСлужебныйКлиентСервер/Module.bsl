
&Вместо("СтрокаЗапускаКомандыWindows")
Функция Изм_СтрокаЗапускаКомандыWindows(СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодировкаИсполнения)

	НаборКоманд = "";

	Если ЗначениеЗаполнено(КодировкаИсполнения) Тогда 

		Если КодировкаИсполнения = "OEM" Тогда
			КодировкаИсполнения = 437;
		ИначеЕсли КодировкаИсполнения = "CP866" Тогда
			КодировкаИсполнения = 866;
		ИначеЕсли КодировкаИсполнения = "UTF8" Тогда
			КодировкаИсполнения = 65001;
		КонецЕсли;

		НаборКоманд = "(chcp " + Формат(КодировкаИсполнения, "ЧГ=") + ")";
	КонецЕсли;

	Если Не ПустаяСтрока(ТекущийКаталог) Тогда 
		НаборКоманд = НаборКоманд + ?(ЗначениеЗаполнено(НаборКоманд), "&&", "") + "(pushd """ + ТекущийКаталог + """)";
	КонецЕсли;
	НаборКоманд = НаборКоманд + ?(ЗначениеЗаполнено(НаборКоманд), "&&", "") + "(" + СокрЛП(СтрокаКоманды) + ")";

	Возврат "cmd /S /C """ + НаборКоманд + """";

КонецФункции
