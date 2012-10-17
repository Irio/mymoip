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
<EnviarInstrucao><InstrucaoUnica TipoValidacao=\"Transparente\"><Razao>some payment_reason</Razao><Valores><Valor moeda=\"BRL\">100.00</Valor><Valor moeda=\"BRL\">200.00</Valor></Valores><IdProprio>some id</IdProprio><Pagador><Nome>some name</Nome><Email>some email</Email><IdPagador>some id</IdPagador><EnderecoCobranca><Logradouro>some address_street</Logradouro><Numero>some address_street_number</Numero><Complemento>some address_street_extra</Complemento><Bairro>some address_neighbourhood</Bairro><Cidade>some address_city</Cidade><Estado>some address_state</Estado><Pais>some address_country</Pais><CEP>some address_cep</CEP><TelefoneFixo>some address_phone</TelefoneFixo></EnderecoCobranca></Pagador></InstrucaoUnica></EnviarInstrucao>
XML
    assert_equal expected_format.rstrip, instruction.to_xml
  end

end
