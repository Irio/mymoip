MyMoip
======

MoIP transactions in a gem to call your own.

Provides a implementation of MoIP's transparent checkout.

Contributing to MyMoip
----------------------

What would you do if you could make your own implementation of MoIP?

Any patch are welcome, even removing extra blank spaces.

1. Open a pull request.
2. Done.

Using
-----

Currently under active development.

**Configuration**
```ruby
MyMoip.token = "your_moip_dev_token"
MyMoip.key   = "your_moip_dev_key"
```

**First request: who**
```ruby
payer = MyMoip::Payer.new(
  id: "your_own_id",
  name: "Juquinha da Rocha",
  email: "juquinha@rocha.com",
  address_street: "Felipe Neri",
  address_street_number: "406",
  address_street_extra: "Sala 501",
  address_neighbourhood: "Auxiliadora",
  address_city: "Porto Alegre",
  address_state: "RS",
  address_country: "BRA",
  address_cep: "90440-150",
  address_phone: "(51)3040-5060"
) # 9 digit phones must be in "(11)93040-5060" format

instruction = MyMoip::Instruction.new(
  id: "your_own_id",
  payment_reason: "Order in Buy Everything Store",
  values: [100.0],
  payer: payer
)

transparent_request = MyMoip::TransparentRequest.new("your_own_id")
transparent_request.api_call(instruction)
```

**Second request: how**
```ruby
credit_card = MyMoip::CreditCard.new(
  logo: :visa,
  card_number: "4916654211627608",
  expiration_date: "06/15",
  security_code: "000",
  owner_name: "Juquinha da Rocha",
  owner_birthday: Date.new(1984, 11, 3),
  owner_phone: "(51)3040-5060",
  owner_rg: "1010202030"
)

credit_card_payment = MyMoip::CreditCardPayment.new(credit_card, 1)
payment_request = MyMoip::PaymentRequest.new("your_own_id")
payment_request.api_call(credit_card_payment, token: transparent_request.token)
```

**Success?**
```ruby
payment_request.success?
```

License
-------

MIT. See LICENSE.txt for further details.
