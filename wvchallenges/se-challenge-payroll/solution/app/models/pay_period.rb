class PayPeriod

  def PayPeriod.add_item(key,value)
    @hash ||= {}
    @hash[key] = value
  end

  def PayPeriod.get_value(key_str)
    PayPeriod.const_get(key_str.upcase)
  end

  def PayPeriod.get_key(value)
    @hash.key(value)
  end
  
  def PayPeriod.const_missing(key)
    @hash[key]
  end 

  def PayPeriod.each
    @hash.each {|key,value| yield(key,value)}
  end
  
  PayPeriod.add_item :MONTHLY, 1
  PayPeriod.add_item :SEMIMONTHLY, 2
  PayPeriod.add_item :BIWEEKLY, 3
  PayPeriod.add_item :WEEKLY, 4


end
