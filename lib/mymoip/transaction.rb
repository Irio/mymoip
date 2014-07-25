module MyMoip
  class Transaction
    PARAMS_MAPPER = {
      'Data'                 => 'date',                       # 2012-04-02T10:45:44.000-03:00
      'DataCredito'          => 'credit_date',                # 2012-04-16T00:00:00.000-03:00
      'TotalPago'            => 'total_paid_value',           # 1.00
      'TaxaParaPagador'      => 'payer_tax_value',            # 0.00
      'TaxaMoIP'             => 'moip_tax_value',             # 0.46
      'ValorLiquido'         => 'equity_value',               # 0.54
      'FormaPagamento'       => 'payment_method',             # CartaoDeCredito
      'InstituicaoPagamento' => 'payment_method_institution', # AmericanExpress
      'Status'               => 'status',                     # Autorizado
      'Parcela'              => { 'installments' => 'TotalParcelas' },
      'CodigoMoIP'           => 'moip_code'                   # 0000.2524.0547
    }

    include MyMoip::ParamsMapper
  end
end