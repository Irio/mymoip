# MyMoip

MoIP transactions in a gem to call your own.

The easier way to use Moip's transparent checkout.

Planning to use with Rails? Check [my_moip-rails](https://github.com/Irio/my_moip-rails) too.

## DISCLAIMER

According with recent changes on Moip's policy, your application won't be accepted if sends credit card information to your own server, as currently implemented in `MyMoip::Purchase` and any class sufixed by the word "Payment". In their place, you must use the [JavaScript library](https://labs.moip.com.br/referencia/javascript_de_pagamento/) (in portuguese). Future changes in MyMoip will reflect this change.

## Contributing to MyMoip

[![Build Status](https://secure.travis-ci.org/Irio/mymoip.png)](http://travis-ci.org/Irio/mymoip)
[![Code
Climate](https://codeclimate.com/github/Irio/mymoip.png)](https://codeclimate.com/github/Irio/mymoip)

What would you do if you could make your own implementation of MoIP?

Any patch are welcome, even removing extra white spaces.

1. Open a pull request.
2. Done.

# Using

## Compatibility

* Ruby >= 1.9.3 - current version
* Ruby 1.9.2 - 0.9.0

## First of all

**Bundler - Gemfile**

```ruby
gem 'mymoip'
```

**Configuration**

```ruby
MyMoip.environment = 'production' # 'sandbox' by default

MyMoip.sandbox_token    = 'your_moip_sandbox_token'
MyMoip.sandbox_key      = 'your_moip_sandbox_key'

MyMoip.production_token = 'your_moip_production_token'
MyMoip.production_key   = 'your_moip_production_key'
```

## The easy way

If you just need to pass some attributes and get if the payment based on them was succesfull or not, this can be your start point.

The payer attributes will be sent to Moip to be stored as your client, identified by... his id. If you don't want to, on each payment, ask your user to all his data, you can always save them in your database.

```ruby
purchase_id       = 'UNIQUE_PURCHASE_ID'
transaction_price = 100.0

card_attrs = {
 'logo'            => 'visa',
 'card_number'     => '4916654211627608',
 'expiration_date' => '06/15',
 'security_code'   => '000',
 'owner_name'      => 'Juquinha da Rocha',
 'owner_birthday'  => '03/11/1980',
 'owner_phone'     => '5130405060',
 'owner_cpf'       => '52211670695'
}

payer_attrs = {
  'id'                    => 'payer_id_defined_by_you',
  'name'                  => 'Juquinha da Rocha',
  'email'                 => 'juquinha@rocha.com',
  'address_street'        => 'Felipe Neri',
  'address_street_number' => '406',
  'address_street_extra'  => 'Sala 501',
  'address_neighbourhood' => 'Auxiliadora',
  'address_city'          => 'Porto Alegre',
  'address_state'         => 'RS',
  'address_country'       => 'BRA',
  'address_cep'           => '90440150',
  'address_phone'         => '5130405060'
}

purchase = MyMoip::Purchase.new(
  id:          purchase_id,
  price:       transaction_price,
  reason:      'Payment of my product',
  credit_card: card_attrs,
  payer:       payer_attrs
)
purchase.checkout! # => true OR false (succesfull state)
purchase.code      # Moip code or nil, depending of the checkout's return
```

## The hard way

### First request: what and from who

```ruby
payer = MyMoip::Payer.new(
  id:                    'payer_id_defined_by_you',
  name:                  'Juquinha da Rocha',
  email:                 'juquinha@rocha.com',
  address_street:        'Felipe Neri',
  address_street_number: '406',
  address_street_extra:  'Sala 501',
  address_neighbourhood: 'Auxiliadora',
  address_city:          'Porto Alegre',
  address_state:         'RS',
  address_country:       'BRA',
  address_cep:           '90440150',
  address_phone:         '5130405060'
)

instruction = MyMoip::Instruction.new(
  id:             'instruction_id_defined_by_you',
  payment_reason: 'Order in Buy Everything Store',
  values:         [100.0],
  payer:          payer
)

transparent_request = MyMoip::TransparentRequest.new('your_logging_id')
transparent_request.api_call(instruction)
```

### Second request: how

#### Credit card

```ruby
credit_card = MyMoip::CreditCard.new(
  logo:                     'visa',
  card_number:              '4916654211627608',
  expiration_date:          '06/15',
  security_code:            '000',
  owner_name:               'Juquinha da Rocha',
  owner_birthday:           '03/11/1984',
  owner_phone:              '5130405060',
  owner_cpf:                '52211670695',
  perform_extra_validation: true  # optional: see the next sub section
)

credit_card_payment = MyMoip::CreditCardPayment.new(credit_card, installments: 1)
payment_request     = MyMoip::PaymentRequest.new('your_logging_id')
payment_request.api_call(credit_card_payment, token: transparent_request.token)
```

##### Credit card extra validation

There is a already [reported](http://goo.gl/celJIZ) bug that the API don't requires some attributes returning a successful [response](https://gist.github.com/Irio/4032350). To "fix it" you can enable an extra validation with `perform_extra_validation` option. It will require the presence of all credit card attributes.


#### Payment slip (aka boleto)

```ruby
payment_slip_payment = MyMoip::PaymentSlipPayment.new()
payment_request      = MyMoip::PaymentRequest.new('your_logging_id')
payment_request.api_call(payment_slip_payment, token: transparent_request.token)
```

#### Bank debit

```ruby
bank_debit = MyMoip::BankDebit.new(bank: :itau)
# you can find the available banks on MyMoip::BankDebit::AVAILABLE_BANKS

bank_debit_payment = MyMoip::BankDebitPayment.new(bank_debit)
payment_request    = MyMoip::PaymentRequest.new('your_logging_id')
payment_request.api_call(bank_debit_payment, token: transparent_request.token)
```

### Success?

```ruby
payment_request.success?
```

### Payment url

For **payment slip** and **bank debit**, payment request will have a url. This
url redirect to:

- When **payment slip**: the payment slip to user print and pay
- When **bank debit**:  the bank's specific payment page

```ruby
payment_request.url
```

## More!

Yes, you should read (and help improve!) the docs.

### Documentation

For more information about usage you can access the [wiki page](https://github.com/Irio/mymoip/wiki).

### Sending payments to multiple receivers

Choosing between commission with fixed or percentage value.

```ruby
commissions = [MyMoip::Commission.new(
  reason:         'System maintenance',
  receiver_login: 'commissioned_moip_login',
  fixed_value:    15.0
)]

# OR

commissions = [MyMoip::Commission.new(
  reason:           'Shipping',
  receiver_login:   'commissioned_moip_login',
  percentage_value: 0.15
)]
```

```ruby
instruction = MyMoip::Instruction.new(
  id:             'instruction_id_defined_by_you',
  payment_reason: 'Order in Buy Everything Store',
  values:         [100.0],
  payer:          payer,
  commissions:    commissions
)
```

[More](https://github.com/Irio/mymoip/wiki/Sending-payments-to-multiple-receivers).

### Installments

The API allows you to set multiple configurations for installments.

On initialization of a MyMoip::Instruction, the #new method accepts a
installment option which will expect something like this array:

```ruby
installments = [
  { min: 1, max:  1, forward_taxes: false },
  { min: 2, max: 12, forward_taxes: true,  fee: 1.99 } # 1.99 fee = 1.99% per month
  { min: 2, max: 12, receive_in_installments: true } # Receive money from moip
  in installments and dont pay taxes

]

instruction = MyMoip::Instruction.new(
  id:             'instruction_id_defined_by_you',
  payment_reason: 'Order in Buy Everything Store',
  values:         [100.0],
  payer:          payer,
  installments:   installments
)
```

[More](https://github.com/Irio/mymoip/wiki/Installments-use).

### Notification and return URLs

URLs configured at MoIP account can be overrided by passing new URLs values to the instruction object.
A notification URL is used for MoIP NASP notification system, responsible for transaction changes signals,
and a return URL is used to return to your website when a payment is using external websites.

```ruby
instruction = MyMoip::Instruction.new(
  id:               'instruction_id_defined_by_you',
  payment_reason:   'Order in Buy Everything Store',
  values:           [100.0],
  payer:            payer,
  notification_url: 'https://example.com/payments/notification',
  return_url:       'https://example.com/payments/return'
)
```

### Payment methods configuration

If you don't need all the payment methods available, you can choose some by configuring
PaymentMethods and adding it to the instruction:

```ruby
payment_methods = MyMoip::PaymentMethods.new(
  payment_slip: false,
  credit_card:  true,
  debit:        true,
  debit_card:   true,
  financing:    true,
  moip_wallet:  true
)

instruction = MyMoip::Instruction.new(
  id:              'instruction_id_defined_by_you',
  payment_reason:  'Order in Buy Everything Store',
  values:          [100.0],
  payer:           payer,
  payment_methods: payment_methods
)
```

### Payment slip (aka boleto) configuration

You can optionally configure your payment slip creating a PaymentSlip and adding to the instruction:

```ruby
payment_slip = MyMoip::PaymentSlip.new(
  expiration_date:      Date.today.next_day.to_datetime,
  expiration_days:      5,
  expiration_days_type: :business_day,
  instruction_line_1:   'This is the first instruction line.',
  instruction_line_2:   'Please do not pay this slip.',
  instruction_line_3:   'This is a test! :)',
  logo_url:             'https://example.com/logo.png'
)

instruction = MyMoip::Instruction.new(
  id:             'instruction_id_defined_by_you',
  payment_reason: 'Order in Buy Everything Store',
  values:         [100.0],
  payer:          payer,
  payment_slip:   payment_slip
)
```

A payment slip can have the following attributes:

  * expiration_date: a DateTime indicating the last payment date to this slip.
  * expiration_days: expiration days after which the printed payment slip will be considered expired.
  * expiration_days_type: type of expiration day, which can be :business_day or :calendar_day.
  * instruction_line_1, instruction_line_2, instruction_line_3: lines of instruction (up to 63 characters each), added to the payment slip.
  * logo_url: an URL pointing to an image which will be added to the body of the payment slip.

### Logger

The methods that make api calls to Moip, log request and response informations. The default logger is `Logger.new(STDOUT)`, but you can set the logger you want as `api_call` option. For instance:

``` ruby
request = MyMoip::PaymentRequest.new('some-id')
request.api_call(data, token: 'some-token', logger: Rails.logger)
```

You can configure the logger globally too:

``` ruby
MyMoip.logger = Rails.logger
```


## Going alive!

If you are ready to get your application using MyMoip approved by MoIP or already have valid production keys, you can read a specific [documentation](https://github.com/Irio/mymoip/wiki/Going-alive).

## License

MIT. See LICENSE.txt for further details.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/Irio/mymoip/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

