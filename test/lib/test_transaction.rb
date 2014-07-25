require_relative '../test_helper'

class TestTransaction < Test::Unit::TestCase
  def setup
    @transaction_params = {
      'Data'                 => '2012-04-02T10:45:44.000-03:00',
      'DataCredito'          => '2012-04-16T00:00:00.000-03:00',
      'TotalPago'            => '1.00',
      'TaxaParaPagador'      => '0.00',
      'TaxaMoIP'             => '0.46',
      'ValorLiquido'         => '0.56',
      'FormaPagamento'       => 'CartaoDeCredito',
      'InstituicaoPagamento' => 'AmericanExpress',
      'Parcela'              => {'TotalParcelas'=>'1'},
      'Status'               => 'Autorizado',
      'CodigoMoIP'           => '0000.2524.0547'
    }
  end

  def test_nasp_params_mapping_and_methods_definition
    subject = MyMoip::Transaction.new(@transaction_params)

    assert_equal subject.date,                       '2012-04-02T10:45:44.000-03:00'
    assert_equal subject.credit_date,                '2012-04-16T00:00:00.000-03:00'
    assert_equal subject.total_paid_value,           '1.00'
    assert_equal subject.payer_tax_value,            '0.00'
    assert_equal subject.moip_tax_value,             '0.46'
    assert_equal subject.equity_value,               '0.56'
    assert_equal subject.payment_method,             'CartaoDeCredito'
    assert_equal subject.payment_method_institution, 'AmericanExpress'
    assert_equal subject.status,                     'Autorizado'
    assert_equal subject.installments,               '1'
    assert_equal subject.moip_code,                  '0000.2524.0547'
  end
end
