require 'helper'

class TestInstruction < Test::Unit::TestCase
  def test_getters_for_attributes
    payer       = Fixture.payer
    commissions = [Fixture.commission]
    instruction = MyMoip::Instruction.new(
      id: "some id",
      payment_reason: "some payment_reason",
      values: [100.0, 200.0],
      payer: payer,
      commissions: commissions,
      fee_payer: "fee_payer_indentifier",
      payment_receiver: "payment_receiver_indentifier",
      payment_receiver_nickname: "nick_fury"
    )

    assert_equal "some id", instruction.id
    assert_equal "some payment_reason", instruction.payment_reason
    assert_equal [100.0, 200.0], instruction.values
    assert_equal payer, instruction.payer
    assert_equal commissions, instruction.commissions
    assert_equal "fee_payer_indentifier", instruction.fee_payer
    assert_equal "payment_receiver_indentifier", instruction.payment_receiver
    assert_equal "nick_fury", instruction.payment_receiver_nickname
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

  def test_xml_format_with_commissions
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value:20,fixed_value:nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>20</ValorPercentual></Comissionamento></Comissoes><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions_and_fee_payer
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value:20,fixed_value:nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions, fee_payer: 'fee_payer_indentifier')
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>20</ValorPercentual></Comissionamento><PagadorTaxa><LoginMoIP>fee_payer_indentifier</LoginMoIP></PagadorTaxa></Comissoes><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions_and_payment_receiver
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value:20,fixed_value:nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions,
                                      payment_receiver:'payment_receiver_indentifier',
                                      payment_receiver_nickname: 'nick_fury' )
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>20</ValorPercentual></Comissionamento></Comissoes><Recebedor><LoginMoIP>payment_receiver_indentifier</LoginMoIP><Apelido>nick_fury</Apelido></Recebedor><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions_and_payment_receiver_and_fee_payer
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value:20,fixed_value:nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions,
                                      payment_receiver:'payment_receiver_indentifier',
                                      payment_receiver_nickname: 'nick_fury',
                                      fee_payer: 'fee_payer_indentifier')
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>20</ValorPercentual></Comissionamento><PagadorTaxa><LoginMoIP>fee_payer_indentifier</LoginMoIP></PagadorTaxa></Comissoes><Recebedor><LoginMoIP>payment_receiver_indentifier</LoginMoIP><Apelido>nick_fury</Apelido></Recebedor><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_to_xml_method_raises_exception_when_called_with_some_invalid_comission
    invalid_commission = Fixture.commission
    invalid_commission.stubs(:invalid?).returns(true)
    subject = Fixture.instruction commissions: [Fixture.commission, invalid_commission]
    assert_raise ArgumentError do
      subject.to_xml
    end
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

  def test_validate_no_presence_of_payment_receiver_in_commissions
    commissions = [Fixture.commission(commissioned: 'payment_receiver_id')]
    subject = Fixture.instruction payment_receiver: 'payment_receiver_id', commissions: commissions
    assert subject.invalid? &&  subject.errors[:payment_receiver].present?,
           "should be invalid with receiver present on commissions"

  end

  def test_validate_presence_of_payment_receiver_nickname
    subject = Fixture.instruction payment_receiver: 'payment_receiver_id'
    assert subject.invalid? && subject.errors[:payment_receiver_nickname].present?,
           "should be invalid with payment receiver without nickname"
  end

  def test_values_sum
    subject = Fixture.instruction(values: [6, 5])
    assert_equal 6 + 5, subject.values_sum
  end

  def test_commissions_sum
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value:10, fixed_value:nil)]
    subject = Fixture.instruction(commissions: commissions, values: [10])
    assert_equal 6, subject.commissions_sum
  end

  def test_validate_commissions_sum
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(fixed_value: 5)]
    subject = Fixture.instruction(commissions: commissions, values: [6])
    assert subject.invalid? && subject.errors[:commissions].present?,
           "should be invalid with commissions sum greater than values sum"
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
