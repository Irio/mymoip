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
    instruction = Fixture.instruction(payer)

    assert_equal String, instruction.to_xml.class
  end

  def test_xml_format
    payer       = Fixture.payer
    instruction = Fixture.instruction(payer)
    expected_format = <<XML
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>your_own_instruction_id</IdProprio><Pagador><Nome>Juquinha da Rocha</Nome><Email>juquinha@rocha.com</Email><IdPagador>your_own_payer_id</IdPagador><EnderecoCobranca><Logradouro>Felipe Neri</Logradouro><Numero>406</Numero><Complemento>Sala 501</Complemento><Bairro>Auxiliadora</Bairro><Cidade>Porto Alegre</Cidade><Estado>RS</Estado><Pais>BRA</Pais><CEP>90440-150</CEP><TelefoneFixo>(51)3040-5060</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

end
