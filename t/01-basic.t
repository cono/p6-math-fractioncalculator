use v6.c;
use Test;
use Math::FractionCalculator;


my $calc = Math::FractionCalculator.new;

is $calc.calc("(2 + 2) + (2 + 2)"), 8, "no fraction equation";
is $calc.calc("42"), 42, "single number";
is $calc.calc("(1/2 + 1/3)"), "5/6", "enclosed in square bracket";

is $calc.calc("1/2 + 1/0"), "1/0", "Edge case, probably should be Inf";

subtest "General equations" => sub {
    my @tests =
        "1/2 + 2/3" => "7/6",
        "(3/6) / (2/3)" => "3/4",
        "(1/2 + 2/3) - ((2/7) / (1/8))" => "-47/42",
        "1 + 1/2" => "3/2",
        "((2/3) * (1/6))" => "1/9",
        "1/(2/(3/(4)))" => '3/8',
        "1/2 + 1/2" => "1";
    for @tests -> $expr {
        is $calc.calc($expr.key), $expr.value, "{$expr.key} = {$expr.value}";
    }
};

subtest "Syntax error" => sub {
    my @tests =
        "1 2",
        "(1",
        "(1))",
        "((1)",
        "1 + 2 3 / 4";

    for @tests -> $expr {
        dies-ok { $calc.calc($expr) }, "$expr";
    }
};



done-testing;
