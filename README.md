MyMoip
======

MoIP transactions in a gem to call your own.

Provides a implementation of MoIP's transparent checkout.

Contributing to MyMoip
----------------------

[![Build Status](https://secure.travis-ci.org/Irio/mymoip.png)](http://travis-ci.org/Irio/mymoip)

What would you do if you could make your own implementation of MoIP?

Any patch are welcome, even removing extra blank spaces.

1. Open a pull request.
2. Done.

Using
-----

Currently under active development.

**Bundler - Gemfile**
```ruby
gem 'mymoip'
```

**Configuration**
```ruby
MyMoip.environment = "production" # Optional. "sandbox" by default
MyMoip.token = "your_moip_dev_token"
MyMoip.key   = "your_moip_dev_key"
```

**First request: what and from who**
```ruby
payer = MyMoip::Payer.new(
  id: "payer_id_defined_by_you",
  name: "Juquinha da Rocha",
  email: "juquinha@rocha.com",
  address_street: "Felipe Neri",
  address_street_number: "406",
  address_street_extra: "Sala 501",
  address_neighbourhood: "Auxiliadora",
  address_city: "Porto Alegre",
  address_state: "RS",
  address_country: "BRA",
  address_cep: "90440150",
  address_phone: "5130405060"
)

instruction = MyMoip::Instruction.new(
  id: "instruction_id_defined_by_you",
  payment_reason: "Order in Buy Everything Store",
  values: [100.0],
  payer: payer
)

transparent_request = MyMoip::TransparentRequest.new("your_logging_id")
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
  owner_phone: "5130405060",
  owner_cpf: "52211670695"
)

credit_card_payment = MyMoip::CreditCardPayment.new(credit_card, installments: 1)
payment_request = MyMoip::PaymentRequest.new("your_logging_id")
payment_request.api_call(credit_card_payment, token: transparent_request.token)
```

**Success?**
```ruby
payment_request.success?
```

Sending payments to multiple receivers
--------------------------------------

Choosing between commission with fixed or percentage value.

```ruby
commissions = [MyMoip::Commission.new(
  reason: 'System maintenance',
  commissioned: 'commissioned_moip_login',
  fixed_value: 15.0
)]

# OR

commissions = [MyMoip::Commission.new(
  reason: 'Shipping',
  commissioned: 'commissioned_moip_login',
  percentage_value: 0.15
)]
```

```ruby
instruction = MyMoip::Instruction.new(
  id: "instruction_id_defined_by_you",
  payment_reason: "Order in Buy Everything Store",
  values: [100.0],
  payer: payer,
  commissions: commissions
)
```

[Wiki](https://github.com/Irio/mymoip/wiki/Sending-payments-to-multiple-receivers) will be helpful here.

Documentation
-------------

For more information you can access the [wiki page](https://github.com/Irio/mymoip/wiki).

License
-------

MIT. See LICENSE.txt for further details.
