trigger OrderOptionAnswer on OptionAnswer__c (after insert, after delete)
{
    if(Trigger.isAfter && Trigger.Size > 0)
     {

        List<OptionAnswer__c> option;

        if(Trigger.isInsert)
        {
            option = Trigger.new;
        }

        if (Trigger.isDelete)
        {
            option = Trigger.old;
        }

        List<OptionAnswer__c> Options = new List<OptionAnswer__c>();

        Question__c q = [select s.name, (select name from Answers__r)
                        from Question__c s
                        where s.id=:option[0].Question__c];

        if(q != null && !q.Answers__r.isEmpty())
        {
            Integer i = 1;
            for (OptionAnswer__c items : q.Answers__r)
            {
                items.Order__c = i++;
                Options.add(items);
            }
                update Options;
        }

    }
}