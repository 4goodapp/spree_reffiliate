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
          if (Spree::Store.default.default_currency == "XOF")
            @amount = 10
          elsif (Spree::Store.default.default_currency == "USD")
            @amount = 20
          elsif (Spree::Store.default.default_currency == "EUR")
            @amount = 30
          else
            @amount = 50
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
