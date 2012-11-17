require 'helper'

class TestInstruction < Test::Unit::TestCase
  def test_getters_for_attributes
    payer       = Fixture.payer
    instruction = MyMoip::Instruction.new(
      id: "some id",
      payment_reason: "some payment_reason",
      values: [100.0, 200.0],
      payer: payer
    )

    assert_equal "some id", instruction.id
    assert_equal "some payment_reason", instruction.payment_reason
    assert_equal [100.0, 200.0], instruction.values
    assert_equal payer, instruction.payer
  end

  def test_should_generate_a_string_when_converting_to_xml
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer)

    assert_equal String, instruction.to_xml.class
  end

  def test_xml_format
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_to_xml_method_raises_exception_when_called_with_invalid_payer
    subject = Fixture.instruction
    MyMoip::Payer.any_instance.stubs(:invalid?).returns(true)
    assert_raise ArgumentError do
      subject.to_xml
    end
  end

  def test_to_xml_method_dont_raises_exception_when_called_with_valid_payer
    subject = Fixture.instruction
    MyMoip::Payer.any_instance.stubs(:invalid?).returns(false)
    assert_nothing_raised ArgumentError do
      subject.to_xml
    end
  end

  def test_to_xml_method_raises_exception_when_called_with_invalid_params
    subject = Fixture.instruction
    MyMoip::Instruction.any_instance.stubs(:invalid?).returns(true)
    assert_raise ArgumentError do
      subject.to_xml
    end
  end

  def test_to_xml_method_dont_raises_exception_when_called_with_valid_params
    subject = Fixture.instruction
    MyMoip::Instruction.any_instance.stubs(:invalid?).returns(false)
    assert_nothing_raised ArgumentError do
      subject.to_xml
    end
  end

  def test_validate_presence_of_id_attribute
    subject = Fixture.instruction
    subject.id = nil
    assert subject.invalid? && subject.errors[:id].present?,
      'should be invalid without an id'
  end

  def test_validate_presence_of_payment_reason_attribute
    subject = Fixture.instruction
    subject.payment_reason = nil
    assert subject.invalid? && subject.errors[:payment_reason].present?,
      'should be invalid without a payment_reason'
    subject.payment_reason = ''
    assert subject.invalid? && subject.errors[:payment_reason].present?,
      'should be invalid without a payment_reason'
  end

  def test_validate_presence_of_values_attribute
    subject = Fixture.instruction
    subject.values = nil
    assert subject.invalid? && subject.errors[:values].present?,
      'should be invalid without values'
  end

  def test_validate_presence_of_payer_attribute
    subject = Fixture.instruction
    subject.payer = nil
    assert subject.invalid? && subject.errors[:payer].present?,
      'should be invalid without a payer'
  end
end
