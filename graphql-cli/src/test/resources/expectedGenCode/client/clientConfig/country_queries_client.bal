import ballerina/http;
import ballerinax/graphql;

public type ClientConfig record {|
    # Configurations related to client authentication
    http:BearerTokenConfig auth;
    # The HTTP version understood by the client
    string httpVersion = "1.1";
    # Configurations related to HTTP/1.x protocol
    http:ClientHttp1Settings http1Settings = {};
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings = {};
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with Redirection
    http:FollowRedirects? followRedirects = ();
    # Configurations associated with request pooling
    http:PoolConfiguration? poolConfig = ();
    # HTTP caching related configurations
    http:CacheConfig cache = {};
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig? circuitBreaker = ();
    # Configurations associated with retrying
    http:RetryConfig? retryConfig = ();
    # Configurations associated with cookies
    http:CookieConfig? cookieConfig = ();
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits = {};
    # SSL/TLS-related options
    http:ClientSecureSocket? secureSocket = ();
|};

public isolated client class CountryqueriesClient {
    final graphql:Client graphqlClient;
    public isolated function init(ClientConfig clientConfig, string serviceUrl) returns graphql:Error? {
        graphql:Client clientEp = check new (serviceUrl, clientConfig);
        self.graphqlClient = clientEp;
        return;
    }
    remote isolated function country(string code) returns CountryResponse|graphql:Error {
        string query = string `query country($code:ID!) {country(code:$code) {capital name}}`;
        map<anydata> variables = {"code": code};
        return <CountryResponse> check self.graphqlClient->execute(CountryResponse, query, variables);
    }
    remote isolated function countries(CountryFilterInput? filter = ()) returns CountriesResponse|graphql:Error {
        string query = string `query countries($filter:CountryFilterInput) {countries(filter:$filter) {name continent {countries {name}}}}`;
        map<anydata> variables = {"filter": filter};
        return <CountriesResponse> check self.graphqlClient->execute(CountriesResponse, query, variables);
    }
    remote isolated function combinedQuery(string code, CountryFilterInput? filter = ()) returns CombinedQueryResponse|graphql:Error {
        string query = string `query combinedQuery($code:ID!,$filter:CountryFilterInput) {country(code:$code) {name} countries(filter:$filter) {name continent {countries {continent {name}}}}}`;
        map<anydata> variables = {"filter": filter, "code": code};
        return <CombinedQueryResponse> check self.graphqlClient->execute(CombinedQueryResponse, query, variables);
    }
    remote isolated function neighbouringCountries() returns NeighbouringCountriesResponse|graphql:Error {
        string query = string `query neighbouringCountries {countries(filter:{code:{eq:"LK"}}) {name continent {countries {name}}}}`;
        map<anydata> variables = {};
        return <NeighbouringCountriesResponse> check self.graphqlClient->execute(NeighbouringCountriesResponse, query, variables);
    }
}
