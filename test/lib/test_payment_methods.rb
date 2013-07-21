require_relative '../test_helper'

class TestPaymentMethods < Test::Unit::TestCase
  def test_initialization_and_setters
    params = {
      payment_slip: true,
      credit_card: false,
      debit: true,
      debit_card: false, 
      financing: true, 
      moip_wallet: false
    }

    subject = MyMoip::PaymentMethods.new(params)
    assert_equal params[:payment_slip], subject.payment_slip
    assert_equal params[:credit_card], subject.credit_card
    assert_equal params[:debit], subject.debit
    assert_equal params[:debit_card], subject.debit_card
    assert_equal params[:financing], subject.financing
    assert_equal params[:moip_wallet], subject.moip_wallet
  end

  def test_validates_boolean
    subject = MyMoip::PaymentMethods.new
    assert subject.valid?

    subject.payment_slip = 1
    subject.credit_card = 1
    subject.debit = 1
    subject.debit_card = 1
    subject.financing = 1
    subject.moip_wallet = 1

    assert subject.invalid? && 
      subject.errors[:payment_slip].present? &&
      subject.errors[:credit_card].present? &&
      subject.errors[:debit].present? &&
      subject.errors[:debit_card].present? &&
      subject.errors[:financing].present? &&
      subject.errors[:moip_wallet].present?
  end

  def test_xml_format
    subject = MyMoip::PaymentMethods.new
    assert_equal '', subject.to_xml

    subject.payment_slip = false
    expected_format = <<XML
<FormaPagamento>CartaoDeCredito</FormaPagamento><FormaPagamento>DebitoBancario</FormaPagamento><FormaPagamento>CartaoDeDebito</FormaPagamento><FormaPagamento>FinanciamentoBancario</FormaPagamento><FormaPagamento>CarteiraMoIP</FormaPagamento>
XML
    assert_equal expected_format.strip, subject.to_xml
  end

end