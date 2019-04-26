use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Routes;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<FRACTION_CALCULATOR_HOST> ||
        die("Missing FRACTION_CALCULATOR_HOST in environment"),
    port => %*ENV<FRACTION_CALCULATOR_PORT> ||
        die("Missing FRACTION_CALCULATOR_PORT in environment"),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<FRACTION_CALCULATOR_HOST>:%*ENV<FRACTION_CALCULATOR_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
