use v6.c;

class X::Math::FractionCalculator::SyntaxError is Exception {
    method message { "Syntax error" }
}

class Math::FractionCalculator:ver<0.0.1> {

    grammar Evaluation {
        token TOP {
            \s* <expression> \s*
        }

        token expression {
            [ <brackets> | <operand> ] \s* <operator> \s* <expression> |
            <brackets> |
            <operand>
        }

        token brackets {
            <open-bracket> \s* <expression> \s* <closing-bracket>
        }

        token open-bracket { '(' }
        token closing-bracket { ')' }

        token operand { \d+ }

        token operator { <[+\-/*]> }
    }

    my %precedence =
        '+' => 0,
        '-' => 0,
        '*' => 1,
        '/' => 1;
    my %operators  =
        '+' => &[+],
        '-' => &[-],
        '*' => &[*],
        '/' => &[/];

    has @!stack;
    has @.result;

    method parse($str) {
        my $match = Evaluation.parse($str);

        X::Math::FractionCalculator::SyntaxError.new.throw unless $match;

        @!stack = ();
        @!result = ();
        self!traverse-match-object({brackets => {expression => $match<expression>}});

        return self;
    }

    method !traverse-match-object($match) {
        with $match<brackets> {
            @!stack.push('(');

            samewith(self, $_<expression>);

            while '(' ne (my $op = @!stack.pop) {
                @!result.push: %operators{ $op };
            }
        } orwith $match<operand> {
            @!result.push: .Int;
        }

        with $match<operator> {
            while @!stack[*-1] ne '(' && %precedence{ @!stack[*-1] } >= %precedence{ .Str } {
                @!result.push: %operators{ @!stack.pop };
            }
            @!stack.push: .Str;
        }

        samewith(self, $_) with $match<expression>;
    }

    method eval {
        die "prase should be called first" unless @!result;

        @!stack = ();

        for @!result -> $item {
            when $item ~~ Code {
                @!stack.push: $item(|@!stack.splice: * - $item.count);
            }

            @!stack.push: $item;
        }

        my $result = @!stack[0];
        $result = $result.nude.join('/') if $result ~~ Rat;

        return $result;
    }

}

=begin pod

=head1 NAME

Math::FractionCalculator - infix to postfix converter + fraction calculator

=head1 SYNOPSIS

=begin code :lang<perl6>

use Math::FractionCalculator;

Math::FractionCalculator.new.parse("1/2 + 1/3").eval; # gives 5/6

=end code

=head1 DESCRIPTION

Math::FractionCalculator is a simple fraction calculator which understand only
square brackets and +, -, /, * operators only.

Method parse converts equation from infix form to postifx form (result placed
to @.result field).

Method eval - evaluates postfix expression via stack machine and returns Rat
result.

=head1 AUTHOR

cono <q@cono.org.ua>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 cono

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
