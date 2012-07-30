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

end
