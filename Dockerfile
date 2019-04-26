FROM croservices/cro-http:0.8.0
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN zef install --deps-only . && perl6 -c -Ilib service.p6
ENV FRACTION_CALCULATOR_PORT="8080" FRACTION_CALCULATOR_HOST="0.0.0.0"
EXPOSE 8080
CMD perl6 -Ilib service.p6
