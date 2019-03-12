use v6.c;
use Test;
use Math::FractionCalculator;


my $calc = Math::FractionCalculator.new;

is $calc.parse("2 + 2").result, (2, 2, &[+]), 'infix to postfix converter';

is $calc.parse("(2 + 2) + (2 + 2)").eval, 8, "no fraction equation";
is $calc.parse("42").eval, 42, "single number";
is $calc.parse("(1/2 + 1/3)").eval, "5/6", "enclosed in square bracket";

my @tests = "1/2 + 2/3" => "7/6", "(3/6) / (2/3)" => "3/4", "(1/2 + 2/3) - ((2/7) / (1/8))" => "-47/42", "1 + 1/2" => "3/2";
for @tests -> $expr {
    is $calc.parse($expr.key).eval, $expr.value, "{$expr.key} = {$expr.value}";
}

done-testing;
