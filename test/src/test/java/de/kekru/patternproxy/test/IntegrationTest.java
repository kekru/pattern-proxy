package de.kekru.patternproxy.test;

import static io.restassured.RestAssured.given;
import static org.mockserver.model.HttpRequest.request;
import static org.mockserver.model.HttpResponse.response;

import org.junit.Test;
import org.mockserver.client.MockServerClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.Network;
import org.testcontainers.containers.output.Slf4jLogConsumer;

public class IntegrationTest {

  private static final Logger LOG_PATTERN_PROXY = LoggerFactory.getLogger("Pattern-Proxy Container");

  private int patternProxyMappedPort;
  private int mockServerMappedPort;

  private MockServerClient mockServerClient;

  @Test
  public void test() {
    try (
        Network network = createNetwork();
        GenericContainer mockServerContainer = createMockServer(network);
        GenericContainer patternProxyContainer = createPatternProxy(network);
    ) {
      mockServerContainer.start();
      patternProxyContainer.start();
      patternProxyMappedPort = patternProxyContainer.getMappedPort(80);
      mockServerMappedPort = mockServerContainer.getMappedPort(1090);
      patternProxyContainer.followOutput(new Slf4jLogConsumer(LOG_PATTERN_PROXY));


      mockServerClient = new MockServerClient("localhost", mockServerMappedPort);
      mockServerClient
          .when(request()
              .withMethod("GET")
              .withPath("/some-redirect"))
          .respond(response()
              .withStatusCode(303)
              .withHeader("Location", "http://abc.mock-server:1090/target/of/redirect"));

      given()
          .when()
          .redirects().follow(false)
      .get("http://abc.pp.127-0-0-1.nip.io:" + patternProxyMappedPort + "/some-redirect")
          .then()
          .header("Location", "http://abc.pp.127-0-0-1.nip.io:" + patternProxyMappedPort + "/target/of/redirect");
    }
  }


  private Network createNetwork() {
    return Network.newNetwork();
  }

  private GenericContainer createPatternProxy(Network network) {

    GenericContainer container = new GenericContainer("kekru/pattern-proxy:temp-for-unittests")
        .withNetwork(network)
        .withExposedPorts(80).withEnv("RULE_1_MODE", "HTTP")
        .withEnv("RULE_1_PATTERN", "(?<service>.+).pp.127-0-0-1.nip.io")
        .withEnv("RULE_1_TARGET", "http://$service.mock-server:1090")
        .withEnv("DNS_RESOLVER", "127.0.0.11") // Internal Docker Network Resolver
        ;
    return container;
  }

  private GenericContainer createMockServer(Network network) {
    return new GenericContainer("mockserver/mockserver:mockserver-5.10.0")
        .withNetwork(network)
        .withNetworkAliases("mock-server", "abc.mock-server")
        .withExposedPorts(1090)
        .withEnv("LOG_LEVEL", "DEBUG")
        .withEnv("SERVER_PORT", "1090");
  }
}
