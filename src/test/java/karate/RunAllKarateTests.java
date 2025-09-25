package karate;

import com.intuit.karate.junit5.Karate;

class RunAllKarateTests {
    @Karate.Test
    Karate runAllTests() {
        return Karate.run().relativeTo(getClass());
    }
}