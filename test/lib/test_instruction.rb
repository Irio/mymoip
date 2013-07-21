require_relative '../test_helper'

class TestInstruction < Test::Unit::TestCase
  def test_getters_for_attributes
    payer       = Fixture.payer
    commissions = [Fixture.commission]
    installments = [{min: 2, max: 12, forward_taxes: true, fee: 1.99}]
    instruction = MyMoip::Instruction.new(
      id: "some id",
      payment_reason: "some payment_reason",
      values: [100.0, 200.0],
      payer: payer,
      commissions: commissions,
      fee_payer_login: "fee_payer_login",
      payment_receiver_login: "payment_receiver_login",
      payment_receiver_name: "nick_fury",
      installments: installments,
      notification_url: 'http://please.notify.me',
      return_url: 'http://return.to.my.address.com'
    )

    assert_equal "some id", instruction.id
    assert_equal "some payment_reason", instruction.payment_reason
    assert_equal [100.0, 200.0], instruction.values
    assert_equal payer, instruction.payer
    assert_equal commissions, instruction.commissions
    assert_equal installments, instruction.installments
    assert_equal "fee_payer_login", instruction.fee_payer_login
    assert_equal "payment_receiver_login", instruction.payment_receiver_login
    assert_equal "nick_fury", instruction.payment_receiver_name
    assert_equal 'http://please.notify.me', instruction.notification_url
    assert_equal 'http://return.to.my.address.com', instruction.return_url
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
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Parcelamentos><Parcelamento><MinimoParcelas>2</MinimoParcelas><MaximoParcelas>12</MaximoParcelas><Repassar>true</Repassar><Juros>1.99</Juros></Parcelamento></Parcelamentos><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end
  
  def test_xml_format_with_urls
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer)
    instruction.notification_url = 'http://qwerty.me/nasp'
    instruction.return_url = 'http://return.to.me'
    
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Parcelamentos><Parcelamento><MinimoParcelas>2</MinimoParcelas><MaximoParcelas>12</MaximoParcelas><Repassar>true</Repassar><Juros>1.99</Juros></Parcelamento></Parcelamentos><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador><URLNotificacao>http://qwerty.me/nasp</URLNotificacao><URLRetorno>http://return.to.me</URLRetorno></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_installments
    payer        = Fixture.payer
    installments = [
      {min: 5, max: 10, fee: 2.99}
    ]
    instruction  = Fixture.instruction(payer: payer, installments: installments)
    
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Parcelamentos><Parcelamento><MinimoParcelas>5</MinimoParcelas><MaximoParcelas>10</MaximoParcelas><Juros>2.99</Juros></Parcelamento></Parcelamentos><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end
  
  def test_xml_format_with_mutiple_installments
    payer        = Fixture.payer
    installments = [
      {min: 2, max: 6, fee: 1.99},
      {min: 7, max: 12, fee: 2.99}
    ]
    instruction  = Fixture.instruction(payer: payer, installments: installments)
    
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Parcelamentos><Parcelamento><MinimoParcelas>2</MinimoParcelas><MaximoParcelas>6</MaximoParcelas><Juros>1.99</Juros></Parcelamento><Parcelamento><MinimoParcelas>7</MinimoParcelas><MaximoParcelas>12</MaximoParcelas><Juros>2.99</Juros></Parcelamento></Parcelamentos><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value: 0.15, fixed_value: nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions, installments: nil)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5.00</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>15.00</ValorPercentual></Comissionamento></Comissoes><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions_and_fee_payer
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value: 0.15,fixed_value: nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions, fee_payer_login: 'fee_payer_indentifier', installments: nil)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5.00</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>15.00</ValorPercentual></Comissionamento><PagadorTaxa><LoginMoIP>fee_payer_indentifier</LoginMoIP></PagadorTaxa></Comissoes><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions_and_payment_receiver
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value: 0.15, fixed_value: nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions,
                                      payment_receiver_login:'payment_receiver_indentifier',
                                      payment_receiver_name: 'nick_fury', installments: nil)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5.00</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>15.00</ValorPercentual></Comissionamento></Comissoes><Recebedor><LoginMoIP>payment_receiver_indentifier</LoginMoIP><Apelido>nick_fury</Apelido></Recebedor><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_xml_format_with_commissions_and_payment_receiver_and_fee_payer
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value: 0.15, fixed_value: nil)]
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer: payer, commissions: commissions,
                                      payment_receiver_login:'payment_receiver_indentifier',
                                      payment_receiver_name: 'nick_fury',
                                      fee_payer_login: 'fee_payer_indentifier',
                                      installments: nil)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Comissoes><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorFixo>5.00</ValorFixo></Comissionamento><Comissionamento><Razao>Because we can</Razao><Comissionado><LoginMoIP>commissioned_indentifier</LoginMoIP></Comissionado><ValorPercentual>15.00</ValorPercentual></Comissionamento><PagadorTaxa><LoginMoIP>fee_payer_indentifier</LoginMoIP></PagadorTaxa></Comissoes><Recebedor><LoginMoIP>payment_receiver_indentifier</LoginMoIP><Apelido>nick_fury</Apelido></Recebedor><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

  def test_to_xml_method_raises_exception_when_called_with_some_invalid_comission
    invalid_commission = Fixture.commission
    invalid_commission.stubs(:invalid?).returns(true)
    subject = Fixture.instruction(commissions: [Fixture.commission, invalid_commission])
    assert_raise MyMoip::InvalidComission do
      subject.to_xml
    end
  end

  def test_to_xml_method_raises_exception_when_called_with_invalid_payer
    subject = Fixture.instruction
    MyMoip::Payer.any_instance.stubs(:invalid?).returns(true)
    assert_raise MyMoip::InvalidPayer do
      subject.to_xml
    end
  end

  def test_to_xml_method_dont_raises_exception_when_called_with_valid_payer
    subject = Fixture.instruction
    MyMoip::Payer.any_instance.stubs(:invalid?).returns(false)
    assert_nothing_raised MyMoip::InvalidPayer do
      subject.to_xml
    end
  end

  def test_to_xml_method_raises_exception_when_called_with_invalid_params
    subject = Fixture.instruction
    MyMoip::Instruction.any_instance.stubs(:invalid?).returns(true)
    assert_raise MyMoip::InvalidInstruction do
      subject.to_xml
    end
  end

  def test_to_xml_method_dont_raises_exception_when_called_with_valid_params
    subject = Fixture.instruction
    MyMoip::Instruction.any_instance.stubs(:invalid?).returns(false)
    assert_nothing_raised MyMoip::InvalidInstruction do
      subject.to_xml
    end
  end

  def test_validate_no_presence_of_payment_receiver_in_commissions
    commissions = [Fixture.commission(receiver_login: 'payment_receiver_id')]
    subject = Fixture.instruction(payment_receiver_login: 'payment_receiver_id', commissions: commissions)
    assert subject.invalid? &&  subject.errors[:payment_receiver_login].present?,
           "should be invalid with receiver present on commissions"
  end

  def test_gross_amount
    subject = Fixture.instruction(values: [6, 5])
    assert_equal 11, subject.gross_amount
  end

  def test_commissions_sum
    commissions = [Fixture.commission(fixed_value: 5), Fixture.commission(percentage_value: 0.1, fixed_value: nil)]
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

  def test_validate_url
    subject = Fixture.instruction
    assert subject.valid?    

    subject.notification_url = 'ftp://sdfsdfs.com'
    subject.return_url = 'xxftpsdfsdfs.com'

    assert subject.invalid? && subject.errors[:notification_url].present? && subject.errors[:return_url].present?
  end
end
