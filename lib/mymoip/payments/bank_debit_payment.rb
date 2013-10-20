module MyMoip
  class BankDebitPayment < Payment
    attr_accessor :bank_debit

    def initialize(bank_debit)
      @bank_debit = bank_debit
    end

    def to_json
      raise InvalidBankDebit, "No bank debit information provided." if @bank_debit.nil?
      raise InvalidBankDebit if @bank_debit.invalid?

      json = {
        Forma: "DebitoBancario",
      }

      json[:Instituicao] = {
        banco_do_brasil: "BancoDoBrasil",
        bradesco: "Bradesco",
        banrisul: "Banrisul",
        itau: "Itau"
      }.fetch(@bank_debit.bank)

      json
    end
  end
end