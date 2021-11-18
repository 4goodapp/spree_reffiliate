module Spree
  class TransactionService

    attr_accessor :transaction, :affiliate, :affiliate_commission_rule, :amount

    def calculate_commission_amount
      if affiliate_commission_rule.present?
        rate = affiliate_commission_rule.rate
        if affiliate_commission_rule.fixed_commission?
          @amount = rate
        else
          #testing currency
                    
          @my_item_total_amount = (transaction.commissionable.try(:item_total))
            
          if (Spree::Store.default.default_currency == "XOF") && (@my_item_total_amount >= 50000)
            @my_item_total_amount_XOF_to_USD = (transaction.commissionable.try(:item_total)) / 570.0)   
            @amount = (@my_item_total_amount_XOF_to_USD * (rate))/100.0 
          elsif (Spree::Store.default.default_currency == "USD") && (@my_item_total_amount >= 100)
            @amount = (@my_item_total_amount_XOF_to_USD * (rate))/100.0 
          elsif (Spree::Store.default.default_currency == "EUR") && (@my_item_total_amount >= 100)        
            @amount = (@my_item_total_amount_XOF_to_USD * (rate))/100.0 
          else
            @amount = 0
          end
          # end testing currency
          #@amount = 50 # (transaction.commissionable.try(:item_total) * (rate))/100
        end
        @amount.to_f
      end
    end

    private

      def initialize(transaction)
        @transaction = transaction
        @affiliate = transaction.affiliate
        if @transaction.commissionable_type.eql? 'Spree::User'
          @affiliate_commission_rule = affiliate.affiliate_commission_rules.active.user_registration.first
        elsif @transaction.commissionable_type.eql? 'Spree::Order'
          @affiliate_commission_rule = affiliate.affiliate_commission_rules.active.order_placement.first
        end
      end
  end
end
