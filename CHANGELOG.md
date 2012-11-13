CHANGELOG
=========

**0.2.6**
* Deprecate owner_rg attribute of MyMoip::CreditCard; you should provide a owner_cpf from now on. Should explain issues with Visa's risk analysis.

**0.2.5**
* Request's log messages moved to debug level.
* Make CreditCard class accept string and symbol logos.
* Create MyMoip::CreditCard::AVAILABLE_LOGOS constant.
* Standardise Request#api_call parameters.

**0.2.4**
* Fix American Express logo format expected by Moip.

**0.2.3**
* Remove .rvmrc
* CreditCardPayment's initialization can now receive a hash of options.
* lib/requests folder created.
* Requests has methods to return its response id.

**0.2.2**
* Explicitly require order for Requests classes.

**0.2.1**
* Bugfix related to explicitly require MyMoip class being needed.

**0.2.0**
* Update production url from `https://desenvolvedor.moip.com.br` to `https://www.moip.com.br`.

**0.1.0**
* First version of the gem.
