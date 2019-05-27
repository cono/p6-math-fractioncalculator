use v6.c;

class X::Math::FractionCalculator::SyntaxError is Exception {
    method message { "Syntax error" }
}

class Math::FractionCalculator:ver<0.0.1> {

    grammar Evaluation {
        rule TOP {
            ^ <expression> $
        }
        rule expression {
            | <term>+ %% $<op>=(['+'|'-'])
            | <group>
        }
        rule term {
            <factor>+  %% $<op>=(['*'|'/'])
        }
        rule factor {
            | <value>
            | <group>
        }
        rule group {
            '(' <expression> ')'
        }
        token value { \d+ }
    }

    class EvaluationActions {
        my %operators  =
            '+' => &[+],
            '-' => &[-],
            '*' => &[*],
            '/' => &[/];

        method TOP($/) {
            $/.make: $<expression>.ast
        }

        method group($/) {
            $/.make: $<expression>.ast
        }

        method value($/) {
            $/.make: +$/
        }

        method factor($/) {
            with $<value> {
                $/.make: +$<value>;
            } orwith $<group> {
                $/.make: $<group>.ast;
            }
        }

        method term($/) {
            my $i = 0;

            $/.make: $<factor>».ast.reduce({ %operators{ $<op>[$i++] }($^a, $^b) });
        }

        method expression($/) {
            $/.make: $<group>.ast when $<group>;

            my $i = 0;
            $/.make: $<term>».ast.reduce({ %operators{ $<op>[$i++] }($^a, $^b) });
        }
    }

    method calc(Str $str) {
        my $eval = Evaluation.parse($str, :actions(EvaluationActions));

        X::Math::FractionCalculator::SyntaxError.new.throw unless $eval;

        my $result = $eval.ast;
        if $result ~~ Rat {
            with $result.nude {
                $result = .reduce(&[==]) ?? ~$result !! .join("/");
            }
        }

        return $result;
    }
}

=begin pod

=head1 NAME

Math::FractionCalculator - grammar based fraction calculator

=head1 SYNOPSIS

=begin code :lang<perl6>

use Math::FractionCalculator;

Math::FractionCalculator.new.calc("1/2 + 1/3"); # gives 5/6

=end code

=head1 DESCRIPTION

Math::FractionCalculator is a simple fraction calculator which understand only
square brackets and +, -, /, * operators only.

Method calc takes string with expression and returns string result of a fraction.

=head1 AUTHOR

cono <q@cono.org.ua>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 cono

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
