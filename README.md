NAME
====

Math::FractionCalculator - infix to postfix converter + fraction calculator

SYNOPSIS
========

```perl6
use Math::FractionCalculator;

Math::FractionCalculator.new.parse("1/2 + 1/3").eval; # gives 5/6
```

DESCRIPTION
===========

Math::FractionCalculator is a simple fraction calculator which understand only square brackets and +, -, /, * operators only.

Method parse converts equation from infix form to postifx form (result placed to @.result field).

Method eval - evaluates postfix expression via stack machine and returns Rat result.

AUTHOR
======

cono <q@cono.org.ua>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 cono

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

