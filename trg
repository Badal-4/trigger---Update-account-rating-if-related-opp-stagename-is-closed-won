trigger trg3 on Opportunity (after insert,after Update) 
{
       Set<Id> accId = new Set<Id>();
       if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate))
       {
           for(Opportunity o : trigger.new)
           {
               if(o.AccountId != null )
               {
                   accId.add(o.AccountId);
               }
           }
       }
    Map<Id,Account> accMap = new Map<Id,Account>([Select Id,Rating from Account where Id IN : accId]);
    Map<Id,Account> acctMap = new Map<Id,Account>();
    for(Opportunity op : trigger.new)
    {
        if(op.Stagename == 'Closed Won' && accMap.containsKey(op.AccountId))
        {
            Account acc = accMap.get(op.AccountId);
            if(acc.Rating != 'Cold' || acc.Rating == null)
            {
                acc.Rating = 'Cold';
                acctMap.put(acc.Id,acc);
            }
        }
    }
    if(acctMap.size() != null)
    {
        update acctMap.values();
    }
}
