# CHANGELOG

## 0.7.0

* Allow payments using redirection to Moip's domain. (by @oznek)
* Include PaymentSlip configuration class. (by @oznek)
* Remove backward compatibility with CreditCardPayment w/o options hash.

## 0.6.2

* Removed development dependency of jeweler. Gems are now managed
directly in .gemspec file.
* Offer a easier way to manage purchase implementations that don't have
many customizations over passing some attribute list, making the
checkout and getting a successful (or not) response. Through
MyMoip::Purchase.
* Accept string keys in initializers of CreditCard and Payer classes.

## 0.6.1

* Send 2 decimal place numbers in fixed and percentage values nodes of
Comission's XML. Percentage values are required to be in a 0 to 100 range.
Reported by @zangrandi.

## 0.6.0

* Add support for Ruby 2.0.
* Improved installments option for Instructions.

## 0.5.0

* Breaking backward compatibility with exceptions raised. ArgumentError
is not used anymore. New MyMoip::InvalidComission, MyMoip::InvalidCreditCard,
MyMoip::InvalidInstruction and MyMoip::InvalidPayer exceptions inherited from
MyMoip::Error.

## 0.4.1

* Simultaneous setters for sandbox and production token/keys.
* DEPRECATE MyMoip.key and MyMoip.token methods over new environment specific setters.
* Going alive instructions added to README file.
* Add reference to new my_moip-rails gem.

## 0.4.0

* Accept multiple receivers for each instruction.
    * Can set a fixed value (e.g. R$ 50,00).
    * Can set a percentage value (e.g. 10%).
    * Define which one will take the fees.
* Accept payments to any MoIP users, even those without API keys.

## 0.3.1

* Re-releasing 0.3.0 after some Rubygems issues.

## 0.3.0

* Add dependency of active_model gem for validations.
* Try always to store the plain value of attributes. While the previous version would require you to provide phones in the `"(51)93040-5060"` format, now works even with `"051930405060"`.
* Payer accepts address_state and address_country downcased.
* CreditCard accept a valid string date as owner_birthday.
* Extract conversions of attributes' formats to a new Formatter class.
* Prevent use of CreditCardPayment#to_json with a invalid CreditCard.
* Prevent use of Instruction#to_xml with invalid attributes by itself or a invalid Payer.

New validations:
* **CreditCard**
    * Require a logo and a security_code.
    * Validate length of owner_phone (accepts 8 and 9 digit phones with its DDD code).
    * Validate length of security_code (American Express has 4 digits, others 3).
    * Validate format of expiration_date using `%m/%y`.
    * Limit logos in the available at AVAILABLE_LOGOS constant.
* **Instruction**
    * Require an id, payment_reason, values and a payer.
* **Payer**
    * Require and id, name, email, address_street, address_street_number, address_neighbourhood, address_city, address_state, address_country, address_cep and an address_phone.
    * Validate length of address_state in 2 chars.
    * Validate length of address_country in 3 chars.
    * Validate length of address_cep in 8 chars.
    * Validate length of address_phone (accepts 8 and 9 digit phones with its DDD code).

## 0.2.6

* DEPRECATE owner_rg attribute of MyMoip::CreditCard; you should provide a owner_cpf from now on. Should explain issues with Visa's risk analysis.

## 0.2.5

* Request's log messages moved to debug level.
* Make CreditCard class accept string and symbol logos.
* Create MyMoip::CreditCard::AVAILABLE_LOGOS constant.
* Standardise Request#api_call parameters.

## 0.2.4

* Fix American Express logo format expected by Moip.

## 0.2.3

* Remove .rvmrc
* CreditCardPayment's initialization can now receive a hash of options.
* lib/requests folder created.
* Requests has methods to return its response id.

## 0.2.2

* Explicitly require order for Requests classes.

## 0.2.1

* Bugfix related to explicitly require MyMoip class being needed.

## 0.2.0

* Update production url from `https://desenvolvedor.moip.com.br` to `https://www.moip.com.br`.

## 0.1.0

* First version of the gem.
