require_relative '../test_helper'

def cc_attrs(attrs = {})
  {
    logo:            :visa,
    card_number:     '4916654211627608',
    expiration_date: '06/15',
    security_code:   '000',
    owner_name:      'Juquinha da Rocha',
    owner_birthday:  '03/11/1980',
    owner_phone:     '5130405060',
    owner_cpf:       '52211670695'
  }.merge(attrs)
end

def payer_attrs(attrs = {})
  {
    id:                    rand,
    name:                  'Juquinha da Rocha',
    email:                 'juquinha@rocha.com',
    address_street:        'Felipe Neri',
    address_street_number: '406',
    address_street_extra:  'Sala 501',
    address_neighbourhood: 'Auxiliadora',
    address_city:          'Porto Alegre',
    address_state:         'RS',
    address_country:       'BRA',
    address_cep:           '90440150',
    address_phone:         '5130405060'
  }.merge(attrs)
end

class TestPurchase < Test::Unit::TestCase
  def setup
    MyMoip::Request.any_instance.stubs(:api_call)
    MyMoip::PaymentRequest.any_instance.stubs(:api_call)
    MyMoip::TransparentRequest.any_instance.stubs(:api_call)
  end

  def subject
    MyMoip::Purchase.new(id:          '42',
                         price:       400,
                         reason:      'Payment of my product',
                         credit_card: cc_attrs,
                         payer:       payer_attrs)
  end

  def test_new_objects_stores_already_initialized_instance_of_credit_ard
    assert subject.credit_card.kind_of?(MyMoip::CreditCard)
  end

  def test_new_objects_stores_already_initialized_instance_of_payer
    assert subject.payer.kind_of?(MyMoip::Payer)
  end

  def test_checkout_uses_initialized_id_for_logging
    MyMoip::PaymentRequest.expects(:new).
                           with('42').
                           returns(stub_everything)
    subject.checkout!
  end

  def test_checkout_instruction_uses_a_generated_id_for_instruction
    MyMoip::Instruction.expects(:new).
                        with(has_entry(id: subject.id)).
                        returns(stub_everything)
    subject.checkout!
  end

  def test_checkout_instruction_uses_initialized_reason
    MyMoip::Instruction.expects(:new).
                        with(has_entry(payment_reason: 'Payment of my product')).
                        returns(stub_everything)
    subject.checkout!
  end

  def test_checkout_instruction_uses_initialized_price
    MyMoip::Instruction.expects(:new).
                        with(has_entry(values: [400.0])).
                        returns(stub_everything)
    subject.checkout!
  end

  def test_checkouts_transparent_request_uses_initialized_id_for_payment_request_logging
    MyMoip::TransparentRequest.expects(:new).
                               with('42').
                               returns(stub_everything)
    subject.checkout!
  end

  def test_checkouts_transparent_request_confirm_request_with_authorized_token
    MyMoip::Purchase.any_instance.stubs(:get_authorization!).
                          returns(stub('MyMoip request', token: 'abc'))

    MyMoip::PaymentRequest.any_instance.expects(:api_call).
                               with(anything, has_entry(token: 'abc')).
                               returns(stub_everything)
    subject.checkout!
  end

  def test_checkouts_transparent_request_assigns_its_code
    MyMoip::PaymentRequest.any_instance.stubs(:success?).returns(true)
    MyMoip::PaymentRequest.any_instance.stubs(:code).returns('foo_bar')
    purchase = subject
    purchase.checkout!

    assert_equal 'foo_bar', purchase.code
  end
end
