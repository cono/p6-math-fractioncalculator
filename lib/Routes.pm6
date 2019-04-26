use Cro::HTTP::Router;
use Math::FractionCalculator;

sub routes() is export {
    my $calc = Math::FractionCalculator.new;

    route {
        get -> {
            content 'text/html', "<h1> fraction-calculator </h1>";
        }
        post -> 'calc' {
            request-body -> ( :$equation ) {
                try {
                    my $result = $calc.calc($equation);

                    content 'application/json', { :$equation, :$result };
                }

                if $! {
                    content 'application/json', ${
                        :$equation,
                        error => $!.message
                    };
                }
            }
        }
        get -> 'healthcheck' {
            content 'application/json', ${ status => "UP" };
        }
    }
}
