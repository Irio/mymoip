require 'helper'

def cc_attrs(attrs = {})
  {
    logo: :visa,
    card_number: '4916654211627608',
    expiration_date: '06/15',
    security_code: '000',
    owner_name: 'Juquinha da Rocha',
    owner_birthday: '03/11/1980',
    owner_phone: '5130405060',
    owner_cpf: '52211670695'
  }.merge(attrs)
end

def payer_attrs(attrs = {})
  {
    id: rand,
    name: 'Juquinha da Rocha',
    email: 'juquinha@rocha.com',
    address_street: 'Felipe Neri',
    address_street_number: '406',
    address_street_extra: 'Sala 501',
    address_neighbourhood: 'Auxiliadora',
    address_city: 'Porto Alegre',
    address_state: 'RS',
    address_country: 'BRA',
    address_cep: '90440150',
    address_phone: '5130405060'
  }.merge(attrs)
end

describe MyMoip::Purchase do
  def subject
    MyMoip::Purchase.new(id: '42',
                         price: 400,
                         credit_card: cc_attrs,
                         payer: payer_attrs)
  end

  describe "new objects" do
    it "stores already initialized instance of MyMoip::CreditCard" do
      subject.credit_card.must_be_kind_of MyMoip::CreditCard
    end

    it "stores already initialized instance of MyMoip::Payer" do
      subject.payer.must_be_kind_of MyMoip::Payer
    end
  end

  describe "checkout" do
    def setup
      MyMoip::Request.any_instance.stubs(:api_call)
      MyMoip::PaymentRequest.any_instance.stubs(:api_call)
      MyMoip::TransparentRequest.any_instance.stubs(:api_call)
    end

    describe "authorization request" do
      it "uses initialized id for logging" do
        MyMoip::PaymentRequest.expects(:new).
                               with('42').
                               returns(stub_everything)
        subject.checkout!
      end

      it "uses the default payment reason" do
        MyMoip::Instruction.expects(:new).
                            with(has_entry(payment_reason: MyMoip::Purchase::REASON)).
                            returns(stub_everything)
        subject.checkout!
      end

      it "uses initialized price" do
        MyMoip::Instruction.expects(:new).
                            with(has_entry(values: [400.0])).
                            returns(stub_everything)
        subject.checkout!
      end

      it "uses a generated id for instruction" do
        MyMoip::Instruction.expects(:new).
                            with(has_entry(id: subject.id)).
                            returns(stub_everything)
        subject.checkout!
      end
    end

    describe "payment request" do
      it "uses initialized id for payment request logging" do
        MyMoip::TransparentRequest.expects(:new).
                                   with('42').
                                   returns(stub_everything)
        subject.checkout!
      end

      it "confirm request with authorized token" do
        MyMoip::Purchase.any_instance.stubs(:get_authorization!).
                              returns(stub('MyMoip request', token: 'abc'))

        MyMoip::PaymentRequest.any_instance.expects(:api_call).
                                   with(anything, has_entry(token: 'abc')).
                                   returns(stub_everything)
        subject.checkout!
      end

      it "assigns its code" do
        MyMoip::PaymentRequest.any_instance.stubs(:api_call)
        MyMoip::TransparentRequest.any_instance.stubs(:api_call)
        MyMoip::PaymentRequest.any_instance.stubs(:success?).returns(true)
        MyMoip::TransparentRequest.any_instance.stubs(:success?).returns(true)
        MyMoip::PaymentRequest.any_instance.stubs(:code).returns('foo_bar')
        subject.checkout!

        subject.code.must_equal 'foo_bar'
      end
    end
  end
end
