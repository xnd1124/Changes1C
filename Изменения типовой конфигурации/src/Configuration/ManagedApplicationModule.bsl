#Область ОбработчикиСобытий
&После("ПриЗавершенииРаботыСистемы")
Процедура Изм_ПриЗавершенииРаботыСистемы()
	Изм_БиблиотекаG6Клиент.УдалитьВсеСлужебныеФайлы();
КонецПроцедуры
#КонецОбласти
