require 'helper'

class TestInstruction < Test::Unit::TestCase

  def test_getters_for_attributes

    payer = Fixture.payer
    instruction = MyMoip::Instruction.new(
      id: "some id",
      payment_reason: "some payment_reason",
      values: "some values",
      payer: payer
    )
    
    assert_equal "some id", instruction.id
    assert_equal "some payment_reason", instruction.payment_reason
    assert_equal "some values", instruction.values
    assert_equal payer, instruction.payer
  end

end
