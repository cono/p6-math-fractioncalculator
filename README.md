[![Build Status](https://travis-ci.org/cono/p6-math-fractioncalculator.svg?branch=master)](https://travis-ci.org/cono/p6-math-fractioncalculator)

NAME
====

Math::FractionCalculator - grammar based fraction calculator

SYNOPSIS
========

```perl6
use Math::FractionCalculator;

Math::FractionCalculator.new.calc("1/2 + 1/3"); # gives 5/6
```

DESCRIPTION
===========

Math::FractionCalculator is a simple fraction calculator which understand only square brackets and +, -, /, * operators only.

Method calc takes string with expression and returns string result of a fraction.

AUTHOR
======

cono <q@cono.org.ua>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 cono

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

